package controller;

import dao.CheckRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CheckRequest;
import model.UserView;

@WebServlet(name = "CheckRequestList", urlPatterns = {"/checkRequestList"})
public class CheckRequestList extends HttpServlet {

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

        CheckRequestDAO dao = new CheckRequestDAO();
        List<CheckRequest> list = dao.getCheckRequestsByRenter(user.getId());
        request.setAttribute("checkRequests", list);
        request.getRequestDispatcher("/Rental/checkRequestList.jsp").forward(request, response);
    }
}

