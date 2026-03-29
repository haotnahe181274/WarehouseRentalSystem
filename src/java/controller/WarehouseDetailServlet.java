package controller;

import dao.WarehouseManagementDAO;
import dao.StorageUnitDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StorageUnit;
import model.Warehouse;
import model.WarehouseImage;
import java.util.Map;

@WebServlet(name = "WarehouseDetailController", urlPatterns = {"/warehouse/detail"})
public class WarehouseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
        // Chuyển hướng về trang chủ hoặc trang login
        response.sendRedirect(request.getContextPath() + "/homepage");
        return; // Quan trọng: Phải return để ngắt xử lý bên dưới
    }
        StorageUnitDAO suDao = new StorageUnitDAO();
        WarehouseManagementDAO Dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        // ── ADD UNIT: generate code + tính diện tích còn lại ──────────────
        if ("addUnit".equals(action)) {
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            String generatedCode    = suDao.generateUnitCode(warehouseId);
            double warehouseArea    = suDao.getWarehouseTotalArea(warehouseId);
            double usedArea         = suDao.getTotalUsedArea(warehouseId);
            Warehouse w = Dao.getWarehouseById(warehouseId);
            double remainingArea    = warehouseArea - usedArea;
            request.setAttribute("warehouseId",    warehouseId);
            request.setAttribute("generatedCode",  generatedCode);
            request.setAttribute("warehouseArea",  warehouseArea);
            request.setAttribute("usedArea",       usedArea);
            request.setAttribute("remainingArea",  remainingArea);
            request.setAttribute("warehousePrice", w.getPricePerArea());
            request.getRequestDispatcher("/Management/storage-unit-form.jsp").forward(request, response);
            return;
        }

        // ── EDIT UNIT: load unit + tính diện tích còn lại (trừ unit đang edit) ──
        if ("editUnit".equals(action)) {
            int unitId      = Integer.parseInt(request.getParameter("unitId"));
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            Warehouse w = Dao.getWarehouseById(warehouseId);
            StorageUnit unit     = suDao.getStorageUnitById(unitId);
            double warehouseArea = suDao.getWarehouseTotalArea(warehouseId);
            double usedArea      = suDao.getTotalUsedAreaExcluding(warehouseId, unitId);
            double remainingArea = warehouseArea - usedArea;
            request.setAttribute("u",             unit);
            request.setAttribute("warehouseId",   warehouseId);
            request.setAttribute("warehouseArea", warehouseArea);
            request.setAttribute("usedArea",      usedArea);
            request.setAttribute("remainingArea", remainingArea); 
            request.setAttribute("warehousePrice", w.getPricePerArea());
            request.getRequestDispatcher("/Management/storage-unit-form.jsp").forward(request, response);
            return;
        }

        // ── VIEW DEFAULT ───────────────────────────────────────────────────
        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warehouse");
                return;
            }
            int id = Integer.parseInt(idRaw);

            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            Warehouse w = dao.getWarehouseById(id);
            if (w == null) {
                response.sendRedirect(request.getContextPath() + "/warehouse");
                return;
            }

            List<WarehouseImage> images = dao.getWarehouseImages(id);

            String searchStart = request.getParameter("searchStart");
            String searchEnd   = request.getParameter("searchEnd");
            List<StorageUnit> units;

            if (searchStart != null && !searchStart.isEmpty()
                    && searchEnd != null && !searchEnd.isEmpty()) {
                units = suDao.searchAvailableUnits(id, searchStart, searchEnd);
                request.setAttribute("searchStart", searchStart);
                request.setAttribute("searchEnd",   searchEnd);
            } else {
                units = dao.getStorageUnits(id);
            }

            // Stats diện tích cho trang detail
            double warehouseArea = suDao.getWarehouseTotalArea(id);
            double usedArea      = suDao.getTotalUsedArea(id);
            double remainingArea = warehouseArea - usedArea;
            request.setAttribute("warehouseArea",  warehouseArea);
            request.setAttribute("usedArea",       usedArea);
            request.setAttribute("remainingArea",  remainingArea);

            // Calendar JSON
            Map<Integer, List<String[]>> unitBookedDates = dao.getUnitBookedDates(id);
            StringBuilder jsonBuilder = new StringBuilder("{");
            int count = 0;
            for (Map.Entry<Integer, List<String[]>> entry : unitBookedDates.entrySet()) {
                jsonBuilder.append("\"").append(entry.getKey()).append("\": [");
                List<String[]> dates = entry.getValue();
                for (int i = 0; i < dates.size(); i++) {
                    jsonBuilder.append("{")
                            .append("\"start\": \"").append(dates.get(i)[0]).append("\",")
                            .append("\"end\": \"").append(dates.get(i)[1]).append("T23:59:59\"")
                            .append("}");
                    if (i < dates.size() - 1) jsonBuilder.append(",");
                }
                jsonBuilder.append("]");
                if (count < unitBookedDates.size() - 1) jsonBuilder.append(",");
                count++;
            }
            jsonBuilder.append("}");

            request.setAttribute("unitEventsJson", jsonBuilder.toString().equals("{}") ? "{}" : jsonBuilder.toString());
            request.setAttribute("w",      w);
            request.setAttribute("images", images);
            request.setAttribute("units",  units);

            request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warehouse");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action        = request.getParameter("action");
        StorageUnitDAO suDao = new StorageUnitDAO();
        WarehouseManagementDAO whDao = new WarehouseManagementDAO(); // Khởi tạo DAO để lấy giá trị kho
        
        String warehouseIdRaw = request.getParameter("warehouseId");

        try {
            int warehouseId = Integer.parseInt(warehouseIdRaw);

            double area  = Double.parseDouble(request.getParameter("area"));
            int status   = Integer.parseInt(request.getParameter("status"));
            String description = request.getParameter("description") != null
                    ? request.getParameter("description").trim() : "";

            // ── TÍNH TOÁN GIÁ DỰA TRÊN DIỆN TÍCH VÀ WAREHOUSE PRICE_PER_M2 ──────────
            Warehouse warehouse = whDao.getWarehouseById(warehouseId);
            if (warehouse == null) {
                throw new Exception("Warehouse not found!");
            }
            
            int pricePerM2 = warehouse.getPricePerArea();
            if (pricePerM2 <= 0) {
                throw new Exception("Warehouse price per m² is not set. Please update warehouse information first.");
            }
            
            // Tính tổng giá = diện tích * giá/m2
            double calculatedPrice = area * pricePerM2;

            // ── Validate cơ bản ──────────────────────────────────────────
            if (area < 10) {
                throw new Exception("Area must be at least 10 m²!");
            }
            // Bỏ đi dòng check price < 1000000 ở code cũ vì giá đã tự động tính.

            // ── Validate diện tích không vượt quá warehouse ──────────────
            double warehouseTotalArea = suDao.getWarehouseTotalArea(warehouseId);

            if (warehouseTotalArea <= 0) {
                throw new Exception("Warehouse total area is not set. Please update warehouse information first.");
            }

            if ("insert".equals(action)) {
                double usedArea = suDao.getTotalUsedArea(warehouseId);
                double remaining = warehouseTotalArea - usedArea;
                if (area > remaining) {
                    throw new Exception(String.format(
                        "Not enough space! Remaining area: %.1f m², requested: %.1f m².", remaining, area));
                }

                // Generate unit code tự động
                String generatedCode = suDao.generateUnitCode(warehouseId);

                // Dùng calculatedPrice thay cho biến price truyền từ form
                boolean isSuccess = suDao.addStorageUnit(warehouseId, generatedCode, area, calculatedPrice, status ,description);
                if (!isSuccess) throw new Exception("Database error while adding new unit.");

                request.getSession().setAttribute("successMsg",
                    "New Storage Unit \"" + generatedCode + "\" added successfully!");

            } else if ("update".equals(action)) {
                int unitId = Integer.parseInt(request.getParameter("unitId"));

                double usedAreaExcluding = suDao.getTotalUsedAreaExcluding(warehouseId, unitId);
                double remaining = warehouseTotalArea - usedAreaExcluding;
                if (area > remaining) {
                    throw new Exception(String.format(
                        "Not enough space! Remaining area: %.1f m², requested: %.1f m².", remaining, area));
                }

                // Giữ nguyên unit code cũ khi update
                StorageUnit existing = suDao.getStorageUnitById(unitId);
                String unitCode = (existing != null) ? existing.getUnitCode() : "";

                // Dùng calculatedPrice thay cho biến price truyền từ form
                boolean isSuccess = suDao.updateStorageUnit(unitId, unitCode, area, calculatedPrice, status, description);
                if (!isSuccess) throw new Exception("Database error while updating unit.");

                request.getSession().setAttribute("successMsg", "Storage Unit updated successfully!");
            }

            response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseId);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", e.getMessage());

            if ("update".equals(action)) {
                String unitIdRaw = request.getParameter("unitId");
                response.sendRedirect(request.getContextPath()
                    + "/warehouse/detail?action=editUnit&unitId=" + unitIdRaw
                    + "&warehouseId=" + warehouseIdRaw);
            } else {
                response.sendRedirect(request.getContextPath()
                    + "/warehouse/detail?action=addUnit&warehouseId=" + warehouseIdRaw);
            }
        }
    }
}