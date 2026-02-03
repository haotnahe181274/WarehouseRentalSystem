package controller;

import jakarta.servlet.annotation.MultipartConfig; // <-- PHẢI IMPORT CÁI NÀY
import java.util.Map;
import java.util.HashMap;
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

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    WarehouseManagementDAO dao = new WarehouseManagementDAO();
    String action = request.getParameter("action");
   
    
    // --- [MỚI] 2. Xử lý ADD (Chuyển sang trang Form) ---
    if ("add".equals(action)) {
        // Chuyển hướng sang file JSP nhập liệu (sẽ tạo ở bước 2)
        request.getRequestDispatcher("Management/warehouse-form.jsp").forward(request, response);
        return; // Dừng code tại đây, không chạy xuống phần lấy danh sách nữa
    }

    // --- [MỚI] 3. Xử lý EDIT (Chuyển sang trang Form và đẩy dữ liệu cũ lên) ---
    if ("edit".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Warehouse w = dao.getWarehouseById(id); // Bạn cần có hàm này trong DAO
            request.setAttribute("warehouse", w);
        }
        request.getRequestDispatcher("Management/warehouse-form.jsp").forward(request, response);
        return;
    }
        
    
    // --- GET DATA ---
    List<Warehouse> list = dao.getAll();

    // --- FILTER ---
    String keyword = request.getParameter("keyword");
    String statusStr = request.getParameter("status");

    if (keyword != null && !keyword.trim().isEmpty()) {
        String key = keyword.toLowerCase();
        list = list.stream()
                   .filter(w -> w.getName().toLowerCase().contains(key))
                   .toList(); 
    }
    
    if (statusStr != null && !statusStr.isEmpty()) {
        int status = Integer.parseInt(statusStr);
        list = list.stream()
                   .filter(w -> w.getStatus() == status)
                   .toList();
    }

    // --- SORT ---
    String sort = request.getParameter("sort");
    if (sort != null) {
        if (sort.equals("asc")) {
            list.sort((o1, o2) -> o1.getName().compareToIgnoreCase(o2.getName()));
        } else if (sort.equals("desc")) {
            list.sort((o1, o2) -> o2.getName().compareToIgnoreCase(o1.getName()));
        }
    }

    // --- PAGING CALCULATION ---
    int totalRecords = list.size();
    int page = 1;
    try {
        page = Integer.parseInt(request.getParameter("page"));
    } catch (NumberFormatException e) {
        page = 1;
    }

    int totalPage = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
    if (page > totalPage && totalPage > 0) page = totalPage;
    
    int offset = (page - 1) * PAGE_SIZE;
    
    List<Warehouse> pageList;
    if (totalRecords == 0) {
        pageList = new ArrayList<>();
    } else {
        int toIndex = Math.min(offset + PAGE_SIZE, totalRecords);
        pageList = list.subList(offset, toIndex);
    }


    // --- BUILD QUERY STRING (Quan trọng cho Pagination tái sử dụng) ---
    StringBuilder qs = new StringBuilder();
    try {
        if (keyword != null && !keyword.isEmpty()) {
            qs.append("&keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        if (statusStr != null && !statusStr.isEmpty()) {
            qs.append("&status=").append(statusStr);
        }
        if (sort != null && !sort.isEmpty()) {
            qs.append("&sort=").append(sort);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Cắt list an toàn (Code cũ)
   
    // === [CODE MỚI: TẠO MAP ẢNH] ===
    // Map này sẽ lưu: Key = ID kho, Value = URL ảnh
    Map<Integer, String> imageMap = new HashMap<>();
    WarehouseImageDAO imgDao = new WarehouseImageDAO();

    for (Warehouse w : pageList) {
        String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
        
        if (imgUrl == null || imgUrl.trim().isEmpty()) {
            imgUrl = "default-warehouse.jpg";
        }
        
        // Lưu vào Map thay vì set vào Model
        imageMap.put(w.getWarehouseId(), imgUrl);
    }

    // Gửi Map sang JSP với tên là "warehouseImages"
    request.setAttribute("warehouseImages", imageMap);
    // ===============================

    request.setAttribute("warehouseList", pageList);
    
    // --- SEND ATTRIBUTES ---
    request.setAttribute("warehouseList", pageList);
    
    // Các biến cần thiết cho component pagination.jsp
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPage); // Lưu ý: pagination.jsp bên User dùng 'totalPages' (có 's')
    request.setAttribute("paginationUrl", request.getContextPath() + "/warehouse");
    request.setAttribute("queryString", qs.toString());

    request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
}


    // ... (Giữ nguyên hàm doGet của bạn ở đây) ...

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Lấy thông tin text
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String desc = request.getParameter("description");
            // Xử lý status an toàn hơn
            int status = 1;
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception e) {}

            // 2. Insert Warehouse
            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);

            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            
            // --- DEBUG LOG 1 ---
            System.out.println("DEBUG: Bắt đầu insert Warehouse...");
            
            int newWarehouseId = dao.insertReturnId(w); 
            
            // --- DEBUG LOG 2 ---
            System.out.println("DEBUG: ID vừa tạo là: " + newWarehouseId);

            // 3. Xử lý Upload Ảnh
            Part filePart = request.getPart("image");
            
            if (newWarehouseId > 0 && filePart != null && filePart.getSize() > 0) {
                
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = newWarehouseId + "_" + System.currentTimeMillis() + "_" + fileName;

                // Đường dẫn lưu file
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                
                // --- DEBUG LOG 3 ---
                System.out.println("DEBUG: Đường dẫn lưu ảnh: " + uploadPath);
                
                // SỬA LỖI: Dùng mkdirs() thay vì mkdir()
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs(); 
                    System.out.println("DEBUG: Đã tạo thư mục mới? " + created);
                }

                // Lưu file
                filePart.write(uploadPath + File.separator + uniqueFileName);
                System.out.println("DEBUG: Ghi file thành công!");

                // 4. Lưu vào Database
                WarehouseImageDAO imgDao = new WarehouseImageDAO();
                WarehouseImage img = new WarehouseImage();
                img.setImageUrl(uniqueFileName);
                img.setPrimary(true);
                img.setStatus(1);
                
                // Lấy đuôi file làm imageType (ví dụ: jpg, png)
                String ext = "jpg";
                if(fileName.contains(".")) ext = fileName.substring(fileName.lastIndexOf(".") + 1);
                img.setImageType(ext);
                
                Warehouse linkW = new Warehouse();
                linkW.setWarehouseId(newWarehouseId);
                img.setWarehouse(linkW);

                imgDao.insertImage(img);
                System.out.println("DEBUG: Đã insert ảnh vào DB");
            } else {
                System.out.println("DEBUG: Không lưu ảnh vì: ID=" + newWarehouseId + ", FilePart=" + (filePart==null?"null":"ok") + ", Size=" + (filePart!=null?filePart.getSize():0));
            }

            response.sendRedirect("warehouse");
            
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra màn hình console nếu có
            response.getWriter().println("LỖI: " + e.getMessage());
        }
    }
}