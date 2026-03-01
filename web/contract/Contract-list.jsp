<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý hợp đồng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/Common/Layout/header.jsp"/>

    <div class="d-flex flex-grow-1">

    <!-- Sidebar chỉ dành cho manager -->
    <c:if test="${role != 'renter'}">
        <jsp:include page="/Common/Layout/sidebar.jsp"/>
    </c:if>

    <div class="container-fluid p-4">

            <!-- TITLE -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-primary">Danh sách hợp đồng</h2>
            </div>

            <!-- SUCCESS -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show">
                    ${sessionScope.message}
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <!-- ERROR -->
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    ${sessionScope.error}
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- TABLE -->
            <div class="card shadow-lg border-0 rounded-3">
                <div class="card-body">

                    <table class="table table-hover table-striped align-middle">

                        <thead class="table-dark text-center">
                            <tr>
                                <th>ID</th>

                                <c:if test="${role == 'manager'}">
                                    <th>Người thuê</th>
                                </c:if>

                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>

                        <tbody>

                            <!-- LIST -->
                            <c:forEach items="${contractList}" var="c">
                                <tr>

                                    <td class="fw-bold text-primary text-center">
                                        #${c.contractId}
                                    </td>

                                    <!-- Manager only -->
                                    <c:if test="${role == 'manager'}">
                                        <td>${c.renterName}</td>
                                    </c:if>

                                    <td class="text-center">
                                        <fmt:formatDate value="${c.startDate}"
                                                        pattern="dd/MM/yyyy"/>
                                    </td>

                                    <td class="text-center">
                                        <fmt:formatDate value="${c.endDate}"
                                                        pattern="dd/MM/yyyy"/>
                                    </td>

                                    <td class="text-end fw-bold text-danger">
                                        <fmt:formatNumber value="${c.price}"
                                                          type="number"
                                                          groupingUsed="true"/>
                                        VNĐ
                                    </td>

                                    <!-- STATUS -->
                                    <td class="text-center">
                                        <c:choose>

                                            <c:when test="${c.status == 0}">
                                                <span class="badge bg-warning text-dark">
                                                    Chờ xử lý
                                                </span>
                                            </c:when>

                                            <c:when test="${c.status == 1}">
                                                <span class="badge bg-success">
                                                    Hoạt động
                                                </span>
                                            </c:when>

                                            <c:when test="${c.status == 2}">
                                                <span class="badge bg-danger">
                                                    Đã hủy
                                                </span>
                                            </c:when>
                                            <c:when test="${c.status == 4}">
                                                <span class="badge bg-danger">
                                                    Đã hủy
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    Kết thúc
                                                </span>
                                            </c:otherwise>

                                        </c:choose>
                                    </td>

                                    <!-- ACTION -->
                                    <td class="text-center">
                                        <a href="contract-detail?id=${c.contractId}"
                                           class="btn btn-outline-info btn-sm">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>

                                </tr>
                            </c:forEach>

                            <!-- EMPTY -->
                            <c:if test="${empty contractList}">
                                <tr>
                                    <td colspan="7"
                                        class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox fs-3"></i><br>
                                        Chưa có hợp đồng nào.
                                    </td>
                                </tr>
                            </c:if>

                        </tbody>

                    </table>

                </div>
            </div>

        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>