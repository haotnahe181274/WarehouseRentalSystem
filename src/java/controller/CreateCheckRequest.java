package controller;

import dao.CheckRequestDAO;
import dao.ItemDAO;
import dao.StorageUnitDAO;
import dao.StorageUnitItemDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Item;
import model.StorageUnit;
import model.UserView;

/**
 * Tạo đơn check in/out cho renter.
 * GET: form chọn unit + item (đã lọc theo rent request tạo ra contract chứa unit).
 * POST: tạo check_request + check_request_item (nhiều item, mỗi item có quantity).
 */
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

        String mode = request.getParameter("mode"); // IN / OUT

        StorageUnitDAO unitDao = new StorageUnitDAO();
        ItemDAO itemDao = new ItemDAO();

        List<StorageUnit> activeUnits = unitDao.getActiveUnitsForRenter(user.getId());

        // Lọc items theo đúng rent request tạo ra contract chứa unit đã chọn
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

        List<Item> items = java.util.Collections.emptyList();
        if (selectedUnitId != null) {
            items = itemDao.getItemsFromRentRequestByUnit(user.getId(), selectedUnitId);
        }

        request.setAttribute("mode", mode);
        request.setAttribute("activeUnits", activeUnits);
        request.setAttribute("items", items);
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

        String mode = request.getParameter("mode"); // IN / OUT
        String unitIdStr = request.getParameter("unitId");
        String[] itemIds = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");

        if (mode == null || unitIdStr == null
                || unitIdStr.isEmpty() || itemIds == null || quantities == null
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
        java.util.List<StorageUnit> activeUnits = unitDao.getActiveUnitsForRenter(user.getId());
        Integer warehouseId = null;
        boolean validUnit = false;
        for (StorageUnit u : activeUnits) {
            if (u.getUnitId() == unitId) {
                validUnit = true;
                if (u.getWarehouse() != null) {
                    warehouseId = u.getWarehouse().getWarehouseId();
                }
                break;
            }
        }
        if (!validUnit || warehouseId == null) {
            response.sendRedirect(request.getContextPath() + "/createCheckRequest?mode=" + mode);
            return;
        }

        java.util.List<int[]> selectedItems = new java.util.ArrayList<>();
        for (int i = 0; i < itemIds.length; i++) {
            try {
                int itemId = Integer.parseInt(itemIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                if (quantity > 0) {
                    selectedItems.add(new int[]{itemId, quantity});
                }
            } catch (NumberFormatException ignored) {
            }
        }
        if (selectedItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/createCheckRequest?mode=" + mode + "&unitId=" + unitId);
            return;
        }

        String requestType = "OUT".equalsIgnoreCase(mode) ? "CHECK_OUT" : "CHECK_IN";
        CheckRequestDAO checkDao = new CheckRequestDAO();
        int checkRequestId = checkDao.insertCheckRequest(user.getId(), warehouseId, unitId, requestType);

        if (checkRequestId > 0) {
            for (int[] pair : selectedItems) {
                checkDao.insertCheckRequestItem(checkRequestId, pair[0], pair[1]);
            }
        }

        response.sendRedirect(request.getContextPath() + "/itemList");
    }
}

