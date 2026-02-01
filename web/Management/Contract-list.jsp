<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý hợp đồng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
    <div class="d-flex justify-content-between mb-3">
        <h2>Danh sách hợp đồng</h2>
        <a href="contract?action=add" class="btn btn-primary">Thêm hợp đồng mới</a>
    </div>
    <table class="table table-bordered table-hover">
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
                    <td>${c.contractId}</td>
                    <td>${c.startDate}</td>
                    <td>${c.endDate}</td>
                    <td>
                        <span class="badge ${c.status == 1 ? 'bg-success' : 'bg-secondary'}">
                            ${c.status == 1 ? 'Hoạt động' : 'Kết thúc'}
                        </span>
                    </td>
                    <td>
                        <a href="contract?action=edit&id=${c.contractId}" class="btn btn-warning btn-sm">Sửa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>