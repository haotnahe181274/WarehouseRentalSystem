/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ultis.OTPUtils;
import ultis.UserValidation;

/**
 *
 * @author ad
 */
@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {

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
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/Common/Login/signup.jsp").forward(request, response);
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
        UserDAO dao = new UserDAO();

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");

        Map<String, String> errors = UserValidation.validateRenterRegister(username, password, rePassword, email,
                fullName, phone, dao);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/Common/Login/signup.jsp").forward(request, response);
        } else {
            // Instead of inserting directly, send OTP
            String otp = OTPUtils.generateOTP();
            boolean isSent = OTPUtils.sendOTPEmail(email, otp);

            if (isSent) {
                HttpSession session = request.getSession();
                session.setAttribute("otp", otp);
                session.setAttribute("otpCreationTime", System.currentTimeMillis());

                // Store registration data in session
                session.setAttribute("tempUsername", username);
                session.setAttribute("tempPassword", password);
                session.setAttribute("tempFullName", fullName);
                session.setAttribute("tempEmail", email);
                session.setAttribute("tempPhone", phone);

                // Redirect to OTP verification page
                response.sendRedirect("verify-otp");
            } else {
                request.setAttribute("errors", Map.of("email", "Failed to send OTP. Please try again later."));
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/Common/Login/signup.jsp").forward(request, response);
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Register Servlet";
    }// </editor-fold>

}
