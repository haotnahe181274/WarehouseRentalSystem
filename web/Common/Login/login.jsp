<%-- 
    Document   : login
    Created on : Feb 3, 2026, 1:52:03 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
    </head>

    <body>

        <!-- HEADER -->
        <jsp:include page="/Common/Layout/header.jsp" />


        <!-- LOGIN -->
        <div class="login-wrapper">
            <div class="login-card">

                <h3>Sign In</h3>
                <div class="login-subtitle">
                    Access your warehouse management portal
                </div>

                <c:if test="${not empty error}">
                    <div class="error-box">
                        ${error}
                    </div>
                </c:if>

                <form action="login" method="post">

                    <div class="form-group">
                        <label>Username</label>
                        <input type="username"
                               name="username"
                               class="form-control"
                               placeholder="Enter your username"
                               required value="${username}">
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password"
                               name="password"
                               class="form-control"
                               placeholder="Enter your password"
                               value="${password}"
                               required>
                    </div>

                    <div class="options">
                        <label>
                            <input type="checkbox" name="remember">
                            Remember me
                        </label>

                        <a href="forgot-password">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn-login">
                        Sign In
                    </button>

                </form>

                <div class="login-footer">
                    <hr>
                    Don’t have an account?
                    <a href="register">Sign Up</a>
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

                padding: 80px 0;   
            }

            /* ===== CARD ===== */
            .login-card {
                width: 100%;
                max-width: 420px;
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
                margin-bottom: 18px;
            }

            label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 6px;
            }

            .form-control {
                width: 100%;
                height: 44px;
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

            /* ===== OPTIONS ===== */
            .options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 14px;
                margin: 8px 0 22px;
            }

            .options a {
                color: #111;
                text-decoration: none;
                font-weight: 500;
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

            /* ===== ERROR ===== */
            .error-box {
                background: #fee2e2;
                color: #991b1b;
                padding: 10px;
                border-radius: 6px;
                font-size: 14px;
                margin-bottom: 16px;
            }


        </style>



    </body>
</html>

