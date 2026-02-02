package controller;

import dao.StaffCheckDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.UnitContractView;

@WebServlet("/staffCheck")
public class StaffCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csuIdRaw = request.getParameter("csuId");
        if (csuIdRaw == null) {
            response.sendRedirect("staffTask");
            return;
        }

        int csuId = Integer.parseInt(csuIdRaw);

        StaffCheckDAO dao = new StaffCheckDAO();
        List<UnitContractView> detail =
                dao.getUnitContractDetailNoNewTable(csuId);

        request.setAttribute("detail", detail);
        request.getRequestDispatcher("staff_check.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csuIdRaw = request.getParameter("csuId");
        String action = request.getParameter("action");

        if (csuIdRaw == null || action == null) {
            response.sendRedirect("staffTask");
            return;
        }

        int csuId = Integer.parseInt(csuIdRaw);
        StaffCheckDAO dao = new StaffCheckDAO();

        if ("checkin".equals(action)) {
            dao.checkIn(csuId);
        } else if ("checkout".equals(action)) {
            dao.checkOut(csuId);
        }

        response.sendRedirect("staffTask");
    }
}
