<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý hợp đồng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <style>
        .table-responsive { border-radius: 10px; overflow: hidden; }
        .status-badge { width: 100px; display: inline-block; }
        .action-buttons {
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>

    <c:if test="${sessionScope.userType != 'INTERNAL'}">
        <style>
            .renter-col {
                display: none;
            }
        </style>
    </c:if>
</head>

<body>

<jsp:include page="/Common/Layout/header.jsp"/>
<jsp:include page="/message/popupMessage.jsp" />
<div class="layout">

    <c:if test="${sessionScope.userType == 'INTERNAL'}">
        <jsp:include page="/Common/Layout/sidebar.jsp"/>
    </c:if>

    <div class="main-content">
        <h3 class="mb-4">Contracts Management</h3>
<c:if test="${sessionScope.userType != 'RENTER'}">
        <jsp:include page="/Common/Layout/stats_cards.jsp">
            <jsp:param name="label1" value="Tổng Hợp Đồng" />
            <jsp:param name="value1" value="${contractStats.total}" />
            <jsp:param name="icon1" value="fa-solid fa-file-contract" />
            <jsp:param name="color1" value="primary" />
            <jsp:param name="label2" value="Đang Hoạt Động" />
            <jsp:param name="value2" value="${contractStats.active}" />
            <jsp:param name="icon2" value="fa-solid fa-file-signature" />
            <jsp:param name="color2" value="success" />
            <jsp:param name="label3" value="Kết Thúc Sớm" />
            <jsp:param name="value3" value="${contractStats.early_ended}" />
            <jsp:param name="icon3" value="fa-solid fa-file-circle-xmark" />
            <jsp:param name="color3" value="danger" />
            <jsp:param name="label4" value="Đã Hết Hạn" />
            <jsp:param name="value4" value="${contractStats.expired}" />
            <jsp:param name="icon4" value="fa-solid fa-clock-rotate-left" />
            <jsp:param name="color4" value="warning" />
        </jsp:include>
</c:if>       
        <div class="management-card">

            <table class="table table-hover align-middle mb-0" id="contractTable">
                <thead>
                    <tr>
                        <th class="text-center py-3">No.</th>
                        <th class="renter-col">Renter</th>
                        <th class="text-center">Start Date</th>
                        <th class="text-center">End Date</th>
                        <th class="text-end">Price</th>
                        <th class="text-center">Status</th>
                        <th class="text-start">Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach items="${contractList}" var="c" varStatus="loop">
                        <tr>
                            <td class="fw-bold text-center text-secondary">
                                ${loop.index + 1}
                            </td>

                            <td class="renter-col">
                                <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                    <div class="d-flex align-items-center">
                                        
                                        <span>${c.renterName}</span>
                                    </div>
                                </c:if>
                            </td>

                            <td class="text-center">
                                <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/>
                            </td>

                            <td class="text-center">
                                <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/>
                            </td>

                            <td class="text-end fw-bold text-dark">
                                <fmt:formatNumber value="${c.price}" type="number" groupingUsed="true"/>
                                <small class="text-muted">VNĐ</small>
                            </td>

                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${c.status == 0}">
                                        <span class="badge bg-secondary">finish</span>
                                    </c:when>

                                    <c:when test="${c.endDate.time lt now.time}">
                                        <span class="badge bg-dark">time-expired</span>
                                    </c:when>

                                    <c:when test="${c.paymentStatus == 1}">
                                        <span class="badge bg-warning">done</span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-success">process</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <div class="action-buttons">
                                    <a href="<c:url value='/contract-detail'><c:param name='contractId' value='${c.contractId}'/></c:url>"
                                       class="btn btn-sm btn-primary">
                                        View
                                    </a>

                                    <c:if test="${sessionScope.userType eq 'RENTER' 
                                                 and c.paymentStatus == 1 
                                                 and c.status == 1}">
                                        <form action="${pageContext.request.contextPath}/contract"
                                              method="post"
                                              class="d-inline">

                                            <input type="hidden" name="contractId" value="${c.contractId}"/>

                                            <button type="submit"
                                                    name="action"
                                                    value="endEarly"
                                                    class="btn btn-sm btn-danger">
                                                End Early
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty contractList}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png"
                                     style="width: 80px; opacity: 0.5;" class="mb-3"><br>
                                Không tìm thấy hợp đồng nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>

        </div>
    </div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        var hasData = ${not empty contractList};

        if (hasData) {
            $('#contractTable').DataTable({
                pageLength: 10,
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