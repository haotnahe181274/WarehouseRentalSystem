<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/Common/Layout/header.jsp"/>
<div class="d-flex">
    <jsp:include page="/Common/Layout/sidebar.jsp"/>

    <div class="container mt-4" style="max-width: 800px;">
        
        <h3>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</h3>

        <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>Lỗi!</strong> ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
        
        <form action="${pageContext.request.contextPath}/warehouse" method="post" enctype="multipart/form-data">
            
            <c:if test="${not empty warehouse}">
                <input type="hidden" name="id" value="${warehouse.warehouseId}">
                <input type="hidden" name="action" value="edit">
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Warehouse Name</label>
                <input type="text" name="name" class="form-control" 
                       value="${warehouse.name}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Address</label>
                <input type="text" name="address" class="form-control" 
                       value="${warehouse.address}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3">${warehouse.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <select name="status" class="form-select">
                    <option value="1" ${warehouse.status == 1 ? 'selected' : ''}>Active</option>
                    <option value="0" ${warehouse.status == 0 ? 'selected' : ''}>Inactive</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Warehouse Image</label>
                <input type="file" name="image" class="form-control" accept="image/*">
                <div class="form-text">Accepted formats: .jpg, .png, .jpeg</div>
            </div>

            <button type="submit" class="btn btn-primary">Save</button>
            <a href="${pageContext.request.contextPath}/warehouse" class="btn btn-secondary">Cancel</a>

        </form>
    </div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

</body>
</html>