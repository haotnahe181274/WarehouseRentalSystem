package controller;

import dao.PaymentDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Payment;
import model.UserView;

/**
 * Hiển thị danh sách tất cả payment của user (RENTER).
 */
@WebServlet(name = "PaymentListServlet", urlPatterns = {"/payments"})
public class PaymentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        if (!"RENTER".equalsIgnoreCase(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        List<Payment> payments = paymentDAO.getPaymentsByRenterId(user.getId());

        request.setAttribute("payments", payments);

        // Forward tới trang JSP hiển thị danh sách
        request.getRequestDispatcher("/Payment/paymentList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Danh sách payment của renter hiện tại";
    }
}

