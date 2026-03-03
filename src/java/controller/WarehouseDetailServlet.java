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
        if ("editUnit".equals(action)) {
            int unitId = Integer.parseInt(request.getParameter("unitId"));
            String warehouseId = request.getParameter("warehouseId");
            
            StorageUnit unit = suDao.getStorageUnitById(unitId);
            
            request.setAttribute("u", unit);
            request.setAttribute("warehouseId", warehouseId);
            
            // Thay đường dẫn này bằng thư mục thực tế chứa file edit của bạn
            request.getRequestDispatcher("/Management/edit-storage-unit.jsp").forward(request, response);
            return;
        }

        // 2. LOGIC LOAD TRANG CHI TIẾT (VIEW)
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

            // ==============================================================
            // LOGIC MỚI: TÌM KIẾM STORAGE UNIT TRỐNG THEO NGÀY
            // ==============================================================
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
            // ==============================================================

            // Tạo dữ liệu cho Lịch (Calendar JSON)
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

        // XỬ LÝ CẬP NHẬT (EDIT)
        if ("update".equals(action)) {
            String warehouseIdRaw = request.getParameter("warehouseId");
            try {
                int warehouseId = Integer.parseInt(warehouseIdRaw);
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                
                // Lấy dữ liệu và loại bỏ khoảng trắng thừa ở 2 đầu
                String unitCode = request.getParameter("unitCode").trim();
                String description = request.getParameter("description").trim();
                int status = Integer.parseInt(request.getParameter("status"));

                // ==========================================
                // BACKEND VALIDATION (Chống hack/nhập sai)
                // ==========================================
                if (unitCode.isEmpty()) {
                    throw new Exception("Storage Unit Code cannot be empty!");
                }

                double area = Double.parseDouble(request.getParameter("area"));
                double price = Double.parseDouble(request.getParameter("price"));

                if (area <= 0) {
                    throw new Exception("Area must be greater than 0!");
                }
                if (price < 0) {
                    throw new Exception("Price cannot be negative!");
                }
                // ==========================================

                // Gọi DAO để update
                boolean isSuccess = suDao.updateStorageUnit(unitId, unitCode, area, price, status, description);
                
                if (isSuccess) {
                    request.getSession().setAttribute("successMsg", "Storage Unit updated successfully!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Failed to update. System error!");
                }
                
                // Thành công thì quay lại trang Detail
                response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseId);
                return;

            } catch (Exception e) {
                // Nếu lỗi Validate, gửi thông báo lỗi màu đỏ về giao diện
                e.printStackTrace();
                request.getSession().setAttribute("errorMsg", "Update failed: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseIdRaw);
                return;
            }
        }
    }
}