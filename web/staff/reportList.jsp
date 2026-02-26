<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Incident Report List</title>
    <link rel="stylesheet"
              href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background-color: #f5f6fa;
        }

        /* ===== LAYOUT ===== */
        .layout {
            display: flex;
            min-height: calc(100vh - 60px); /* trừ header */
        }

        .main-content {
            flex: 1;
            padding: 24px;
            background: #f5f7fb;
        }

        /* ===== PAGE CONTENT ===== */
        .page-box {
            background: #fff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .page-box h2 {
            margin-bottom: 20px;
            color: #2c3e50;
        }

        /* TOOLBAR */
        .toolbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 15px;
        }

        .toolbar button {
            padding: 8px 16px;
            border: none;
            background-color: #3498db;
            color: #fff;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .toolbar button:hover {
            background-color: #2980b9;
        }

        /* TABLE */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color:black;
            color: #fff;
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: top;
            font-size: 14px;
        }

       
        /* STATUS */
        .status-open {
            color: #e67e22;
            font-weight: bold;
        }

        .status-closed {
            color: #27ae60;
            font-weight: bold;
        }
        /* Nút View */
        .btn-view {
            display: inline-block;
            padding: 5px 12px;
            background-color: #2ecc71; /* Màu xanh lá */
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 12px;
            transition: background 0.3s;
        }

        .btn-view:hover {
            background-color: #27ae60;
            color: #fff;
        }

        
    </style>
</head>

<body>
    <!-- HEADER -->
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="layout">
        <!-- SIDEBAR -->
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <!-- MAIN -->
        <div class="main-content">
            <div class="page-box">
                <h2>Incident Report List</h2>

                <div class="toolbar">
                    <c:if test="${sessionScope.user.role eq 'Staff'}">
                        <a href="${pageContext.request.contextPath}/staffReport">
                            <button>Staff Task</button>
                        </a>
                    </c:if>
                </div>

                <table id="itemTable">
                    <thead>
                        <tr>   
                            <th>Staff</th>
                            <th>Type</th>
                            <th>Warehouse</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th> </tr>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="r" items="${incidentList}">
                            <tr> 
                                <td>${r.staffName}</td>
                                <td>${r.type}</td>
                                <td>${r.warehouseName}</td>                  
                                <td>${r.reportDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 1}">
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${r.status == 2}">
                                            <span class="status-badge status-process">Processing</span>
                                        </c:when>
                                        <c:when test="${r.status == 3}">
                                            <span class="status-badge status-fail">reject</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">Unknown</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/viewReport?id=${r.reportId}" class="btn-view">
                                        View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
        <jsp:include page="/Common/Layout/footer.jsp" />
        <script>
            $(document).ready(function () {
                $('#itemTable').DataTable({
                    pageLength: 5
                    
                });
            });
        </script>
</body>
</html>
