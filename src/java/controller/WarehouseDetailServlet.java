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
import model.StorageUnit;
import model.Warehouse;
import model.WarehouseImage;
import java.util.Map;

@WebServlet(name = "WarehouseDetailController", urlPatterns = {"/warehouse/detail"})
public class WarehouseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        StorageUnitDAO suDao = new StorageUnitDAO();
        String action = request.getParameter("action");

        // =========================================================
        // 1. ĐIỀU HƯỚNG SANG TRANG FORM (DÙNG CHUNG CHO ADD & EDIT)
        // =========================================================
        if ("addUnit".equals(action)) {
            String warehouseId = request.getParameter("warehouseId");
            request.setAttribute("warehouseId", warehouseId);
            // Bỏ trống thuộc tính 'u', JSP sẽ tự hiểu là chức năng Thêm mới
            request.getRequestDispatcher("/Management/storage-unit-form.jsp").forward(request, response);
            return;
        }
        
        if ("editUnit".equals(action)) {
            int unitId = Integer.parseInt(request.getParameter("unitId"));
            String warehouseId = request.getParameter("warehouseId");
            
            StorageUnit unit = suDao.getStorageUnitById(unitId);
            
            // Có thuộc tính 'u', JSP sẽ điền dữ liệu và hiểu là chức năng Edit
            request.setAttribute("u", unit);
            request.setAttribute("warehouseId", warehouseId);
            
            request.getRequestDispatcher("/Management/storage-unit-form.jsp").forward(request, response);
            return;
        }

        // =========================================================
        // 2. LOGIC LOAD TRANG CHI TIẾT WAREHOUSE (VIEW DEFAULT)
        // =========================================================
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

            // LOGIC TÌM KIẾM STORAGE UNIT TRỐNG THEO NGÀY
            String searchStart = request.getParameter("searchStart");
            String searchEnd = request.getParameter("searchEnd");

            List<StorageUnit> units;

            if (searchStart != null && !searchStart.isEmpty() && searchEnd != null && !searchEnd.isEmpty()) {
                units = suDao.searchAvailableUnits(id, searchStart, searchEnd);
                request.setAttribute("searchStart", searchStart);
                request.setAttribute("searchEnd", searchEnd);
            } else {
                units = dao.getStorageUnits(id);
            }

            // TẠO DỮ LIỆU LỊCH (CALENDAR JSON)
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
                    if (i < dates.size() - 1) {
                        jsonBuilder.append(",");
                    }
                }
                jsonBuilder.append("]");
                if (count < unitBookedDates.size() - 1) {
                    jsonBuilder.append(",");
                }
                count++;
            }
            jsonBuilder.append("}");

            request.setAttribute("unitEventsJson", jsonBuilder.toString().equals("{}") ? "{}" : jsonBuilder.toString());
            request.setAttribute("w", w);
            request.setAttribute("images", images);
            request.setAttribute("units", units);

            request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warehouse");
        }
    }
   

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        StorageUnitDAO suDao = new StorageUnitDAO();
        String warehouseIdRaw = request.getParameter("warehouseId");
        
        try {
            int warehouseId = Integer.parseInt(warehouseIdRaw);
            
            // Lấy các dữ liệu dùng chung cho cả Insert và Update
            String unitCode = request.getParameter("unitCode").trim();
            double area = Double.parseDouble(request.getParameter("area"));
            double price = Double.parseDouble(request.getParameter("price"));
            int status = Integer.parseInt(request.getParameter("status"));
            String description = request.getParameter("description").trim();

            // ==========================================
            // BACKEND VALIDATION (Kiểm tra dữ liệu đầu vào)
            // ==========================================
            if (unitCode.isEmpty()) {
                throw new Exception("Storage Unit Code cannot be empty!");
            }
            if (area < 10) {
                throw new Exception("Area must be at least 10 sq ft!");
            }
            if (price < 1000000) {
                throw new Exception("Rent Price must be at least 1,000,000 VND!");
            }

            // XỬ LÝ THÊM MỚI (INSERT)
            if ("insert".equals(action)) {
                boolean isSuccess = suDao.addStorageUnit(warehouseId, unitCode, area, price, status, description);
                if (isSuccess) {
                    request.getSession().setAttribute("successMsg", "New Storage Unit added successfully!");
                } else {
                    throw new Exception("Database error while adding new unit.");
                }
            }
            // XỬ LÝ CẬP NHẬT (UPDATE)
            else if ("update".equals(action)) {
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                boolean isSuccess = suDao.updateStorageUnit(unitId, unitCode, area, price, status, description);
                if (isSuccess) {
                    request.getSession().setAttribute("successMsg", "Storage Unit updated successfully!");
                } else {
                    throw new Exception("Database error while updating unit.");
                }
            }

            // Thành công thì quay lại trang Detail
            response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseId);

        } catch (Exception e) {
            // Nếu có lỗi Validate, bắt tại đây và báo về giao diện FORM
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", e.getMessage());
            
            // Trả ngược lại đúng form đang thực hiện (Add hoặc Edit)
            if ("update".equals(action)) {
                String unitIdRaw = request.getParameter("unitId");
                response.sendRedirect(request.getContextPath() + "/warehouse/detail?action=editUnit&unitId=" + unitIdRaw + "&warehouseId=" + warehouseIdRaw);
            } else {
                response.sendRedirect(request.getContextPath() + "/warehouse/detail?action=addUnit&warehouseId=" + warehouseIdRaw);
            }
        }
    }
}