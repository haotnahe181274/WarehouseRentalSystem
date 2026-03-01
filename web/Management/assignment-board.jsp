<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Phân Công Nhiệm Vụ Tự Động</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    
    <c:if test="${not empty MSG_SUCCESS}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${MSG_SUCCESS}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty MSG_ERROR}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${MSG_ERROR}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Tạo Nhiệm Vụ Mới (Auto-Routing)</h5>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/management/auto-assign" method="POST">
                
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Chọn Kho (Warehouse)</label>
                        <select class="form-select" name="warehouseId" id="warehouseId" onchange="loadStorageUnits()" required>
                            <option value="" disabled selected>-- Chọn kho bãi --</option>
                            <c:forEach items="${listWarehouse}" var="w">
                                <option value="${w.warehouseId}">
                                    ${w.name} - (${w.address})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Khu Vực (Storage Unit)</label>
                        <select class="form-select" name="unitId" id="unitId">
                            <option value="">-- Áp dụng toàn bộ Kho --</option>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Loại Nhiệm Vụ</label>
                        <select class="form-select" name="assignmentType" required>
                            <option value="1">Kiểm kê định kỳ</option>
                            <option value="2">Dọn dẹp và bảo trì</option>
                            <option value="3">Hỗ trợ Check-in / Check-out</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Chi tiết công việc</label>
                    <textarea class="form-control" name="description" rows="3" required></textarea>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-bold">Hạn chót (Số ngày)</label>
                    <input type="number" class="form-control" name="dueDays" value="1" min="1" required>
                </div>

                <button type="submit" class="btn btn-success w-100 py-2 fw-bold">
                    Tự Động Quét & Phân Công Nhiệm Vụ
                </button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function loadStorageUnits() {
        var warehouseId = document.getElementById("warehouseId").value;
        var unitSelect = document.getElementById("unitId");
        
        if (warehouseId) {
            fetch('${pageContext.request.contextPath}/management/load-units?warehouseId=' + warehouseId)
                .then(response => response.text())
                .then(data => {
                    unitSelect.innerHTML = '<option value="">-- Áp dụng toàn bộ Kho --</option>' + data;
                })
                .catch(error => console.error('Lỗi khi tải Unit:', error));
        } else {
            unitSelect.innerHTML = '<option value="">-- Áp dụng toàn bộ Kho --</option>';
        }
    }
</script>
</body>
</html>