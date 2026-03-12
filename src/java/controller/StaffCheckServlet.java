package controller;

import dao.StaffTaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CheckRequest;
import model.CheckRequestItem;
import model.UserView;

@WebServlet("/staffCheck")
public class StaffCheckServlet extends HttpServlet {

    // ==============================
    // LOAD PAGE
    // ==============================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserView staff = (UserView) session.getAttribute("user");

        if (staff == null) {
            response.sendRedirect("login");
            return;
        }

        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));

        StaffTaskDAO dao = new StaffTaskDAO();

        int requestId = dao.getRequestIdByAssignment(assignmentId);

        CheckRequest checkRequest = dao.getCheckRequestById(requestId);

        request.setAttribute("checkRequest", checkRequest);
        request.setAttribute("assignmentId", assignmentId);

        request.getRequestDispatcher("/staff/staff_check.jsp").forward(request, response);
    }

    // ==============================
    // SUBMIT CHECK
    // ==============================
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    StaffTaskDAO dao = new StaffTaskDAO();

    try {

        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        CheckRequest checkRequest = dao.getCheckRequestById(requestId);

        for (CheckRequestItem item : checkRequest.getItems()) {

            String raw = request.getParameter("processed_" + item.getId());

            int processedQty = 0;

            if (raw != null && !raw.isEmpty()) {
                processedQty = Integer.parseInt(raw);
            }

            int requiredQty = item.getQuantity();

            String status;

            if (processedQty >= requiredQty) {
                status = "done";
            } else {
                status = "fail";
            }

            dao.updateCheckRequestItem(item.getId(), processedQty, status);
        }
            dao.completeAssignment(assignmentId);
        // quay lại staff task
        response.sendRedirect("staffTask");

    } catch (Exception e) {
        e.printStackTrace();
    }
}

}