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

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ContractDAO dao = new ContractDAO();
        String action = request.getParameter("action");

        // Mặc định hiển thị danh sách hợp đồng
        if (action == null || "list".equals(action)) {
            List<Contract> list = dao.getAllContracts();
            request.setAttribute("listC", list);
            request.getRequestDispatcher("contract/Contract-list.jsp").forward(request, response);
        } 
        else if ("edit".equals(action)) {
            // Logic lấy 1 contract để sửa (giữ nguyên của bạn)
            int id = Integer.parseInt(request.getParameter("id"));
            Contract c = dao.getContractById(id);
            request.setAttribute("contract", c);
            request.getRequestDispatcher("contract/Contract-form.jsp").forward(request, response);
        }
    }

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
            // Khớp với hàm createContracts(int requestId) trong DAO
            if ("create".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                
                // Gọi hàm DAO trả về số dòng (int)
                int rowsAffected = dao.createContracts(requestId);

                if (rowsAffected > 0) {
                    session.setAttribute("message", "Thành công: Đã tạo " + rowsAffected + " hợp đồng.");
                } else {
                    // Nếu trả về 0, có thể do ID đã tồn tại trong Contract hoặc status != 1
                    session.setAttribute("error", "Không thể tạo hợp đồng. Vui lòng kiểm tra lại trạng thái yêu cầu hoặc yêu cầu này đã có hợp đồng rồi.");
                }
            }
            
            // Nếu bạn muốn làm nút "Tạo tất cả"
            else if ("createAll".equals(action)) {
                int totalCreated = dao.createContracts(0); // Truyền 0 để quét tất cả
                session.setAttribute("message", "Đã xử lý xong. Tổng số hợp đồng mới: " + totalCreated);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Redirect để tránh bị lặp lệnh Insert khi user F5 trình duyệt
        response.sendRedirect(request.getContextPath() + "/contract");
    }
}