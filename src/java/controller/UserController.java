/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.UserView;

/**
 *
 * @author hao23
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
@WebServlet("/user/list")
public class UserController extends HttpServlet {

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
            out.println("<title>Servlet UserController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserController at " + request.getContextPath() + "</h1>");
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
    UserDAO userDAO = new UserDAO();

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String rawId = request.getParameter("id");
        String type = request.getParameter("type");

        //View user detail
        if ("view".equals(action)) {
            int id = Integer.parseInt(rawId);
            UserView user = userDAO.getUserById(id, type);
            request.setAttribute("user", user);
            request.setAttribute("mode", "view");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("mode", "add");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(rawId);
            UserView user = userDAO.getUserById(id, type);
            request.setAttribute("user", user);
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }

        List<UserView> users;
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String filterType = request.getParameter("filterType");
        String sort = request.getParameter("sort");
        if(keyword != null) keyword = keyword.trim();
        if((keyword == null || keyword.isEmpty())
                && (status == null || status.isEmpty())
                && (filterType == null || filterType.isEmpty())
                && (sort ==  null || sort.isEmpty())) users = userDAO.getAllUserViews();
        else users = userDAO.filterUsers(keyword, status, filterType, sort);
        
        request.setAttribute("users", users);
        
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("filterType", filterType);
        request.setAttribute("sort", sort);
        request.getRequestDispatcher("/user/userlist.jsp").forward(request, response);

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

        String action = request.getParameter("action");
        String mode = request.getParameter("mode");
        if ("block".equals(action) || "unblock".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");
            int status = action.equals("block") ? 0 : 1;
            userDAO.updateStatus(id, type, status);
            response.sendRedirect(request.getContextPath() + "/user/list");
            return;
        }

        if ("save".equals(action)) {

            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String role = request.getParameter("roleId");

            // upload image
            Part avatar = request.getPart("image");
            String fileName = null;

            if (avatar != null && avatar.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + avatar.getSubmittedFileName();
                String uploadPath = request.getServletContext().getRealPath("/resources/user");
                new File(uploadPath).mkdirs();
                avatar.write(uploadPath + File.separator + fileName);
            }

            // ===== ADD =====
            if ("add".equals(mode)) {
                int roleId = Integer.parseInt(role);
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                userDAO.insertInternalUser(
                        username, password, email, fullName, phone, fileName, roleId
                );
            }

            // ===== UPDATE =====
            if ("edit".equals(mode)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int roleId = Integer.parseInt(role);

                // nếu không upload ảnh mới → giữ ảnh cũ
                if (fileName == null) {
                    UserView old = userDAO.getUserById(id, "INTERNAL");
                    fileName = old.getImage();
                }

                userDAO.updateInternalUser(
                        id, email, fullName, phone, fileName, roleId
                );
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/user/list");
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
