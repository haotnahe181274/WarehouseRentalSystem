<%-- 
    Document   : listRental
    Created on : Feb 10, 2026, 2:54:19 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Rent Request List</title>

        <!-- CSS giống User List -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

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

            #rentRequestTable_filter,
            #rentRequestTable_length {
                display: flex !important;
                align-items: center;
                gap: 10px;
                float: none !important;
            }

            .filter-wrapper {
                display: flex;
                align-items: center;
                gap: 15px;
                float: left;
            }

            select {
                padding: 6px 10px;
                border-radius: 6px;
                border: 1px solid #d1d5db;
                background-color: #fff;
                font-size: 14px;
            }

            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
            }

            .btn-info {
                background: #1890ff;
                color: white;
            }

            .btn-success {
                background: #52c41a;
                color: white;
            }

            .btn-danger {
                background: #ff4d4f;
                color: white;
            }

            .btn-update {
                background: black;
                color: white;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/Common/Layout/header.jsp" />

        <div class="layout">

            <c:if test="${sessionScope.userType == 'INTERNAL'}">
                <jsp:include page="/Common/Layout/sidebar.jsp" />
            </c:if>

            <div class="main-content">

                <h3>Rent Request List</h3>

                <!-- STATUS FILTER -->
                <div class="filter-section">
                    <label>
                        Status:
                        <select id="statusFilter">
                            <option value="">All</option>
                            <option value="0">Pending</option>
                            <option value="1">Approved</option>
                            <option value="2">Rejected</option>
                            <option value="3">Cancelled</option>
                        </select>
                    </label>
                </div>

                <table id="rentRequestTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Request Date</th>
                            <th>Status</th>

                            <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                <th>Renter</th>
                                </c:if>

                            <th>Warehouse</th>
                            <th>Processed Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${rentRequests}" var="rr">
                            <tr>
                                <td>${rr.requestId}</td>

                                <td>
                                    <fmt:formatDate value="${rr.requestDate}" pattern="dd-MM-yyyy HH:mm"/>
                                </td>

                                <td data-search="${rr.status}" data-order="${rr.status}">
                                    <c:choose>
                                        <c:when test="${rr.status == 0}">Pending</c:when>
                                        <c:when test="${rr.status == 1}">Approved</c:when>
                                        <c:when test="${rr.status == 2}">Rejected</c:when>
                                        <c:when test="${rr.status == 3}">Cancelled</c:when>
                                    </c:choose>
                                </td>

                                <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                    <td>${rr.renter.fullName}</td>
                                </c:if>

                                <td>${rr.warehouse.name}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${rr.processedDate != null}">
                                            <fmt:formatDate value="${rr.processedDate}" pattern="dd-MM-yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>None</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}"
                                       class="btn btn-info">View</a>

                                    <!-- INTERNAL -->
                                    <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                        <c:if test="${rr.status == 0}">
                                            <form action="${pageContext.request.contextPath}/rentRequestApprove"
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${rr.requestId}">
                                                <button class="btn btn-success">Approve</button>
                                            </form>

                                            <form action="${pageContext.request.contextPath}/rentRequestCancel"
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${rr.requestId}">
                                                <button class="btn btn-danger">Reject</button>
                                            </form>
                                        </c:if>
                                    </c:if>

                                    <!-- RENTER -->
                                    <c:if test="${sessionScope.userType == 'RENTER'}">
                                        <c:if test="${rr.status == 0}">
                                            <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}&action=edit"
                                               class="btn btn-update">Update</a>

                                            <form action="${pageContext.request.contextPath}/rentRequestCancel"
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${rr.requestId}">
                                                <button class="btn btn-danger">Cancel</button>
                                            </form>
                                        </c:if>
                                    </c:if>
                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

            </div>
        </div>

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

        <script>
            $(document).ready(function () {

                let table = $('#rentRequestTable').DataTable({
                    order: [[0, 'desc']], // sort theo ID
                    pageLength: 10
                });

                // Khi đổi dropdown
                $('#statusFilter').on('change', function () {
                    let val = $(this).val();

                    if (val === "") {
                        table.column(2).search("").draw(); // All
                    } else {
                        table.column(2).search("^" + val + "$", true, false).draw();
                    }
                });

            });
        </script>

        <jsp:include page="/Common/Layout/footer.jsp" />

    </body>
</html>