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

        // 1. Kiểm tra Login (Quan trọng: Key phải khớp với bên LoginController)
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) { // Lưu ý: Check kỹ xem bạn lưu là "account" hay "user"
            response.sendRedirect("login"); 
            return; 
        }

        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        // --- Xử lý chuyển trang sang Form ADD ---
        if ("add".equals(action)) {
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // --- Xử lý chuyển trang sang Form EDIT ---
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

        // --- LẤY DANH SÁCH VÀ PHÂN TRANG (Logic cũ của Hiếu giữ nguyên) ---
        List<Warehouse> list = dao.getAll();
        
        // Filter logic...
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

        // Sort logic...
        String sort = request.getParameter("sort");
        if (sort != null) {
            if (sort.equals("asc")) list.sort((o1, o2) -> o1.getName().compareToIgnoreCase(o2.getName()));
            else if (sort.equals("desc")) list.sort((o1, o2) -> o2.getName().compareToIgnoreCase(o1.getName()));
        }

        // Pagination logic...
        int totalRecords = list.size();
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        
        int totalPage = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPage && totalPage > 0) page = totalPage;
        int offset = (page - 1) * PAGE_SIZE;
        
        List<Warehouse> pageList = (totalRecords == 0) ? new ArrayList<>() 
                                   : list.subList(offset, Math.min(offset + PAGE_SIZE, totalRecords));

        // --- TẠO MAP ẢNH ĐỂ HIỂN THỊ ---
        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();

        for (Warehouse w : pageList) {
            String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
            // Nếu không có ảnh trong DB thì gán tên ảnh mặc định
            imageMap.put(w.getWarehouseId(), imgUrl);
        }

        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPage);
        
        // Build Query String cho phân trang giữ filter
        StringBuilder qs = new StringBuilder();
        if (keyword != null) qs.append("&keyword=").append(keyword);
        if (statusStr != null) qs.append("&status=").append(statusStr);
        if (sort != null) qs.append("&sort=").append(sort);
        request.setAttribute("queryString", qs.toString());

        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== PHẦN POST (XỬ LÝ THÊM/SỬA) ==================
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
            // 2. Lấy dữ liệu Text
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

            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId = 0; 

            // 3. Logic: ADD hay EDIT?
            if (idStr != null && !idStr.trim().isEmpty()) {
                // --- CASE EDIT ---
                currentWarehouseId = Integer.parseInt(idStr);
                w.setWarehouseId(currentWarehouseId);
                dao.update(w); // Cần có hàm update trong DAO
                System.out.println("DEBUG: Đã UPDATE kho ID: " + currentWarehouseId);
            } else {
                // --- CASE ADD ---
                currentWarehouseId = dao.insertReturnId(w);
                System.out.println("DEBUG: Đã ADD kho mới ID: " + currentWarehouseId);
            }

            // 4. Xử lý Ảnh (Chỉ chạy khi User chọn file)
            Part filePart = request.getPart("image");
            
            if (currentWarehouseId > 0 && filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file unique
                    String uniqueFileName = currentWarehouseId + "_" + System.currentTimeMillis() + "_" + fileName;
                    
                    // Lưu file vào thư mục server
                    String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    filePart.write(uploadPath + File.separator + uniqueFileName);
                    
                    // Lưu vào DB
                    WarehouseImageDAO imgDao = new WarehouseImageDAO();
                    WarehouseImage img = new WarehouseImage();
                    
                    img.setImageUrl(uniqueFileName);
                    img.setPrimary(true); // Ảnh mới nhất luôn là ảnh chính
                    img.setStatus(1);
                    
                    String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".") + 1) : "jpg";
                    img.setImageType(ext);
                    
                    Warehouse linkW = new Warehouse();
                    linkW.setWarehouseId(currentWarehouseId);
                    img.setWarehouse(linkW); // Gắn ID kho vào ảnh
                    
                    imgDao.insertImage(img);
                    System.out.println("DEBUG: Đã lưu ảnh mới cho ID: " + currentWarehouseId);
                }
            } else {
                System.out.println("DEBUG: Không có ảnh mới được upload. Giữ nguyên ảnh cũ (nếu có).");
            }

            response.sendRedirect(request.getContextPath() + "/warehouse");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("LỖI: " + e.getMessage());
        }
    }
}