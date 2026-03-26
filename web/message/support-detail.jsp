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
    <title>Support Chat</title>

    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background: #f1f5f9;
        }

        /* HEADER CHAT */
        .chat-header {
            background: #0d6efd;
            color: white;
            padding: 12px;
            font-weight: bold;
        }

        /* MESSAGE AREA */
        .message-list {
            height: 320px;
            overflow-y: auto;
            padding: 12px;
            background: #f8fafc;
        }

        .message {
            padding: 10px 14px;
            border-radius: 12px;
            margin-bottom: 10px;
            max-width: 70%;
            word-wrap: break-word;
            font-size: 14px;
        }

        .renter {
            background: #dbeafe;
            margin-left: auto;
            text-align: right;
        }

        .internal {
            background: #e5e7eb;
            margin-right: auto;
        }

        .time {
            font-size: 11px;
            color: gray;
            margin-top: 4px;
        }

        /* INPUT AREA */
        .message-form {
            border-top: 1px solid #ddd;
            padding: 10px;
            background: white;
        }

        textarea {
            width: 100%;
            height: 60px;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 8px;
            resize: none;
        }

        button {
            margin-top: 6px;
            padding: 8px 14px;
            border: none;
            background: #0d6efd;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background: #0b5ed7;
        }

        .not-found {
            padding: 20px;
        }
    </style>
</head>

<body>

<% if (conversation == null) { %>
    <div class="not-found">
        Conversation not found.
    </div>
<% } else { %>

    <!-- HEADER -->
   

    <!-- MESSAGE LIST -->
    <div class="message-list" id="messageList">
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

    <!-- SEND MESSAGE -->
    <form class="message-form"
          action="${pageContext.request.contextPath}/send-support-message"
          method="post">

        <input type="hidden" name="conversationId"
               value="<%= conversation.getConversationId() %>">

        <textarea name="messageContent"
                  placeholder="Type your message..."
                  required></textarea>

        <button type="submit">Send</button>
    </form>

<% } %>

<script>
    // Auto scroll xuống tin nhắn cuối
    var messageList = document.getElementById("messageList");
    if (messageList) {
        messageList.scrollTop = messageList.scrollHeight;
    }
</script>

</body>
</html>