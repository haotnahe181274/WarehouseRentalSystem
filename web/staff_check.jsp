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

    <c:if test="${empty list}">
        No data found
    </c:if>

    <c:set var="first" value="${list[0]}"/>

    <!-- BOOKING INFO -->
    <div class="card">
        <h3>Booking Info</h3>
        Customer: ${first.renterName} <br>
        Unit: ${first.unitCode} <br>
        Start: ${first.checkInDate} <br>
        End: ${first.checkOutDate}
    </div>

    <!-- ITEMS -->
    <div class="card">
        <h3>Items in Unit</h3>

        <c:forEach var="u" items="${list}">
            <div class="item">
                <strong>${u.itemName}</strong><br>
                <small>${u.description}</small>
            </div>
        </c:forEach>
    </div>

    <!-- COMPLETE -->
    <form method="post" action="staffCheck">
        <input type="hidden" name="assignmentId" value="${assignmentId}">
        <button class="btn">Complete Task</button>
    </form>

</div>

</body>
</html>
