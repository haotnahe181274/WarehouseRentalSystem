<%-- 
    Document   : listRental
    Created on : Feb 10, 2026, 2:54:19 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

        <jsp:include page="/Common/Layout/header.jsp" />
        <h2>Rent Request List</h2>

        <label style="margin-bottom:10px;">
            Status:
            <select id="statusFilter">
                <option value="0" >Pending</option>
                <option value="1">Approved</option>
                <option value="2">Rejected</option>
                <option value="3">Cancelled</option>
                <option value="" selected>All</option>
            </select>
        </label>


        <table id="rentRequestTable" class="display">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Request Date</th>
                    <th class="col-status">Status</th>

                    <c:if test="${sessionScope.userType == 'INTERNAL' }">
                        <th>Renter </th>
                        </c:if>

                    <th>Warehouse</th>
                    <th>Processed Date</th>


                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${rentRequests}" var="rr">
                    <tr>
                        <td>${rr.requestId}</td>

                        <td>
                            <fmt:formatDate value="${rr.requestDate}"
                                            pattern="dd-MM-yyyy HH:mm"/>
                        </td>

                        <td class="col-status" data-search="${rr.status}" data-order="${rr.status}">
                            <c:choose>
                                <c:when test="${rr.status == 0}">Pending</c:when>
                                <c:when test="${rr.status == 1}">Approved</c:when>
                                <c:when test="${rr.status == 2}">Rejected</c:when>
                                <c:when test="${rr.status == 3}">Cancelled</c:when>
                            </c:choose>
                        </td>


                        <c:if test="${sessionScope.userType == 'INTERNAL' }">
                            <td>${rr.renter.fullName}</td>
                        </c:if>

                        <td>${rr.warehouse.name}</td>
                        <td>
                            <c:choose>
                                <c:when test="${rr.processedDate != null}">
                                    <fmt:formatDate value="${rr.processedDate}"
                                                    pattern="dd-MM-yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>none</c:otherwise>
                            </c:choose>
                        </td>


                        <td>
                            <!-- VIEW: ai cũng thấy -->
                            <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}"
                               class="btn btn-sm btn-info">
                                View
                            </a>

                            <!-- ========== MANAGER ========== -->
                            <c:if test="${sessionScope.userType == 'INTERNAL' }">
                                <c:if test="${rr.status == 0}">
                                    <!-- APPROVE -->
                                    <form action="${pageContext.request.contextPath}/rentRequestApprove"
                                          method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="list">
                                        <button class="btn btn-sm btn-success">
                                            Approve
                                        </button>
                                    </form>

                                    <!-- CANCEL -->
                                    <form action="${pageContext.request.contextPath}/rentRequestCancel"
                                          method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="list">
                                        <button class="btn btn-sm btn-danger">
                                            Reject
                                        </button>
                                    </form>
                                </c:if>
                            </c:if>

                            <!-- ========== RENTER ========== -->
                            <c:if test="${sessionScope.userType == 'RENTER'}">
                                <c:if test="${rr.status == 0}">
                                    <!-- UPDATE -->
                                    <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}&action=edit"
                                       class="btn btn-update">Update</a>

                                    <!-- CANCEL -->
                                    <form action="${pageContext.request.contextPath}/rentRequestCancel"
                                          method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="list">
                                        <button class="btn btn-sm btn-danger">
                                            Cancel
                                        </button>
                                    </form>
                                </c:if>
                            </c:if>
                        </td>

                    </tr>
                </c:forEach>

            </tbody>
        </table>
        <script>
            $(document).ready(function () {
                let table = $('#rentRequestTable').DataTable({
                    order: [[0, 'desc']], // sort theo ID
                    pageLength: 10,
                });



                // Khi đổi dropdown
                $('#statusFilter').on('change', function () {
                    let val = $(this).val();

                    if (val === "") {
                        table.column(2).search("").draw(); // All
                    } else {
                        table.column(2).search("^" + val + "$", true, false).draw();
                    }
                });
            });
        </script>
        <jsp:include page="/Common/Layout/footer.jsp" />
    </body>
</html>
