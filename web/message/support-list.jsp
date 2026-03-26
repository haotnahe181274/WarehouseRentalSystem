<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.SupportConversation" %>

<%
    ArrayList<SupportConversation> conversationList =
            (ArrayList<SupportConversation>) request.getAttribute("conversationList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Conversations</title>

    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background: #f1f5f9;
        }

        /* HEADER */
        .chat-header {
            background: #0d6efd;
            color: white;
            padding: 12px;
            font-weight: bold;
        }

        /* LIST */
        .conversation-list {
            height: 440px;
            overflow-y: auto;
            background: #f8fafc;
            padding: 10px;
        }

        .conversation-box {
            background: white;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            transition: 0.2s;
        }

        .conversation-box:hover {
            background: #eef2ff;
        }

        .conversation-box a {
            text-decoration: none;
            color: black;
            display: block;
        }

        .subject {
            font-weight: bold;
            font-size: 14px;
        }

        .meta {
            color: gray;
            font-size: 12px;
            margin-top: 4px;
        }

        .no-data {
            padding: 20px;
        }
    </style>
</head>
<body>



<div class="conversation-list">
    <%
        if (conversationList != null && !conversationList.isEmpty()) {
            for (SupportConversation c : conversationList) {
    %>
        <div class="conversation-box">
            <a href="${pageContext.request.contextPath}/send-support-message?conversationId=<%= c.getConversationId() %>&popup=true">
                <div class="subject"><%= c.getSubject() %></div>
                <div class="meta">
                    Status: <%= c.getStatus() %> |
                    Updated: <%= c.getUpdatedAt() %>
                </div>
            </a>
        </div>
    <%
            }
        } else {
    %>
        <div class="no-data">
            No conversations found.
        </div>
    <%
        }
    %>
</div>

</body>
</html>