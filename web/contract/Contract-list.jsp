<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý hợp đồng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .table-responsive { border-radius: 10px; overflow: hidden; }
        .status-badge { width: 100px; display: inline-block; }
        .action-buttons{
            display:flex;
            align-items:center;
            gap:8px;
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/Common/Layout/header.jsp"/>

    <div class="d-flex flex-grow-1">

        <c:if test="${sessionScope.userType ne 'RENTER'}">
            <jsp:include page="/Common/Layout/sidebar.jsp"/>
        </c:if>

        <div class="container-fluid p-4">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-primary mb-0">
                        <i class="bi bi-file-earmark-text-fill me-2"></i>Danh sách hợp đồng
                    </h2>
                    <small class="text-muted">Quản lý và theo dõi các hợp đồng thuê kho</small>
                </div>
            </div>

            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm">
                    <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            <jsp:useBean id="now" class="java.util.Date"/>
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-white">
                                <tr>
                                    <th class="text-center py-3">Mã HĐ</th>
                                    <%-- Hiển thị cột Người Thuê nếu là Manager --%>
                                    <c:if test="${role == 'manager'}">
                                        <th>Renter</th>
                                    </c:if>
                                    <th class="text-center">Start Date</th>
                                    <th class="text-center">End Date</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-start">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${contractList}" var="c">
                                    <tr>
                                        <td class="fw-bold text-center text-secondary">#${c.contractId}</td>
                                        
                                        <c:if test="${role == 'manager'}">
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                                        ${c.renterName.substring(0,1)}
                                                    </div>
                                                    <span>${c.renterName}</span>
                                                </div>
                                            </td>
                                        </c:if>

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
                                                    <span class="badge bg-secondary px-3 py-2 rounded-pill status-badge">
                                                        finish-early
                                                    </span>
                                                </c:when>
                                                
                                                <c:when test="${c.endDate.time lt now.time}">
                                                    <span class="badge bg-dark px-3 py-2 rounded-pill status-badge">
                                                        time-expired
                                                    </span>
                                                </c:when>

                                                <c:when test="${c.paymentStatus == 1}">
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-3 py-2 rounded-pill status-badge">
                                                        done
                                                    </span>
                                                </c:when>


                                                <c:otherwise>
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill status-badge">
                                                        process
                                                    </span>
                                                </c:otherwise>

                                            </c:choose>
                                        </td>

                                       <td>
                                            <div class="action-buttons">

                                                <!-- View -->
                                                <a href="<c:url value='/contract-detail'>
                                                            <c:param name='contractId' value='${c.contractId}'/>
                                                         </c:url>"
                                                   class="btn btn-sm btn-primary">
                                                    View
                                                </a>

                                                <!-- End Early -->
                                                <c:if test="${sessionScope.userType eq 'RENTER' 
                                                             and c.paymentStatus == 1 
                                                             and c.status == 1}">
                                                    <form action="${pageContext.request.contextPath}/contract"
                                                          method="post"
                                                          class="d-inline">

                                                        <input type="hidden" name="contractId"
                                                               value="${c.contractId}"/>

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

                                <%-- Trường hợp danh sách trống --%>
                                <c:if test="${empty contractList}">
                                    <tr>
                                        <td colspan="${role == 'manager' ? 7 : 6}" class="text-center py-5 text-muted">
                                            <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" alt="empty" style="width: 80px; opacity: 0.5;" class="mb-3"><br>
                                            Không tìm thấy hợp đồng nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

<c:if test="${not empty sessionScope.MESSAGE}">
    <div class="alert alert-success">
        ${sessionScope.MESSAGE}
    </div>
    <c:remove var="MESSAGE" scope="session"/>
</c:if>
    <jsp:include page="/Common/Layout/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>