package controller;

import dao.ContractDAO;
import dao.FeedbackDAO;
import dao.FeedbackResponseDAO;
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
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import model.Feedback;
import model.FeedbackResponse;
import model.StorageUnit;
import model.UserView;
import model.Warehouse;
import model.WarehouseImage;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(name = "WarehouseManagerController", urlPatterns = {"/warehouse"})
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
                           jsonBuilder.append("{")
                                      .append("\"title\": \"Đã Thuê\",") 
                                      .append("\"start\": \"").append(dates.get(i)[0]).append("\",")
                                      .append("\"end\": \"").append(dates.get(i)[1]).append("T23:59:59\",")
                                      .append("\"color\": \"#dc3545\",") 
                                      .append("\"textColor\": \"#ffffff\"") 
                                      .append("}");
                            if (i < dates.size() - 1) jsonBuilder.append(",");
                        }
                        jsonBuilder.append("]");
                        if (count < unitBookedDates.size() - 1) jsonBuilder.append(",");
                        count++;
                    }
                    jsonBuilder.append("}");
                    
                    request.setAttribute("unitEventsJson", jsonBuilder.toString().equals("{}") ? "{}" : jsonBuilder.toString());
                    // ==========================================
                    request.setAttribute("w", w);
                    request.setAttribute("images", images);
                    request.setAttribute("units", units);

                    FeedbackDAO feedbackDAO = new FeedbackDAO();
                    List<Feedback> feedbackList = feedbackDAO.getFeedbackByWarehouseId(id);
                    request.setAttribute("feedbackList", feedbackList);
                    request.setAttribute("warehouseId", id);

                    // Fetch responses
                    FeedbackResponseDAO responseDAO = new FeedbackResponseDAO();
                    Map<Integer, FeedbackResponse> feedbackResponses = responseDAO.getResponsesByWarehouseId(id);
                    request.setAttribute("feedbackResponses", feedbackResponses);

                    // Check permissions
                    UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;
                    boolean canFeedback = false;
                    boolean canReply = false;

                    if (user != null) {
                        if ("RENTER".equalsIgnoreCase(user.getType())) {
                            ContractDAO contractDAO = new ContractDAO();
                            int contractId = contractDAO.getValidContractId(user.getId(), id);
                            if (contractId != -1) {
                                canFeedback = true;
                            }
                        }
                        if ("MANAGER".equalsIgnoreCase(user.getRole())
                                || "ADMIN".equalsIgnoreCase(user.getRole())
                                || "Internal".equalsIgnoreCase(user.getType())) {
                            canReply = true;
                        }
                    }
                    request.setAttribute("canFeedback", canFeedback);
                    request.setAttribute("canReply", canReply);
                    // ==========================================

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

        // ========================================================================
        // --- ACTION: LIST (MẶC ĐỊNH) CÓ PHÂN TRANG ---
        // ========================================================================
        // 0. Fetch counts for stats cards
        int totalWarehousesCount = dao.countTotal();
        int activeWarehousesCount = dao.countByStatus(1);
        int inactiveWarehousesCount = dao.countByStatus(0);
        request.setAttribute("totalWarehouses", totalWarehousesCount);
        request.setAttribute("activeWarehouses", activeWarehousesCount);
        request.setAttribute("inactiveWarehouses", inactiveWarehousesCount);

        List<Warehouse> list = dao.getAll();
        
        // 1. Lọc theo Status (Giữ nguyên logic của bạn)
        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            try {
                int status = Integer.parseInt(statusStr);
                list = list.stream()
                           .filter(w -> w.getStatus() == status)
                           .collect(Collectors.toList());
            } catch (NumberFormatException e) {}
        }

        // 2. LOGIC PHÂN TRANG
        int page = 1;
        int pageSize = 10; // Mặc định hiển thị 10 dòng 1 trang

        // Lấy page từ URL
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (Exception e) {}
        }
        
        // Lấy pageSize từ Form Filter (nếu người dùng đổi select option)
        String pageSizeStr = request.getParameter("pageSize");
        if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            try { pageSize = Integer.parseInt(pageSizeStr); } catch (Exception e) {}
        }

        int totalRecords = list.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Đảm bảo người dùng không nhập page linh tinh (như page = 1000 trong khi chỉ có 3 trang)
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        // Cắt danh sách theo trang hiện tại (In-memory Pagination)
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalRecords);
        List<Warehouse> paginatedList = new ArrayList<>();
        if (start < totalRecords) {
            paginatedList = list.subList(start, end);
        }

        // 3. Lấy ảnh đại diện (Đã tối ưu: CHỈ LẤY ẢNH CHO CÁC RECORD Ở TRANG HIỆN TẠI)
        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();
        for (Warehouse w : paginatedList) { 
            String imgUrl = imgDao.getPrimaryImage(w.getWarehouseId());
            imageMap.put(w.getWarehouseId(), imgUrl);
        }

        // 4. Tạo queryString để giữ lại bộ lọc khi bấm Next/Prev
        StringBuilder queryString = new StringBuilder();
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            queryString.append("&status=").append(statusStr);
        }
        if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            queryString.append("&pageSize=").append(pageSizeStr);
        }

        // 5. Gửi dữ liệu ra giao diện (JSP)
        request.setAttribute("warehouseList", paginatedList); // Đã thay 'list' bằng 'paginatedList'
        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("filterStatus", statusStr); 
        
        // Gửi dữ liệu cho component pagination.jsp
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("paginationUrl", request.getContextPath() + "/warehouse");
        request.setAttribute("queryString", queryString.toString());

        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== PHẦN POST (GIỮ NGUYÊN) ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... Code doPost của bạn giữ nguyên, không cần thay đổi gì cả
    }
}