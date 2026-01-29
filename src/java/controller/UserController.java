/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.InternalUserDAO;
import dao.RenterDAO;
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
    InternalUserDAO internalDAO = new InternalUserDAO();
    RenterDAO renterDAO = new RenterDAO();
    UserDAO userDAO = new UserDAO();

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        //View user detail
        if ("view".equalsIgnoreCase(action)) {
            String rawId = request.getParameter("id");
            String type = request.getParameter("type");
            if (rawId == null || rawId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing user id");
                return;
            }
            int id = Integer.parseInt(rawId);
            UserView user = userDAO.getUserById(id, type);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/viewdetails.jsp").forward(request, response);
            return;
        }

        if ("add".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/user/userform.jsp").forward(request, response);
            return;
        }

        if ("edit".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");
            UserView user = userDAO.getUserById(id, type);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/userform.jsp").forward(request, response);
            return;
        }

        List<UserView> users = userDAO.getAllUserViews();
        request.setAttribute("users", users);
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

                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                int roleId = Integer.parseInt(request.getParameter("roleId"));

                // upload image
                Part imagePart = request.getPart("image");
                String imageName = null;

                if (imagePart != null && imagePart.getSize() > 0) {
                    imageName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String path = request.getServletContext().getRealPath("/image/user");
                    imagePart.write(path + File.separator + imageName);
                }

                // ===== ADD =====
                if ("add".equals(action)) {
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    internalDAO.insertInternalUser(username, password, email, fullName, phone, imageName, roleId);
                }

                // ===== UPDATE =====
                if ("update".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    internalDAO.updateInternalUser(id, email, fullName, phone, imageName, roleId);
                }

                if ("block".equalsIgnoreCase(action) || "unblock".equalsIgnoreCase(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String type = request.getParameter("type");
                    int status = action.equals("block") ? 0 : 1;

                    if ("INTERNAL".equalsIgnoreCase(type)) {
                        internalDAO.updateStatus(id, status);
                    } else {
                        renterDAO.updateStatus(id, status);
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
