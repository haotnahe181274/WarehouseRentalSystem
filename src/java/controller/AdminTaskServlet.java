package controller;

import dao.AssignmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.StaffAssignment;
import model.UserView;

@WebServlet("/taskBoard")
public class AdminTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user   = (UserView) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");
        String role     = (String) session.getAttribute("role");

        // Only Admin and Manager can access the task board
        if (!"INTERNAL".equals(userType)
                || (!"Admin".equals(role) && !"Manager".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        AssignmentDAO dao = new AssignmentDAO();
        List<StaffAssignment> taskList = dao.getAllAssignments();

        // Stats for cards
        long totalTasks     = taskList.size();
        long completedTasks = taskList.stream().filter(t -> t.getCompletedAt() != null).count();
        long pendingTasks   = taskList.stream().filter(t -> t.getCompletedAt() == null && !t.isOverdue()).count();
        long overdueTasks   = taskList.stream().filter(t -> t.isOverdue()).count();

        request.setAttribute("taskList",       taskList);
        request.setAttribute("totalTasks",     totalTasks);
        request.setAttribute("completedTasks", completedTasks);
        request.setAttribute("pendingTasks",   pendingTasks);
        request.setAttribute("overdueTasks",   overdueTasks);

        request.getRequestDispatcher("/Management/task_board.jsp").forward(request, response);
    }
}