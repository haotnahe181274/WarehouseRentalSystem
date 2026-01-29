<%-- 
    Document   : viewdetails
    Created on : Jan 28, 2026, 4:13:06 PM
    Author     : hao23
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    </head>
    <body>
  
        <h2>User Detail</h2>

    <c:if test="${not empty user.image}">
        <img src="${pageContext.request.contextPath}/image/user/${user.image}">
    </c:if>

    <div class="row"><label>Username:</label> ${user.name}</div>
    <div class="row"><label>Email:</label> ${user.email}</div>
    <div class="row"><label>Full Name:</label> ${user.fullName}</div>
    <div class="row"><label>Phone:</label> ${user.phone}</div>

    <div class="row">
        <label>Role:</label>
        <c:choose>
            <c:when test="${user.type == 'INTERNAL'}">
                ${user.role}
            </c:when>
            <c:otherwise>-</c:otherwise>
        </c:choose>
    </div>

    <div class="row"><label>Type:</label> ${user.type}</div>

    <div class="row">
        <label>Status:</label>
        <c:choose>
            <c:when test="${user.status == 1}">Active</c:when>
            <c:otherwise>Blocked</c:otherwise>
        </c:choose>
    </div>

    <div class="row">
        <label>Created At:</label>
        <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
    </div>

    <br>
    <a href="${pageContext.request.contextPath}/user/list">← Back to list</a>
</div>
</body>
</html>
