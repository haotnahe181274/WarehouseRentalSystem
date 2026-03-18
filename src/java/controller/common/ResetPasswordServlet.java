package controller.common;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Kiểm tra xem người dùng đã qua bước xác thực OTP chưa
        if (session.getAttribute("resetUserId") == null) {
            response.sendRedirect("forgot-password");
            return;
        }
        request.getRequestDispatcher("/Common/Login/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/Common/Login/reset-password.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        String userType = (String) session.getAttribute("resetUserType");

        if (userId != null && userType != null) {
            UserDAO dao = new UserDAO();
            boolean isUpdated = dao.changePassword(userId, userType, newPassword);

            if (isUpdated) {
                // Xóa các session liên quan đến reset password
                session.removeAttribute("otp");
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetUserId");
                session.removeAttribute("resetUserType");

                // Chuyển hướng về trang đăng nhập kèm thông báo thành công
                request.setAttribute("message", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");
                request.getRequestDispatcher("/Common/Login/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đã có lỗi xảy ra. Không thể cập nhật mật khẩu.");
                request.getRequestDispatcher("/Common/Login/reset-password.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("forgot-password");
        }
    }
}