<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Check</title>
    <style>
        :root {
            --primary-blue: #2563eb;
            --hover-blue: #1d4ed8;
            --bg-gray: #f8fafc;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background-color: var(--bg-gray);
            margin: 0;
            color: var(--text-main);
        }

        .layout { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 20px 40px; }
        .container { max-width: 1000px; margin: 0 auto; }

        /* Header link điều hướng */
        .top-nav {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        /* INFO CARD GRID */
        .info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin-bottom: 24px;
            border: 1px solid var(--border-color);
        }

        .info-item span {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            color: var(--text-sub);
            font-weight: 600;
            margin-bottom: 6px;
        }

        .info-item b { font-size: 15px; color: var(--text-main); }

        .badge {
            display: inline-block;
            background: #dbeafe;
            color: var(--primary-blue);
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        /* ITEM CHECK LIST CARD */
        .card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-color);
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* ITEM ROW - Đã sửa lỗi layout */
        .item-wrapper {
            margin-bottom: 24px;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 24px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            background: white;
            transition: all 0.2s;
        }

        .item-row:hover {
            border-color: var(--primary-blue);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.08);
        }

        .item-left { display: flex; align-items: center; gap: 20px; }

        .item-icon {
            width: 44px;
            height: 44px;
            background: #f8fafc;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            border: 1px solid #f1f5f9;
        }

        .item-name { font-weight: 700; font-size: 16px; color: #1e293b; margin-bottom: 4px; }
        .item-sub { font-size: 13px; color: var(--text-sub); }
        .item-sub b { color: #1e293b; }

        /* INPUT STYLING */
        .item-right-container {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-top: 8px;
        }

        .item-right-container label { 
            font-size: 11px; 
            font-weight: 700; 
            color: var(--text-sub); 
            margin-bottom: 6px; 
        }

        .input-qty {
            width: 60px;
            padding: 8px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            text-align: center;
            font-weight: 700;
            color: var(--primary-blue);
            outline: none;
        }

        .input-qty:focus { border-color: var(--primary-blue); ring: 2px solid #dbeafe; }

        /* ACTION BUTTONS */
        .card-footer {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .actions {
            display: flex;
            gap: 12px;
        }

        .btn-submit {
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
            color: white;
        }

        .btn-save { background-color: #facc15; color: #854d0e; }
        .btn-save:hover { background-color: #f87171; color: white; } /* Tùy chỉnh hover */

        .btn-complete { background-color: var(--primary-blue); }
        .btn-complete:hover { background-color: var(--hover-blue); }

        .back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 20px;
    color: black;
    text-decoration: none;
    font-size: 15px; /* Tăng nhẹ kích thước */
    font-weight: 800; /* Đổi từ 500 thành 800 để chữ đậm rõ rệt */
    transition: all 0.2s;
}

.back-link:hover {
    color: var(--primary-blue);
    transform: translateX(-4px); /* Thêm hiệu ứng nhích nhẹ sang trái khi hover */
}
    </style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp" />
    <jsp:include page="/message/popupMessage.jsp" />
    <div class="layout">
        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <jsp:include page="/Common/Layout/sidebar.jsp"/>
        </c:if>

        <div class="main-content">
            <div class="container">
                <div class="top-nav">
                    <a href="staffTask" class="back-link">← Back to Task Assignments</a>
                </div>

                <div class="info-card">
                    <div class="info-item">
                        <span>Request ID</span>
                        <b>#${checkRequest.id}</b>
                    </div>
                    <div class="info-item">
                        <span>Type</span>
                        <div><span class="badge">${checkRequest.requestType}</span></div>
                    </div>
                    <div class="info-item">
                        <span>Warehouse</span>
                        <b>Warehouse ${checkRequest.warehouseId}</b>
                    </div>
                    <div class="info-item">
                        <span>Unit Location</span>
                        <b>Unit ${checkRequest.unitId}</b>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/staffCheck" method="post">
                    <input type="hidden" name="assignmentId" value="${assignmentId}">
                    <input type="hidden" name="requestId" value="${checkRequest.id}">

                    <div class="card">
                        <div class="card-title">
                            📦 Item Check List
                        </div>

                        <c:forEach var="i" items="${checkRequest.items}">
                            <div class="item-wrapper">
                                <div class="item-row">
                                    <div class="item-left">
                                        <div class="item-icon">📦</div>
                                        <div>
                                            <div class="item-name">${i.item.itemName}</div>
                                            <div class="item-sub">
                                                Required Quantity: <b>${i.quantity}</b> | 
                                                Total Processed: <b>${i.processedQuantity != null ? i.processedQuantity : 0}</b>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="item-right-container">
                                    <label>Actual Qty</label>
                                    <input type="number" 
                                           class="input-qty"
                                           name="processed_${i.id}" 
                                           min="0" 
                                           max="${i.quantity - (i.processedQuantity != null ? i.processedQuantity : 0)}" 
                                           value="${i.processedQuantity != null ? i.processedQuantity : 0}">
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="card-footer">
                        <div style="color: var(--text-sub); font-weight: 500;">
                            Total Items: <span style="color: var(--text-main); font-weight: 700;">${checkRequest.items.size()}</span>
                        </div>

                        <div class="footer-actions-group">
                            <div class="note-text">
                                ⚠️ <i>Please <b>Save Progress</b> before clicking <b>Complete</b> to avoid data loss.</i>
                            </div>

                            <div class="actions">
                                <button type="submit" name="action" value="save" class="btn-submit btn-save" style="background-color:#facc15; color: #854d0e;">
                                    💾 Save Progress
                                </button>
                                <button type="submit" name="action" value="complete" class="btn-submit btn-complete">
                                    ✅ Complete Check
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>