package Filter;
import dao.NotificationDAO;
import model.Notification; 
import model.UserView; 


import java.io.IOException;
import java.util.List;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@WebFilter(filterName = "NotificationFilter", urlPatterns = {"/*"})
public class NotificationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter (có thể để trống)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
            
        HttpServletRequest req = (HttpServletRequest) request;
        String path = req.getRequestURI();

        // 1. Tối ưu hiệu năng: Bỏ qua việc truy vấn DB đối với các file tĩnh (CSS, JS, Images)
        if (path.contains("/resources/") || path.contains("/assets/") || 
            path.endsWith(".css") || path.endsWith(".js") || 
            path.endsWith(".jpg") || path.endsWith(".png") || path.endsWith(".woff2")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Lấy session hiện tại (không tạo mới nếu chưa có)
        HttpSession session = req.getSession(false);

        // 3. Kiểm tra user đã đăng nhập chưa
        if (session != null && session.getAttribute("user") != null) {
            String userType = (String) session.getAttribute("userType");
            Object userObj = session.getAttribute("user");
            
            int userId = -1;

            // 4. Lấy đúng ID tùy thuộc vào loại người dùng là RENTER hay INTERNAL
            try {
                if ("RENTER".equals(userType)) {
                    UserView renter = (UserView) userObj;
                    userId = renter.getId(); // Thay đổi tên hàm get() cho khớp với Renter class của Hiếu
                } else if ("INTERNAL".equals(userType)) {
                    UserView internalUser = (UserView) userObj;
                    userId = internalUser.getId(); // Thay đổi tên hàm get() cho khớp với InternalUser class của Hiếu
                }
            } catch (ClassCastException e) {
                System.out.println("Lỗi ép kiểu User trong NotificationFilter: " + e.getMessage());
            }

            // 5. Nếu lấy được ID thành công, tiến hành truy vấn thông báo
            // Bên trong NotificationFilter.java, đoạn sau khi lấy được userId:
if (userId != -1) {
    NotificationDAO notiDAO = null;
    try {
        notiDAO = new NotificationDAO();
        List<Notification> notiList = notiDAO.getTopNotificationsByUser(userId, userType, 5);
        int unreadCount = notiDAO.getUnreadCount(userId, userType);

        req.setAttribute("notiList", notiList);
        req.setAttribute("unreadCount", unreadCount);
    } catch (Exception e) {
        System.out.println("Lỗi truy vấn Notification: " + e.getMessage());
    } finally {
        // RẤT QUAN TRỌNG: Luôn luôn đóng kết nối DB sau khi Filter dùng xong
        if (notiDAO != null) {
            notiDAO.closeConnection();
        }
    }
} else {
    System.out.println("=== DEBUG NOTIFICATION: KHÔNG LẤY ĐƯỢC USER ID ===");
}
        }

        // 6. Cho phép request tiếp tục đi tới Servlet/JSP đích
        chain.doFilter(request, response);
    }
}