<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Hợp đồng cho thuê nhà xưởng và kho bãi</title>
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --success-color: #27ae60;
            --danger-color: #e74c3c;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f1f5f9; 
            margin: 0; 
            color: #1e293b; 
        }
        
        .layout { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 40px 20px; }

        .contract-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 1050px;
            margin: 0 auto;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .card-header {
            background: var(--primary-color);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .status-badge { 
            padding: 8px 16px; 
            border-radius: 50px; 
            font-size: 12px; 
            font-weight: 700; 
            text-transform: uppercase;
        }

        .card-body { padding: 50px 60px; }

        .contract-title-formal { text-align: center; margin-bottom: 45px; }
        .contract-title-formal h2 { 
            margin-top: 20px; 
            text-transform: uppercase; 
            color: var(--primary-color);
            font-size: 22px;
        }

        .section-title {
            color: var(--primary-color);
            font-size: 17px;
            font-weight: 700;
            border-left: 5px solid var(--accent-color);
            padding-left: 15px;
            text-transform: uppercase;
            margin: 50px 0 20px 0; 
        }

        .info-group .section-title { margin-top: 0; margin-bottom: 15px; font-size: 15px; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .info-box { 
            background: var(--light-bg); 
            padding: 25px; 
            border-radius: 12px; 
            border: 1px solid var(--border-color); 
        }
        .info-box p { margin: 10px 0; font-size: 14px; }
        .info-box b { color: #64748b; width: 140px; display: inline-block; }

        .custom-table { 
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0; 
            margin: 20px 0; 
            border-radius: 10px; 
            overflow: hidden; 
            border: 1px solid var(--border-color);
        }
        .custom-table th { background: #f1f5f9; color: var(--secondary-color); padding: 15px; text-align: left; }
        .custom-table td { padding: 15px; border-top: 1px solid var(--border-color); }

        .summary-box {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            padding: 25px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        .price-tag { color: var(--danger-color); font-size: 24px; font-weight: 800; }

        .legal-terms { font-size: 14.5px; color: #334155; line-height: 1.7; }
        .legal-terms h4 { color: #1e293b; margin: 25px 0 10px 0; text-decoration: underline; }
        .legal-terms ul { padding-left: 20px; margin-bottom: 20px; }
        .legal-terms li { margin-bottom: 8px; }

        .actions { 
            margin-top: 50px; 
            padding-top: 30px; 
            border-top: 1px solid var(--border-color); 
            text-align: right; 
        }
        .btn { 
            padding: 12px 28px; 
            border-radius: 8px; 
            font-weight: 700; 
            cursor: pointer; 
            border: none; 
            text-decoration: none; 
            display: inline-block; 
            font-size: 14px; 
        }
        .btn-back { background: #cbd5e1; color: #334155; margin-right: 10px; }
        .btn-agree { background: var(--success-color); color: white; }
        .btn-reject { background: var(--danger-color); color: white; margin-left: 10px; }
    </style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp"/>
    <div class="layout">
        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <jsp:include page="/Common/Layout/sidebar.jsp"/>
        </c:if>

        <div class="main-content">
            <c:choose>
                <c:when test="${not empty contract}">
                    <div class="contract-card">
                        <div class="card-header">
                            <span class="contract-id">MÃ HĐ: #${contract.contractId}</span>
                            <div class="status-container">
                                <c:choose>
                                    <c:when test="${contract.status == 0}"><span class="status-badge" style="background:#fef3c7; color:#92400e">Thanh toán thành công</span></c:when>
                                    <c:when test="${contract.status == 1}"><span class="status-badge" style="background:#dbeafe; color:#1e40af">Chờ Renter xác nhận</span></c:when>
                                    <c:when test="${contract.status == 3}"><span class="status-badge" style="background:#dcfce7; color:#166534">Hợp đồng có hiệu lực</span></c:when>
                                    <c:otherwise><span class="status-badge" style="background:#fee2e2; color:#991b1b">Đã từ chối</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="contract-title-formal">
                                <p><b>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</b></p>
                                <p>Độc lập – Tự do – Hạnh phúc</p>
                                <h2>HỢP ĐỒNG CHO THUÊ NHÀ XƯỞNG VÀ KHO BÃI</h2>
                            </div>

                            <div class="info-grid">
                                <div class="info-group">
                                    <h3 class="section-title">Bên Cho Thuê (Bên A)</h3>
                                    <div class="info-box">
                                        <p><b>Công ty:</b> Warehouse Rental System</p>
                                        <p><b>Đại diện:</b> ${contract.managerName}</p>
                                        <p><b>Điện thoại:</b> ${contract.managerPhone}</p>
                                        <p><b>Email:</b> ${contract.managerEmail}</p>
                                        <p><b>Địa chỉ:</b> Sơn Tây, Hà Nội</p>
                                    </div>
                                </div>

                                <div class="info-group">
                                    <h3 class="section-title">Bên Thuê (Bên B)</h3>
                                    <div class="info-box">
                                        <p><b>Tổ chức:</b> ${contract.renterName}</p>
                                        <p><b>Đại diện:</b> ${contract.renterName}</p>
                                        <p><b>Điện thoại:</b> ${contract.renterPhone}</p>
                                        <p><b>Email:</b> ${contract.renterEmail}</p>
                                        <p><b>Địa chỉ liên hệ:</b> Thông tin tài khoản</p>
                                    </div>
                                </div>
                            </div>

                            <h3 class="section-title">Điều 1: Nội dung và Mục đích thuê</h3>
                            <div class="legal-terms">
                                <p><b>1.1.</b> Bên A đồng ý cho thuê và Bên B đồng ý thuê diện tích kho bãi thuộc hệ thống quản lý của Bên A.</p>
                                <p><b>1.2. Mục đích thuê:</b> Sử dụng làm nhà xưởng sản xuất hoặc kho lưu trữ hàng hóa.</p>
                                <p><b>1.3. Vị trí:</b> ${contract.warehouseName} - ${contract.warehouseAddress}.</p>
                            </div>

                            <h3 class="section-title">Điều 2: Thời hạn và Giá cả</h3>
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Diện tích</th>
                                        <th>Đơn giá / tháng</th>
                                        <th>Thời hạn thuê</th>
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
                                                <span style="color:#aaa;">→</span> 
                                                <fmt:formatDate value="${u.endDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="summary-box">
                                <div>
                                    <p style="margin:0; color:#64748b;">Phương thức thanh toán:</p>
                                    <strong>Chuyển khoản định kỳ</strong>
                                </div>
                                <div style="text-align: right;">
                                    <p style="margin:0; color:#64748b;">Tổng cộng (Giá thuê/tháng):</p>
                                    <span class="price-tag"><fmt:formatNumber value="${contract.price}" type="number"/> VNĐ</span>
                                </div>
                            </div>

                            <h3 class="section-title">Điều 3: TRÁCH NHIỆM CỦA HAI BÊN</h3>
                            <div class="legal-terms">
                                <h4>3.1. Trách nhiệm Bên A:</h4>
                                <ul>
                                    <li><b>3.1.1.</b> Bên A cam kết bảo đảm quyền sử dụng trọn vẹn hợp pháp và tạo mọi điều kiện thuận lợi để Bên B sử dụng mặt bằng hiệu quả.</li>
                                    <li><b>3.1.2.</b> Bên A bàn giao toàn bộ các trang thiết bị đồ dùng hiện có như đã thỏa thuận ngay sau khi ký kết hợp đồng này (có biên bản bàn giao đính kèm).</li>
                                    <li><b>3.1.3.</b> Bên A cam kết cấu trúc của nhà xưởng được xây dựng là chắc chắn, nếu trong quá trình sử dụng có xảy ra sự cố gây thiệt hại đến tính mạng, tài sản của Bên B; Bên A sẽ chịu hoàn toàn trách nhiệm bồi thường.</li>
                                    <li><b>3.1.4.</b> Chịu trách nhiệm thanh toán tiền thuê cho thuê nhà xưởng với cơ quan thuế.</li>
                                </ul>
                                <h4>3.2. Trách nhiệm của Bên B:</h4>
                                <ul>
                                    <li><b>3.2.1.</b> Sử dụng nhà xưởng đúng mục đích thuê, khi cần sửa chữa cải tạo theo yêu cầu sử dụng riêng sẽ bàn bạc cụ thể với Bên A.</li>
                                    <li><b>3.2.2.</b> Thanh toán tiền thuê nhà đúng thời hạn.</li>
                                    <li><b>3.2.3.</b> Có trách nhiệm về sự hư hỏng, mất mát các trang thiết bị và các đồ đạc tư trang của bản thân.</li>
                                    <li><b>3.2.4.</b> Chịu trách nhiệm về mọi hoạt động sản xuất kinh doanh của mình theo đúng Pháp luật hiện hành.</li>
                                    <li><b>3.2.5.</b> Thanh toán các khoản chi phí phát sinh (tiền điện, điện thoại, thuế kinh doanh…) đầy đủ và đúng thời hạn.</li>
                                </ul>
                            </div>

                            <h3 class="section-title">Điều 4: CAM KẾT CHUNG</h3>
                            <div class="legal-terms">
                                <p>Hai bên cam kết thực hiện đúng các điều khoản đã nêu trong hợp đồng. Nếu có xảy ra tranh chấp hoặc có một bên vi phạm hợp đồng thì hai bên sẽ giải quyết thông qua thương lượng. Trong trường hợp không tự giải quyết được, sẽ đưa ra giải quyết tại Tòa án nhân dân có thẩm quyền.</p>
                                <p>Hợp đồng này có giá trị ngay sau khi hai bên ký kết và được lập thành các bản có giá trị pháp lý như nhau.</p>
                            </div>

                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/contract" class="btn btn-back"> Quay lại danh sách</a>
                                <c:if test="${sessionScope.userType eq 'RENTER' and contract.status == 1}">
                                    <form action="${pageContext.request.contextPath}/payment" method="post" style="display:inline;">
                                        <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                        <button type="submit" name="action" value="agree" class="btn btn-agree">Ký kết & Thanh toán</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/contract-detail" method="post" style="display:inline;">
                                        <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                        <button type="submit" name="action" value="reject" class="btn btn-reject" onclick="return confirm('Xác nhận từ chối hợp đồng này?');">Từ chối</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding: 100px 20px;">
                        <h2 style="color:var(--danger-color);">Không tìm thấy thông tin hợp đồng!</h2>
                        <a href="${pageContext.request.contextPath}/contract" class="btn btn-back">Quay lại</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="/Common/Layout/footer.jsp"/>

    <c:if test="${param.paymentError eq '3'}">
        <script>
            (function () {
                alert('Không thể ký kết & thanh toán vì unit đã bị thuê trong khoảng thời gian yêu cầu. Hợp đồng đã bị hủy.');
            })();
        </script>
    </c:if>
</body>
</html>