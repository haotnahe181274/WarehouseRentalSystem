/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RentRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InternalUser;
import model.Renter;
import model.UserView;

/**
 *
 * @author ad
 */
@WebServlet(name = "RentRequestCancel", urlPatterns = {"/rentRequestCancel"})
public class RentRequestCancel extends HttpServlet {

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
            out.println("<title>Servlet RentRequestCancel</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RentRequestCancel at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/rentList");
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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user = (UserView) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        if (userType == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String redirect = request.getParameter("redirect");

        RentRequestDAO dao = new RentRequestDAO();

        if ("RENTER".equals(userType)) {
            // renter chỉ được cancel request của chính mình
            dao.cancelByRenter(requestId, user.getId());
        } else if ("INTERNAL".equals(userType)) {
            // manager reject request
            dao.updateStatusByManager(
                    requestId,
                    2, // Rejected
                    user.getId()
            );
        }

        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath()
                    + "/rentDetail?id=" + requestId);
        } else {
            response.sendRedirect(request.getContextPath() + "/rentList");
        }

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
