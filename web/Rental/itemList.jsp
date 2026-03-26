<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <body>

        <jsp:include page="/Common/Layout/header.jsp"/>

        <div class="layout">

            <div class="main-content">

                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">

                    <h3 style="margin:0;">My Stored Items</h3>

                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/createCheckRequest?mode=IN"
                           class="btn btn-dark">
                            Check In
                        </a>

                        <a href="${pageContext.request.contextPath}/createCheckRequest?mode=OUT"
                           class="btn btn-danger">
                            Check Out
                        </a>

                        <a href="${pageContext.request.contextPath}/checkRequestList"
                           class="btn btn-primary">
                            History
                        </a>
                    </div>

                </div>
                           <div class="management-card">

    
                <table id="itemTable">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Item Name</th>
                            <th>Description</th>
                            <th>Quantity</th>
                            <th>Unit Code</th>
                            <th>Warehouse</th>
                            <th>Address</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${itemList}" var="sui" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>  <!-- STT bắt đầu từ 1 -->
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

            </div>
        </div>

        <jsp:include page="/Common/Layout/footer.jsp"/>

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

        <script>
            $(document).ready(function () {

    let table = $('#itemTable').DataTable({
        order: [[0, 'desc']],
        pageLength: 10,
        dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
        language: {
            search: "Search:",
            lengthMenu: "_MENU_ entries per page"
        }
    });

});        
    </script>

    </body>
</html>