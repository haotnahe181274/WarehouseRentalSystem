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
    .main-content { flex: 1; padding: 40px 20px; }
    .container { max-width: 900px; margin: 0 auto; }

    /* INFO CARD GRID */
    .info-card {
        background: white;
        border-radius: 12px;
        padding: 24px;
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        margin-bottom: 24px;
        border: 1px solid var(--border-color);
    }

    .info-item span {
        display: block;
        font-size: 12px;
        text-transform: uppercase;
        color: var(--text-sub);
        font-weight: 600;
        margin-bottom: 4px;
    }

    .info-item b { font-size: 16px; color: var(--text-main); }

    /* BADGE */
    .badge {
        display: inline-block;
        background: #dbeafe;
        color: var(--primary-blue);
        padding: 4px 12px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 700;
    }

    /* ITEM CHECK LIST CARD */
    .card {
        background: white;
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        border: 1px solid var(--border-color);
    }

    .card-title {
        font-size: 1.25rem;
        font-weight: 700;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* ITEM ROW REFINEMENT */
    .item-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        margin-bottom: 12px;
        transition: all 0.2s;
    }

    .item-row:hover {
        border-color: var(--primary-blue);
        background-color: #f0f7ff;
    }

    .item-left { display: flex; align-items: center; gap: 16px; }

    .item-icon {
        width: 48px;
        height: 48px;
        background: #f1f5f9;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }

    .item-name { font-weight: 600; font-size: 15px; margin-bottom: 2px; }
    .item-sub { font-size: 13px; color: var(--text-sub); }

    /* INPUT STYLING */
    .item-right { text-align: right; }
    .item-right label { font-size: 12px; font-weight: 600; color: var(--text-sub); display: block; margin-bottom: 4px; }
    
    .input-qty {
        width: 90px;
        padding: 8px 12px;
        border: 2px solid var(--border-color);
        border-radius: 8px;
        text-align: center;
        font-weight: 700;
        color: var(--primary-blue);
        outline: none;
        transition: border-color 0.2s;
    }

    .input-qty:focus { border-color: var(--primary-blue); }

    /* FOOTER & BUTTON */
    .card-footer {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .btn-submit {
        background-color: var(--primary-blue);
        color: white;
        padding: 12px 28px;
        border: none;
        border-radius: 10px;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
        box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
    }

    .btn-submit:hover { background-color: var(--hover-blue); }

    .back-link {
        display: inline-block;
        margin-top: 20px;
        color: var(--text-sub);
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
    }

    .back-link:hover { color: var(--primary-blue); }
</style>

</head>


<body>
    <jsp:include page="/Common/Layout/header.jsp" />
    
    <div class="layout">
        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <jsp:include page="/Common/Layout/sidebar.jsp"/>
        </c:if>

        <div class="main-content">
            <div class="container">

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
                            <div class="item-row">
                                <div class="item-left">
                                    <div class="item-icon">📦</div>
                                    <div>
                                        <div class="item-name">${i.item.itemName}</div>
                                        <div class="item-sub">Required Quantity: <b>${i.quantity}</b></div>
                                    </div>
                                </div>

                                <div class="item-right">
                                    <label>Actual Qty</label>
                                    <input type="number" 
                                           class="input-qty"
                                           name="processed_${i.id}" 
                                           min="0" 
                                           max="${i.quantity}" 
                                           value="${i.quantity}">
                                </div>
                            </div>
                        </c:forEach>

                        <div class="card-footer">
                            <div style="color: var(--text-sub); font-weight: 500;">
                                Total Items: <span style="color: var(--text-main); font-weight: 700;">${checkRequest.items.size()}</span>
                            </div>
                            <button type="submit" class="btn-submit">Confirm & Complete Check</button>
                        </div>
                    </div>
                </form>

                <a href="staffTask" class="back-link">← Back to Task Assignments</a>

            </div>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>