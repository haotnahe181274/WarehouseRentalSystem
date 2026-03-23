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

@WebServlet(name = "SupportServlet", urlPatterns = {"/support"})
public class SupportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserView user = (session != null) ? (UserView) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SupportConversationDAO conversationDAO = new SupportConversationDAO();
        SupportMessageDAO messageDAO = new SupportMessageDAO();

        try {
            if ("RENTER".equalsIgnoreCase(user.getType())) {
                int renterId = user.getId();

                SupportConversation conversation = conversationDAO.getDefaultConversationByRenter(renterId);

                if (conversation == null) {
                    int conversationId = conversationDAO.createDefaultConversation(renterId);
                    if (conversationId > 0) {
                        conversation = conversationDAO.getConversationById(conversationId);
                    }
                }

                ArrayList<SupportMessage> messageList = new ArrayList<>();
                if (conversation != null) {
                    messageList = messageDAO.getMessagesByConversationId(conversation.getConversationId());
                    messageDAO.markMessagesAsReadByRenter(conversation.getConversationId());
                }

                request.setAttribute("conversation", conversation);
                request.setAttribute("messageList", messageList);
                request.getRequestDispatcher("/message/support-detail.jsp").forward(request, response);

            } else {
                ArrayList<SupportConversation> conversationList = conversationDAO.getConversationsByInternalUser(user.getId());
                ArrayList<SupportConversation> unassignedList = conversationDAO.getUnassignedConversations();

                for (SupportConversation c : unassignedList) {
                    boolean existed = false;
                    for (SupportConversation item : conversationList) {
                        if (item.getConversationId() == c.getConversationId()) {
                            existed = true;
                            break;
                        }
                    }
                    if (!existed) {
                        conversationList.add(c);
                    }
                }

                request.setAttribute("conversationList", conversationList);
                request.getRequestDispatcher("/message/support-list.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}