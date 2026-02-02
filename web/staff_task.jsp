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

    <!-- ================= HEADER ================= -->
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

                    <c:choose>
                        <c:when test="${t.status == 0}">
                            <a href="staffCheck?action=checkin&csuId=${t.csuId}"
                               class="btn">
                                Check-In
                            </a>
                        </c:when>

                        <c:otherwise>
                            <span class="btn done">Completed</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>

        <!-- ================= CHECK OUT ================= -->
        <div class="card">
            <h3>Expected Check-Outs</h3>

            <c:if test="${empty checkOutList}">
                <p>No expected check-outs.</p>
            </c:if>

            <c:forEach var="t" items="${checkOutList}">
                <div class="task">
                    <div>
                        <strong>${t.renterName}</strong><br>
                        <small>
                            Unit ${t.unitCode}
                            • End: ${t.endDate}
                        </small>
                    </div>

                    <c:choose>
                        <c:when test="${t.status == 1}">
                            <a href="staffCheck?action=checkout&csuId=${t.csuId}"
                               class="btn">
                                Check-Out
                            </a>
                        </c:when>

                        <c:otherwise>
                            <span class="btn done">Completed</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>

    </div>
</div>

</body>
</html>
