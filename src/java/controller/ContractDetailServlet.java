package controller;

import dao.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.ContractDetail;
import model.UserView;

@WebServlet(name = "ContractDetailServlet", urlPatterns = {"/contract-detail"})
public class ContractDetailServlet extends HttpServlet {

    /* ================= GET DETAIL ================= */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        ContractDAO dao = new ContractDAO();
        ContractDetail detail = dao.getContractDetail(id);

        request.setAttribute("contract", detail);

        request.getRequestDispatcher("/contract/Contract-detail.jsp")
                .forward(request, response);
    }

    /* ================= UPDATE STATUS ================= */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    ContractDAO dao = new ContractDAO();

    String action = request.getParameter("action");
    int contractId = Integer.parseInt(request.getParameter("contractId"));

    HttpSession session = request.getSession();

    try {

        /* ================= MANAGER ================= */
        if ("agree".equals(action)
                && "Manager".equals(session.getAttribute("role"))) {

            UserView user = (UserView) session.getAttribute("user");

            dao.managerUpdateStatus(
                    contractId,
                    1, // status = 1 (manager approved)
                    user.getId()
            );

            response.sendRedirect("contract");
            return;
        }

        if ("reject".equals(action)
                && "Manager".equals(session.getAttribute("role"))) {

            UserView user = (UserView) session.getAttribute("user");

            dao.managerUpdateStatus(
                    contractId,
                    2, // rejected
                    user.getId()
            );

            response.sendRedirect("contract");
            return;
        }

        /* ================= RENTER ================= */
        if ("agree".equals(action)
                && "RENTER".equals(session.getAttribute("userType"))) {

            dao.renterUpdateStatus(contractId, 3);

            response.sendRedirect("contract");
            return;
        }

        if ("reject".equals(action)
                && "RENTER".equals(session.getAttribute("userType"))) {

            dao.renterUpdateStatus(contractId, 4);

            response.sendRedirect("contract");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    response.sendRedirect("contract");
}
}