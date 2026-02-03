<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý hợp đồng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/Common/Layout/header.jsp"/>

    <div class="d-flex flex-grow-1">
        
        <jsp:include page="/Common/Layout/sidebar.jsp"/>

        <div class="container-fluid p-4">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-primary">Danh sách hợp đồng</h2>
                <a href="contract?action=add" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> Thêm hợp đồng mới
                </a>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listC}" var="c">
                                <tr>
                                    <td class="fw-bold">#${c.contractId}</td>
                                    <td>${c.startDate}</td>
                                    <td>${c.endDate}</td>
                                    <td>
                                        <span class="badge rounded-pill ${c.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                            ${c.status == 1 ? 'Hoạt động' : 'Kết thúc'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="contract?action=edit&id=${c.contractId}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty listC}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        Chưa có hợp đồng nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </div> </div>

    <jsp:include page="/Common/Layout/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>