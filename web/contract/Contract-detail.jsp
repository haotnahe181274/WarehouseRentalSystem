<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết hợp đồng</title>

<style>
    :root {
        --primary-color: #2c3e50;
        --secondary-color: #34495e;
        --accent-color: #3498db;
        --success-color: #27ae60;
        --danger-color: #e74c3c;
        --warning-color: #f39c12;
        --light-gray: #f8f9fa;
        --border-color: #dee2e6;
    }

    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; margin: 0; color: #333; }
    
    .layout { display: flex; min-height: 100vh; }
    .main-content { flex: 1; padding: 30px; }

    /* Card Wrapper */
    .contract-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        overflow: hidden;
        max-width: 1100px;
        margin: 0 auto;
    }

    /* Header Section */
    .card-header {
        background: var(--primary-color);
        color: white;
        padding: 20px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .contract-id { font-size: 1.2rem; font-weight: 600; letter-spacing: 1px; }

    /* Badge Status */
    .status-badge {
        padding: 6px 16px;
        border-radius: 50px;
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
    }

    /* Content Body */
    .card-body { padding: 40px; }

    .section-title {
        color: var(--primary-color);
        font-size: 1.1rem;
        font-weight: 700;
        border-left: 4px solid var(--accent-color);
        padding-left: 15px;
        margin: 30px 0 20px 0;
        text-transform: uppercase;
    }
    .section-title:first-child { margin-top: 0; }

    /* Info Grid */
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; }
    .info-box { background: var(--light-gray); padding: 20px; border-radius: 8px; border: 1px solid #eee; }
    .info-box p { margin: 10px 0; font-size: 14px; line-height: 1.6; }
    .info-box b { color: #555; width: 100px; display: inline-block; }

    /* Custom Table */
    .custom-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        border-radius: 8px;
        overflow: hidden;
    }
    .custom-table th {
        background: #ebedef;
        color: var(--secondary-color);
        text-align: left;
        padding: 15px;
        font-size: 14px;
    }
    .custom-table td {
        padding: 15px;
        border-bottom: 1px solid #eee;
        font-size: 14px;
    }
    .custom-table tr:hover { background: #fcfcfc; }

    /* Highlight Box */
    .summary-box {
        background: #eef7ff;
        border: 1px solid #badfff;
        padding: 20px;
        border-radius: 8px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .price-tag { color: var(--danger-color); font-size: 22px; font-weight: 800; }

    /* Buttons */
    .actions { margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; text-align: right; }
    .btn {
        padding: 12px 25px;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        border: none;
        text-decoration: none;
        display: inline-block;
        font-size: 14px;
    }
    .btn-back { background: #95a5a6; color: white; margin-right: 10px; }
    .btn-agree { background: var(--success-color); color: white; }
    .btn-reject { background: var(--danger-color); color: white; margin-left: 10px; }
    .btn:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    
    ul.terms-list { padding-left: 20px; color: #666; font-size: 14px; }
    ul.terms-list li { margin-bottom: 8px; }
</style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp"/>
    <div class="layout">

    <!-- SIDEBAR -->
    <c:if test="${sessionScope.userType == 'INTERNAL'}">
                <jsp:include page="/Common/Layout/sidebar.jsp"/>
            </c:if>
    <div class="main-content">
    <c:choose>
        <c:when test="${not empty contract}">
            <div class="contract-card">
                <div class="card-header">
                    <span class="contract-id">MÃ HỢP ĐỒNG: #${contract.contractId}</span>
                    <div class="status-container">
                        <c:choose>
                            <c:when test="${contract.status == 0}">
                                <span class="status-badge" style="background:#fff3cd; color:#856404">Thanh toán thành công</span>
                            </c:when>
                            <c:when test="${contract.status == 1}">
                                <span class="status-badge" style="background:#cce5ff; color:#004085">Chờ Renter xác nhận</span>
                            </c:when>
                            <c:when test="${contract.status == 3}">
                                <span class="status-badge" style="background:#d4edda; color:#155724">Hợp đồng có hiệu lực</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge" style="background:#f8d7da; color:#721c24">Đã từ chối</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-group">
                            <h3 class="section-title">Bên cho thuê (Bên A)</h3>
                            <div class="info-box">
                                <p><b>Công ty:</b> Warehouse Rental System</p>
                                <p><b>Đại diện:</b> ${contract.managerName}</p>
                                <p><b>Email:</b> ${contract.managerEmail}</p>
                                <p><b>Điện thoại:</b> ${contract.managerPhone}</p>
                            </div>
                        </div>
                        <div class="info-group">
                            <h3 class="section-title">Bên thuê (Bên B)</h3>
                            <div class="info-box">
                                <p><b>Họ tên:</b> ${contract.renterName}</p>
                                <p><b>Email:</b> ${contract.renterEmail}</p>
                                <p><b>Điện thoại:</b> ${contract.renterPhone}</p>
                            </div>
                        </div>
                    </div>

                    <h3 class="section-title">Chi tiết kho bãi & Tài chính</h3>
                    <p style="margin-bottom: 15px;">
                        <i class="fas fa-warehouse"></i> <b>Kho:</b> ${contract.warehouseName} | 
                        <i class="fas fa-map-marker-alt"></i> <b>Địa chỉ:</b> ${contract.warehouseAddress}
                    </p>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Diện tích (m²)</th>
                                <th>Giá thuê / tháng</th>
                                <th>Thời gian thuê</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${unitList}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>${u.area} m²</td>
                                    <td><fmt:formatNumber value="${u.price}" type="number"/> VNĐ</td>
                                    <td>
                                        <fmt:formatDate value="${u.startDate}" pattern="dd/MM/yyyy"/> 
                                        <span style="color:#aaa; margin:0 5px;">→</span>
                                        <fmt:formatDate value="${u.endDate}" pattern="dd/MM/yyyy"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="summary-box">
                        <div>
                            <p style="margin:0; color:#555;">Thời hạn tổng thể:</p>
                            <strong style="font-size: 16px;">
                                <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/> → 
                                <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                            </strong>
                        </div>
                        <div style="text-align: right;">
                            <p style="margin:0; color:#555;">Tổng giá thuê:</p>
                            <span class="price-tag"><fmt:formatNumber value="${contract.price}" type="number" groupingUsed="true"/> VNĐ/tháng</span>
                        </div>
                    </div>

                    <h3 class="section-title">Điều khoản chính</h3>
                    <ul class="terms-list">
                        <li>Giá thuê chưa bao gồm thuế VAT và chi phí điện nước phát sinh hàng tháng.</li>
                        <li>Khách thuê thực hiện thanh toán định kỳ vào ngày 05 hàng tháng.</li>
                        <li>Bên B có trách nhiệm tuân thủ nghiêm ngặt các quy định về PCCC tại khu vực kho.</li>
                    </ul>

                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/contract" class="btn btn-back"> Quay lại danh sách</a>
                        
                        <c:if test="${sessionScope.userType eq 'RENTER' and contract.status == 1 and contract.paymentStatus == 0 }">
                            <form action="${pageContext.request.contextPath}/payment" method="post" style="display:inline;">
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" name="action" value="agree" class="btn btn-agree">Đồng ý hợp đồng & Thanh toán</button>
                            </form>

                            <form action="${pageContext.request.contextPath}/contract-detail" method="post" style="display:inline;">
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" name="action" value="reject" class="btn btn-reject" onclick="return confirm('Bạn có chắc muốn từ chối hợp đồng này?');">Từ chối</button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div style="text-align:center; padding: 50px;">
                <h2 style="color:var(--danger-color);">Không tìm thấy thông tin hợp đồng!</h2>
                <a href="${pageContext.request.contextPath}/contract" class="btn btn-back">Quay lại</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
    </div>
 <jsp:include page="/Common/Layout/footer.jsp"/>

</body>
</html>