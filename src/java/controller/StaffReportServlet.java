package controller;

import dao.IncidentReportDAO;
import model.UserView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "StaffReportServlet", urlPatterns = {"/staffReport"})
public class StaffReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        // KIỂM TRA QUYỀN: Chỉ cho phép "Staff" vào trang này
        if (user == null || !user.getRole().equalsIgnoreCase("Staff")) {
            // Nếu không phải Staff, trả về lỗi 403 Forbidden
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này!");
            return;
        }

        IncidentReportDAO dao = new IncidentReportDAO();
        Object[] warehouseInfo = dao.getAssignedWarehouse(user.getId());

        if (warehouseInfo != null) {
            request.setAttribute("whId", warehouseInfo[0]);
            request.setAttribute("whName", warehouseInfo[1]);
        } else {
            request.setAttribute("error", "Tài khoản của bạn chưa được gán vào kho nào!");
        }

        request.getRequestDispatcher("staff_report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        UserView user = (UserView) session.getAttribute("user");

        // Bảo mật kép: Kiểm tra role một lần nữa trước khi lưu vào DB
        if (user == null || !user.getRole().equalsIgnoreCase("Staff")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String warehouseIdStr = request.getParameter("warehouse_id");

        if (warehouseIdStr != null && !warehouseIdStr.isEmpty()) {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            IncidentReportDAO dao = new IncidentReportDAO();
            boolean success = dao.insert(type, description, warehouseId, user.getId());

            if (success) {
                response.sendRedirect("staffReport?success=1"); // Hoặc redirect về trang danh sách
                return;
            }
        }
        
        request.setAttribute("error", "Gửi báo cáo thất bại!");
        doGet(request, response);
    }
}