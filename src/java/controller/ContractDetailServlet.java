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

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        /* ================= LOGIN CHECK ================= */
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user = (UserView) session.getAttribute("user");

        /* ================= GET PARAM ================= */
        String idRaw = request.getParameter("contractId");

        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect("contract");
            return;
        }

        int contractId = Integer.parseInt(idRaw);

        /* ================= GET DATA ================= */
        ContractDAO dao = new ContractDAO();
        ContractDetail detail = dao.getContractDetail(contractId);

        if (detail == null) {
            response.sendRedirect(request.getContextPath() + "/contract");
            return;
        }

        /* ================= PHÂN QUYỀN ================= */
        String type = user.getType();
        String role = user.getRole();

        // INTERNAL (Manager/Admin) xem tất cả
        if ("INTERNAL".equalsIgnoreCase(type)
                && ("Manager".equalsIgnoreCase(role)
                || "Admin".equalsIgnoreCase(role))) {

            request.setAttribute("role", "manager");
        }
        // RENTER chỉ xem contract của mình
        else if ("RENTER".equalsIgnoreCase(type)) {

            if (detail.getRenterId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            request.setAttribute("role", "renter");
        }
        else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        /* ================= SEND DATA ================= */
        request.setAttribute("contract", detail);

        request.getRequestDispatcher("/contract/Contract-detail.jsp")
               .forward(request, response);
    }
}
