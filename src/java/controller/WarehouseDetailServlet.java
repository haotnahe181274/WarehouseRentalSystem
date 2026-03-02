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
        
        // 1. XỬ LÝ ACTION TỪ GIAO DIỆN TRƯỚC (NẾU CÓ)
       if ("disable".equals(action)) {
            try {
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));

                // Gọi hàm DAO
                suDao.changeStorageUnit(unitId, 0); 
                
                // ==============================================================
                // THÊM DÒNG NÀY ĐỂ GỬI LỜI NHẮN THÀNH CÔNG VÀO SESSION
                request.getSession().setAttribute("successMsg", "Storage Unit has been successfully disabled!");
                // ==============================================================

                // Trở về trang cũ
                response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseId);
                return; 
            } catch (Exception e) {
                e.printStackTrace();
            }
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
}