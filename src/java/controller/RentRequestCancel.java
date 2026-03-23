package controller;

import dao.NotificationDAO;
import dao.RentRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.RentRequest;
import model.UserView;

@WebServlet(name = "RentRequestCancel", urlPatterns = {"/rentRequestCancel"})
public class RentRequestCancel extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/rentList");
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
        String userType = (String) session.getAttribute("userType");

        if (userType == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String redirect = request.getParameter("redirect");

        RentRequestDAO dao = new RentRequestDAO();

        // Lấy thông tin request TRƯỚC khi update (sau update có thể mất context)
        RentRequest ren = dao.getRentRequestDetailById(requestId);
        String warehouseName = (ren != null && ren.getWarehouse() != null)
                ? ren.getWarehouse().getName() : "N/A";

        if ("RENTER".equals(userType)) {
            // Renter tự hủy request của mình
            dao.cancelByRenter(requestId, user.getId());

            // Không cần gửi notification vì chính renter là người hủy
            // (họ biết rồi). Chỉ gửi nếu muốn lưu lịch sử — bỏ comment nếu cần:
            /*
            try {
                Notification noti = new Notification();
                noti.setTitle("Rent request cancelled");
                noti.setMessage("You have cancelled your rent request for warehouse \""
                        + warehouseName + "\".");
                noti.setType("WARNING");
                noti.setLinkUrl("/rentList");
                noti.setRenterId(user.getId());
                new NotificationDAO().insertNotification(noti);
            } catch (Exception e) {
                System.err.println("Failed to insert notification: " + e.getMessage());
            }
            */

        } else if ("INTERNAL".equals(userType)) {
            // Manager reject request → gửi notification cho Renter
            dao.updateStatusByManager(requestId, 2, user.getId());

            try {
                if (ren != null && ren.getRenter() != null) {
                    Notification noti = new Notification();
                    noti.setTitle("Rent request rejected");
                    noti.setMessage("Your rent request for warehouse \""
                            + warehouseName
                            + "\" has been rejected. Please contact us for more information.");
                    noti.setType("WARNING");
                    noti.setLinkUrl("/rentDetail?id=" + requestId);
                    noti.setRenterId(ren.getRenter().getRenterId());
                    new NotificationDAO().insertNotification(noti);
                }
            } catch (Exception e) {
                System.err.println("Failed to insert notification: " + e.getMessage());
            }
        }

        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/rentDetail?id=" + requestId);
        } else {
            response.sendRedirect(request.getContextPath() + "/rentList");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}