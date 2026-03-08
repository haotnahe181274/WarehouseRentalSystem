<%-- 
    Document   : paymentResult
    Kết quả thanh toán VNPay - Giao diện trắng đen, UX/UI thân thiện
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả giao dịch | WRS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" 
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: #f5f5f5;
            color: #1a1a1a;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .result-wrap {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .result-card {
            max-width: 420px;
            width: 100%;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,.08);
            padding: 2.5rem 2rem;
            text-align: center;
        }
        .result-icon {
            width: 72px;
            height: 72px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }
        .result-icon.success {
            background: #e8f5e9;
            color: #1b5e20;
        }
        .result-icon.fail {
            background: #ffebee;
            color: #b71c1c;
        }
        .result-icon.pending {
            background: #fff8e1;
            color: #e65100;
        }
        .result-card h1 {
            margin: 0 0 0.5rem;
            font-size: 1.35rem;
            font-weight: 600;
            color: #1a1a1a;
        }
        .result-card .lead {
            margin: 0 0 1.5rem;
            font-size: 0.95rem;
            color: #555;
            line-height: 1.5;
        }
        .support-box {
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 1rem 1.25rem;
            margin-top: 1.5rem;
            text-align: left;
        }
        .support-box .label {
            font-size: 0.8rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }
        .support-box .phone {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1a1a;
            letter-spacing: 0.02em;
        }
        .actions {
            margin-top: 2rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            transition: background .2s, color .2s;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: #1a1a1a;
            color: #fff;
        }
        .btn-primary:hover {
            background: #333;
        }
        .btn-outline {
            background: transparent;
            color: #1a1a1a;
            border: 1px solid #ddd;
        }
        .btn-outline:hover {
            background: #f5f5f5;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            margin-bottom: 1.5rem;
            color: #555;
            text-decoration: none;
            font-size: 0.9rem;
        }
        .back-link:hover {
            color: #1a1a1a;
        }
        .actions .btn {
            min-width: 200px;
            text-align: center;
        }
        @media (max-width: 480px) {
            .result-card { padding: 1.75rem 1.25rem; }
            .result-card h1 { font-size: 1.2rem; }
        }
    </style>
</head>
<body>
    <jsp:include page="/Common/Layout/header.jsp"/>

    <div class="result-wrap">
        <div class="result-card">
            <a href="${pageContext.request.contextPath}/contract" class="back-link">
                <i class="fas fa-arrow-left"></i> Quay lại hợp đồng
            </a>
            <%-- Thành công --%>
            <c:if test="${transResult == true}">
                <div class="result-icon success">
                    <i class="fas fa-check"></i>
                </div>
                <h1>Giao dịch thành công</h1>
                <p class="lead">Thanh toán của bạn đã được xử lý. Chúng tôi sẽ liên hệ để xác nhận và hướng dẫn bước tiếp theo.</p>
                <div class="support-box">
                    <div class="label">Hotline hỗ trợ</div>
                    <div class="phone">0336 347 918</div>
                </div>
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/contract" class="btn btn-primary"><i class="fas fa-file-contract"></i> Xem hợp đồng</a>
                    <a href="${pageContext.request.contextPath}/homepage" class="btn btn-outline"><i class="fas fa-home"></i> Về trang chủ</a>
                </div>
            </c:if>

            <%-- Thất bại --%>
            <c:if test="${transResult == false}">
                <div class="result-icon fail">
                    <i class="fas fa-times"></i>
                </div>
                <h1>Giao dịch không thành công</h1>
                <p class="lead">Thanh toán chưa được thực hiện. Bạn có thể thử lại từ trang hợp đồng hoặc liên hệ tổng đài để được hỗ trợ.</p>
                <div class="support-box">
                    <div class="label">Hotline hỗ trợ</div>
                    <div class="phone">0336 347 918</div>
                </div>
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/contract" class="btn btn-primary"><i class="fas fa-redo"></i> Thử thanh toán lại</a>
                    <a href="${pageContext.request.contextPath}/homepage" class="btn btn-outline"><i class="fas fa-home"></i> Về trang chủ</a>
                </div>
            </c:if>

            <%-- Đang xử lý --%>
            <c:if test="${transResult == null}">
                <div class="result-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <h1>Đang xử lý giao dịch</h1>
                <p class="lead">Chúng tôi đã tiếp nhận đơn hàng. Vui lòng chờ trong giây lát hoặc kiểm tra lại sau. Nếu cần hỗ trợ, hãy gọi hotline bên dưới.</p>
                <div class="support-box">
                    <div class="label">Hotline hỗ trợ</div>
                    <div class="phone">0336 347 918</div>
                </div>
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/contract" class="btn btn-primary"><i class="fas fa-file-contract"></i> Xem hợp đồng</a>
                    <a href="${pageContext.request.contextPath}/homepage" class="btn btn-outline"><i class="fas fa-home"></i> Về trang chủ</a>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp"/>
</body>
</html>
