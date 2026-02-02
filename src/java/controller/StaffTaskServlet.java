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

        StaffTaskDAO dao = new StaffTaskDAO();

        // ✅ LẤY ĐÚNG METHOD ĐANG TỒN TẠI
        request.setAttribute("checkInList", dao.getCheckInList());
        request.setAttribute("checkOutList", dao.getCheckOutList());
        request.setAttribute("completedCount", dao.countCompleted());

        request.getRequestDispatcher("staff_task.jsp")
               .forward(request, response);
    }
}
