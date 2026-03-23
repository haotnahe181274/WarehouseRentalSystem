<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>
    <title>Staff Check</title>

    <style>

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f3f4f6;
    margin: 0;
}

.container {
    max-width: 950px;
    margin: 30px auto;
}

/* CARD */
.card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 20px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.card-title {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 20px;
}

/* INFO CARD */
.info-grid {
    display: flex;
    justify-content: space-between;
}

.info-grid span {
    font-size: 13px;
    color: #777;
}

.info-grid b {
    display: block;
    margin-top: 5px;
    font-size: 16px;
}

/* BADGE */
.badge {
    background: #2563eb;
    color: white;
    padding: 3px 10px;
    border-radius: 6px;
    font-size: 12px;
}

/* ITEM ROW */
.item-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 12px;
}

.item-left {
    display: flex;
    align-items: center;
    gap: 15px;
}

.item-icon {
    width: 45px;
    height: 45px;
    background: #eef2ff;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.item-name {
    font-weight: 600;
}

.item-sub {
    font-size: 13px;
    color: #777;
}

.item-right input {
    width: 80px;
    padding: 6px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

/* CARD FOOTER */
.card-footer {
    margin-top: 20px;
    padding-top: 15px;
    border-top: 1px solid #eee;

    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* BUTTON */
button {
    background: #2563eb;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
}

button:hover {
    background: #1d4ed8;
}

/* BACK LINK */
.back a {
    color: #2563eb;
    text-decoration: none;
}


    </style>

</head>


<body>
<jsp:include page="/Common/Layout/header.jsp" />

<div class="container">

    <!-- REQUEST INFO -->
    <div class="card info-card">
        <div class="info-grid">
            <div>
                <span>Request ID</span>
                <b>#${checkRequest.id}</b>
            </div>
            <div>
                <span>Type</span>
                <b class="badge">${checkRequest.requestType}</b>
            </div>
            <div>
                <span>Warehouse</span>
                <b>${checkRequest.warehouseId}</b>
            </div>
            <div>
                <span>Unit</span>
                <b>${checkRequest.unitId}</b>
            </div>
        </div>
    </div>

    <!-- CHECK LIST -->
    <form action="${pageContext.request.contextPath}/staffCheck" method="post">
        <input type="hidden" name="assignmentId" value="${assignmentId}">
        <input type="hidden" name="requestId" value="${checkRequest.id}">

        <div class="card">
            <div class="card-title">Item Check List</div>

            <c:forEach var="i" items="${checkRequest.items}">
                <div class="item-row">
                    <div class="item-left">
                        <div class="item-icon">📦</div>
                        <div>
                            <div class="item-name">${i.item.itemName}</div>
                            <div class="item-sub">Required Qty: ${i.quantity}</div>
                        </div>
                    </div>

                    <div class="item-right">
                        <label>Qty</label>
                        <input type="number"
                               name="processed_${i.id}"
                               min="0"
                               max="${i.quantity}"
                               value="${i.quantity}">
                    </div>
                </div>
            </c:forEach>

            <div class="card-footer">
                <div>Items: ${checkRequest.items.size()}</div>
                <button type="submit">Complete Check</button>
            </div>
        </div>
    </form>

    <div class="back">
        <a href="staffTask">← Back to Task</a>
    </div>

</div>
                    
<jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>