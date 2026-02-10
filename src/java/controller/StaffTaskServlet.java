package controller;

import dao.StaffTaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/staffTask")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. CHECK LOGIN + ROLE
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login");
            return;
        }

        String role = session.getAttribute("role").toString();
        if (!"Staff".equals(role)) {
            response.sendRedirect("403.jsp");
            return;
        }

        // 2. NGHIỆP VỤ STAFF
        StaffTaskDAO dao = new StaffTaskDAO();

        request.setAttribute("checkInList", dao.getCheckInList());
        request.setAttribute("checkOutList", dao.getCheckOutList());
        request.setAttribute("completedCount", dao.countCompleted());

        // 3. FORWARD VIEW
        request.getRequestDispatcher("/staff/staff_task.jsp")
               .forward(request, response);
    }
}
