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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
    <style>
        .support-list-panel {
            height: 440px;
            overflow-y: auto;
            background: var(--mgmt-bg, #f5f7fb);
            padding: 12px;
            border-radius: 12px;
            border: 1px solid var(--mgmt-border, #e2e8f0);
        }
        .conversation-box {
            background: var(--mgmt-card-bg, #ffffff);
            padding: 12px 14px;
            border-radius: var(--mgmt-radius, 12px);
            margin-bottom: 10px;
            border: 1px solid var(--mgmt-border, #e2e8f0);
            box-shadow: var(--mgmt-shadow, 0 1px 3px rgba(0, 0, 0, 0.06));
            transition: background 0.15s ease;
        }
        .conversation-box:hover {
            background: #f9fafb;
        }
        .conversation-box a {
            text-decoration: none;
            color: #111827;
            display: block;
        }
        .subject {
            font-weight: 600;
            font-size: 14px;
            color: #111827;
        }
        .meta {
            color: #6b7280;
            font-size: 12px;
            margin-top: 6px;
        }
        .no-data {
            padding: 20px;
            text-align: center;
            color: #6b7280;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="support-list-panel">
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
            No conversations yet.
        </div>
    <%
        }
    %>
</div>

</body>
</html>
