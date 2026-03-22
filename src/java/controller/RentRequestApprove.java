package controller;

import dao.AssignmentDAO;
import dao.ContractDAO;
import dao.NotificationDAO;
import dao.RentRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InternalUser;
import model.Notification;
import model.RentRequest;
import model.UserView;

@WebServlet(name = "RentRequestApprove", urlPatterns = {"/rentRequestApprove"})
public class RentRequestApprove extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user = (UserView) session.getAttribute("user");
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        RentRequestDAO dao = new RentRequestDAO();
        ContractDAO contractDAO = new ContractDAO();
        RentRequest ren = dao.getRentRequestDetailById(requestId);

        // 1. Cập nhật trạng thái Request thành Approved
        dao.updateStatusByManager(requestId, 1, user.getId());

        // 2. Tạo Contract từ Request
        int contractId = contractDAO.insertContractFromRequest(requestId);

        // 3. Insert vào Contract_Storage_unit
        contractDAO.insertContractStorageUnit(contractId);

        // 4. Gửi notification cho Renter sau khi tất cả xử lý thành công
        try {
            Notification noti = new Notification();
            noti.setTitle("Rent request approved");
            noti.setMessage("Your rent request for warehouse \""
                    + ren.getWarehouse().getName()
                    + "\" has been approved. Your contract is ready.");
            noti.setType("SUCCESS");
            noti.setLinkUrl("/contract-detail?contractId=" + contractId);
            noti.setRenterId(ren.getRenter().getRenterId());
            new NotificationDAO().insertNotification(noti);
        } catch (Exception e) {
            // Không để lỗi notification ảnh hưởng đến luồng chính
            System.err.println("Failed to insert notification: " + e.getMessage());
        }

        // 5. Redirect sang trang chi tiết hợp đồng
        response.sendRedirect(request.getContextPath() + "/contract-detail?contractId=" + contractId);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}