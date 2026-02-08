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
import java.util.ArrayList;
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

    private static final int PAGE_SIZE = 5;

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

        // --- LẤY DANH SÁCH & PHÂN TRANG ---
        List<Warehouse> list = dao.getAll();
        
        String keyword = request.getParameter("keyword");
        String statusStr = request.getParameter("status");

        if (keyword != null && !keyword.trim().isEmpty()) {
            String key = keyword.toLowerCase();
            list = list.stream().filter(w -> w.getName().toLowerCase().contains(key)).toList();
        }
        if (statusStr != null && !statusStr.isEmpty()) {
            int status = Integer.parseInt(statusStr);
            list = list.stream().filter(w -> w.getStatus() == status).toList();
        }

        String sort = request.getParameter("sort");
        if (sort != null) {
            if (sort.equals("asc")) list.sort((o1, o2) -> o1.getName().compareToIgnoreCase(o2.getName()));
            else if (sort.equals("desc")) list.sort((o1, o2) -> o2.getName().compareToIgnoreCase(o1.getName()));
        }

        int totalRecords = list.size();
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        
        int totalPage = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPage && totalPage > 0) page = totalPage;
        int offset = (page - 1) * PAGE_SIZE;
        
        List<Warehouse> pageList = (totalRecords == 0) ? new ArrayList<>() 
                                   : list.subList(offset, Math.min(offset + PAGE_SIZE, totalRecords));

        // --- TẠO MAP ẢNH ---
        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();

        for (Warehouse w : pageList) {
            String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
            imageMap.put(w.getWarehouseId(), imgUrl);
        }

        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPage);
        
        StringBuilder qs = new StringBuilder();
        if (keyword != null) qs.append("&keyword=").append(keyword);
        if (statusStr != null) qs.append("&status=").append(statusStr);
        if (sort != null) qs.append("&sort=").append(sort);
        request.setAttribute("queryString", qs.toString());

        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== PHẦN POST (XỬ LÝ THÊM/SỬA) - ĐÃ CÓ VALIDATION ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check Login
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // --- LẤY DỮ LIỆU TỪ FORM ---
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String desc = request.getParameter("description");
            
            int status = 1;
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception e) {}

            // Tạo object Warehouse (để giữ lại dữ liệu nếu bị lỗi)
            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);
            if (idStr != null && !idStr.isEmpty()) {
                w.setWarehouseId(Integer.parseInt(idStr));
            }

            // --- LẤY FILE ẢNH ĐỂ CHECK (Chưa lưu vội) ---
            Part filePart = request.getPart("image");
            
            // ================== BẮT ĐẦU VALIDATION ==================
            String errorMessage = null;

            // 1. Validate Text
            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Tên kho không được để trống!";
            } else if (address == null || address.trim().isEmpty()) {
                errorMessage = "Địa chỉ không được để trống!";
            }

            // 2. Validate Ảnh (Chỉ check nếu User có chọn file ảnh)
            if (errorMessage == null && filePart != null && filePart.getSize() > 0) {
                
                // Rule 2.1: Check loại file bằng ContentType (MIME Type)
                // Hàm này trả về kiểu như "image/jpeg", "image/png", "application/pdf"...
                String mimeType = filePart.getContentType();
                
                if (mimeType == null || !mimeType.startsWith("image/")) {
                    errorMessage = "File tải lên không hợp lệ! Vui lòng chỉ chọn file ảnh.";
                }
                
                // Rule 2.2: Check dung lượng (Max 5MB)
                // 5MB = 5 * 1024 * 1024 bytes
                else if (filePart.getSize() > 5 * 1024 * 1024) {
                    errorMessage = "Ảnh quá nặng! Vui lòng chọn ảnh dưới 5MB.";
                }
            }

            // --- NẾU CÓ LỖI -> TRẢ VỀ FORM ---
            if (errorMessage != null) {
                request.setAttribute("warehouse", w); // Gửi lại dữ liệu cũ
                request.setAttribute("errorMessage", errorMessage); // Gửi thông báo lỗi
                request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
                return; // Dừng code tại đây, không lưu vào DB
            }
            // ================== KẾT THÚC VALIDATION ==================


            // --- NẾU HỢP LỆ THÌ MỚI LƯU VÀO DB ---
            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId = 0;

            if (idStr != null && !idStr.trim().isEmpty()) {
                // Edit
                currentWarehouseId = Integer.parseInt(idStr);
                w.setWarehouseId(currentWarehouseId);
                dao.update(w);
            } else {
                // Add
                currentWarehouseId = dao.insertReturnId(w);
            }

            // --- XỬ LÝ LƯU FILE (Khi đã chắc chắn file ngon) ---
            if (currentWarehouseId > 0 && filePart != null && filePart.getSize() > 0) {
                
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = currentWarehouseId + "_" + System.currentTimeMillis() + "_" + fileName;
                
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                filePart.write(uploadPath + File.separator + uniqueFileName);

                // Insert vào DB Ảnh
                WarehouseImageDAO imgDao = new WarehouseImageDAO();
                WarehouseImage img = new WarehouseImage();
                img.setImageUrl(uniqueFileName);
                img.setPrimary(true);
                img.setStatus(1);
                
                // Lấy đuôi file để lưu vào cột Type (dù đã validate mimeType nhưng DB vẫn cần text đuôi file)
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