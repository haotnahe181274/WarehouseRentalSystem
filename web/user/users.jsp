<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User</title>
    </head>
    <body>

        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Add User</c:when>
                <c:when test="${mode == 'edit'}">Update User</c:when>
                <c:otherwise>User Detail</c:otherwise>
            </c:choose>
        </h2>

        <form 
            action="${pageContext.request.contextPath}/user/list"
            method="post"
            enctype="multipart/form-data">

            <input type="hidden" name="action" value="save">
            <input type="hidden" name="mode" value="${mode}">

            <c:if test="${user != null}">
                <input type="hidden" name="id" value="${user.id}">
                <input type="hidden" name="type" value="${user.type}">
            </c:if>

            <!-- AVATAR -->
            <c:if test="${not empty user.image}">
                <img src="${pageContext.request.contextPath}/image/user/${user.image}" width="120"><br>
            </c:if>

            <!-- USERNAME -->
            <div>
                <label>Username:</label>
                <c:choose>
                    <c:when test="${mode == 'view'}">${user.name}</c:when>
                    <c:when test="${mode == 'add'}">
                        <input type="text" name="username" required>
                    </c:when>
                    <c:otherwise>${user.name}</c:otherwise>
                </c:choose>
            </div>

            <!-- PASSWORD (CHỈ ADD) -->
            <c:if test="${mode == 'add'}">
                <div>
                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>
            </c:if>

            <!-- EMAIL -->
            <div>
                <label>Email:</label>
                <c:choose>
                    <c:when test="${mode == 'view'}">${user.email}</c:when>
                    <c:otherwise>
                        <input type="email" name="email" value="${user.email}" required>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- FULL NAME -->
            <div>
                <label>Full Name:</label>
                <c:choose>
                    <c:when test="${mode == 'view'}">${user.fullName}</c:when>
                    <c:otherwise>
                        <input type="text" name="fullName" value="${user.fullName}" required>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- PHONE -->
            <div>
                <label>Phone:</label>
                <c:choose>
                    <c:when test="${mode == 'view'}">${user.phone}</c:when>
                    <c:otherwise>
                        <input type="text" name="phone" value="${user.phone}">
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ROLE -->
            <c:if test="${user.type == 'INTERNAL' || mode == 'add'}">
                <div>
                    <label>Role:</label>
                    <c:choose>
                        <c:when test="${mode == 'view'}">${user.role}</c:when>
                        <c:otherwise>
                            <select name="roleId">
                                <option value="1" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                <option value="2" ${user.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                <option value="3" ${user.role == 'Staff' ? 'selected' : ''}>Staff</option>
                            </select>

                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- STATUS -->
            <c:if test="${mode == 'view'}">
                <div>
                    <label>Status:</label>
                    <c:choose>
                        <c:when test="${user.status == 1}">Active</c:when>
                        <c:otherwise>Blocked</c:otherwise>
                    </c:choose>
                </div>

                <div>
                    <label>Created At:</label>
                    <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
            </c:if>

            <!-- IMAGE -->
            <c:if test="${mode != 'view'}">
                <div>
                    <label>Avatar:</label>
                    <input type="file" name="image">
                </div>
            </c:if>

            <br>

            <!-- BUTTON -->
            <c:if test="${mode != 'view'}">
                <button type="submit">
                    ${mode == 'add' ? 'Add' : 'Update'}
                </button>
            </c:if>

            <a href="${pageContext.request.contextPath}/user/list">Back</a>

        </form>

    </body>
</html>
