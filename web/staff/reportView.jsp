<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Report Details - #${report.reportId}</title>
    <style>
       * {
    box-sizing: border-box;
}

html, body {
    margin: 0;
    padding: 0;
    height: 100%;
    font-family: Arial, sans-serif;
    background: #f4f6f8;
}

/* Layout toàn trang để footer luôn ở dưới */
.page-wrapper {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

/* Phần giữa gồm sidebar + content */
.layout {
    display: flex;
    flex: 1;
}

/* Sidebar kéo dài full chiều cao */
.sidebar {
    width: 220px;
    background: #000;
    color: white;
    min-height: 100%;
}

/* Nội dung bên phải */
.container {
    flex: 1;
    padding: 24px;
    background: #f5f7fb;
}

/* Form */
h2 {
    text-align: center;
    margin-bottom: 25px;
}

.form-group {
    margin-bottom: 18px;
}

label {
    display: block;
    font-weight: bold;
    margin-bottom: 6px;
}

input, select, textarea {
    width: 100%;
    padding: 10px;
    border-radius: 4px;
    border: 1px solid #ccc;
}

textarea {
    resize: vertical;
}

input[readonly] {
    background: #f1f1f1;
}

.row {
    display: flex;
    gap: 20px;
}

.row .form-group {
    flex: 1;
}

/* Status badge */
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    color: white;
    font-size: 0.9em;
}

.status-1 { background: #ffc107; }
.status-2 { background: #007bff; }
.status-3 { background: red; }

/* Buttons */
.btn {
    background: #007bff;
    color: #fff;
    padding: 10px 18px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.btn-process {
    background-color: #27ae60;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
}

.btn-reject {
    background-color: #e74c3c;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    margin-left: 10px;
}
    </style>
</head>
<body>
<jsp:include page="/Common/Layout/header.jsp" />
<jsp:include page="/message/popupMessage.jsp" />
<div class="layout">   
<jsp:include page="/Common/Layout/sidebar.jsp" />
<div class="container">
    <h2>Incident Report Details</h2>

    <div style="text-align: center; margin-bottom: 20px;">
        Status: 
        <span class="status-badge status-${report.status}">
            <c:choose>
                <c:when test="${report.status == 1}">Processing</c:when>
                <c:when test="${report.status == 2}">Resolved</c:when>
                <c:otherwise>reject</c:otherwise>
            </c:choose>
        </span>
    </div>

    <form>
        <div class="row">
            <div class="form-group">
                <label>Incident ID</label>
                <input type="text" value="#${report.reportId}" readonly />
            </div>
            <div class="form-group">
                <label>Report Date</label>
                <input type="text" value="<fmt:formatDate value='${report.reportDate}' pattern='dd/MM/yyyy HH:mm'/>" readonly />
            </div>
        </div>

        <div class="form-group">
            <label>Incident Type</label>
            <input type="text" value="${report.type}" readonly />
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea rows="4" readonly>${report.description}</textarea>
        </div>

        <div class="row">
            <div class="form-group">
                <label>Reported By</label>
                <input type="text" value="${report.staffName}" readonly />
            </div>
            <div class="form-group">
                <label>Warehouse</label>
                <input type="text" value="${report.warehouseName}" readonly />
            </div>
        </div>

       </form> 

        <c:if test="${(sessionScope.user.role eq 'Manager' || sessionScope.user.role eq 'Admin') && report.status == 1}">
            <div style="margin-top: 30px; text-align: center;">
                <form action="${pageContext.request.contextPath}/viewReport" method="post">
                    <input type="hidden" name="id" value="${report.reportId}">

                    <button type="submit" name="status" value="2" class="btn-process">
                        Accept & Process
                    </button>
                    <button type="submit" name="status" value="3" class="btn-reject">
                        Reject
                    </button>
                </form>
            </div>
        </c:if>

        <div style="text-align:center; margin-top: 25px;">
            <button type="button" class="btn" onclick="history.back()" style="background: #6c757d;">Back to List</button>
        </div>
    </form>
</div>
</div>                     
<jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>