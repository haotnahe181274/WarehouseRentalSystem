package controller;

import dao.StaffTaskDAO;
import model.CheckInTask;
import model.InternalUser;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staffTask")
public class StaffTaskServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        StaffTaskDAO dao = new StaffTaskDAO();

        request.setAttribute("checkInList",dao.getCheckInTasks());
        request.setAttribute("checkOutList", dao.getCheckOutTasks());
        request.setAttribute("completedCount", dao.countCompleted());
        request.getRequestDispatcher("staff_task.jsp")
               .forward(request, response);
    }
}


