package controller;

import dao.FeedbackDAO;
import dao.FeedbackResponseDAO;
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
import model.UserView;

@WebServlet(name = "FeedbackManagementServlet", urlPatterns = { "/feedbackManagement" })
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

            try {
                int feedbackId = Integer.parseInt(feedbackIdStr);

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
