<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${empty u ? 'Add New' : 'Edit'} Storage Unit | WRS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f5f7fb; font-family: Arial, sans-serif; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .max-w-750 { max-width: 750px; }
    </style>
</head>
<body>
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="d-flex min-vh-100">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="flex-grow-1 p-4">
            <div class="container max-w-750">
                
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/warehouse/detail?id=${warehouseId}" class="text-decoration-none text-muted fw-bold">
                        <i class="fas fa-arrow-left me-1"></i> Back to Warehouse
                    </a>
                </div>

                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                        <i class="fas fa-exclamation-triangle me-2 fs-5 align-middle"></i> 
                        <span class="align-middle fw-bold">${sessionScope.errorMsg}</span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMsg" scope="session" />
                </c:if>
                <div class="card card-custom p-4">
                    <div class="d-flex align-items-center gap-2 mb-4 pb-3 border-bottom">
                        <i class="fas ${empty u ? 'fa-plus-circle' : 'fa-edit'} fs-4 text-primary"></i>
                        <h4 class="fw-bold mb-0">${empty u ? 'Add New' : 'Edit'} Storage Unit</h4>
                    </div>

                    <form action="${pageContext.request.contextPath}/warehouse/detail" method="POST">
                        <input type="hidden" name="action" value="${empty u ? 'insert' : 'update'}"> 
                        <input type="hidden" name="unitId" value="${u.unitId}">
                        <input type="hidden" name="warehouseId" value="${warehouseId}">
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Storage Unit Code <span class="text-danger">*</span></label>
                            <input type="text" name="unitCode" class="form-control" value="${u.unitCode}" required maxlength="50" placeholder="e.g., SU-A1">
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-dark">Area (sq ft) <span class="text-danger">*</span></label>
                                <input type="number" step="0.1" min="10" name="area" class="form-control" value="${u.area}" required placeholder="0.0">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-dark">Rent Price (VND) <span class="text-danger">*</span></label>
                                <fmt:formatNumber value="${u.pricePerUnit}" pattern="0" var="formattedPrice" />
                                <input type="number" min="1000000" name="price" class="form-control" value="${formattedPrice}" required placeholder="Enter amount">
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Status</label>
                            <select name="status" class="form-select">
                                <option value="1" ${u.status == 1 ? 'selected' : ''}>Available</option>
                                <option value="2" ${u.status == 2 ? 'selected' : ''}>Under Maintenance</option>
                            </select>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Description</label>
                            <textarea name="description" class="form-control" rows="4" maxlength="255" placeholder="Enter unit details...">${u.description}</textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/warehouse/detail?id=${warehouseId}" class="btn btn-light border px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">
                                <i class="fas fa-check me-1"></i> ${empty u ? 'Create Unit' : 'Save Changes'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>