<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Detail</title>
    <link rel="stylesheet" href="css/Staff-check.css">
</head>
<body>

<div class="container">
    <h1>Check Detail</h1>

    <c:if test="${empty detail}">
        <p>No data found</p>
    </c:if>

    <c:forEach var="u" items="${detail}">
        <div class="card">
            <h3>Unit ${u.unitCode}</h3>

            <p>
                <strong>Customer:</strong> ${u.renterName}<br>
                <strong>Start:</strong> ${u.checkInDate}<br>
                <strong>End:</strong> ${u.checkOutDate}
            </p>

            <c:if test="${not empty u.itemName}">
                <div class="item">
                    <strong>${u.itemName}</strong><br>
                    <small>${u.description}</small>
                </div>
            </c:if>

            <div class="action">
                <c:choose>
                    <c:when test="${u.unitStatusCode == 0}">
                        <form method="post" action="staffCheck">
                            <input type="hidden" name="csuId" value="${u.csuId}">
                            <input type="hidden" name="action" value="checkin">
                            <button class="btn">Check-In</button>
                        </form>
                    </c:when>

                    <c:when test="${u.unitStatusCode == 1}">
                        <form method="post" action="staffCheck">
                            <input type="hidden" name="csuId" value="${u.csuId}">
                            <input type="hidden" name="action" value="checkout">
                            <button class="btn">Check-Out</button>
                        </form>
                    </c:when>

                    <c:otherwise>
                        <span class="btn done">Completed</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</div>

</body>
</html>
