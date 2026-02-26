package controller;

import dao.StaffTaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.UserView;

@WebServlet("/staffTask")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        String role = user.getRole() != null ? user.getRole() : "";
        if (!"Staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/homepage");
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
