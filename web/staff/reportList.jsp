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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        /* Page-specific styles only — shared styles in management-layout.css */
        .toolbar { display: flex; justify-content: flex-end; margin-bottom: 15px; }
        .toolbar button { padding: 8px 16px; border: none; background-color: #3498db; color: #fff; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .toolbar button:hover { background-color: #2980b9; }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-progress { background: #dbeafe; color: #1e40af; }
        .status-fail { background: #fef2f2; color: #991b1b; }
        .btn-view { display: inline-block; padding: 5px 12px; background-color: #2ecc71; color: white; text-decoration: none; border-radius: 4px; font-size: 12px; transition: background 0.3s; }
        .btn-view:hover { background-color: #27ae60; color: #fff; }
    </style>
</head>

<body>
    <!-- HEADER -->
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="layout">
        <!-- SIDEBAR -->
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="main-content">
                <h3>Incident Report List</h3>

                <div class="stats-container">
                    <jsp:include page="/Common/Layout/stats_cards.jsp">
                        <jsp:param name="label1" value="Total Report" />
                        <jsp:param name="value1" value="${totalReports}" />
                        <jsp:param name="icon1" value="fa-solid fa-triangle-exclamation" />
                        <jsp:param name="color1" value="primary" />

                        <jsp:param name="label2" value="Processing" />
                        <jsp:param name="value2" value="${pendingReports}" />
                        <jsp:param name="icon2" value="fa-solid fa-clock" />
                        <jsp:param name="color2" value="warning" />

                        <jsp:param name="label3" value="Resolved" />
                        <jsp:param name="value3" value="${processingReports}" />
                        <jsp:param name="icon3" value="fa-solid fa-gears" />
                        <jsp:param name="color3" value="info" />

                        <jsp:param name="label4" value="Reject" />
                        <jsp:param name="value4" value="${rejectReports}" />
                        <jsp:param name="icon4" value="fa-solid fa-rectangle-xmark" />
                        <jsp:param name="color4" value="danger" />
                    </jsp:include>
                </div>

                <div class="management-card">
                    
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
                                            <span class="status-badge status-pending">Processing</span>
                                        </c:when>
                                        <c:when test="${r.status == 2}">
                                            <span class="status-badge status-progress">Resolved</span>
                                        </c:when>
                                        <c:when test="${r.status == 3}">
                                            <span class="status-badge status-fail">Reject</span>
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
                </div> <!-- End management-card -->
            </div> <!-- End main-content -->
        </div> <!-- End layout -->
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
