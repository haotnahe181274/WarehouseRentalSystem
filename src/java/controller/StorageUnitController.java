package controller;

import dao.WarehouseManagementDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.StorageUnit;
import model.Warehouse;

@WebServlet(name = "StorageUnitController", urlPatterns = {"/warehouse/unit"})
public class StorageUnitController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nhận dữ liệu từ form
        String action = request.getParameter("action");
        String warehouseIdStr = request.getParameter("warehouseId");
        
        try {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            String unitCode = request.getParameter("unitCode");
            double area = Double.parseDouble(request.getParameter("area"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            int status = Integer.parseInt(request.getParameter("status"));

            // Khởi tạo đối tượng
            Warehouse w = new Warehouse();
            w.setWarehouseId(warehouseId);
            
            // StorageUnit(int unitId, String unitCode, int status, double area, double price, String description, Warehouse warehouse)
            StorageUnit unit = new StorageUnit(0, unitCode, status, area, price, description, w);
            WarehouseManagementDAO dao = new WarehouseManagementDAO();

            if ("add".equals(action)) {
                dao.insertStorageUnit(unit);
            } 
            else if ("edit".equals(action)) {
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                unit.setUnitId(unitId);
                dao.updateStorageUnit(unit);
            }

            // Xong việc thì quay lại đúng cái trang Chi tiết Kho đó
            response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + warehouseId);

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi (Có thể redirect kèm thông báo lỗi)
            response.sendRedirect(request.getContextPath() + "/warehouse/detail?id=" + request.getParameter("warehouseId") + "&error=true");
        }
    }
}