package controller;

import dao.ContractDAO;
import dao.FeedbackDAO;
import dao.FeedbackResponseDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
import model.InternalUser;
import model.UserView;
import model.Contract;
import model.Renter;
import ultis.UserValidation;

@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserView user = session != null ? (UserView) session.getAttribute("user") : null;

        String warehouseIdStr = request.getParameter("warehouseId");
        if (warehouseIdStr == null || warehouseIdStr.isEmpty()) {
            if (request.getAttribute("jakarta.servlet.include.request_uri") == null) {
                response.sendRedirect(request.getContextPath() + "/homepage");
            }
            return;
        }

        try {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> feedbackList = feedbackDAO.getFeedbackByWarehouseId(warehouseId);

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("warehouseId", warehouseId);

            // Check if user can feedback
            boolean canFeedback = false;

            if (user != null && "RENTER".equalsIgnoreCase(user.getType())) {
                ContractDAO contractDAO = new ContractDAO();
                int contractId = contractDAO.getValidContractId(user.getId(), warehouseId);
                if (contractId != -1) {
                    canFeedback = !feedbackDAO.hasFeedbackBeenGiven(contractId);
                    request.setAttribute("hasAlreadyFeedback", !canFeedback);
                }
            }
            request.setAttribute("canFeedback", canFeedback);

            // Fetch responses
            FeedbackResponseDAO responseDAO = new FeedbackResponseDAO();
            Map<Integer, FeedbackResponse> feedbackResponses = responseDAO.getResponsesByWarehouseId(warehouseId);
            request.setAttribute("feedbackResponses", feedbackResponses);

            // Check if user can reply (Manager or Admin)
            boolean canReply = false;
            if (user != null && ("MANAGER".equalsIgnoreCase(user.getRole()) || "ADMIN".equalsIgnoreCase(user.getRole())
                    || "Internal".equalsIgnoreCase(user.getType()))) {
                canReply = true;
            }
            request.setAttribute("canReply", canReply);

            request.getRequestDispatcher("/feedback.jsp").include(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (request.getAttribute("jakarta.servlet.include.request_uri") == null) {
                response.sendRedirect(request.getContextPath() + "/homepage");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login"); // Or access denied page
            return;
        }

        String action = request.getParameter("action");
        if ("reply".equals(action)) {
            handleReply(request, response, user);
            return;
        }

        if (!"RENTER".equalsIgnoreCase(user.getType())) {
            response.sendRedirect("login");
            return;
        }

        String warehouseIdStr = request.getParameter("warehouseId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String anonymousStr = request.getParameter("anonymous");

        try {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            int rating = Integer.parseInt(ratingStr);
            boolean isAnonymous = "on".equals(anonymousStr) || "true".equals(anonymousStr);

            if (!UserValidation.isValidString(comment)) {
                request.setAttribute("error", "Comment must not have leading/trailing spaces or consecutive spaces.");
                request.setAttribute("warehouseId", warehouseId);
                doGet(request, response);
                return;
            }

            ContractDAO contractDAO = new ContractDAO();
            int contractId = contractDAO.getValidContractId(user.getId(), warehouseId);

            if (contractId != -1) {
                Feedback feedback = new Feedback();
                feedback.setRating(rating);
                feedback.setComment(comment);
                feedback.setAnonymous(isAnonymous);

                Renter renter = new Renter();
                renter.setRenterId(user.getId());
                feedback.setRenter(renter);

                Contract contract = new Contract();
                contract.setContractId(contractId);
                feedback.setContract(contract);

                FeedbackDAO feedbackDAO = new FeedbackDAO();
                if (feedbackDAO.hasFeedbackBeenGiven(contractId)) {
                    request.setAttribute("error", "You have already submitted feedback for this contract.");
                    doGet(request, response);
                    return;
                }
                feedbackDAO.insertFeedback(feedback);

                // Redirect to avoid resubmission and show updated list
                response.sendRedirect("warehouse/detail?id=" + warehouseId);
            } else {
                // User does not have a valid contract
                request.setAttribute("error", "You need a valid contract to submit feedback.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("homepage");
        }
    }

    private void handleReply(HttpServletRequest request,
            HttpServletResponse response, UserView user)
            throws IOException {
        // Check permission again
        if (!"Internal".equalsIgnoreCase(user.getType())) {
            response.sendRedirect("homepage");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        String responseText = request.getParameter("responseText");
        String warehouseIdStr = request.getParameter("warehouseId");
        String redirectTo = request.getParameter("redirectTo");

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);
            int warehouseId = Integer.parseInt(warehouseIdStr);

            if (!UserValidation.isValidString(responseText)) {
                request.setAttribute("error", "Response must not have leading/trailing spaces or consecutive spaces.");
                request.setAttribute("warehouseId", warehouseId);
                doGet(request, response);
                return;
            }

            FeedbackResponse feedbackResponse = new FeedbackResponse();
            feedbackResponse.setResponseText(responseText);

            Feedback feedback = new Feedback();
            feedback.setFeedbackId(feedbackId);
            feedbackResponse.setFeedback(feedback);

            InternalUser internalUser = new InternalUser();
            internalUser.setInternalUserId(user.getId());
            feedbackResponse.setInternalUser(internalUser);

            FeedbackResponseDAO dao = new FeedbackResponseDAO();
            dao.insertResponse(feedbackResponse);

            // Redirect based on source page
            if ("feedbackManagement".equals(redirectTo)) {
                response.sendRedirect("feedbackManagement");
            } else {
                response.sendRedirect("warehouse/detail?id=" + warehouseId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("homepage");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
