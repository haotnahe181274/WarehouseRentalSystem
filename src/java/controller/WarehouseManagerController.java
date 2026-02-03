package controller;

import dao.WarehouseManagementDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Warehouse;

@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseManagerController extends HttpServlet {

    private static final int PAGE_SIZE = 5;
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        WarehouseManagementDAO dao = new WarehouseManagementDAO();
//        String action = request.getParameter("action");
//
//        // 1. Xử lý Delete trước (nếu có)
//        if ("delete".equals(action)) {
//            String idStr = request.getParameter("id");
//            if (idStr != null && !idStr.isEmpty()) {
//                dao.delete(Integer.parseInt(idStr));
//            }
//            response.sendRedirect("warehouse");
//            return;
//        }
//
//        // 2. Lấy TOÀN BỘ danh sách ban đầu
//        List<Warehouse> list = dao.getAll();
//
//        // 3. --- LỌC (SEARCH) ---
//        // Phải lọc TRƯỚC khi tính toán số trang
//        String keyword = request.getParameter("keyword");
//        String statusStr = request.getParameter("status");
//
//        if (keyword != null && !keyword.trim().isEmpty()) {
//            String key = keyword.toLowerCase();
//            list = list.stream()
//                    .filter(w -> w.getName().toLowerCase().contains(key))
//                    .toList(); // Java 16+
//            // Nếu dùng Java cũ hơn 16 dùng: .collect(Collectors.toList());
//        }
//
//        if (statusStr != null && !statusStr.isEmpty()) {
//            int status = Integer.parseInt(statusStr);
//            list = list.stream()
//                    .filter(w -> w.getStatus() == status)
//                    .toList();
//        }
//
//        // 4. --- SẮP XẾP (SORT) ---
//        String sort = request.getParameter("sort");
//        if (sort != null) {
//            if (sort.equals("asc")) {
//                list.sort((o1, o2) -> o1.getName().compareToIgnoreCase(o2.getName()));
//            } else if (sort.equals("desc")) {
//                list.sort((o1, o2) -> o2.getName().compareToIgnoreCase(o1.getName()));
//            }
//        }
//
//        // 5. --- PHÂN TRANG (PAGING) ---
//        // QUAN TRỌNG: Bây giờ mới được tính size
//        int totalRecords = list.size();
//        int page = 1;
//        String pageParam = request.getParameter("page");
//        if (pageParam != null && !pageParam.isEmpty()) {
//            try {
//                page = Integer.parseInt(pageParam);
//            } catch (NumberFormatException e) {
//                page = 1;
//            }
//        }
//
//        int totalPage = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
//
//        // Kiểm tra trang hợp lệ (Nếu đang ở trang 2 mà lọc ra 1 kết quả thì phải về trang 1)
//        if (page > totalPage) {
//            page = (totalPage == 0) ? 1 : totalPage;
//        }
//
//        int offset = (page - 1) * PAGE_SIZE;
//
//        // Cắt list an toàn
//        List<Warehouse> pageList;
//        if (totalRecords == 0) {
//            pageList = new java.util.ArrayList<>();
//        } else {
//            int toIndex = Math.min(offset + PAGE_SIZE, totalRecords);
//            pageList = list.subList(offset, toIndex);
//        }
//
//        // 6. Gửi dữ liệu sang JSP
//        request.setAttribute("warehouseList", pageList);
//        request.setAttribute("currentPage", page);
//        request.setAttribute("totalPage", totalPage);
//
//        // Lưu lại các từ khóa để JSP giữ lại trong ô input sau khi reload
//        request.setAttribute("paramKeyword", keyword);
//        request.setAttribute("paramStatus", statusStr);
//        request.setAttribute("paramSort", sort);
//
//        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
//    }
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    WarehouseManagementDAO dao = new WarehouseManagementDAO();
    String action = request.getParameter("action");
    
    // --- DELETE (Chỉ Admin) ---
    if ("delete".equals(action)) {
        // Có thể thêm check role ở đây nếu muốn bảo mật backend
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            dao.delete(Integer.parseInt(idStr));
        }
        response.sendRedirect("warehouse");
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
        pageList = new java.util.ArrayList<>();
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

    // --- SEND ATTRIBUTES ---
    request.setAttribute("warehouseList", pageList);
    
    // Các biến cần thiết cho component pagination.jsp
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPage); // Lưu ý: pagination.jsp bên User dùng 'totalPages' (có 's')
    request.setAttribute("paginationUrl", request.getContextPath() + "/warehouse");
    request.setAttribute("queryString", qs.toString());

    request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String desc = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

         
        
        Warehouse w = new Warehouse(0, name, address, desc, status, null);

        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        dao.insert(w);

        response.sendRedirect("warehouse");
    }
}
