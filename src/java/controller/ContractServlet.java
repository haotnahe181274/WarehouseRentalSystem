package controller;

import dao.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.ContractDetail;
import model.UserView;

@WebServlet(name = "ContractServlet", urlPatterns = {"/contract"})
public class ContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // ================= LOGIN CHECK =================
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        // ⭐ USER TRONG SESSION LÀ UserView
        UserView user = (UserView) session.getAttribute("user");

        ContractDAO dao = new ContractDAO();
        List<ContractDetail> contracts;

        String type = user.getType();   // INTERNAL / RENTER
        String role = user.getRole();   // Admin / Manager / Staff

        // ================= MANAGER / ADMIN =================
        if ("INTERNAL".equalsIgnoreCase(type)
                && ("Manager".equalsIgnoreCase(role)
                    || "Admin".equalsIgnoreCase(role))) {

            contracts = dao.getAllContracts();
            request.setAttribute("role", "manager");
        }

        // ================= RENTER =================
        else if ("RENTER".equalsIgnoreCase(type)) {

            // id trong UserView chính là renter_id
            contracts = dao.getContractsByRenter(user.getId());
            request.setAttribute("role", "renter");
        }

        // ================= FORBIDDEN =================
        else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("contractList", contracts);

        request.getRequestDispatcher("/contract/Contract-list.jsp")
               .forward(request, response);
    }

    // ======================================
    // POST
    // ======================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ContractDAO dao = new ContractDAO();
        String action = request.getParameter("action");

        try {

            if ("create".equals(action)) {

                int requestId =
                        Integer.parseInt(request.getParameter("requestId"));

                int rowsAffected = dao.createContracts(requestId);

                if (rowsAffected > 0) {
                    session.setAttribute("message",
                            "Thành công: Đã tạo " + rowsAffected + " hợp đồng.");
                } else {
                    session.setAttribute("error",
                            "Không thể tạo hợp đồng.");
                }
            }

            else if ("createAll".equals(action)) {

                int totalCreated = dao.createContracts(0);

                session.setAttribute("message",
                        "Đã xử lý xong. Tổng số hợp đồng mới: " + totalCreated);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/contract");
    }
}