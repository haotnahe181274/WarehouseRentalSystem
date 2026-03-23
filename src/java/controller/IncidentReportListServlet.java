package controller;

import dao.IncidentReportDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.UserView;

@WebServlet("/incident")
public class IncidentReportListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");

        IncidentReportDAO dao = new IncidentReportDAO();

        // role trong UserView là STRING
        if ("Staff".equalsIgnoreCase(user.getRole())) {
            request.setAttribute(
                "incidentList",
                dao.getByStaff(user.getId())
            );
        } else {
            request.setAttribute(
                "incidentList",
                dao.getAll()
            );
        }

        // Fetch counts for stats cards
        request.setAttribute("totalReports", dao.countTotal());
        request.setAttribute("pendingReports", dao.countByStatus(1));
        request.setAttribute("processingReports", dao.countByStatus(2));
        request.setAttribute("rejectReports", dao.countByStatus(3));

        request.getRequestDispatcher("/staff/reportList.jsp").forward(request, response);
    }
}
