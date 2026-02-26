/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.IncidentReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.IncidentReport;
import model.UserView;

/**
 *
 * @author acer
 */
@WebServlet(name = "ReportViewServlet", urlPatterns = {"/viewReport"})
public class ReportViewServlet extends HttpServlet {

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
            out.println("<title>Servlet ReportViewServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReportViewServlet at " + request.getContextPath() + "</h1>");
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

        // 1. Lấy ID từ URL (ví dụ: viewReport?id=5)
        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            int id = Integer.parseInt(idRaw);

            // 2. Gọi hàm getById vừa tạo
            IncidentReportDAO dao = new IncidentReportDAO();
            IncidentReport report = dao.getById(id);

            if (report != null) {
                // 3. Đẩy object sang trang JSP
                request.setAttribute("report", report);
                request.getRequestDispatcher("/staff/reportView.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/incident");
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
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        // 1. Kiểm tra quyền Manager
        if (user == null || !user.getRole().equalsIgnoreCase("Manager")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // 2. Lấy dữ liệu từ form
            int id = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));

            // 3. Gọi DAO cập nhật DB
            IncidentReportDAO dao = new IncidentReportDAO();
            boolean isUpdated = dao.updateStatus(id, status);

            // 4. CHUYỂN HƯỚNG (Quan trọng)
            if (isUpdated) {
                // "reportList" phải là urlPattern của Servlet danh sách của bạn
                response.sendRedirect("incident?status=success");
            } else {
                // Nếu lỗi DB, quay lại chính trang chi tiết đó kèm báo lỗi
                response.sendRedirect("viewReport?id=" + id + "&error=failed");
            }
        } catch (Exception e) {
            // Nếu parse ID lỗi, đẩy thẳng ra list cho an toàn
            response.sendRedirect("incident");
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
