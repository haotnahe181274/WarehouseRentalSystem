<%-- Document : verify_otp Created on : Feb 12, 2026 Author : ad --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Verify OTP</title>
                <style>
                    * {
                        box-sizing: border-box;
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
                    }

                    body {
                        margin: 0;
                        min-height: 100vh;
                        background: #f3f4f6;
                        display: flex;
                        flex-direction: column;
                    }

                    .login-wrapper {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 40px 0;
                    }

                    .login-card {
                        width: 100%;
                        max-width: 400px;
                        background: #fff;
                        padding: 32px;
                        border-radius: 10px;
                        border: 1px solid #e5e7eb;
                        text-align: center;
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

                    .form-group {
                        margin-bottom: 20px;
                        text-align: left;
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
                        text-align: center;
                        letter-spacing: 2px;
                        font-weight: bold;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: #111;
                        background: #fff;
                    }

                    .error-text {
                        color: #dc2626;
                        font-size: 14px;
                        margin-bottom: 15px;
                    }

                    .message-text {
                        color: #059669;
                        font-size: 14px;
                        margin-bottom: 15px;
                    }

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

                    .resend-link {
                        margin-top: 20px;
                        font-size: 14px;
                        color: #6b7280;
                    }

                    .resend-link a {
                        color: #111;
                        text-decoration: none;
                        font-weight: 600;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/Common/Layout/header.jsp" />

                <div class="login-wrapper">
                    <div class="login-card">
                        <h3>Verify OTP</h3>
                        <div class="login-subtitle">
                            Enter the code sent to your email
                        </div>

                        <c:if test="${not empty error}">
                            <div class="error-text">${error}</div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="message-text">${message}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                            <div class="form-group">
                                <label>One-Time Password</label>
                                <input type="text" name="otp" class="form-control" placeholder="Enter 6-digit code"
                                    required maxlength="6">
                            </div>
                            <button type="submit" class="btn-login">Verify</button>
                        </form>

                        <div class="resend-link">
                            Didn't receive code? <a href="#">Resend</a>
                        </div>
                    </div>
                </div>

                <jsp:include page="/Common/Layout/footer.jsp" />
            </body>

            </html>