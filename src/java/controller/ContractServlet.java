package controller;

import dao.ContractDAO;
import model.Contract;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ContractServlet", urlPatterns = {"/contract"})
public class ContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =============================
        // CHECK LOGIN
        // =============================
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ContractDAO dao = new ContractDAO();
        String action = request.getParameter("action");

        // =============================
        // LIST CONTRACT
        // =============================
        if (action == null || action.equals("list")) {

            List<Contract> list = dao.getAllContracts();
            request.setAttribute("listC", list);

            request.getRequestDispatcher("contract/Contract-list.jsp")
                    .forward(request, response);
        }

        // =============================
        // ✅ VIEW DETAIL (THÊM MỚI)
        // =============================
        else if (action.equals("view")) {

            int id = Integer.parseInt(request.getParameter("id"));

            // lấy contract detail
            Contract contract = dao.getContractById(id);

            if (contract == null) {
                session.setAttribute("error", "Không tìm thấy hợp đồng.");
                response.sendRedirect(request.getContextPath() + "/contract");
                return;
            }

            request.setAttribute("contract", contract);

            // 👉 chuyển sang trang detail
            request.getRequestDispatcher("contract/Contract-detail.jsp")
                    .forward(request, response);
        }

        // =============================
        // EDIT CONTRACT
        // =============================
        else if (action.equals("edit")) {

            int id = Integer.parseInt(request.getParameter("id"));

            Contract c = dao.getContractById(id);

            request.setAttribute("contract", c);

            request.getRequestDispatcher("contract/Contract-detail.jsp")
                    .forward(request, response);
        }
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