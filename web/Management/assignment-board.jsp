<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Auto-Assignment | WRS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .main-wrapper { display: flex; min-height: 100vh; }
        .content-area { flex: 1; padding: 2rem; background: #f1f5f9; }
        .form-card { border-radius: 15px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        .step-icon { width: 40px; height: 40px; background: #e2e8f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 10px; }
    </style>
</head>
<body>

    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <main class="content-area">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-9">
                        
                        <div class="mb-4">
                            <h2 class="fw-bold">Hệ thống Phân công Tự động</h2>
                            <p class="text-muted">Quét nhân viên đang rảnh và chỉ định công việc dựa trên vị trí kho bãi.</p>
                        </div>

                        <c:if test="${not empty MSG_SUCCESS}">
                            <div class="alert alert-success alert-dismissible fade border-0 shadow-sm rounded-4 shadow-sm show" role="alert">
                                <i class="fas fa-check-circle me-2"></i> ${MSG_SUCCESS}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="card form-card overflow-hidden">
                            <div class="card-header bg-white border-0 py-3">
                                <div class="d-flex align-items-center">
                                    <div class="step-icon bg-primary text-white mb-0 me-3"><i class="fas fa-robot"></i></div>
                                    <h5 class="mb-0 fw-bold">Thiết lập Nhiệm vụ mới</h5>
                                </div>
                            </div>
                            <div class="card-body p-4 pt-0">
                                <form action="${pageContext.request.contextPath}/Management/autoAssign" method="POST">
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Kho bãi mục tiêu</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light"><i class="fas fa-warehouse"></i></span>
                                                <select class="form-select border-start-0" name="warehouseId" id="warehouseId" onchange="loadStorageUnits()" required>
                                                    <option value="" disabled selected>Chọn kho...</option>
                                                    <c:forEach items="${listWarehouse}" var="w">
                                                        <option value="${w.warehouseId}">${w.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Phạm vi công việc</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light"><i class="fas fa-th-large"></i></span>
                                                <select class="form-select border-start-0" name="unitId" id="unitId">
                                                    <option value="">Toàn bộ khu vực</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Loại hình nhiệm vụ</label>
                                            <select class="form-select" name="assignmentType" required>
                                                <option value="1">🔍 Kiểm kê định kỳ</option>
                                                <option value="2">🧹 Dọn dẹp & Bảo trì</option>
                                                <option value="3">📋 Hỗ trợ Check-in/out</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Hạn hoàn thành (Số ngày)</label>
                                            <input type="number" class="form-control" name="dueDays" value="1" min="1" required>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label fw-semibold">Mô tả chi tiết chỉ dẫn cho nhân viên</label>
                                            <textarea class="form-control" name="description" rows="4" placeholder="Nhập ghi chú công việc cụ thể tại đây..." required></textarea>
                                        </div>

                                        <div class="col-12 mt-4 text-center">
                                            <button type="submit" class="btn btn-primary px-5 py-2 fw-bold rounded-pill">
                                                <i class="fas fa-magic me-2"></i> Kích hoạt Quét & Phân công
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function loadStorageUnits() {
            var warehouseId = document.getElementById("warehouseId").value;
            var unitSelect = document.getElementById("unitId");
            if (warehouseId) {
                fetch('${pageContext.request.contextPath}/management/load-units?warehouseId=' + warehouseId)
                    .then(response => response.text())
                    .then(data => { unitSelect.innerHTML = '<option value="">Toàn bộ khu vực</option>' + data; });
            }
        }
    </script>
</body>
</html>