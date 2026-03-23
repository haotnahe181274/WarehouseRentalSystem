package controller;

import dao.FeedbackDAO;
import dao.FeedbackResponseDAO;
import dao.NotificationDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;
import model.FeedbackResponse;
import model.Notification;
import model.UserView;

@WebServlet(name = "FeedbackManagementServlet", urlPatterns = { "/feedbackManagement" })
@WebServlet(name = "FeedbackManagementServlet", urlPatterns = {"/feedbackManagement"})
public class FeedbackManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserView user = (UserView) session.getAttribute("user");
        // Only Admin, Manager, or Internal users can access
        if (!"Internal".equalsIgnoreCase(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
        request.setAttribute("feedbackList", feedbackList);

        FeedbackResponseDAO responseDAO = new FeedbackResponseDAO();
        Map<Integer, FeedbackResponse> feedbackResponses = responseDAO.getAllResponses();
        request.setAttribute("feedbackResponses", feedbackResponses);

        request.setAttribute("totalFeedback",   feedbackDAO.countTotal());
        request.setAttribute("pendingFeedback",  feedbackDAO.countPending());
        request.setAttribute("repliedFeedback",  feedbackDAO.countReplied());

>>>>>>> Stashed changes
        request.getRequestDispatcher("/Management/feedback-management.jsp").forward(request, response);
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
        if (!"Internal".equalsIgnoreCase(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        String action = request.getParameter("action");
        if ("reply".equals(action)) {
            String feedbackIdStr = request.getParameter("feedbackId");
            String responseText = request.getParameter("responseText");
            String responseText  = request.getParameter("responseText");

            try {
                int feedbackId = Integer.parseInt(feedbackIdStr);

                // Build response object
                FeedbackResponse feedbackResponse = new FeedbackResponse();
                feedbackResponse.setResponseText(responseText);

                model.Feedback feedback = new model.Feedback();
                feedback.setFeedbackId(feedbackId);
                feedbackResponse.setFeedback(feedback);

                model.InternalUser internalUser = new model.InternalUser();
                internalUser.setInternalUserId(user.getId());
                feedbackResponse.setInternalUser(internalUser);

                FeedbackResponseDAO dao = new FeedbackResponseDAO();
                boolean success = dao.insertResponse(feedbackResponse);

                if (!success) {
                if (success) {
                    // Lấy Feedback gốc để có renterId
                    try {
                        FeedbackDAO feedbackDAO = new FeedbackDAO();
                        Feedback originalFeedback = feedbackDAO.getFeedbackById(feedbackId);

                        if (originalFeedback != null && originalFeedback.getRenterId() > 0) {
                            // Cắt ngắn preview response text (tối đa 60 ký tự)
                            String preview = responseText != null ? responseText.trim() : "";
                            if (preview.length() > 60) {
                                preview = preview.substring(0, 60) + "...";
                            }

                            Notification noti = new Notification();
                            noti.setTitle("WareSpace replied to your feedback");
                            noti.setMessage("Our team has responded to your feedback: \""
                                    + preview + "\"");
                            noti.setType("INFO");
                            noti.setLinkUrl("/contract");
                            noti.setRenterId(originalFeedback.getRenterId());
                            new NotificationDAO().insertNotification(noti);
                        }
                    } catch (Exception e) {
                        System.err.println("Failed to insert notification: " + e.getMessage());
                    }
                } else {
                    System.out.println("FeedbackManagement: Failed to insert response for feedbackId=" + feedbackId);
                }

            } catch (Exception e) {
                System.out.println("FeedbackManagement: Error processing reply");
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/feedbackManagement");
    }
}
}