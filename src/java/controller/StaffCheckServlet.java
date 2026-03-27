package controller;

import dao.StaffTaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CheckRequest;
import model.CheckRequestItem;
import model.UserView;

@WebServlet("/staffCheck")
public class StaffCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserView staff = (UserView) session.getAttribute("user");
        if (staff == null) {
            response.sendRedirect("login");
            return;
        }

        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        StaffTaskDAO dao = new StaffTaskDAO();

        int requestId = dao.getRequestIdByAssignment(assignmentId);
        CheckRequest checkRequest = dao.getCheckRequestById(requestId);
        for (CheckRequestItem item : checkRequest.getItems()) {
            int totalProcessed = dao.getTotalProcessedQty(item.getItemId(), checkRequest.getId());
            item.setProcessedQuantity(totalProcessed);
        }
        request.setAttribute("checkRequest", checkRequest);
        request.setAttribute("assignmentId", assignmentId);

        request.getRequestDispatcher("/staff/staff_check.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StaffTaskDAO dao = new StaffTaskDAO();
        HttpSession session = request.getSession();
        UserView staff = (UserView) session.getAttribute("user");

        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int requestId = Integer.parseInt(request.getParameter("requestId"));

            CheckRequest checkRequest = dao.getCheckRequestById(requestId);
            String type = checkRequest.getRequestType(); // CHECK_IN / CHECK_OUT / CHECK

            String action = request.getParameter("action"); // save hoặc complete

            for (CheckRequestItem item : checkRequest.getItems()) {
                String raw = request.getParameter("processed_" + item.getId());
                int qty = (raw != null && !raw.isEmpty()) ? Integer.parseInt(raw) : 0;
                
                if ("save".equalsIgnoreCase(action)) {
                    // ==== LƯU TẠM ====
                    if (qty > 0) {
                        dao.insertInventoryLog(
                                "CHECK_IN".equalsIgnoreCase(type) ? 1 : 2, // action
                                qty,
                                item.getItemId(),
                                checkRequest.getUnitId(),
                                staff.getId(),
                                checkRequest.getId() // thêm check_request_id
                        );
                        int totalQty = dao.getTotalProcessedQty(item.getItemId(), checkRequest.getId());
                        item.setProcessedQuantity(totalQty);
                    }
                } else if ("complete".equalsIgnoreCase(action)) {
                    // ==== HOÀN TẤT ====
                    int totalQty = dao.getTotalInventoryLogQty(item.getId(), checkRequest.getId());

                    if (totalQty > 0) {
                        int requestedQty = item.getQuantity();
                            String status;

                            if (totalQty == requestedQty) {
                                status = "done";
                            } else {
                                status = "fail";
                            }
                        // 1. Cập nhật processed_quantity và status
                        dao.updateCheckRequestItem(item.getId(), totalQty, status);

                        // 2. Cập nhật kho
                      
                    }
                }
            }

            if ("complete".equalsIgnoreCase(action)) {
                dao.completeAssignment(assignmentId);
                response.sendRedirect("staffTask?status=success");
            } else {
                response.sendRedirect("staffCheck?assignmentId=" + assignmentId + "&status=saved");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staffTask?status=error");
        }
    }
}