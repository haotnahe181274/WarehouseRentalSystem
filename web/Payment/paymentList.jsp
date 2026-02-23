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
        <link rel="stylesheet"
              href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>

        <div class="page-container">
            <h2 class="page-title">My Payments</h2>

            <c:if test="${empty payments}">
                <div class="empty-box">
                    You have no payments yet.
                </div>
            </c:if>

            <c:if test="${not empty payments}">
                <div class="card">
                    <table class="table" id="paymentTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Payment ID</th>
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
                                    <td>${p.paymentId}</td>
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
                                                  <c:when test='${p.status == 1}'> status-paid</c:when>
                                                  <c:when test='${p.status == 0}'> status-pending</c:when>
                                                  <c:otherwise> status-cancelled</c:otherwise>
                                              </c:choose>
                                              ">
                                            <c:choose>
                                                <c:when test="${p.status == 1}">Paid</c:when>
                                                <c:when test="${p.status == 0}">Unpaid</c:when>
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

        <jsp:include page="/Common/Layout/footer.jsp"/>

        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f9;
                margin: 0;
            }

            .page-container {
                max-width: 1000px;
                margin: 40px auto;
                padding: 0 16px 40px;
            }

            .page-title {
                margin: 0 0 24px;
                font-size: 22px;
                font-weight: 600;
                color: #1e293b;
            }

            .card {
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.06);
                padding: 20px;
                overflow-x: auto;
            }

            .empty-box {
                background: #ffffff;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                color: #64748b;
                border: 1px dashed #cbd5e1;
            }

            .table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }

            .table thead {
                background-color: #1e293b;
                color: #ffffff;
            }

            .table th,
            .table td {
                padding: 10px 12px;
                text-align: left;
                border-bottom: 1px solid #e2e8f0;
                white-space: nowrap;
            }

            .table tbody tr:hover {
                background-color: #f1f5f9;
            }

            .status-badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-paid {
                background-color: #22c55e;
                color: #ffffff;
            }

            .status-pending {
                background-color: #facc15;
                color: #1f2933;
            }

            .status-cancelled {
                background-color: #ef4444;
                color: #ffffff;
            }
        </style>
        
        <script>
            $(document).ready(function () {
                $('#paymentTable').DataTable({
                    pageLength: 5
                    
                });
            });
        </script>
    </body>
</html>

