<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background: #f5f6fa;
                        padding: 30px;
                    }

                    h2 {
                        margin-bottom: 20px;
                    }

                    .user-form {
                        max-width: 600px;
                        background: #fff;
                        padding: 25px;
                        border-radius: 8px;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                    }

                    .form-group {
                        margin-bottom: 15px;
                    }

                    label {
                        display: block;
                        font-weight: bold;
                        margin-bottom: 6px;
                    }

                    input[type="text"],
                    input[type="email"],
                    input[type="password"],
                    select {
                        width: 100%;
                        padding: 8px 10px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                    }

                    input[type="file"] {
                        margin-top: 5px;
                    }

                    .avatar-preview {
                        width: 120px;
                        height: 120px;
                        object-fit: cover;
                        border-radius: 50%;
                        border: 1px solid #ddd;
                        margin-bottom: 15px;
                    }

                    .btn {
                        padding: 8px 16px;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                        text-decoration: none;
                        font-size: 14px;
                    }

                    .btn-primary {
                        background: #ddd;
                        color: #333;
                    }

                    .btn-secondary {
                        background: #ddd;
                        color: #333;
                    }

                    .form-actions {
                        display: flex;
                        gap: 10px;
                        margin-top: 20px;
                    }

                    .error-msg {
                        color: #ff4d4f;
                        font-size: 13px;
                        margin-top: 4px;
                    }

                    .error-box {
                        background: #fff2f0;
                        border: 1px solid #ffccc7;
                        border-radius: 4px;
                        padding: 12px;
                        margin-bottom: 15px;
                    }

                    .error-box ul {
                        margin: 0;
                        padding-left: 20px;
                    }

                    .error-box li {
                        color: #ff4d4f;
                    }
                </style>
            </head>

            <body>

                <h2>
                    <c:choose>
                        <c:when test="${mode == 'add'}">Add User</c:when>
                        <c:when test="${mode == 'edit'}">Update User</c:when>
                        <c:otherwise>User Detail</c:otherwise>
                    </c:choose>
                </h2>

                <!-- Hiển thị errors nếu có -->
                <!--  <c:if test="${not empty errors}">
                    <div class="error-box">
                        <ul>
                            <c:forEach var="e" items="${errors}">
                                <li>${e.value}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if> -->

                <form class="user-form" action="${pageContext.request.contextPath}/user/list" method="post"
                    enctype="multipart/form-data">

                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="mode" value="${mode}">

                    <c:if test="${user != null}">
                        <input type="hidden" name="id" value="${user.id}">
                        <input type="hidden" name="type" value="${user.type}">
                    </c:if>

                    <!-- AVATAR -->
                    <c:if test="${not empty user.image}">
                        <img src="${pageContext.request.contextPath}/resources/user/image/${user.image}" width="120"
                            class="avatar-preview"><br>
                    </c:if>

                    <!-- USERNAME -->
                    <div class="form-group">
                        <label>Username:</label>
                        <c:choose>
                            <c:when test="${mode == 'view'}">${user.name}</c:when>
                            <c:when test="${mode == 'add'}">
                                <input type="text" name="username" value="${username}" required>
                                <c:if test="${not empty errors.username}">
                                    <div class="error-msg">${errors.username}</div>
                                </c:if>
                            </c:when>
                            <c:otherwise>${user.name}</c:otherwise>
                        </c:choose>
                    </div>

                    <!-- PASSWORD (CHỈ ADD) -->
                    <c:if test="${mode == 'add'}">
                        <div class="form-group">
                            <label>Password:</label>
                            <input type="password" name="password" required>
                            <c:if test="${not empty errors.password}">
                                <div class="error-msg">${errors.password}</div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- EMAIL -->
                    <div class="form-group">
                        <label>Email:</label>
                        <c:choose>
                            <c:when test="${mode == 'view'}">${user.email}</c:when>
                            <c:otherwise>
                                <input type="email" name="email" value="${not empty email ? email : user.email}"
                                    required>
                                <c:if test="${not empty errors.email}">
                                    <div class="error-msg">${errors.email}</div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- FULL NAME -->
                    <div class="form-group">
                        <label>Full Name:</label>
                        <c:choose>
                            <c:when test="${mode == 'view'}">${user.fullName}</c:when>
                            <c:otherwise>
                                <input type="text" name="fullName"
                                    value="${not empty fullName ? fullName : user.fullName}" required>
                                <c:if test="${not empty errors.fullName}">
                                    <div class="error-msg">${errors.fullName}</div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- PHONE -->
                    <div class="form-group">
                        <label>Phone:</label>
                        <c:choose>
                            <c:when test="${mode == 'view'}">${user.phone}</c:when>
                            <c:otherwise>
                                <input type="text" name="phone" value="${not empty phone ? phone : user.phone}">
                                <c:if test="${not empty errors.phone}">
                                    <div class="error-msg">${errors.phone}</div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- ROLE -->
                    <c:if test="${user.type == 'INTERNAL' || mode == 'add'}">
                        <div class="form-group">
                            <label>Role:</label>
                            <c:choose>
                                <c:when test="${mode == 'view'}">${user.role}</c:when>
                                <c:otherwise>
                                    <select name="roleId">
                                        <option value="1" ${user.role=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option value="2" ${user.role=='Manager' ? 'selected' : '' }>Manager</option>
                                        <option value="3" ${user.role=='Staff' ? 'selected' : '' }>Staff</option>
                                    </select>

                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- STATUS -->
                    <c:if test="${mode == 'view'}">
                        <div class="form-group">
                            <label>Status:</label>
                            <c:choose>
                                <c:when test="${user.status == 1}">Active</c:when>
                                <c:otherwise>Blocked</c:otherwise>
                            </c:choose>
                        </div>

                        <div>
                            <label>Created At:</label>
                            <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                    </c:if>

                    <!-- IMAGE -->
                    <c:if test="${mode != 'view'}">
                        <div class="form-group">
                            <label>Avatar:</label>
                            <input type="file" name="image">
                        </div>
                    </c:if>

                    <br>

                    <!-- BUTTON -->
                    <div class="form-actions">
                        <c:if test="${mode != 'view'}">
                            <button class="btn btn-primary" type="submit">
                                ${mode == 'add' ? 'Add User' : 'Update User'}
                            </button>
                        </c:if>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/user/list">
                            Back
                        </a>
                    </div>

                </form>

            </body>

            </html>