package controller;

import dao.AssignmentDAO;
import dao.CheckRequestDAO;
import dao.ItemDAO;
import dao.NotificationDAO;
import dao.StorageUnitDAO;
import dao.StorageUnitItemDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
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
        String[] checkDates = request.getParameterValues("checkDate");

        if (mode == null || unitIdStr == null || unitIdStr.isEmpty()
                || itemIds == null || quantities == null || checkDates == null
                || itemIds.length != quantities.length
                || itemIds.length != checkDates.length) {
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

        // Group theo ngày: date -> (itemId -> tổng quantity trong ngày)
        Map<LocalDate, Map<Integer, Integer>> qtyByDateItem = new HashMap<>();
        // Group theo item để validate tổng cho CHECK_OUT (tránh âm tồn kho do checkout nhiều ngày)
        Map<Integer, Integer> totalQtyByItemId = new HashMap<>();

        for (int i = 0; i < itemIds.length; i++) {
            try {
                int itemId = Integer.parseInt(itemIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                if (quantity <= 0) continue;

                String dateRaw = checkDates[i];
                if (dateRaw == null || dateRaw.isBlank()) {
                    request.setAttribute("quantityError", "Bạn phải chọn ngày check-in/check-out cho từng ngày.");
                    doGet(request, response);
                    return;
                }

                LocalDate date;
                try {
                    date = LocalDate.parse(dateRaw);
                } catch (Exception e) {
                    request.setAttribute("quantityError", "Ngày check-in/check-out không hợp lệ.");
                    doGet(request, response);
                    return;
                }

                totalQtyByItemId.merge(itemId, quantity, Integer::sum);
                qtyByDateItem
                        .computeIfAbsent(date, d -> new HashMap<>())
                        .merge(itemId, quantity, Integer::sum);
            } catch (NumberFormatException ignored) {
            }
        }

        if (qtyByDateItem.isEmpty()) {
            request.setAttribute("quantityError", "Bạn phải nhập ít nhất 1 item có số lượng > 0.");
            doGet(request, response);
            return;
        }

        // Validate checkDate nằm trong khoảng hợp đồng (Contract_Storage_unit) có hiệu lực.
        // Chỉ validate cho các ngày có item được nhập số lượng > 0.
        LocalDate today = LocalDate.now();
        for (LocalDate day : qtyByDateItem.keySet()) {
            if (day.isBefore(today)) {
                request.setAttribute("quantityError",
                        "Bạn phải chọn sau khoảng thời gian hiện tại.");
                doGet(request, response);
                return;
            }
            boolean rentedOnDay = unitDao.isUnitRentedOnDate(user.getId(), unitId, day);
            if (!rentedOnDay) {
                request.setAttribute("quantityError",
                        "Ngày " + day + " không nằm trong thời gian hợp đồng có hiệu lực cho unit này.");
                doGet(request, response);
                return;
            }
        }

        // Validate tổng theo item (đặc biệt cho CHECK_OUT)
        if ("OUT".equals(normalizedMode)) {
            for (Map.Entry<Integer, Integer> entry : totalQtyByItemId.entrySet()) {
                int itemId = entry.getKey();
                int totalQty = entry.getValue();
                Integer maxAllowed = allowedItemQtyMap.get(itemId);
                if (maxAllowed == null) {
                    request.setAttribute("quantityError", "Item không hợp lệ cho unit hiện tại.");
                    doGet(request, response);
                    return;
                }
                if (totalQty > maxAllowed) {
                    request.setAttribute("quantityError", "Tổng số lượng checkout cho mỗi item không được vượt quá tồn kho hiện tại.");
                    doGet(request, response);
                    return;
                }
            }
        }

        String requestType = "OUT".equals(normalizedMode) ? "CHECK_OUT" : "CHECK_IN";
        CheckRequestDAO checkDao = new CheckRequestDAO();

        AssignmentDAO assignmentDAO = new AssignmentDAO();
        List<Integer> createdCheckRequestIds = new ArrayList<>();
        boolean anyTaskAssigned = false;

        List<LocalDate> sortedDates = new ArrayList<>(qtyByDateItem.keySet());
        sortedDates.sort(LocalDate::compareTo);

        try {
            NotificationDAO notiDAO = new NotificationDAO();
            String actionLabel = "CHECK_OUT".equals(requestType) ? "check-out" : "check-in";
            String wName = warehouseName != null ? "\"" + warehouseName + "\"" : "the warehouse";

            for (LocalDate day : sortedDates) {
                Map<Integer, Integer> dayItems = qtyByDateItem.get(day);
                Timestamp requestDate = Timestamp.valueOf(day.atStartOfDay());

                // Tạo 1 check_request cho mỗi ngày
                int checkRequestId = checkDao.insertCheckRequest(
                        user.getId(), warehouseId, unitId, requestType, requestDate
                );
                if (checkRequestId <= 0) continue;
                createdCheckRequestIds.add(checkRequestId);

                // Lưu các mặt hàng vào đơn tương ứng ngày đó
                for (Map.Entry<Integer, Integer> itemQty : dayItems.entrySet()) {
                    checkDao.insertCheckRequestItem(checkRequestId, itemQty.getKey(), itemQty.getValue());
                }

                // Auto assign staff
                boolean isTaskAssigned = assignmentDAO.createTaskFromCheckRequest(checkRequestId);
                if (isTaskAssigned) anyTaskAssigned = true;

                // Notification cho staff (nếu có)
                if (isTaskAssigned) {
                    // Chọn staff theo warehouse (tham số đúng)
                    int assignedStaffId = assignmentDAO.getOptimalStaffId(warehouseId);
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
                }

                // Notification cho renter (luôn luôn)
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
            }
        } catch (Exception e) {
            System.err.println("Failed to insert notification: " + e.getMessage());
        }

        if (!createdCheckRequestIds.isEmpty()) {
            session.setAttribute("MESSAGE",
                    anyTaskAssigned
                            ? "Tạo đơn thành công! Nhân viên kho đang chuẩn bị hỗ trợ bạn."
                            : "Tạo đơn thành công! Quản lý kho sẽ sớm điều phối nhân viên hỗ trợ bạn.");
            response.sendRedirect(request.getContextPath() + "/checkRequestList");
        } else {
            response.sendRedirect(request.getContextPath() + "/itemList");
        }
    }
}