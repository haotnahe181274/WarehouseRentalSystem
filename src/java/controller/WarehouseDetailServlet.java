package controller;

import dao.WarehouseManagementDAO;
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

// Định nghĩa đường dẫn URL cho trang chi tiết
@WebServlet(name = "WarehouseDetailController", urlPatterns = {"/warehouse/detail"})
public class WarehouseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Lấy ID từ URL (ví dụ: /warehouse/detail?id=5)
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warehouse");
                return;
            }
            int id = Integer.parseInt(idRaw);

            // 2. Gọi DAO
            WarehouseManagementDAO dao = new WarehouseManagementDAO();
 
            // A. Lấy thông tin cơ bản của kho (Tên, địa chỉ, mô tả, min_price...)
            Warehouse w = dao.getWarehouseById(id);
            
            // Kiểm tra nếu không tìm thấy kho thì quay về trang danh sách
            if (w == null) {
                response.sendRedirect(request.getContextPath() + "/warehouse");
                return;
            }

            // B. Lấy danh sách ảnh (WarehouseImage object)
            List<WarehouseImage> images = dao.getWarehouseById(id);

            // C. Lấy danh sách các ô chứa/Zone (StorageUnit object)
            List<StorageUnit> units = dao.getStorageUnits(id);

            // 3. Đẩy dữ liệu sang JSP
            request.setAttribute("w", w);           // Để hiển thị tên, địa chỉ, giá...
            request.setAttribute("images", images); // Để hiển thị Gallery ảnh
            request.setAttribute("units", units);   // Để hiển thị sơ đồ Zone và Form đặt thuê

            // 4. Chuyển hướng đến file giao diện
            request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu id không phải số, quay về trang danh sách
            response.sendRedirect(request.getContextPath() + "/warehouse");
        }
    }
}