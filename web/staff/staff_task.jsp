
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Task Board</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        body {
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .staff-task-layout {
            display: flex;
            flex: 1;
        }

        .staff-task-main {
            flex: 1;
            padding: 24px;
            background-color: var(--mgmt-bg);
        }

        .header {
            margin-bottom: 25px;
        }

        .header h3 {
            margin: 0;
            font-weight: 700;
            color: #111827;
            font-size: 20px;
        }

        .header span {
            color: #6b7280;
            font-size: 14px;
        }

        .staff-task-main .btn-row {
            display: inline-block;
        }

        .staff-task-main .btn-row .btn {
            background: #111827;
            color: white;
            padding: 6px 14px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        .staff-task-main .btn-row .btn:hover {
            background: #374151;
            color: white;
        }

        footer {
            margin-top: auto;
        }

    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/Common/Layout/header.jsp"/>
<jsp:include page="/message/popupMessage.jsp" />
<div class="staff-task-layout">

    <!-- SIDEBAR -->
    <jsp:include page="/Common/Layout/sidebar.jsp"/>

    <!-- MAIN CONTENT -->
    <div class="staff-task-main">

        <!-- PAGE HEADER -->
        <div class="header">
            <h3>Staff Task Board</h3>
            <span>Today's Assigned Tasks</span>
        </div>

        <!-- TASK TABLE -->
        <div class="management-card">
            <c:if test="${empty taskList}">
                <p class="page-subtitle" style="margin-bottom: 0;">No tasks assigned.</p>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>Assignment ID</th>
                        <th>Request Type</th>
                        <th>Warehouse</th>
                        <th>Unit</th>
                        <th>Request Date</th>
                        <th>Due Date</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="t" items="${taskList}">
                        <tr>
                            <td>${t.assignmentId}</td>
                            <td>${t.requestType}</td>
                            <td>${t.warehouseName}</td>
                            <td>${t.unitName}</td>
                            <td>${t.requestDate}</td>
                            <td>${t.dueDate}</td>
                            <td>
                                <a class="btn btn-row"
                                   href="${pageContext.request.contextPath}/staffCheck?assignmentId=${t.assignmentId}">
                                    Check
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </div>

    </div>
</div>

<!-- FOOTER -->
<jsp:include page="/Common/Layout/footer.jsp"/>

</body>
</html>
