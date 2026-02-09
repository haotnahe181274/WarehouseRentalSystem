package controller;

import dao.IncidentReportDAO;
import model.IncidentReport;
import model.InternalUser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "IncidentReportServlet", urlPatterns = {"/staffReport"})
public class IncidentReportServlet extends HttpServlet {

    private IncidentReportDAO dao = new IncidentReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        InternalUser user = (InternalUser) session.getAttribute("user");

        /*if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }*/

        String role = user.getRole().getRoleName();
        List<IncidentReport> list;

        if (role.equalsIgnoreCase("STAFF")) {
            list = dao.getByStaff(user.getInternalUserId());
        } else {
            list = dao.getAll();
        }

        request.setAttribute("list", list);
        request.getRequestDispatcher("staff_report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        InternalUser user = (InternalUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // ================= CREATE (STAFF)
        if ("create".equals(action)) {
            String type = request.getParameter("type");
            String description = request.getParameter("description");
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));

            dao.insertReport(type, description, warehouseId, user.getInternalUserId());
        }

        // ================= DELETE (STAFF – own)
        if ("delete".equals(action)) {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            dao.delete(reportId, user.getInternalUserId());
        }

        // ================= UPDATE STATUS (ADMIN / MANAGER)
        if ("updateStatus".equals(action)) {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            int status = Integer.parseInt(request.getParameter("status"));
            dao.updateStatus(reportId, status);
        }

        response.sendRedirect("staffReport");
    }
}
