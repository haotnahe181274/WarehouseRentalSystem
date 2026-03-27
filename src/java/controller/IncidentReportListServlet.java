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
                dao.getByStaff(user.getId()) );
            int currentStaffId = (user.getId());
request.setAttribute("totalReports", dao.countTotalById(currentStaffId)); 
request.setAttribute("pendingReports", dao.countByStatusById(1, currentStaffId));
request.setAttribute("processingReports", dao.countByStatusById(2, currentStaffId));
request.setAttribute("rejectReports", dao.countByStatusById(3, currentStaffId));
        } else {
            request.setAttribute("totalReports", dao.countTotalById(0)); 
request.setAttribute("pendingReports", dao.countByStatusById(1, 0));
request.setAttribute("processingReports", dao.countByStatusById(2, 0));
request.setAttribute("rejectReports", dao.countByStatusById(3, 0));
            request.setAttribute(
                    
                "incidentList",
                dao.getAll()
            );
        }
        

        request.getRequestDispatcher("/staff/reportList.jsp").forward(request, response);
    }
}
