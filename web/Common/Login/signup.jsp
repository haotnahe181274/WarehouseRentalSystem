<%-- Document : signup Created on : Feb 11, 2026 Author : ad --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Sign Up</title>
            </head>

            <body>

                <!-- HEADER -->
                <jsp:include page="/Common/Layout/header.jsp" />


                <!-- SIGN UP -->
                <div class="login-wrapper">
                    <div class="login-card">

                        <h3>Create Account</h3>
                        <div class="login-subtitle">
                            Register as a new renter
                        </div>

                        <form action="register" method="post">

                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" name="fullName" class="form-control"
                                    placeholder="Enter your full name" value="${fullName}" required>
                                <c:if test="${not empty errors.fullName}">
                                    <div class="error-text">${errors.fullName}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" class="form-control" placeholder="Enter your email"
                                    value="${email}" required>
                                <c:if test="${not empty errors.email}">
                                    <div class="error-text">${errors.email}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="phone" class="form-control"
                                    placeholder="Enter your phone number" value="${phone}" required>
                                <c:if test="${not empty errors.phone}">
                                    <div class="error-text">${errors.phone}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="username" class="form-control" placeholder="Choose a username"
                                    value="${username}" required>
                                <c:if test="${not empty errors.username}">
                                    <div class="error-text">${errors.username}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" name="password" class="form-control"
                                    placeholder="Create a password" required>
                                <c:if test="${not empty errors.password}">
                                    <div class="error-text">${errors.password}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Confirm Password</label>
                                <input type="password" name="rePassword" class="form-control"
                                    placeholder="Confirm your password" required>
                                <c:if test="${not empty errors.rePassword}">
                                    <div class="error-text">${errors.rePassword}</div>
                                </c:if>
                            </div>

                            <button type="submit" class="btn-login" style="margin-top: 20px;">
                                Sign Up
                            </button>

                        </form>

                        <div class="login-footer">
                            <hr>
                            Already have an account?
                            <a href="login">Sign In</a>
                        </div>

                    </div>
                </div>

                <jsp:include page="/Common/Layout/footer.jsp" />


                <style>
                    * {
                        box-sizing: border-box;
                        font-family: -apple-system, BlinkMacSystemFont,
                            "Segoe UI", Roboto, Arial, sans-serif;
                    }

                    body {
                        margin: 0;
                        min-height: 100vh;
                        background: #f3f4f6;
                        display: flex;
                        flex-direction: column;
                    }

                    /* ===== CENTER ===== */
                    .login-wrapper {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 40px 0;
                    }

                    /* ===== CARD ===== */
                    .login-card {
                        width: 100%;
                        max-width: 480px;
                        /* Widened for signup */
                        background: #fff;
                        padding: 32px;
                        border-radius: 10px;
                        border: 1px solid #e5e7eb;
                    }

                    .login-card h3 {
                        margin: 0 0 6px;
                        font-size: 24px;
                        font-weight: 600;
                    }

                    .login-subtitle {
                        font-size: 14px;
                        color: #6b7280;
                        margin-bottom: 24px;
                    }

                    /* ===== FORM ===== */
                    .form-group {
                        margin-bottom: 15px;
                    }

                    label {
                        display: block;
                        font-size: 14px;
                        font-weight: 500;
                        margin-bottom: 6px;
                    }

                    .form-control {
                        width: 100%;
                        height: 40px;
                        padding: 0 12px;
                        border-radius: 6px;
                        border: 1px solid #d1d5db;
                        font-size: 14px;
                        background: #f9fafb;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: #111;
                        background: #fff;
                    }

                    .error-text {
                        color: #dc2626;
                        font-size: 12px;
                        margin-top: 4px;
                    }

                    /* ===== BUTTON ===== */
                    .btn-login {
                        width: 100%;
                        height: 46px;
                        background: #111;
                        color: #fff;
                        border: none;
                        border-radius: 6px;
                        cursor: pointer;
                        font-size: 15px;
                        font-weight: 600;
                    }

                    .btn-login:hover {
                        background: #000;
                    }

                    .login-footer {
                        margin-top: 24px;
                        text-align: center;
                        font-size: 14px;
                        color: #6b7280;
                    }

                    .login-footer hr {
                        margin-bottom: 20px;
                        border: 0;
                        border-top: 1px solid #e5e7eb;
                    }

                    .login-footer a {
                        color: #111;
                        text-decoration: none;
                        font-weight: 600;
                        margin-left: 4px;
                    }
                </style>

            </body>

            </html>