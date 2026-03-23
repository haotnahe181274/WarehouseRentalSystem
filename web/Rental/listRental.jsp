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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

        <style>
            /* Page-specific styles only — shared styles in management-layout.css */
            .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
            .btn-info { background: #1890ff; color: white; }
            .btn-success { background: #52c41a; color: white; }
            .btn-danger { background: #ff4d4f; color: white; }
            .btn-update { background: black; color: white; }
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

                <c:if test="${sessionScope.userType == 'INTERNAL'}">
                <div class="stats-container">
                    <jsp:include page="/Common/Layout/stats_cards.jsp">
                        <jsp:param name="label1" value="Total Request" />
                        <jsp:param name="value1" value="${totalRentRequests}" />
                        <jsp:param name="icon1" value="fa-solid fa-file-invoice" />
                        <jsp:param name="color1" value="primary" />
                        
                        <jsp:param name="label2" value="Pending" />
                        <jsp:param name="value2" value="${pendingRentRequests}" />
                        <jsp:param name="icon2" value="fa-solid fa-clock" />
                        <jsp:param name="color2" value="warning" />
                        
                        <jsp:param name="label3" value="Approved" />
                        <jsp:param name="value3" value="${approvedRentRequests}" />
                        <jsp:param name="icon3" value="fa-solid fa-check-double" />
                        <jsp:param name="color3" value="success" />
                        
                        <jsp:param name="label4" value="Cancelled" />
                        <jsp:param name="value4" value="${cancelledRentRequests}" />
                        <jsp:param name="icon4" value="fa-solid fa-ban" />
                        <jsp:param name="color4" value="danger" />
                    </jsp:include>
                </div>
                </c:if>

                <div class="management-card">

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
                </div> <!-- End management-card -->
            </div>
        </div>

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

        <script>
            $(document).ready(function () {

                let table = $('#rentRequestTable').DataTable({
                    order: [[0, 'desc']], 
                    pageLength: 10,
                    dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
                    language: {
                        search: "Search:",
                        lengthMenu: "_MENU_ entries per page"
                    }
                });

                // Move filters into header if needed or keep standard
                var filterHtml = `
                    <div class="filter-wrapper ms-2">
                        <select id="statusFilter" class="form-select form-select-sm" style="width: auto; display: inline-block;">
                            <option value="">All Status</option>
                            <option value="Pending">Pending</option>
                            <option value="Approved">Approved</option>
                            <option value="Rejected">Rejected</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                `;
                
                $('.dataTables_filter').append(filterHtml);

                $('#statusFilter').on('change', function () {
                    let val = $(this).val();
                    table.column(2).search(val).draw();
                });

            });
        </script>

        <jsp:include page="/Common/Layout/footer.jsp" />

    </body>
</html>