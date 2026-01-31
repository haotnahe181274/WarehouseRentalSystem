package controller;

import dao.StaffTaskDAO;
import model.CheckInTask;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staffTask")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StaffTaskDAO dao = new StaffTaskDAO();
        List<CheckInTask> checkInList = dao.getExpectedCheckIns();

        // DEBUG CỰC QUAN TRỌNG
        System.out.println("Check-in size = " + checkInList.size());

        request.setAttribute("checkInList", checkInList);
        request.getRequestDispatcher("staff_task.jsp").forward(request, response);
    }
}
