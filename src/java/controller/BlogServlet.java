/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.BlogPost;

/**
 *
 * @author hao23
 */
@WebServlet(name = "BlogServlet", urlPatterns = { "/blog-crud" })
public class BlogServlet extends HttpServlet {

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
            out.println("<title>Servlet BlogServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BlogServlet at " + request.getContextPath() + "</h1>");
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
    BlogDAO dao = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "list":
                response.sendRedirect("blog");
                break;
            case "view":
                int viewId = Integer.parseInt(request.getParameter("id"));
                BlogPost viewPost = dao.getPostById(viewId);
                request.setAttribute("post", viewPost);
                request.getRequestDispatcher("blog/blog-view.jsp").forward(request, response);
                break;
            case "create":
                request.setAttribute("categories", dao.getBlogCategories());
                request.getRequestDispatcher("blog/blog.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                BlogPost post = dao.getPostById(id);
                request.setAttribute("post", post);
                request.setAttribute("categories", dao.getBlogCategories());
                request.getRequestDispatcher("blog/blog.jsp").forward(request, response);
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                dao.deletePost(deleteId);
                response.sendRedirect("blog");
                break;
        }
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
        String action = request.getParameter("action");
        String tilte = request.getParameter("title");
        String content = request.getParameter("content");
        String catIdStr = request.getParameter("categoryId");
        int categoryId = (catIdStr != null && !catIdStr.isEmpty()) ? Integer.parseInt(catIdStr) : 0;

        HttpSession session = request.getSession();
        model.UserView user = (model.UserView) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : 1;
        String userType = (user != null) ? user.getType() : "RENTER";

        if (action != null && action.equalsIgnoreCase("create")) {
            dao.createPost(tilte, content, categoryId, userId, userType);
        } else if (action != null && action.equalsIgnoreCase("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.updatePost(id, tilte, content, categoryId);
        }
        response.sendRedirect("blog");
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
