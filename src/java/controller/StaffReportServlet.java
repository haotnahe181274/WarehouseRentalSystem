package controller;

import dao.IncidentReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.UserView;

@WebServlet(name = "StaffReportServlet", urlPatterns = {"/staffReport"})
public class StaffReportServlet extends HttpServlet {

    // =========================
    // HIỂN THỊ FORM REPORT
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("staff_report.jsp").forward(request, response);
    }

    // =========================
    // XỬ LÝ SUBMIT REPORT
    // =========================
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserView user = (UserView) session.getAttribute("user");

    String type = request.getParameter("type");
    String description = request.getParameter("description");

    IncidentReportDAO dao = new IncidentReportDAO();
    boolean success = dao.insert(type, description, user.getId());

    if (success) {
        response.sendRedirect("staffReport?success=1");
    } else {
        response.sendRedirect("staffReport?error=1");
    }
}


}
