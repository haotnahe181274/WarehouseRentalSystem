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
            <span>Monday, January 22, 2024</span>
        </div>
        <div class="user-info">
            <strong>Sarah Johnson</strong><br>
            <span>Staff Member</span>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats">
        <div class="stat-card"><p>Total Tasks</p><h2>24</h2></div>
        <div class="stat-card"><p>Check-Ins</p><h2>12</h2></div>
        <div class="stat-card"><p>Check-Outs</p><h2>12</h2></div>
        <div class="stat-card"><p>Completed</p><h2>8</h2></div>
    </div>

    <!-- Main -->
    <div class="main">
        <!-- Check-ins -->
        <div class="card">
            <h3>Expected Check-Ins</h3>


            <c:if test="${empty checkInList}">
                <p>No expected check-ins.</p>
            </c:if>

            <c:forEach items="${checkInList}" var="t">
                <div class="task">
                    <div>
                        <strong>
                            ${t.renterName}
                        </strong><br>
                        <small>
                            Unit ${t.unitCode}
                            • ${t.startDate} 
                        </small>
                    </div>

                    <form action="startCheckIn" method="post">
                        <input type="hidden" name="unitCode" value="${t.unitCode}">
                        <button class="btn">Start Check-In</button>
                    </form>
                </div>
            </c:forEach>


    </div>

        <!-- Check-outs -->
        <div class="card">
            <h3>Expected Check-Outs</h3>

            <c:forEach items="${checkInList}" var="t">
                <div class="task">
                    <div>
                        <strong>
                            ${t.renterName}
                        </strong><br>
                        <small>
                            Unit ${t.unitCode}
                            • ${t.endDate}
                        </small>
                    </div>

                    <form action="startCheckIn" method="post">
                        <input type="hidden" name="unitCode" value="${t.unitCode}">
                        <button class="btn">Start Check-out</button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>
