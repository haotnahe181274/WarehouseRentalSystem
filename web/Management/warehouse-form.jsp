<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<jsp:include page="/Common/Layout/header.jsp"/>
<div class="d-flex">
    <jsp:include page="/Common/Layout/sidebar.jsp"/>
    <div class="container mt-4" style="max-width: 800px;">

        <h3>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</h3>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/warehouse" method="post" enctype="multipart/form-data">

            <c:if test="${not empty warehouse}">
                <input type="hidden" name="id"     value="${warehouse.warehouseId}">
                <input type="hidden" name="action" value="edit">
            </c:if>

            <div class="mb-3">
                <label class="form-label">Warehouse Name <span class="text-danger">*</span></label>
                <input type="text" name="name" class="form-control"
                       value="${warehouse.name}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Address <span class="text-danger">*</span></label>
                <input type="text" name="address" class="form-control"
                       value="${warehouse.address}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3">${warehouse.description}</textarea>
            </div>

            <%-- ── Total Area (THÊM MỚI) ── --%>
            <div class="mb-3">
                <label class="form-label">
                    Total Area (m²) <span class="text-danger">*</span>
                    <small class="text-muted fw-normal">— Tổng diện tích của kho, dùng để giới hạn các ô chứa</small>
                </label>
                <input type="number" name="totalArea" class="form-control"
                       min="1" step="0.1"
                       value="${warehouse.totalArea > 0 ? warehouse.totalArea : ''}">
                <div class="form-text text-muted">
                    <i class="fa-solid fa-circle-info me-1"></i>
                    Tổng diện tích các ô chứa không được vượt quá giá trị này.
                </div>
            </div>
                <%-- ── Price per Area (THÊM MỚI) ── --%>
            <div class="mb-3">
                <label class="form-label">
                    Price per m² (VNĐ) <span class="text-danger">*</span>
                    <small class="text-muted fw-normal">— Giá thuê áp dụng cho mỗi mét vuông</small>
                </label>
                <input type="number" name="pricePerArea" class="form-control"
                       min="10000" step="1"
                       value="${warehouse.pricePerArea > 0 ? warehouse.pricePerArea : ''}">
                <div class="form-text text-muted">
                    <i class="fa-solid fa-circle-info me-1"></i>
                    Mức giá tối thiểu phải từ 10,000 VNĐ.
                </div>
      
            </div>
                                 
            <%-- ── Status ── --%>
            <div class="mb-3">
                <label class="form-label">Status</label>
                <c:choose>
                    <c:when test="${empty warehouse}">
                        <%-- Chế độ ADD: Hiện text giả nhưng gửi value=1 về server --%>
                        <input type="text" class="form-control bg-light" value="Active (Default)" readonly>
                        <input type="hidden" name="status" value="1">
                    </c:when>
                    <c:otherwise>
                        <%-- Chế độ EDIT: Cho phép chọn --%>
                        <select name="status" class="form-select">
                            <option value="1" ${warehouse.status == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${warehouse.status == 0 ? 'selected' : ''}>Inactive</option>
                        </select>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mb-3">
                <label class="form-label">Warehouse Type</label>
                <select name="warehouseTypeId" class="form-select" required>
                    <option value="1" ${warehouse != null && warehouse.warehouseType.warehouseTypeId == 1 ? 'selected' : ''}>Cold Storage</option>
                    <option value="2" ${warehouse != null && warehouse.warehouseType.warehouseTypeId == 2 ? 'selected' : ''}>Normal Storage</option>
                    <option value="3" ${warehouse != null && warehouse.warehouseType.warehouseTypeId == 3 ? 'selected' : ''}>High Security</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Warehouse Images</label>
                <input type="file" name="images" class="form-control" accept="image/*" multiple>
                <div class="form-text">
                    Accepted: .jpg, .png, .jpeg (Max 5MB/image).<br>
                    <span class="text-danger">First image will be the primary thumbnail.</span>
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Save
                </button>
                <a href="${pageContext.request.contextPath}/warehouse" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/Common/Layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
