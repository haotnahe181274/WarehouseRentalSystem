    package controller;

import dao.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.ContractDetail;
import model.UserView;

@WebServlet("/contract")
public class ContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user = (UserView) session.getAttribute("user");

        ContractDAO dao = new ContractDAO();
        List<ContractDetail> contracts;

// 2. Gọi hàm lấy số liệu thống kê (hàm chúng ta vừa viết)
Map<String, Integer> contractStats = dao.getContractStatistics();

// 3. Đẩy biến 'contractStats' sang JSP để hiển thị
request.setAttribute("contractStats", contractStats);
        
        if ("INTERNAL".equalsIgnoreCase(user.getType())
                && ("Manager".equalsIgnoreCase(user.getRole())
                || "Admin".equalsIgnoreCase(user.getRole()))) {

            contracts = dao.getAllContracts();

        } else if ("RENTER".equalsIgnoreCase(user.getType())) {

            contracts = dao.getContractsByRenter(user.getId());

        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Fetch counts for stats cards
        request.setAttribute("totalContracts", dao.countTotal());
        request.setAttribute("processingContracts", dao.countProcess());
        request.setAttribute("doneContracts", dao.countDone());
        request.setAttribute("expiredContracts", dao.countExpired());

        request.setAttribute("contractList", contracts);
        request.setAttribute("user", user);

        request.getRequestDispatcher("/contract/Contract-list.jsp")
               .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("endEarly".equals(action)) {

        int contractId = Integer.parseInt(request.getParameter("contractId"));

        ContractDAO dao = new ContractDAO();
        dao.endContractEarly(contractId);

        response.sendRedirect(request.getContextPath() + "/contract");
        return;
    }
}
}