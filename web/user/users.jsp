
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            body {
                font-family: 'Inter', Arial, sans-serif;
                background: #f3f4f6;
            }

            /* TITLE */
            h2 {
                margin-bottom: 24px;
                font-weight: 600;
                color: #111827;
            }

            /* LAYOUT */
            .layout {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 32px;
                background: #f5f7fb;
            }

            /* FORM CARD */
            .user-form {
                max-width: 720px;
                margin: 0 auto;
                background: #ffffff;
                padding: 32px;
                border-radius: 14px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            }

            /* AVATAR */
            .avatar-preview {
                width: 130px;
                height: 130px;
                object-fit: cover;
                border-radius: 50%;
                border: 4px solid #e5e7eb;
                display: block;
                margin: 0 auto 20px;
            }

            /* FORM GROUP */
            .form-group {
                margin-bottom: 18px;
            }

            label {
                font-weight: 500;
                font-size: 14px;
                color: #374151;
                margin-bottom: 6px;
            }

            /* INPUT */
            input[type="text"],
            input[type="email"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px 14px;
                border-radius: 10px;
                border: 1px solid #d1d5db;
                background: #f9fafb;
                font-size: 14px;
                transition: all 0.2s ease;
            }

            input:focus,
            select:focus {
                outline: none;
                border-color: #6366f1;
                background: #ffffff;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
            }

            /* FILE INPUT */
            input[type="file"] {
                font-size: 14px;
            }

            /* ERROR */
            .error-msg {
                color: #dc2626;
                font-size: 13px;
                margin-top: 4px;
            }

            /* ACTION BUTTONS */
            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 28px;
                flex-wrap: wrap;
            }

            /* BUTTONS */
            .btn {
                padding: 10px 18px;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 500;
            }

            .btn-primary {
                background: #6366f1;
                color: #fff;
            }

            .btn-primary:hover {
                background: #4f46e5;
            }

            .btn-secondary {
                background: #e5e7eb;
                color: #374151;
            }

            .btn-secondary:hover {
                background: #d1d5db;
            }

            /* VIEW MODE TEXT */
            .form-group span,
            .form-group div {
                font-size: 14px;
                color: #111827;
            }

        </style>

    </head>

    <body>
        <jsp:include page="/Common/Layout/header.jsp" />
        <c:set var="loginUser" value="${sessionScope.user}" />
        <c:set var="isProfile" value="${loginUser != null && targetUser != null && loginUser.id == targetUser.id}" />
        <div class="layout">

            <jsp:include page="/Common/Layout/sidebar.jsp" />
            <div class="main-content">



<!--                <h2>
                    <c:choose>
                        <c:when test="${mode == 'add'}">Add User</c:when>
                        <c:when test="${mode == 'edit' && isProfile}">Update Profile</c:when>
                        <c:when test="${mode == 'edit'}">Update User</c:when>
                        <c:when test="${isProfile}">My Profile</c:when>
                        <c:otherwise>User Detail</c:otherwise>
                    </c:choose>
                </h2>-->



                <form class="user-form" action="${pageContext.request.contextPath}/user/list" method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="mode" value="${mode}">

                    <c:if test="${targetUser != null}">
                        <input type="hidden" name="id" value="${targetUser.id}">
                        <input type="hidden" name="type" value="${targetUser.type}">
                    </c:if>

                    <!-- AVATAR -->
                    <c:if test="${not empty targetUser.image}">
                        <img src="${pageContext.request.contextPath}/resources/user/image/${targetUser.image}" width="120"
                             class="avatar-preview"><br>
                    </c:if>

                    <!-- USERNAME -->
                    <div class="form-group">
                        <label>Username:</label>
                        <c:choose>
                            <c:when test="${mode == 'view'}">${targetUser.name}</c:when>
                            <c:when test="${mode == 'add'}">
                                <input type="text" name="username" value="${username}" required>
                                <c:if test="${not empty errors.username}">
                                    <div class="error-msg">${errors.username}</div>
                                </c:if>
                            </c:when>
                            <c:otherwise>${targetUser.name}</c:otherwise>
                        </c:choose>
                    </div>

                    <!-- PASSWORD (CH? ADD) -->
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
                            <c:when test="${mode == 'view'}">${targetUser.email}</c:when>
                            <c:otherwise>
                                <input type="email" name="email" value="${not empty email ? email : targetUser.email}"
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
                            <c:when test="${mode == 'view'}">${targetUser.fullName}</c:when>
                            <c:otherwise>
                                <input type="text" name="fullName"
                                       value="${not empty fullName ? fullName : targetUser.fullName}" required>
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
                            <c:when test="${mode == 'view'}">${targetUser.phone}</c:when>
                            <c:otherwise>
                                <input type="text" name="phone" value="${not empty phone ? phone : targetUser.phone}">
                                <c:if test="${not empty errors.phone}">
                                    <div class="error-msg">${errors.phone}</div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- ROLE -->
                    <c:if test="${!isProfile && (targetUser.type == 'INTERNAL' || mode == 'add')}">
                        <div class="form-group">
                            <label>Role:</label>
                            <c:choose>
                                <c:when test="${mode == 'view'}">${targetUser.role}</c:when>
                                <c:otherwise>
                                    <select name="roleId">
                                        <option value="1" ${targetUser.role=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option value="2" ${targetUser.role=='Manager' ? 'selected' : '' }>Manager</option>
                                        <option value="3" ${targetUser.role=='Staff' ? 'selected' : '' }>Staff</option>
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
                                <c:when test="${targetUser.status == 1}">Active</c:when>
                                <c:otherwise>Blocked</c:otherwise>
                            </c:choose>
                        </div>

                        <div>
                            <label>Created At:</label>
                            <fmt:formatDate value="${targetUser.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                    </c:if>

                    <!-- IMAGE -->
                    <c:if test="${mode != 'view'}">
                        <div class="form-group">
                            <label>Avatar:</label>
                            <input type="file" name="image" accept=".jpg, .jpeg, .png">
                            <c:if test="${not empty errors.image}">
                                <div class="error-msg">${errors.image}</div>
                            </c:if>
                        </div>
                    </c:if>

                    <br>

                    <!-- BUTTON -->
                    <div class="form-actions">

                        <!-- UPDATE USER (Admin / Manager) -->
                        <c:if test="${mode == 'view' && !isProfile && loginUser.role == 'Admin'}">
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/user/list?action=edit&id=${targetUser.id}&type=${targetUser.type}">
                                Update
                            </a>
                        </c:if>


                        <!-- UPDATE PROFILE -->
                        <c:if test="${mode == 'view' && isProfile}">
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/profile?mode=edit">
                                Update Profile
                            </a>
                        </c:if>


                        <!-- SAVE -->
                        <c:if test="${mode != 'view'}">
                            <button class="btn btn-primary" type="submit">
                                Save
                            </button>
                        </c:if>

                        <!-- BACK -->
                        <a class="btn btn-secondary" href="javascript:history.back()">
                            Back
                        </a>




                    </div>



                </form>

            </div>
        </div>
        <jsp:include page="/Common/Layout/footer.jsp" />
    </body>

</html>

