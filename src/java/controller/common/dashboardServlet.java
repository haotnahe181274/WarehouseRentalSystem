package controller.common;

import dao.DashboardDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserView;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class dashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {      
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        
        int userId = user.getId();
        
        UserDAO daou = new UserDAO();
        String roleId = daou.getUserById(userId, "Internal").getRole();        
        DashboardDAO dao = new DashboardDAO();

        // Xử lý luồng dữ liệu theo Role
        if ("Manager".equalsIgnoreCase(roleId) || "Admin".equalsIgnoreCase(roleId)) {
            int totalUsers = dao.getTotalUsers();
            int totalWarehouses = dao.getTotalWarehouses();
            int totalBookings = dao.getTotalBookings();
            double monthlyRevenue = dao.getMonthlyRevenue();

            String formattedRevenue = String.format("%.1fM", monthlyRevenue / 1000000.0);

            request.setAttribute("totalUsers", String.format("%,d", totalUsers));
            request.setAttribute("totalWarehouses", String.format("%,d", totalWarehouses));
            request.setAttribute("totalBookings", String.format("%,d", totalBookings));
            request.setAttribute("monthlyRevenue", formattedRevenue);

            // --- XỬ LÝ BIỂU ĐỒ 1: REVENUE (DOANH THU) ---
            Map<String, Double> revenueMap = dao.getRevenueByMonth();
            request.setAttribute("revenueLabels", convertKeysToJsonArray(revenueMap));
            request.setAttribute("revenueData", convertValuesToJsonArray(revenueMap));

            // --- XỬ LÝ BIỂU ĐỒ 2: BOOKINGS ---
            Map<String, Integer> bookingMap = dao.getBookingsByMonth();
            request.setAttribute("bookingLabels", convertKeysToJsonArray(bookingMap));
            request.setAttribute("bookingData", convertValuesToJsonArray(bookingMap));

        } else if ("Staff".equalsIgnoreCase(roleId)) {
            int pendingTasks = dao.getPendingTasks(userId);
            int completedTasks = dao.getCompletedTasks(userId);

            request.setAttribute("pendingTasks", pendingTasks);
            request.setAttribute("completedTasks", completedTasks);
        }

        request.getRequestDispatcher("Common/Layout/dashboard.jsp").forward(request, response);
    }
    
    // ========================================================
    // CÁC HÀM HỖ TRỢ ĐỊNH DẠNG JSON CHO CHART.JS
    // ========================================================

    private String convertKeysToJsonArray(Map<String, ?> map) {
        if (map == null || map.isEmpty()) return "['No Data']";
        StringBuilder sb = new StringBuilder("[");
        for (String key : map.keySet()) {
            sb.append("'").append(key).append("',");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append("]");
        return sb.toString();
    }

    private String convertValuesToJsonArray(Map<String, ? extends Number> map) {
        if (map == null || map.isEmpty()) return "[0]";
        StringBuilder sb = new StringBuilder("[");
        for (Number value : map.values()) {
            sb.append(value).append(",");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append("]");
        return sb.toString();
    }
}