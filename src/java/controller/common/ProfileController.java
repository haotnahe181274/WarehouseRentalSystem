/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.UserView;

/**
 *
 * @author hao23
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProfileController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProfileController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView loginUser = (UserView) session.getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String mode = request.getParameter("mode");
        if (mode == null) {
            mode = "view";
        }
        String idRaw = request.getParameter("id");
        String type = request.getParameter("type");
        UserView targetUser;
        // ===== STAFF / RENTER: chỉ xem chính mình =====
        if ("STAFF".equalsIgnoreCase(loginUser.getRole()) || "RENTER".equalsIgnoreCase(loginUser.getRole())) {
            targetUser = loginUser;
        }else if (idRaw == null || type == null){
            targetUser = loginUser;
        }else {
            int id = Integer.parseInt(idRaw);
            targetUser = userDao.getUserById(id, type);
        }

        if ("edit".equalsIgnoreCase(mode) && !canEdit(loginUser, targetUser)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        request.setAttribute("targetUser", targetUser);
        request.setAttribute("mode", mode);

        request.getRequestDispatcher("user/users.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView loginUser = (UserView) session.getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String type = request.getParameter("type");

        UserView targetUser = new UserView();
        targetUser.setId(id);
        targetUser.setType(type);
        targetUser.setEmail(request.getParameter("email"));
        targetUser.setFullName(request.getParameter("fullName"));
        targetUser.setPhone(request.getParameter("phone"));

        if (!canEdit(loginUser, targetUser)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        userDao.updateProfile(targetUser);
        if (loginUser.getId() == id && loginUser.getType().equals(type)) {
            loginUser.setEmail(targetUser.getEmail());
            loginUser.setFullName(targetUser.getFullName());
            loginUser.setPhone(targetUser.getPhone());
            session.setAttribute("user", loginUser);
        }
        response.sendRedirect(request.getContextPath() + "/profile?id=" + id + "&type=" + type);
    }

    private boolean canEdit(UserView loginUser, UserView target) {

        if ("ADMIN".equals(loginUser.getRole())) {
            return true;
        }

        if ("MANAGER".equals(loginUser.getRole())) {
            return "MANAGER".equals(target.getRole());
        }

        // STAFF / RENTER: chỉ sửa chính mình
        return loginUser.getId() == target.getId()
                && loginUser.getType().equals(target.getType());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
