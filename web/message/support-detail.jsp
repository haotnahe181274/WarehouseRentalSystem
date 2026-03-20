<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.SupportConversation" %>
<%@ page import="model.SupportMessage" %>
<%@ page import="model.UserView" %>

<%
    SupportConversation conversation = (SupportConversation) request.getAttribute("conversation");
    ArrayList<SupportMessage> messageList =
            (ArrayList<SupportMessage>) request.getAttribute("messageList");

    UserView user = (UserView) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Conversation Detail</title>
    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: #f7f8fa;
        }

        /* Bọc toàn bộ nội dung trang để footer nằm dưới */
        .page-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Phần nội dung chính */
        .page-content {
            flex: 1;
            width: 100%;
            padding: 40px 20px 80px; /* tạo khoảng cách với header và footer */
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .conversation-info {
            border: 1px solid #dcdfe4;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .conversation-info h2 {
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 22px;
        }

        .conversation-info p {
            margin: 10px 0;
            font-size: 16px;
        }

        .message-list {
            border: 1px solid #dcdfe4;
            border-radius: 12px;
            padding: 16px;
            min-height: 360px;
            max-height: 500px;
            overflow-y: auto;
            margin-bottom: 20px;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .message {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 14px;
            max-width: 72%;
            word-wrap: break-word;
            clear: both;
        }

        .renter {
            background-color: #dbeafe;
            margin-left: auto;
            text-align: right;
        }

        .internal {
            background-color: #f1f5f9;
            margin-right: auto;
            text-align: left;
        }

        .time {
            font-size: 12px;
            color: #6b7280;
            margin-top: 6px;
        }

        .message-form {
            background: #fff;
            border: 1px solid #dcdfe4;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        textarea {
            width: 100%;
            min-height: 110px;
            padding: 12px;
            border: 1px solid #cfd6df;
            border-radius: 8px;
            resize: vertical;
            font-size: 14px;
            outline: none;
        }

        textarea:focus {
            border-color: #3b82f6;
        }

        button {
            margin-top: 12px;
            padding: 10px 18px;
            border: none;
            background-color: #0d6efd;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
        }

        button:hover {
            background-color: #0b5ed7;
        }

        .not-found {
            background: #fff;
            border: 1px solid #dcdfe4;
            border-radius: 12px;
            padding: 24px;
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <jsp:include page="/Common/Layout/header.jsp" />

        <main class="page-content">
            <div class="container">
                <% if (conversation == null) { %>
                    <div class="not-found">
                        <p>Conversation not found.</p>
                    </div>
                <% } else { %>
                    <div class="conversation-info">
                        <h2><%= conversation.getSubject() %></h2>
                        <p>Status: <strong><%= conversation.getStatus() %></strong></p>
                        <p>Request ID: <%= conversation.getRequestId() == null ? "N/A" : conversation.getRequestId() %></p>
                        <p>
                            Assigned Internal User ID:
                            <%= conversation.getAssignedInternalUserId() == null ? "Not assigned" : conversation.getAssignedInternalUserId() %>
                        </p>
                    </div>

                    <div class="message-list">
                        <%
                            if (messageList != null && !messageList.isEmpty()) {
                                for (SupportMessage m : messageList) {
                                    boolean isRenterMessage = "RENTER".equalsIgnoreCase(m.getSenderType());
                        %>
                            <div class="message <%= isRenterMessage ? "renter" : "internal" %>">
                                <div><%= m.getMessageContent() %></div>
                                <div class="time"><%= m.getSentAt() %></div>
                            </div>
                        <%
                                }
                            } else {
                        %>
                            <p>No messages yet.</p>
                        <%
                            }
                        %>
                    </div>

                    <form class="message-form" action="${pageContext.request.contextPath}/send-support-message" method="post">
                        <input type="hidden" name="conversationId" value="<%= conversation.getConversationId() %>">
                        <textarea name="messageContent" placeholder="Enter your message..." required></textarea>
                        <button type="submit">Send</button>
                    </form>
                <% } %>
            </div>
        </main>

        <jsp:include page="/Common/Layout/footer.jsp" />
    </div>
</body>
</html>