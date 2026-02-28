package controller;

import dao.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.ContractDetail;
import model.InternalUser;

@WebServlet("/contract-detail")
public class ContractDetailServlet extends HttpServlet {

    // =========================
    // HIỂN THỊ CHI TIẾT
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int contractId =
                Integer.parseInt(request.getParameter("id"));

        ContractDAO dao = new ContractDAO();

        // ✅ LẤY MODEL MỚI
        ContractDetail contractDetail =
                dao.getContractByRequest(contractId);

        if (contractDetail != null) {

            // ✅ tên attribute phải giống JSP
            request.setAttribute("contractDetail", contractDetail);

            request.getRequestDispatcher("/contract/contract.jsp")
                    .forward(request, response);
            System.out.println("Contract ID = " + contractId);
        } else {
            response.getWriter().print("Hợp đồng không tồn tại!");
        }
    }

    // =========================
    // MANAGER ĐỒNG Ý / TỪ CHỐI
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int contractId =
                Integer.parseInt(request.getParameter("contractId"));

        int status =
                Integer.parseInt(request.getParameter("status"));

        HttpSession session = request.getSession();
        InternalUser manager =
                (InternalUser) session.getAttribute("user");

        if (manager == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int managerId = manager.getInternalUserId();

        ContractDAO dao = new ContractDAO();
        dao.managerUpdateStatus(contractId, status, managerId);

        response.sendRedirect("contract-detail?id=" + contractId);
    }
}