<%-- 
    Document   : add
    Created on : Jan 28, 2026, 8:51:58 AM
    Author     : hao23
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Staff</title>
    </head>
    <body>
        <form action="${pageContext.request.contextPath}/user/list" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="${user != null ? 'update' : 'add'}"> 
            <c:if test= "${user != null}">
                <input type="hidden" name="id" value="${user.id}">
            </c:if>
            <c:if test ="${user == null}">
                Username:
                <input type="text" name="username"  required><br>
            </c:if>
            <c:if test="${user==null}">
                Password:
                <input type="password" name="password" required><br>
            </c:if>

            Email:
            <input type="email" name="email" value="${user.email}" required><br>
            Full Name:
            <input type="text" name="fullName" value="${user.fullName}" required><br>
            Phone: 
            <input type="text" name="phone" value="${user.phone}">
            Role:
            <select name="roleId">
                <option value="1">Admin</option>
                <option value="2">Manager</option>
                <option value="3">Staff</option>
            </select><br>
            Avatar:
            <input type="file" name="image"><br>
            <button type="submit">
                ${user == null ? "Add" : "Update"}
            </button>
        </form>


    </body>
</html>
