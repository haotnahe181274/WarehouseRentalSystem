package controller;

import jakarta.servlet.annotation.MultipartConfig;
import dao.WarehouseImageDAO;
import dao.WarehouseManagementDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import model.Warehouse;
import model.WarehouseImage;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseManagerController extends HttpServlet {

    // ================== PHẦN GET (HIỂN THỊ DANH SÁCH) ==================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra Login
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) { 
            response.sendRedirect("login"); 
            return; 
        }

        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        // --- Chuyển trang Form ADD ---
        if ("add".equals(action)) {
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // --- Chuyển trang Form EDIT ---
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Warehouse w = dao.getWarehouseById(id);
                request.setAttribute("warehouse", w);
            }
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // --- LẤY DANH SÁCH (Bỏ phân trang server, bỏ sort thủ công) ---
        List<Warehouse> list = dao.getAll();
        
        // --- LỌC THEO STATUS (Giống User module: Lọc Server-side, còn Search/Sort để Client) ---
        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            try {
                int status = Integer.parseInt(statusStr);
                // Lọc bằng Stream Java (hoặc có thể viết hàm DAO riêng nếu muốn)
                list = list.stream().filter(w -> w.getStatus() == status).toList();
            } catch (NumberFormatException e) {
                // Ignore lỗi ép kiểu
            }
        }

        // --- TẠO MAP ẢNH ---
        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();

        for (Warehouse w : list) { // Duyệt hết list (không phải pageList nữa)
            String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
            imageMap.put(w.getWarehouseId(), imgUrl);
        }

        // --- GỬI DỮ LIỆU SANG JSP ---
        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList", list); // Gửi toàn bộ list
        request.setAttribute("filterStatus", statusStr); // Để giữ trạng thái dropdown

        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== PHẦN POST (GIỮ NGUYÊN KHÔNG ĐỔI) ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ... (Giữ nguyên logic thêm/sửa/upload ảnh của bạn ở đây) ...
        // Copy lại y nguyên phần doPost cũ vào đây nhé, vì logic đó không cần đổi.
        // Để ngắn gọn mình không paste lại phần doPost cũ.
        
        // Chỉ lưu ý 1 điểm nhỏ: Sau khi xong thì redirect về trang danh sách:
        // response.sendRedirect(request.getContextPath() + "/warehouse");
        
        // LOGIC POST CŨ CỦA BẠN:
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String desc = request.getParameter("description");
            
            int status = 1;
            try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception e) {}

            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);
            if (idStr != null && !idStr.isEmpty()) {
                w.setWarehouseId(Integer.parseInt(idStr));
            }

            Part filePart = request.getPart("image");
            String errorMessage = null;

            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Tên kho không được để trống!";
            } else if (address == null || address.trim().isEmpty()) {
                errorMessage = "Địa chỉ không được để trống!";
            }

            if (errorMessage == null && filePart != null && filePart.getSize() > 0) {
                String mimeType = filePart.getContentType();
                if (mimeType == null || !mimeType.startsWith("image/")) {
                    errorMessage = "File tải lên không hợp lệ! Vui lòng chỉ chọn file ảnh.";
                } else if (filePart.getSize() > 5 * 1024 * 1024) {
                    errorMessage = "Ảnh quá nặng! Vui lòng chọn ảnh dưới 5MB.";
                }
            }

            if (errorMessage != null) {
                request.setAttribute("warehouse", w);
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
                return;
            }

            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId = 0;

            if (idStr != null && !idStr.trim().isEmpty()) {
                currentWarehouseId = Integer.parseInt(idStr);
                w.setWarehouseId(currentWarehouseId);
                dao.update(w);
            } else {
                currentWarehouseId = dao.insertReturnId(w);
            }

            if (currentWarehouseId > 0 && filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = currentWarehouseId + "_" + System.currentTimeMillis() + "_" + fileName;
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + uniqueFileName);

                WarehouseImageDAO imgDao = new WarehouseImageDAO();
                WarehouseImage img = new WarehouseImage();
                img.setImageUrl(uniqueFileName);
                img.setPrimary(true);
                img.setStatus(1);
                String ext = "jpg";
                if (fileName.contains(".")) {
                    ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                }
                img.setImageType(ext);
                Warehouse linkW = new Warehouse();
                linkW.setWarehouseId(currentWarehouseId);
                img.setWarehouse(linkW);
                imgDao.insertImage(img);
            }
            response.sendRedirect(request.getContextPath() + "/warehouse");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
        }
    }
}