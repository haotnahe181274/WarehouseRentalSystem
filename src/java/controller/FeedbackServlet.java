package controller;

import dao.ContractDAO;
import dao.FeedbackDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;
import model.UserView;
import model.Contract;
import model.Renter;

@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String warehouseIdStr = request.getParameter("warehouseId");
        if (warehouseIdStr == null || warehouseIdStr.isEmpty()) {
            response.sendRedirect("homepage"); // Or logic to handle missing ID
            return;
        }

        try {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> feedbackList = feedbackDAO.getFeedbackByWarehouseId(warehouseId);

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("warehouseId", warehouseId);

            // Check if user can feedback
            HttpSession session = request.getSession();
            UserView user = (UserView) session.getAttribute("user");
            boolean canFeedback = false;

            if (user != null && "RENTER".equalsIgnoreCase(user.getType())) {
                ContractDAO contractDAO = new ContractDAO();
                int contractId = contractDAO.getValidContractId(user.getId(), warehouseId); // UserView.id is renter_id
                                                                                            // for Renter
                if (contractId != -1) {
                    canFeedback = true;
                }
            }
            request.setAttribute("canFeedback", canFeedback);

            request.getRequestDispatcher("feedback.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("homepage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserView user = (UserView) session.getAttribute("user");

        if (user == null || !"RENTER".equalsIgnoreCase(user.getType())) {
            response.sendRedirect("login"); // Or access denied page
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
                feedbackDAO.insertFeedback(feedback);

                // Redirect to avoid resubmission and show updated list
                response.sendRedirect("feedback?warehouseId=" + warehouseId);
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
