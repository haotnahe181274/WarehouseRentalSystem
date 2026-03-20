package controller;

import dao.SupportConversationDAO;
import dao.SupportMessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.SupportConversation;
import model.SupportMessage;
import model.UserView;

@WebServlet(name = "SendSupportMessageServlet", urlPatterns = {"/send-support-message"})
public class SendSupportMessageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String conversationIdRaw = request.getParameter("conversationId");
        if (conversationIdRaw == null || conversationIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }

        try {
            int conversationId = Integer.parseInt(conversationIdRaw);

            SupportConversationDAO conversationDAO = new SupportConversationDAO();
            SupportMessageDAO messageDAO = new SupportMessageDAO();

            SupportConversation conversation = conversationDAO.getConversationById(conversationId);
            ArrayList<SupportMessage> messageList = messageDAO.getMessagesByConversationId(conversationId);

            if (conversation == null) {
                response.sendRedirect(request.getContextPath() + "/support");
                return;
            }

            if ("RENTER".equalsIgnoreCase(user.getType())) {
                if (conversation.getRenterId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/support");
                    return;
                }
            }

            request.setAttribute("conversation", conversation);
            request.setAttribute("messageList", messageList);
            request.getRequestDispatcher("/message/support-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/support");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String conversationIdRaw = request.getParameter("conversationId");
        String messageContent = request.getParameter("messageContent");

        if (conversationIdRaw == null || messageContent == null || messageContent.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }

        try {
            int conversationId = Integer.parseInt(conversationIdRaw);

            SupportConversationDAO conversationDAO = new SupportConversationDAO();
            SupportConversation conversation = conversationDAO.getConversationById(conversationId);

            if (conversation == null) {
                response.sendRedirect(request.getContextPath() + "/support");
                return;
            }

            SupportMessage message = new SupportMessage();
            message.setConversationId(conversationId);
            message.setMessageContent(messageContent.trim());
            message.setIsRead(false);

            if ("RENTER".equalsIgnoreCase(user.getType())) {
                if (conversation.getRenterId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/support");
                    return;
                }

                message.setSenderType("RENTER");
                message.setRenterId(user.getId());
                message.setInternalUserId(null);
            } else {
                message.setSenderType("INTERNAL_USER");
                message.setRenterId(null);
                message.setInternalUserId(user.getId());

                if (conversation.getAssignedInternalUserId() == null) {
                    conversationDAO.assignConversation(conversationId, user.getId());
                }
            }

            SupportMessageDAO messageDAO = new SupportMessageDAO();
            messageDAO.sendMessage(message);
            conversationDAO.updateConversationTime(conversationId);

            response.sendRedirect(request.getContextPath() + "/send-support-message?conversationId=" + conversationId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}