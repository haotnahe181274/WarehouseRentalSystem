<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Kho</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h2>Thêm Kho Mới</h2>
    <form action="warehouse" method="post" class="mb-5">
        <div class="row">
            <div class="col"><input type="text" name="name" class="form-control" placeholder="Tên kho" required></div>
            <div class="col"><input type="text" name="address" class="form-control" placeholder="Địa chỉ" required></div>
            <div class="col">
                <select name="status" class="form-control">
                    <option value="1">Hoạt động</option>
                    <option value="0">Ngừng hoạt động</option>
                </select>
            </div>
            <div class="col"><button type="submit" class="btn btn-primary">Thêm</button></div>
        </div>
    </form>

    <hr>

    <h2>Danh sách Kho</h2>
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Địa chỉ</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
         <c:forEach items="${data}" var="w">
    <tr>
        <td>${w.warehouseId}</td>
        <td>${w.name}</td>
        <td>${w.address}</td>
        <td>${w.warehouseType.typeName}</td> 
        <td>
            <c:choose>
                <c:when test="${w.status == 1}">
                    <span class="badge bg-success">Hoạt động</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary">Tạm dừng</span>
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <a href="warehouse?action=edit&id=${w.warehouseId}" 
               class="btn btn-warning btn-sm">Sửa</a>

            <a href="warehouse?action=delete&id=${w.warehouseId}" 
               onclick="return confirm('Bạn có chắc muốn xóa kho ${w.name}?')" 
               class="btn btn-danger btn-sm">Xóa</a>
        </td>
    </tr>
</c:forEach>
        </tbody>
    </table>
</body>
</html>