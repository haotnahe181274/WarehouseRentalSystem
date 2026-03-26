package controller;

import dao.AssignmentDAO;
import dao.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import model.ContractDetail;
import model.RentUnit;
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
        List<RentUnit> units = dao.getRentUnitsByContract(contractId);
        if (detail == null) {
            response.sendRedirect(request.getContextPath() + "/contract");
            return;
        }

        /* ================= PHÂN QUYỀN ================= */
        String type = user.getType();
        String role = user.getRole();
        request.setAttribute("canAgree", false);

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
            if (detail.getStatus() == 1) {
                boolean canAgree = dao.canRenterAgreeAndPay(contractId, user.getId());
                request.setAttribute("canAgree", canAgree);
            }
            // Token một lần để tránh double-submit; mỗi lần xem trang là mã mới (VNPay cần TxnRef mới mỗi lần)
            if (detail.getStatus() == 1) {
                session.setAttribute("paymentToken_" + contractId, UUID.randomUUID().toString());
            }
        }
        else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        /* ================= SEND DATA ================= */
        request.setAttribute("contract", detail);
        request.setAttribute("unitList", units);
        request.getRequestDispatcher("/contract/Contract-detail.jsp")
               .forward(request, response);
    }
    
       @Override
        protected void doPost(HttpServletRequest request,
                              HttpServletResponse response)
                throws ServletException, IOException {

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            UserView user = (UserView) session.getAttribute("user");

            String action = request.getParameter("action");
            String idRaw = request.getParameter("contractId");

            if (idRaw == null) {
                response.sendRedirect("contract");
                return;
            }

            int contractId = Integer.parseInt(idRaw);
            ContractDAO dao = new ContractDAO();

            /* ===== RENTER REJECT CONTRACT ===== */
            if ("reject".equals(action)) {

                // check quyền renter
                ContractDetail detail = dao.getContractDetail(contractId);

                if (detail == null || detail.getRenterId() != user.getId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                dao.rejectContract(contractId);

                response.sendRedirect(request.getContextPath() + "/contract");
                return;
            }
        }
    
}
