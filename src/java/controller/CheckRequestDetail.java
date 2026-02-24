package controller;

import dao.CheckRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CheckRequest;
import model.UserView;

@WebServlet(name = "CheckRequestDetail", urlPatterns = {"/checkRequestDetail"})
public class CheckRequestDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        if (!"RENTER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect(request.getContextPath() + "/checkRequestList");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/checkRequestList");
            return;
        }

        CheckRequestDAO dao = new CheckRequestDAO();
        CheckRequest cr = dao.getCheckRequestWithItems(id, user.getId());
        if (cr == null) {
            response.sendRedirect(request.getContextPath() + "/checkRequestList");
            return;
        }

        String mode = "OUT".equalsIgnoreCase(cr.getRequestType()) || "CHECK_OUT".equalsIgnoreCase(cr.getRequestType())
                ? "OUT" : "IN";

        request.setAttribute("pageMode", "view");
        request.setAttribute("mode", mode);
        request.setAttribute("checkRequest", cr);
        request.getRequestDispatcher("/Rental/checkRequest.jsp").forward(request, response);
    }
}

