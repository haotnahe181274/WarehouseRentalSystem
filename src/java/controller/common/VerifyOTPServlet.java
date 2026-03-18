/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ad
 */
@WebServlet(name = "VerifyOTPServlet", urlPatterns = { "/verify-otp" })
public class VerifyOTPServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VerifyOTPServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyOTPServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Common/Login/verify_otp.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String enteredOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");

        if (sessionOtp == null) {
            request.setAttribute("error", "Không tìm thấy mã OTP. Vui lòng thử lại.");
            request.getRequestDispatcher("/Common/Login/verify_otp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra thời gian hết hạn của OTP (60 giây)
        Long otpCreationTime = (Long) session.getAttribute("otpCreationTime");
        long currentTime = System.currentTimeMillis();
        if (otpCreationTime != null && (currentTime - otpCreationTime) > (60 * 1000)) {
            session.removeAttribute("otp");
            session.removeAttribute("otpCreationTime");
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
            request.getRequestDispatcher("/Common/Login/verify_otp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mã OTP nhập vào có khớp không
        if (sessionOtp.equals(enteredOtp)) {
            
            // ==========================================
            // LUỒNG 1: XÁC THỰC OTP CHO ĐĂNG KÝ TÀI KHOẢN
            // ==========================================
            if (session.getAttribute("tempUsername") != null) {
                String username = (String) session.getAttribute("tempUsername");
                String password = (String) session.getAttribute("tempPassword");
                String fullName = (String) session.getAttribute("tempFullName");
                String email = (String) session.getAttribute("tempEmail");
                String phone = (String) session.getAttribute("tempPhone");

                UserDAO dao = new UserDAO();
                dao.insertRenter(username, password, fullName, email, phone);

                // Dọn dẹp session đăng ký
                session.removeAttribute("otp");
                session.removeAttribute("otpCreationTime");
                session.removeAttribute("tempUsername");
                session.removeAttribute("tempPassword");
                session.removeAttribute("tempFullName");
                session.removeAttribute("tempEmail");
                session.removeAttribute("tempPhone");

                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("success", "Xác thực thành công! Tài khoản đã được tạo. Vui lòng đăng nhập.");
                request.getRequestDispatcher("/Common/Login/login.jsp").forward(request, response);
            } 
            // ==========================================
            // LUỒNG 2: XÁC THỰC OTP CHO QUÊN MẬT KHẨU
            // ==========================================
            else if (session.getAttribute("resetEmail") != null) {
                // OTP đúng, dọn dẹp session OTP để tránh dùng lại mã cũ
                session.removeAttribute("otp");
                session.removeAttribute("otpCreationTime");
                
                // Đánh dấu là đã xác thực thành công để cho phép vào trang đổi mật khẩu
                session.setAttribute("canResetPassword", true);
                
                response.sendRedirect("reset-password");
            } 
            // Trường hợp không xác định
            else {
                response.sendRedirect("login");
            }

        } else {
            // Báo lỗi sai OTP
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại.");
            request.getRequestDispatcher("/Common/Login/verify_otp.jsp").forward(request, response);
        }
    }
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Verify OTP Servlet";
    }// </editor-fold>

}
