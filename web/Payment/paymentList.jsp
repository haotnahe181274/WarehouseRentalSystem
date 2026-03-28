<%--
    Hiển thị danh sách tất cả payment của user hiện tại (RENTER).
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Payments</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
        <style>
            .payment-status-paid { background: #d1fae5; color: #065f46; }
            .payment-status-failed { background: #fee2e2; color: #991b1b; }
        </style>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>
        <jsp:include page="/message/popupMessage.jsp"/>

        <div class="layout">
            <div class="main-content">
                <h3>My Payments</h3>

                <c:if test="${empty payments}">
                    <div class="management-card">
                        <p class="page-subtitle" style="margin-bottom: 0;">You have no payments yet.</p>
                    </div>
                </c:if>

                <c:if test="${not empty payments}">
                    <div class="management-card">
                        <table class="table mb-0" id="paymentTable">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Contract ID</th>
                                    <th>Amount (VND)</th>
                                    <th>Payment Date</th>
                                    <th>Method</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${payments}" var="p" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td>
                                            <c:if test="${p.contract != null}">
                                                ${p.contract.contractId}
                                            </c:if>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${p.amount}" type="number" minFractionDigits="0" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${p.paymentDate}" pattern="dd-MM-yyyy HH:mm" />
                                        </td>
                                        <td>${p.method}</td>
                                        <td>
                                            <span class="status-badge
                                                  <c:choose>
                                                      <c:when test='${p.status == 1}'> payment-status-paid</c:when>
                                                      <c:otherwise> payment-status-failed</c:otherwise>
                                                  </c:choose>
                                                  ">
                                                <c:choose>
                                                    <c:when test="${p.status == 1}">Paid</c:when>
                                                    <c:otherwise>Failed</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <jsp:include page="/Common/Layout/footer.jsp"/>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script>
            $(document).ready(function () {
                if ($('#paymentTable').length) {
                    $('#paymentTable').DataTable({
                        pageLength: 5,
                        dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
                        language: {
                            search: "Search:",
                            lengthMenu: "_MENU_ entries per page"
                        }
                    });
                }
            });
        </script>
    </body>
</html>
