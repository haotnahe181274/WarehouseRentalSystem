<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet"
              href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <title>Check Request History</title>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>

        <div class="detail-container">
            <h2>Check In / Check Out History</h2>

            <table class="table" id="itemTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Warehouse</th>
                        <th>Unit</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${checkRequests}" var="cr">
                        <tr>
                            <td>${cr.id}</td>
                            <td>${cr.requestDate}</td>
                            <td>${cr.requestType}</td>
                            <td>${cr.warehouse.name}</td>
                            <td>${cr.unit.unitCode}</td>
                            <td>${cr.overallStatus}</td>
                            <td>
                                <a class="btn btn-approve" href="${pageContext.request.contextPath}/checkRequestDetail?id=${cr.id}">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="margin-top:16px;">
                <a href="${pageContext.request.contextPath}/itemlist" class="btn btn-reject">Back to Items</a>
            </div>
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

