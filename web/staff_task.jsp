<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Tasks</title>
    <link rel="stylesheet" href="css/Staff-tasks.css">
</head>

<body>
<div class="container">

    <!-- Header -->
    <div class="header">
        <div>
            <h1>Today's Tasks</h1>
            <span>Staff Task Board</span>
        </div>

        <div class="user-info">
            <strong>Staff</strong><br>
            <span>Task View</span>
        </div>
    </div>

    <!-- ================= STATS ================= -->
    <div class="stats">
        <div class="stat-card">
            <p>Total Tasks</p>
            <h2>${checkInList.size() + checkOutList.size()}</h2>
        </div>

        <div class="stat-card">
            <p>Check-Ins</p>
            <h2>${checkInList.size()}</h2>
        </div>

        <div class="stat-card">
            <p>Check-Outs</p>
            <h2>${checkOutList.size()}</h2>
        </div>

        <div class="stat-card">
            <p>Completed</p>
            <h2>${completedCount}</h2>
        </div>
    </div>

    <div class="main">

        <!-- ================= CHECK IN ================= -->
        <div class="card">
            <h3>Expected Check-Ins</h3>

            <c:if test="${empty checkInList}">
                <p>No expected check-ins.</p>
            </c:if>

            <c:forEach var="t" items="${checkInList}">
                <div class="task">

                    <div>
                        <strong>${t.renterName}</strong><br>
                        <small>
                            Unit ${t.unitCode}
                            • Start: ${t.startDate}
                        </small>
                    </div>

                    <!-- nếu completed -->
                    <c:choose>
                        <c:when test="${t.status == 2}">
                            <span class="btn done">Completed</span>
                        </c:when>

                        <c:otherwise>
                            <a href="staffCheck?assignmentId=${t.assignmentId}" class="btn">
                                Check-In
                            </a>
                        </c:otherwise>
                    </c:choose>

                </div>
            </c:forEach>
        </div>

        <!-- ================= CHECK OUT ================= -->
        <div class="card">
            <h3>Expected Check-out</h3>

            <c:if test="${empty checkOutList}">
                <p>No expected check-ins.</p>
            </c:if>

            <c:forEach var="t" items="${checkOutList}">
                <div class="task">

                    <div>
                        <strong>${t.renterName}</strong><br>
                        <small>
                            Unit ${t.unitCode}
                            • finish: ${t.endDate}
                        </small>
                    </div>

                    <!-- nếu completed -->
                    <c:choose>
                        <c:when test="${t.status == 2}">
                            <span class="btn done">Completed</span>
                        </c:when>

                        <c:otherwise>
                            <a href="staffCheck?assignmentId=${t.assignmentId}" class="btn">
                                Check-out
                            </a>
                        </c:otherwise>
                    </c:choose>

                </div>
            </c:forEach>
        </div>

    </div>
</div>

</body>
</html>
