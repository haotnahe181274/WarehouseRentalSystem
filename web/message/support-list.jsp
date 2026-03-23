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
        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: Arial, sans-serif;
        }

        .support-page {
            min-height: 120vh;
            padding: 20px;
            box-sizing: border-box;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .conversation-box {
            border: 1px solid #ccc;
            padding: 12px;
            margin-top: 10px;
            border-radius: 8px;
            background: #fff;
        }

        .conversation-box a {
            text-decoration: none;
            color: black;
            display: block;
        }

        .subject {
            font-weight: bold;
            font-size: 16px;
        }

        .meta {
            color: gray;
            font-size: 13px;
            margin-top: 5px;
        }

        .btn-create {
            padding: 8px 14px;
            background: #007bff;
            color: white;
            border-radius: 6px;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <jsp:include page="/Common/Layout/header.jsp" />

    <main class="support-page">
        <div class="header">
            <h2>Support Conversations</h2>
                   </div>

        <%
            if (conversationList != null && !conversationList.isEmpty()) {
                for (SupportConversation c : conversationList) {
        %>
            <div class="conversation-box">
                <a href="${pageContext.request.contextPath}/send-support-message?conversationId=<%= c.getConversationId() %>">
                    <div class="subject"><%= c.getSubject() %></div>
                    <div class="meta">
                        Status: <%= c.getStatus() %> |
                        Request ID: <%= c.getRequestId() == null ? "N/A" : c.getRequestId() %> |
                        Updated at: <%= c.getUpdatedAt() %>
                    </div>
                </a>
            </div>
        <%
                }
            } else {
        %>
            <p>No conversations found.</p>
        <%
            }
        %>
    </main>

    <jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>