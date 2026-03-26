/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vnpay.common;

import dao.ContractDAO;
import dao.PaymentDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.Payment;
import model.UserView;

/**
 *
 * @author CTT VNPAY
 */
@WebServlet(name = "ajaxServlet", urlPatterns = {"/payment"})
public class ajaxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String contextPath = req.getContextPath();
        String contractIdStr = req.getParameter("contractId");
        if (contractIdStr == null || contractIdStr.isEmpty()) {
            resp.sendRedirect(contextPath + "/contract");
            return;
        }
        int contractId;
        try {
            contractId = Integer.parseInt(contractIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(contextPath + "/contract");
            return;
        }

        // Token một lần: tránh double-submit, đồng thời mỗi lần thanh toán phải có TxnRef mới (VNPay không cho dùng lại mã cũ)
        HttpSession session = req.getSession(false);
        String tokenKey = "paymentToken_" + contractId;
        if (session == null) {
            resp.sendRedirect(contextPath + "/contract-detail?contractId=" + contractId + "&paymentError=2");
            return;
        }
        Object token = session.getAttribute(tokenKey);
        if (token == null) {
            resp.sendRedirect(contextPath + "/contract-detail?contractId=" + contractId + "&paymentError=2");
            return;
        }
        session.removeAttribute(tokenKey);

        ContractDAO dao = new ContractDAO();
        UserView user = (UserView) session.getAttribute("user");
        if (user == null || !"RENTER".equalsIgnoreCase(user.getType())) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // RENTER chỉ được ký & thanh toán nếu thỏa toàn bộ điều kiện theo yêu cầu nghiệp vụ
        if (!dao.canRenterAgreeAndPay(contractId, user.getId())) {
            // Nếu unit/kho đã bị thuê trùng hoặc không thỏa điều kiện nghiệp vụ
            // thì chuyển contract sang trạng thái 0 để tránh còn hiển thị/cho phép thanh toán tiếp.
            dao.rejectContract(contractId);
            resp.sendRedirect(contextPath + "/contract-detail?contractId=" + contractId + "&paymentError=3");
            return;
        }

        Contract contract = dao.getContractById(contractId);
        if (contract == null) {
            resp.sendRedirect(contextPath + "/contract");
            return;
        }
        double amountDouble = contract.getPrice();

        String bankCode = req.getParameter("bankCode");
        PaymentDAO paymentDao = new PaymentDAO();
        Payment payment = new Payment();
        payment.setAmount(amountDouble);
        payment.setContract(contract);

        int orderId = paymentDao.insertPayment(payment);

        if (orderId < 1) {
            resp.sendRedirect(contextPath + "/contract-detail?contractId=" + contractId + "&paymentError=1");
            return;
        }

        // ==================== DEV TEST: Auto success (bypass VNPay) ====================
        // Nếu VNPay đang lỗi và bạn muốn bấm "Đồng ý hợp đồng" là tự hiện thành công để test UI,
         boolean devAutoPay = true; // <-- đặt true khi cần auto success
         if (devAutoPay) {
             // Mark Payment.status = 1 (thành công) ngay lập tức
             Payment paymen = new Payment();
             paymen.setPaymentId(orderId);
             paymen.setStatus(1);
             paymentDao.updatePaymentStatus(paymen);
        
             // Điều hướng tới trang hiển thị kết quả như VNPay callback
             req.setAttribute("transResult", true);
             req.getRequestDispatcher("Payment/paymentResult.jsp")
                    .forward(req, resp);
             return;
         }
        // ==================== END DEV TEST ====================

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";

        long amount = (long) (amountDouble * 100);
        String vnp_TxnRef = String.valueOf(orderId);
        String vnp_IpAddr = Config.getIpAddress(req);

        String vnp_TmnCode = Config.vnp_TmnCode;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);

        String locate = req.getParameter("language");
        if (locate != null && !locate.isEmpty()) {
            vnp_Params.put("vnp_Locale", locate);
        } else {
            vnp_Params.put("vnp_Locale", "vn");
        }
        // ReturnUrl động theo môi trường đang chạy để tránh lỗi redirect thỉnh thoảng
        String vnp_ReturnUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + contextPath + "/vnpay-return";
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        // Use Vietnam timezone explicitly. Also set timezone for formatter để tránh lệch giờ theo server default timezone.
        TimeZone vnTimeZone = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar cld = Calendar.getInstance(vnTimeZone);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(vnTimeZone);
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        // Tăng thời gian hết hạn để giảm lỗi "code=01" do chờ lâu/timeout
        cld.add(Calendar.MINUTE, 60);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;

        // Debug giúp khoanh vùng khi VNPay trả code=01 (thỉnh thoảng thành công/thất bại)
        System.out.println("VNPay request:");
        System.out.println("  vnp_TxnRef=" + vnp_TxnRef);
        System.out.println("  vnp_Amount=" + amount);
        System.out.println("  vnp_CreateDate=" + vnp_Params.get("vnp_CreateDate"));
        System.out.println("  vnp_ExpireDate=" + vnp_Params.get("vnp_ExpireDate"));
        System.out.println("  vnp_IpAddr=" + vnp_IpAddr);
        System.out.println("  vnp_ReturnUrl=" + vnp_Params.get("vnp_ReturnUrl"));
        System.out.println("  paymentUrl(secureHash omitted) prefix=" + paymentUrl.substring(0, Math.min(paymentUrl.length(), 120)));
        resp.sendRedirect(paymentUrl);
    }
}
