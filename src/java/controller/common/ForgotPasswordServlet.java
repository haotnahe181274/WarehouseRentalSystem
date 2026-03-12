package controller.common;

import dao.UserDAO;
import model.UserView;
import ultis.OTPUtils;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Common/Login/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        UserView user = dao.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("/Common/Login/forgot-password.jsp").forward(request, response);
            return;
        }

        // Tạo và gửi OTP
        String otp = OTPUtils.generateOTP();
        boolean isSent = OTPUtils.sendOTPEmail(email, otp);

        if (isSent) {
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("otpCreationTime", System.currentTimeMillis()); // Thêm dòng này
session.setAttribute("resetEmail", email);
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetUserId", user.getId());
            session.setAttribute("resetUserType", user.getType());
            
            // Chuyển hướng sang trang xác thực OTP
            response.sendRedirect("verify-otp");
        } else {
            request.setAttribute("error", "Lỗi gửi email. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/Common/Login/forgot-password.jsp").forward(request, response);
        }
    }
}   