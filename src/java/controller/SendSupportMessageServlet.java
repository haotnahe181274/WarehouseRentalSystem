    package controller;

    import dao.NotificationDAO;
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
    import model.Notification;
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
            String messageContent    = request.getParameter("messageContent");

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

                // Cắt ngắn preview tin nhắn cho notification (tối đa 60 ký tự)
                String preview = messageContent.trim();
                if (preview.length() > 60) {
                    preview = preview.substring(0, 60) + "...";
                }

                String subject = conversation.getSubject() != null
                        ? "\"" + conversation.getSubject() + "\""
                        : "support conversation #" + conversationId;

                if ("RENTER".equalsIgnoreCase(user.getType())) {
                    // ── Renter gửi tin nhắn ──────────────────────────────────
                    if (conversation.getRenterId() != user.getId()) {
                        response.sendRedirect(request.getContextPath() + "/support");
                        return;
                    }

                    message.setSenderType("RENTER");
                    message.setRenterId(user.getId());
                    message.setInternalUserId(null);

                    // Gửi notification cho Staff/Manager đang phụ trách conversation
                    try {
                        Integer assignedStaffId = conversation.getAssignedInternalUserId();
                        if (assignedStaffId != null && assignedStaffId > 0) {
                            Notification noti = new Notification();
                            noti.setTitle("New support message");
                            noti.setMessage("Renter sent a message in " + subject + ": \"" + preview + "\"");
                            noti.setType("INFO");
                            noti.setLinkUrl("?openChat=true&conversationId=" + conversationId);
                            noti.setInternalUserId(assignedStaffId);
                            new NotificationDAO().insertNotification(noti);
                        }
                        // Nếu chưa có staff phụ trách thì không gửi
                        // (staff sẽ thấy conversation trong danh sách unassigned)
                    } catch (Exception e) {
                        System.err.println("Failed to insert notification (renter→staff): " + e.getMessage());
                    }

                } else {
                    // ── Staff / Manager reply ─────────────────────────────────
                    message.setSenderType("INTERNAL_USER");
                    message.setRenterId(null);
                    message.setInternalUserId(user.getId());

                    // Tự động assign conversation nếu chưa có staff phụ trách
                    if (conversation.getAssignedInternalUserId() == null) {
                        conversationDAO.assignConversation(conversationId, user.getId());
                    }

                    // Gửi notification cho Renter
                    try {
                        Notification noti = new Notification();
                        noti.setTitle("New reply from WareSpace support");
                        noti.setMessage("Staff replied to your " + subject + ": \"" + preview + "\"");
                        noti.setType("INFO");
                       noti.setLinkUrl("?openChat=true&conversationId=" + conversationId);
                        noti.setRenterId(conversation.getRenterId());
                        new NotificationDAO().insertNotification(noti);
                    } catch (Exception e) {
                        System.err.println("Failed to insert notification (staff→renter): " + e.getMessage());
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