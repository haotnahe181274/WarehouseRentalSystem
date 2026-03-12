<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
</head>

<body>

    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="login-wrapper">
        <div class="login-card">

            <h3>Reset Password</h3>
            <div class="login-subtitle">
                Mã OTP hợp lệ. Vui lòng tạo mật khẩu mới.
            </div>

            <c:if test="${not empty error}">
                <div class="error-box">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="post">

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPassword" class="form-control"
                        placeholder="Nhập mật khẩu mới" required minlength="6">
                </div>
                
                <div class="form-group">
                    <label>Xác nhận mật khẩu</label>
                    <input type="password" name="confirmPassword" class="form-control"
                        placeholder="Nhập lại mật khẩu mới" required minlength="6">
                </div>

                <button type="submit" class="btn-login" style="margin-top: 10px;">
                    Cập nhật mật khẩu
                </button>

            </form>

        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />

    <style>
        /* GIỮ NGUYÊN CSS NHƯ BÊN TRÊN */
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

        .login-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 0;
        }

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