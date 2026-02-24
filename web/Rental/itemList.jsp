<%-- 
    Document   : itemList
    Created on : Feb 16, 2026, 4:55:05 PM
    Author     : ad
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet"
              href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>

        <div class="detail-container">

            <h2>My Stored Items</h2>

            <div style="margin-bottom:15px;">
                <a href="${pageContext.request.contextPath}/createCheckRequest?mode=IN" class="btn btn-approve">New Check In Request</a>
                <a href="${pageContext.request.contextPath}/createCheckRequest?mode=OUT" class="btn btn-reject" style="margin-left:8px;">New Check Out Request</a>
                <a href="${pageContext.request.contextPath}/checkRequestList" class="btn btn-reject" style="margin-left:8px;">Check Request History</a>
            </div>

            <table class="table" id="itemTable">
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Description</th>
                        <th>Quantity</th>
                        <th>Unit Code</th>
                        <th>Warehouse</th>
                        <th>Address</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach items="${itemList}" var="sui">
                        <tr>
                            <td>${sui.item.itemName}</td>
                            <td>${sui.item.description}</td>
                            <td>${sui.quantity}</td>
                            <td>${sui.unit.unitCode}</td>
                            <td>${sui.unit.warehouse.name}</td>
                            <td>${sui.unit.warehouse.address}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>


        </div>

        <jsp:include page="/Common/Layout/footer.jsp"/>


        <script>
            $(document).ready(function () {
                $('#itemTable').DataTable({
                    pageLength: 5
                    
                });
            });
        </script>

    </body>
</html>
