<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Stored Items</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <style>
        .layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 24px;
            background: #f5f7fb;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
        }

        h3 {
            margin-bottom: 15px;
            font-weight: 600;
            color: #111827;
        }

        table.dataTable {
            width: 100% !important;
            background: #fff;
            border-radius: 6px;
            overflow: hidden;
        }

        #itemTable_filter,
        #itemTable_length {
            display: flex !important;
            align-items: center;
            gap: 10px;
            float: none !important;
        }

        .dt-controls-left {
            display: flex;
            align-items: center;
            gap: 15px;
            float: left;
        }

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-checkin {
            background: black;
            color: white;
        }

        .btn-checkout {
            background: #ff4d4f;
            color: white;
        }

        .btn-history {
            background: #1890ff;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .action-bar {
            margin-bottom: 15px;
        }
    </style>
</head>

<body>

<jsp:include page="/Common/Layout/header.jsp"/>

<div class="layout">

    <div class="main-content">

        <h3>My Stored Items</h3>

        <div class="action-bar">
            <a href="${pageContext.request.contextPath}/createCheckRequest?mode=IN"
               class="btn btn-checkin">New Check In Request</a>

            <a href="${pageContext.request.contextPath}/createCheckRequest?mode=OUT"
               class="btn btn-checkout" style="margin-left:8px;">
                New Check Out Request
            </a>

            <a href="${pageContext.request.contextPath}/checkRequestList"
               class="btn btn-history" style="margin-left:8px;">
                Check Request History
            </a>
        </div>

        <table id="itemTable">
            <thead>
            <tr>
                <th>Item Name</th>
                <th>Description</th>
                <th>Quantity</th>
                <th>Unit Code</th>
                <th>Warehouse</th>
                <th>Address</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${itemList}" var="sui">
                <tr>
                    <td>${sui.item.itemName}</td>
                    <td>${sui.item.description}</td>
                    <td>${sui.quantity}</td>
                    <td>${sui.unit.unitCode}</td>
                    <td>${sui.unit.warehouse.name}</td>
                    <td>${sui.unit.warehouse.address}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
    $(function () {
        $('#itemTable').DataTable({
            pageLength: 5
        });
    });
</script>

</body>
</html>