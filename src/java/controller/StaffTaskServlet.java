package controller;

import dao.StaffTaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.StaffTask;
import model.UserView;

@WebServlet("/staffTask")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();

    UserView staff = (UserView) session.getAttribute("user");

    if (staff == null) {
        response.sendRedirect("login");
        return;
    }

    int staffId = staff.getId();

    StaffTaskDAO dao = new StaffTaskDAO();

    List<StaffTask> taskList = dao.getTasksByStaff(staffId);

    request.setAttribute("taskList", taskList);

    request.getRequestDispatcher("/staff/staff_task.jsp").forward(request, response);
}
}
