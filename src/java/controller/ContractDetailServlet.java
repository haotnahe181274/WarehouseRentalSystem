package controller;

import dao.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.*;

@WebServlet(name = "ContractDetailServlet", urlPatterns = {"/contract-detail"})
public class ContractDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    int id = Integer.parseInt(request.getParameter("id"));

    ContractDAO dao = new ContractDAO();
    ContractDetail detail = dao.getContractDetail(id);

    request.setAttribute("contract", detail);

    request.getRequestDispatcher("/contract/Contract-detail.jsp")
           .forward(request, response);
}
}