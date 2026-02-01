package controller;

import dao.ContractDAO;
import model.Contract;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContractServlet", urlPatterns = {"/contract"})
public class ContractServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ContractDAO dao = new ContractDAO();

        if (action == null) {
            // Hiển thị danh sách
            List<Contract> list = dao.getAllContracts();
            request.setAttribute("listC", list);
            request.getRequestDispatcher("Management/Contract-list.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            // Chuyển sang trang sửa
            int id = Integer.parseInt(request.getParameter("id"));
            Contract c = dao.getContractById(id);
            request.setAttribute("contract", c);
            request.getRequestDispatcher("contract-form.jsp").forward(request, response);
        } else if (action.equals("add")) {
            // Chuyển sang trang thêm mới
            request.getRequestDispatcher("contract-form.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ContractDAO dao = new ContractDAO();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            
            String idStr = request.getParameter("contractId");
            java.util.Date start = sdf.parse(request.getParameter("startDate"));
            java.util.Date end = sdf.parse(request.getParameter("endDate"));
            int status = Integer.parseInt(request.getParameter("status"));

            if (idStr == null || idStr.isEmpty()) {
                // Add new
                dao.addContract(new Contract(0, start, end, status, null, null));
            } else {
                // Update
                int id = Integer.parseInt(idStr);
                dao.updateContract(new Contract(id, start, end, status, null, null));
            }
            response.sendRedirect("contract");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}