<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html>

<head>
    <meta charset="UTF-8">
    <title>Staff Task Board</title>

```
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/Staff-tasks.css">

<style>

    body {
        margin: 0;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background: #f5f7fb;
    }

    .layout {
        display: flex;
        flex: 1;
    }

    .main-content {
        flex: 1;
        padding: 24px;
    }

    /* HEADER */

    .header {
        margin-bottom: 25px;
    }

    .header h1 {
        margin: 0;
    }

    /* STATISTICS */

    .stats {
        display: flex;
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        padding: 18px;
        border-radius: 10px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        min-width: 160px;
    }

    /* CARD */

    .card {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    /* TABLE */

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th {
        background: #f1f3f7;
        text-align: left;
        padding: 12px;
    }

    td {
        padding: 12px;
        border-bottom: 1px solid #eee;
    }

    /* BUTTON */

    .btn {
        background: #4CAF50;
        color: white;
        padding: 6px 14px;
        border-radius: 6px;
        text-decoration: none;
    }

    .btn:hover {
        background: #3d9140;
    }

</style>
```

</head>

<body>

```
<!-- HEADER -->
<jsp:include page="/Common/Layout/header.jsp"/>

<div class="layout">

    <!-- SIDEBAR -->
    <jsp:include page="/Common/Layout/sidebar.jsp"/>


    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- PAGE HEADER -->
        <div class="header">
            <h1>Staff Task Board</h1>
            <span>Today's Assigned Tasks</span>
        </div>





        <!-- TASK TABLE -->
        <div class="card">

            <h3>Assigned Tasks</h3>

            <c:if test="${empty taskList}">
                <p>No tasks assigned.</p>
            </c:if>


            <table>

                <!-- TABLE HEADER -->
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


                <!-- TABLE BODY -->
                <tbody>

                    <c:forEach var="t" items="${taskList}">

                        <tr>

                            <td>
                                ${t.assignmentId}
                            </td>

                            <td>
                                ${t.requestType}
                            </td>

                            <td>
                                ${t.warehouseName}
                            </td>

                            <td>
                                ${t.unitName}
                            </td>

                            <td>
                                ${t.requestDate}
                            </td>

                            <td>
                                ${t.dueDate}
                            </td>

                            <td>
                                <a 
                                    href="staffCheck?assignmentId=${t.assignmentId}" 
                                    class="btn"
                                >
                                    Process
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
```

</body>
</html>
