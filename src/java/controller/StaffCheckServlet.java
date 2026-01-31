package controller;

import dao.StaffCheckDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/staffCheck")
public class StaffCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("assignmentId"));

        StaffCheckDAO dao = new StaffCheckDAO();

        request.setAttribute("list", dao.getCheckByAssignment(id));
        request.setAttribute("assignmentId", id);

        request.getRequestDispatcher("staff_check.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("assignmentId"));

        StaffCheckDAO dao = new StaffCheckDAO();
        dao.completeAssignment(id);

        response.sendRedirect("staffTask");
    }
}
