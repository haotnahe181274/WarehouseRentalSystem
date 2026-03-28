<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Request History</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        .btn { padding: 6px 12px; border-radius: 4px; }
        .btn-approve { background: #1890ff; color: white; }
        .btn-reject { background: black; color: white; }
    </style>
</head>
<body>

<jsp:include page="/Common/Layout/header.jsp"/>
<jsp:include page="/message/popupMessage.jsp" />
<div class="layout">
    

<div class="main-content">

    <h3>Check In / Check Out History</h3>

    <div class="management-card">
    <table id="itemTable" class="display">
        <thead>
        <tr>
            <th>No.</th>
            <th>Date</th>
            <th>Type</th>
            <th>Warehouse</th>
            <th>Unit</th>
            <th>Status</th>
            <th></th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${checkRequests}" var="cr" varStatus="loop">
            <tr>
                <td>${loop.count}</td>  <!-- STT bắt đầu từ 1 -->
                
                <td><fmt:formatDate value="${cr.requestDate}" pattern="yyyy-MM-dd"/></td>
                <td>${cr.requestType}</td>
                <td>${cr.warehouse.name}</td>
                <td>${cr.unit.unitCode}</td>
                <td>${cr.overallStatus}</td>
                <td>
                    <a class="btn btn-approve"
                       href="${pageContext.request.contextPath}/checkRequestDetail?id=${cr.id}">
                        View
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </div>

    <div class="action-area">
        <a href="${pageContext.request.contextPath}/itemlist"
           class="btn btn-reject">
            Back to Items
        </a>
    </div>
</div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script>
    $(document).ready(function () {

    let table = $('#itemTable').DataTable({
        order: [[0, 'desc']],
        pageLength: 10,
        dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
        language: {
            search: "Search:",
            lengthMenu: "_MENU_ entries per page"
        }
    });

    // thêm dropdown filter
    let filterHtml = `
        <div class="filter-wrapper ms-2">
            <select id="typeFilter" class="form-select form-select-sm" style="width:auto; display:inline-block;">
                <option value="">All Type</option>
                <option value="IN">Check In</option>
                <option value="OUT">Check Out</option>
            </select>
        </div>
    `;

    $('.dataTables_filter').append(filterHtml);

    // filter theo type
    $('#typeFilter').on('change', function () {
        let val = $(this).val();
        table.column(2).search(val).draw();
    });

});
</script>

    </body>
</html>

