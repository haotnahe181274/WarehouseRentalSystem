<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Request History</title>

    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
            margin: 0;
        }

        .main-content {
            padding: 24px;
            max-width: 1200px;
            margin: auto;
        }

        h3 {
            margin-bottom: 20px;
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

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-approve {
            background: #1890ff;
            color: white;
        }

        .btn-reject {
            background: black;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .action-area {
            margin-top: 16px;
        }
    </style>
</head>

<body>

<jsp:include page="/Common/Layout/header.jsp"/>

<div class="main-content">

    <h3>Check In / Check Out History</h3>

    <table id="itemTable">
        <thead>
        <tr>
            <th>ID</th>
            <th>Date</th>
            <th>Type</th>
            <th>Warehouse</th>
            <th>Unit</th>
            <th>Status</th>
            <th></th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${checkRequests}" var="cr">
            <tr>
                <td>${cr.id}</td>
                <td>${cr.requestDate}</td>
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

    <div class="action-area">
        <a href="${pageContext.request.contextPath}/itemlist"
           class="btn btn-reject">
            Back to Items
        </a>
    </div>

</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

        
        <script>
            $(document).ready(function () {
                $('#itemTable').DataTable({
                    pageLength: 5
                    
                });
            });
        </script>

    </body>
</html>

