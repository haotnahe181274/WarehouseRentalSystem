package controller;

import jakarta.servlet.annotation.MultipartConfig;
import dao.WarehouseImageDAO;
import dao.WarehouseManagementDAO;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import model.StorageUnit;
import model.Warehouse;
import model.WarehouseImage;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseManagerController extends HttpServlet {

    // ================== PHẦN GET (HIỂN THỊ & ĐIỀU HƯỚNG) ==================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra Login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        // --- ACTION: ADD ---
        if ("add".equals(action)) {
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // ========================================================================
        // --- ACTION: VIEW ---
        // ========================================================================
       if ("view".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    
                    Warehouse w = dao.getWarehouseById(id);
                    List<WarehouseImage> images = dao.getWarehouseImages(id);
                    List<StorageUnit> units = dao.getStorageUnits(id);

                  // ==========================================
                    // TẠO DỮ LIỆU LỊCH CHO TỪNG ZONE
                    // ==========================================
                    Map<Integer, List<String[]>> unitBookedDates = dao.getUnitBookedDates(id);
                    StringBuilder jsonBuilder = new StringBuilder("{");
                    
                    int count = 0;
                    for (Map.Entry<Integer, List<String[]>> entry : unitBookedDates.entrySet()) {
                        jsonBuilder.append("\"").append(entry.getKey()).append("\": [");
                        List<String[]> dates = entry.getValue();
                        
                        for (int i = 0; i < dates.size(); i++) {
                           // Sửa lại đoạn nối chuỗi sự kiện trong Java
                            jsonBuilder.append("{")
                                       .append("\"title\": \"Đã Thuê\",") // Thêm tiêu đề sự kiện
                                       .append("\"start\": \"").append(dates.get(i)[0]).append("\",")
                                       .append("\"end\": \"").append(dates.get(i)[1]).append("T23:59:59\",")
                                       .append("\"color\": \"#dc3545\",") // Đổi sang màu đỏ đậm (Danger) cho nổi bật
                                       .append("\"textColor\": \"#ffffff\"") // Chữ màu trắng
                                       .append("}");
                            if (i < dates.size() - 1) jsonBuilder.append(",");
                        }
                        jsonBuilder.append("]");
                        if (count < unitBookedDates.size() - 1) jsonBuilder.append(",");
                        count++;
                    }
                    jsonBuilder.append("}");
                    
                    // Gửi chuỗi JSON siêu to khổng lồ này sang JSP
                    request.setAttribute("unitEventsJson", jsonBuilder.toString().equals("{}") ? "{}" : jsonBuilder.toString());
                    // ==========================================
                    request.setAttribute("w", w);
                    request.setAttribute("images", images);
                    request.setAttribute("units", units);

                    request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);
                    return;
                } catch (Exception e) {}
            }
        }
        

        // --- ACTION: EDIT ---
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

        // --- ACTION: LIST (MẶC ĐỊNH) ---
        List<Warehouse> list = dao.getAll();
        
        // Lọc theo Status
        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            try {
                int status = Integer.parseInt(statusStr);
                list = list.stream()
                           .filter(w -> w.getStatus() == status)
                           .collect(Collectors.toList());
            } catch (NumberFormatException e) {}
        }

        // Lấy ảnh đại diện
        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();
        for (Warehouse w : list) { 
            String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
            imageMap.put(w.getWarehouseId(), imgUrl);
        }

        // Gửi dữ liệu sang JSP danh sách
        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList", list); 
        request.setAttribute("filterStatus", statusStr); 

        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== PHẦN POST (ĐÃ CẬP NHẬT UP NHIỀU ẢNH) ==================
  @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1. Nhận dữ liệu text từ form
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String desc = request.getParameter("description");
            
            int status = 1;
            int typeId = 1; 
            
            try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception e) {}
            try { typeId = Integer.parseInt(request.getParameter("warehouseTypeId")); } catch (Exception e) {}

            boolean isEdit = (idStr != null && !idStr.trim().isEmpty());

            // 2. Map vào Object Warehouse
            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);
            if (isEdit) w.setWarehouseId(Integer.parseInt(idStr));
            
            model.WarehouseType type = new model.WarehouseType();
            type.setWarehouseTypeId(typeId); 
            w.setWarehouseType(type);

            // ==========================================
            // 3. XỬ LÝ NHIỀU FILE ẢNH & VALIDATION
            // ==========================================
            List<Part> fileParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    fileParts.add(part);
                }
            }

            String errorMessage = null;

            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Tên kho không được để trống!";
            } else if (address == null || address.trim().isEmpty()) {
                errorMessage = "Địa chỉ không được để trống!";
            }

            // Logic Validation file ảnh theo yêu cầu
            if (errorMessage == null && !fileParts.isEmpty()) {
                for (Part filePart : fileParts) {
                    // Check dung lượng (5MB = 5 * 1024 * 1024 bytes)
                    if (filePart.getSize() > 5 * 1024 * 1024) {
                        errorMessage = "Có ảnh dung lượng lớn hơn 5MB! Vui lòng chọn lại.";
                        break; // Dừng check nếu có 1 file vi phạm
                    }

                    // Check định dạng file dựa trên đuôi mở rộng (extension)
                    String submittedFileName = filePart.getSubmittedFileName();
                    if (submittedFileName == null || !submittedFileName.contains(".")) {
                        errorMessage = "File tải lên không hợp lệ!";
                        break;
                    }
                    
                    String ext = submittedFileName.substring(submittedFileName.lastIndexOf(".") + 1).toLowerCase();
                    if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                        errorMessage = "Chỉ hỗ trợ file ảnh định dạng .png, .jpg, .jpeg";
                        break;
                    }
                }
            }

            // Nếu có lỗi -> Trả về form cùng thông báo
            if (errorMessage != null) {
                request.setAttribute("warehouse", w);
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
                return;
            }

            // ==========================================
            // 4. LƯU THÔNG TIN KHO VÀO DB
            // ==========================================
            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId = 0;

            if (isEdit) {
                currentWarehouseId = w.getWarehouseId();
                dao.update(w);
            } else {
                currentWarehouseId = dao.insertReturnId(w);
            }

            // ==========================================
            // 5. LƯU TẤT CẢ FILE ẢNH VÀO Ổ CỨNG VÀ DB
            // ==========================================
            if (currentWarehouseId > 0 && !fileParts.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                WarehouseImageDAO imgDao = new WarehouseImageDAO();
                boolean isFirstImage = true; 

                for (int i = 0; i < fileParts.size(); i++) {
                    Part filePart = fileParts.get(i);
                    String submittedFileName = filePart.getSubmittedFileName();
                    
                    // Nối thêm biến 'i' để không bị trùng tên khi up nhiều file cùng lúc
                    String uniqueFileName = currentWarehouseId + "_" + System.currentTimeMillis() + "_" + i + "_" + submittedFileName;
                    
                    // Lưu file vật lý
                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    // Insert database
                    WarehouseImage img = new WarehouseImage();
                    img.setImageUrl(uniqueFileName);
                    
                    if (!isEdit && isFirstImage) {
                        img.setPrimary(true);
                        isFirstImage = false;
                    } else {
                        img.setPrimary(false);
                    }
                    
                    img.setStatus(1);
                    
                    // Lấy đuôi mở rộng lưu vào DB (đã chắc chắn an toàn qua bước validation)
                    String ext = submittedFileName.substring(submittedFileName.lastIndexOf(".") + 1).toLowerCase();
                    img.setImageType(ext);
                    
                    Warehouse linkW = new Warehouse();
                    linkW.setWarehouseId(currentWarehouseId);
                    img.setWarehouse(linkW);
                    
                    imgDao.insertImage(img);
                }
            }

            // 6. Xong -> Redirect về list
            response.sendRedirect(request.getContextPath() + "/warehouse");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
        }
    }
}