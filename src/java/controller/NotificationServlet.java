package controller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Notification;
import model.UserView;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user   = (UserView) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");
        String filter   = request.getParameter("filter"); // null = all, "unread", "SUCCESS", "WARNING", "INFO"

        NotificationDAO notiDAO = new NotificationDAO();

        // Lấy toàn bộ notification (không giới hạn) theo filter
        List<Notification> allNotiList = notiDAO.getAllNotificationsByUser(user.getId(), userType, filter);
        int unreadCount = notiDAO.getUnreadCount(user.getId(), userType);

        request.setAttribute("allNotiList", allNotiList);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/Common/Layout/notifications.jsp").forward(request, response);
    }
}