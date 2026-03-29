package com.vnpay.common;

import dao.NotificationDAO;
import dao.PaymentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import model.Notification;
import model.Payment;

@WebServlet(name = "VnpayReturn", urlPatterns = {"/vnpay-return"})
public class VnpayReturn extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            // Thu thập tất cả fields từ VNPay callback
            Map<String, String> fields = new HashMap<>();

            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = params.nextElement(); // giữ nguyên
                String fieldValue = request.getParameter(fieldName); // lấy value chuẩn

                if (fieldValue != null && !fieldValue.isEmpty()) {
                    fields.put(fieldName, fieldValue);
                }
            }

            PaymentDAO paymentDao = new PaymentDAO();

            // Xác thực chữ ký VNPay
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }

            String signValue = Config.hashAllFields(fields);

            if (signValue.equals(vnp_SecureHash)) {
                int paymentId = Integer.parseInt(request.getParameter("vnp_TxnRef"));
                boolean transSuccess = "00".equals(request.getParameter("vnp_TransactionStatus"));

                // Cập nhật trạng thái payment
                Payment payment = new Payment();
                payment.setPaymentId(paymentId);
                payment.setStatus(transSuccess ? 1 : 2);
                paymentDao.updatePaymentStatus(payment);

                // Gửi notification nếu thanh toán thành công
                if (transSuccess) {
                    try {
                        // Lấy thông tin đầy đủ của payment (có contractId, renterId, amount)
                        Payment fullPayment = paymentDao.getPaymentById(paymentId);

                        if (fullPayment != null && fullPayment.getContract().getRenter().getRenterId() > 0) {
                            String amountStr = String.format("%,.0f", fullPayment.getAmount());

                            Notification noti = new Notification();
                            noti.setTitle("Payment successful");
                            noti.setMessage("Your payment of " + amountStr
                                    + " VND for contract #" + fullPayment.getContract().getContractId()
                                    + " has been received successfully.");
                            noti.setType("SUCCESS");
                            noti.setLinkUrl("/payments");
                            noti.setRenterId(fullPayment.getContract().getRenter().getRenterId());
                            new NotificationDAO().insertNotification(noti);
                        }
                    } catch (Exception e) {
                        System.err.println("Failed to insert notification: " + e.getMessage());
                    }
                }

                request.setAttribute("transResult", transSuccess);
                request.getRequestDispatcher("Payment/paymentResult.jsp").forward(request, response);

            } else {
                System.out.println("GD KO HOP LE (invalid signature)");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
