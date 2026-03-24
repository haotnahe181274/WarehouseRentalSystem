package controller;

import dao.AssignmentDAO;
import dao.CheckRequestDAO;
import dao.ItemDAO;
import dao.NotificationDAO;
import dao.StorageUnitDAO;
import dao.StorageUnitItemDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Item;
import model.Notification;
import model.StorageUnit;
import model.StorageUnitItem;
import model.UserView;

@WebServlet(name = "CreateCheckRequest", urlPatterns = {"/createCheckRequest"})
public class CreateCheckRequest extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        if (!"RENTER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        String mode = request.getParameter("mode");

        StorageUnitDAO unitDao = new StorageUnitDAO();
        ItemDAO itemDao = new ItemDAO();

        List<StorageUnit> activeUnits = unitDao.getActiveUnitsForRenter(user.getId());

        String unitIdStr = request.getParameter("unitId");
        Integer selectedUnitId = null;
        if (unitIdStr != null && !unitIdStr.isEmpty()) {
            try {
                int uid = Integer.parseInt(unitIdStr);
                for (StorageUnit u : activeUnits) {
                    if (u.getUnitId() == uid) {
                        selectedUnitId = uid;
                        break;
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }

        List<Item> items = Collections.emptyList();
        Map<Integer, Integer> availableQtyMap = new HashMap<>();
        if (selectedUnitId != null) {
            if ("OUT".equalsIgnoreCase(mode)) {
                List<Item> declaredItems = itemDao.getItemsFromRentRequestByUnit(user.getId(), selectedUnitId);
                StorageUnitItemDAO storageUnitItemDAO = new StorageUnitItemDAO();
                List<StorageUnitItem> stockedItems = storageUnitItemDAO.getItemsByUnitAndRenter(selectedUnitId, user.getId());
                Map<Integer, Integer> stockedQtyByItemId = new HashMap<>();
                for (StorageUnitItem sui : stockedItems) {
                    if (sui.getItem() != null) {
                        stockedQtyByItemId.put(sui.getItem().getItemId(), sui.getQuantity());
                    }
                }
                List<Item> outItems = new ArrayList<>();
                for (Item declared : declaredItems) {
                    outItems.add(declared);
                    availableQtyMap.put(declared.getItemId(), stockedQtyByItemId.getOrDefault(declared.getItemId(), 0));
                }
                items = outItems;
            } else {
                items = itemDao.getItemsFromRentRequestByUnit(user.getId(), selectedUnitId);
            }
        }

        request.setAttribute("mode", mode);
        request.setAttribute("activeUnits", activeUnits);
        request.setAttribute("items", items);
        request.setAttribute("availableQtyMap", availableQtyMap);
        request.setAttribute("selectedUnitId", selectedUnitId);
        request.getRequestDispatcher("/Rental/checkRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        if (!"RENTER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        String mode      = request.getParameter("mode");
        String unitIdStr = request.getParameter("unitId");
        String[] itemIds    = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");

        if (mode == null || unitIdStr == null || unitIdStr.isEmpty()
                || itemIds == null || quantities == null
                || itemIds.length != quantities.length) {
            response.sendRedirect(request.getContextPath() + "/createCheckRequest?mode=" + mode);
            return;
        }

        int unitId;
        try {
            unitId = Integer.parseInt(unitIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/createCheckRequest?mode=" + mode);
            return;
        }

        StorageUnitDAO unitDao = new StorageUnitDAO();
        List<StorageUnit> activeUnits = unitDao.getActiveUnitsForRenter(user.getId());
        Integer warehouseId   = null;
        String  warehouseName = null;
        boolean validUnit     = false;
        for (StorageUnit u : activeUnits) {
            if (u.getUnitId() == unitId) {
                validUnit = true;
                if (u.getWarehouse() != null) {
                    warehouseId   = u.getWarehouse().getWarehouseId();
                    warehouseName = u.getWarehouse().getName();
                }
                break;
            }
        }
        if (!validUnit || warehouseId == null) {
            response.sendRedirect(request.getContextPath() + "/createCheckRequest?mode=" + mode);
            return;
        }

        ItemDAO itemDao = new ItemDAO();
        StorageUnitItemDAO storageUnitItemDAO = new StorageUnitItemDAO();
        String normalizedMode = "OUT".equalsIgnoreCase(mode) ? "OUT" : "IN";

        Map<Integer, Integer> allowedItemQtyMap = new HashMap<>();
        if ("OUT".equals(normalizedMode)) {
            List<Item> declaredItems = itemDao.getItemsFromRentRequestByUnit(user.getId(), unitId);
            Set<Integer> declaredItemIds = new HashSet<>();
            for (Item it : declaredItems) declaredItemIds.add(it.getItemId());

            List<StorageUnitItem> stockedItems = storageUnitItemDAO.getItemsByUnitAndRenter(unitId, user.getId());
            for (StorageUnitItem sui : stockedItems) {
                if (sui.getItem() != null) {
                    int iid = sui.getItem().getItemId();
                    if (declaredItemIds.contains(iid)) {
                        allowedItemQtyMap.put(iid, sui.getQuantity());
                    }
                }
            }
        } else {
            List<Item> allowedItems = itemDao.getItemsFromRentRequestByUnit(user.getId(), unitId);
            for (Item it : allowedItems) allowedItemQtyMap.put(it.getItemId(), Integer.MAX_VALUE);
        }

        List<int[]> selectedItems = new ArrayList<>();
        for (int i = 0; i < itemIds.length; i++) {
            try {
                int itemId   = Integer.parseInt(itemIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                if (quantity > 0) {
                    Integer maxAllowed = allowedItemQtyMap.get(itemId);
                    if (maxAllowed == null) {
                        request.setAttribute("quantityError", "Item không hợp lệ cho unit hiện tại.");
                        doGet(request, response);
                        return;
                    }
                    if ("OUT".equals(normalizedMode) && quantity > maxAllowed) {
                        request.setAttribute("quantityError", "Số lượng checkout không được vượt quá tồn kho hiện tại.");
                        doGet(request, response);
                        return;
                    }
                    selectedItems.add(new int[]{itemId, quantity});
                }
            } catch (NumberFormatException ignored) {
            }
        }
        if (selectedItems.isEmpty()) {
            request.setAttribute("quantityError", "Bạn phải nhập ít nhất 1 item có số lượng > 0.");
            doGet(request, response);
            return;
        }

        String requestType = "OUT".equals(normalizedMode) ? "CHECK_OUT" : "CHECK_IN";
        CheckRequestDAO checkDao = new CheckRequestDAO();

        // 1. Tạo đơn Check Request
        int checkRequestId = checkDao.insertCheckRequest(user.getId(), warehouseId, unitId, requestType);

        if (checkRequestId > 0) {
            // 2. Lưu các mặt hàng vào đơn
            for (int[] pair : selectedItems) {
                checkDao.insertCheckRequestItem(checkRequestId, pair[0], pair[1]);
            }

            // 3. Auto assign staff
            AssignmentDAO assignmentDAO = new AssignmentDAO();
            boolean isTaskAssigned = assignmentDAO.createTaskFromCheckRequest(checkRequestId);

            // 4. Gửi notification
            try {
                NotificationDAO notiDAO = new NotificationDAO();
                String actionLabel = "CHECK_OUT".equals(requestType) ? "check-out" : "check-in";
                String wName       = warehouseName != null ? "\"" + warehouseName + "\"" : "the warehouse";

                if (isTaskAssigned) {
                    // 4a. Staff đã được assign → gửi notification cho staff
                    //     Lấy staffId từ assignment vừa tạo
                    int assignedStaffId = assignmentDAO.getOptimalStaffId(checkRequestId);
                    if (assignedStaffId > 0) {
                        Notification notiStaff = new Notification();
                        notiStaff.setTitle("New " + actionLabel + " task assigned");
                        notiStaff.setMessage("You have been assigned a " + actionLabel
                                + " task at warehouse " + wName
                                + ". Please check your task list.");
                        notiStaff.setType("WARNING");
                        notiStaff.setLinkUrl("/staffTask");
                        notiStaff.setInternalUserId(assignedStaffId);
                        notiDAO.insertNotification(notiStaff);
                    }

                    session.setAttribute("MESSAGE",
                            "Tạo đơn thành công! Nhân viên kho đã nhận được lệnh và đang chuẩn bị.");
                } else {
                    // 4b. Chưa assign được → chỉ báo cho Renter biết đang chờ
                    session.setAttribute("MESSAGE",
                            "Tạo đơn thành công! Quản lý kho sẽ sớm điều phối nhân viên hỗ trợ bạn.");
                }

                // 4c. Luôn gửi confirmation cho Renter dù assign được hay không
                Notification notiRenter = new Notification();
                notiRenter.setTitle(actionLabel.substring(0, 1).toUpperCase()
                        + actionLabel.substring(1) + " request submitted");
                notiRenter.setMessage("Your " + actionLabel + " request at warehouse " + wName
                        + " has been submitted."
                        + (isTaskAssigned
                                ? " A staff member has been assigned."
                                : " Our manager will assign staff shortly."));
                notiRenter.setType("INFO");
                notiRenter.setLinkUrl("/checkRequestDetail?id=" + checkRequestId);
                notiRenter.setRenterId(user.getId());
                notiDAO.insertNotification(notiRenter);

            } catch (Exception e) {
                System.err.println("Failed to insert notification: " + e.getMessage());
            }

            // 5. Redirect sang trang chi tiết
            response.sendRedirect(request.getContextPath() + "/checkRequestDetail?id=" + checkRequestId);
        } else {
            response.sendRedirect(request.getContextPath() + "/itemList");
        }
    }
}