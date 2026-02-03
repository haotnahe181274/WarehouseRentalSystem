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
        <title>Login | WarehouseHub</title>

        <!-- Bootstrap (nếu bạn đã có thì bỏ dòng này) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background: #f5f6f8;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* ===== HEADER ===== */
            .login-header {
                padding: 20px 30px;
                font-weight: 600;
                font-size: 20px;
            }

            /* ===== LOGIN CARD ===== */
            .login-wrapper {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .login-card {
                width: 100%;
                max-width: 420px;
                background: #fff;
                border-radius: 6px;
                padding: 35px 30px;
                box-shadow: 0 0 0 1px rgba(0,0,0,0.08);
            }

            .login-card h3 {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .login-subtitle {
                color: #6c757d;
                font-size: 14px;
                margin-bottom: 25px;
            }

            .form-control {
                height: 45px;
            }

            .input-group-text {
                background: #fff;
            }

            .btn-login {
                background: #111;
                color: #fff;
                height: 45px;
                border-radius: 3px;
            }

            .btn-login:hover {
                background: #000;
            }

            .login-footer {
                text-align: center;
                font-size: 14px;
                margin-top: 15px;
            }

            /* ===== PAGE FOOTER ===== */
            .page-footer {
                text-align: center;
                font-size: 13px;
                color: #888;
                padding: 15px;
            }
        </style>
    </head>

    <body>

        <!-- ===== HEADER ===== -->
        <div class="login-header">
            <i class="bi bi-box-seam"></i> WareSpace
        </div>

        <!-- ===== LOGIN FORM ===== -->
        <div class="login-wrapper">
            <div class="login-card">

                <h3>Sign In</h3>
                <div class="login-subtitle">
                    Access your warehouse management portal
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 mb-3">
                        <i class="bi bi-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <form action="login" method="post">

                    <!-- EMAIL -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-envelope"></i>
                            </span>
                            <input type="email"
                                   name="email"
                                   class="form-control"
                                   placeholder="Enter your email"
                                   required>
                        </div>
                    </div>

                    <!-- PASSWORD -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   placeholder="Enter your password"
                                   required>
                        </div>
                    </div>

                    <!-- OPTIONS -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="remember">
                            <label class="form-check-label">
                                Remember me
                            </label>
                        </div>

                        <a href="forgot-password" class="text-decoration-none">
                            Forgot Password?
                        </a>
                    </div>

                    <!-- SUBMIT -->
                    <button type="submit" class="btn btn-login w-100">
                        Sign In
                    </button>

                </form>

                <!-- SIGN UP -->
                <div class="login-footer">
                    <hr>
                    Don't have an account?
                    <a href="register" class="fw-semibold text-decoration-none">
                        Sign Up
                    </a>
                </div>

            </div>
        </div>

        <!-- ===== FOOTER ===== -->
        <div class="page-footer">
            © 2024 WarehouseHub. All rights reserved.
        </div>

    </body>
</html>

