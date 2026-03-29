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
        .max-w-750  { max-width: 750px; }

        /* Area progress bar */
        .area-stat {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 24px;
        }
        .area-stat-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        .area-stat-row span:last-child {
            font-weight: 600;
            color: #111827;
        }
        .area-bar-wrap {
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 6px;
        }
        .area-bar-used {
            height: 100%;
            background: #3b82f6;
            border-radius: 4px;
            transition: width 0.3s;
        }
        .area-bar-new {
            height: 100%;
            background: #f59e0b;
            border-radius: 4px;
            margin-top: -8px;
            transition: width 0.3s;
        }
        .area-legend {
            display: flex;
            gap: 16px;
            font-size: 12px;
            color: #6b7280;
        }
        .area-legend span::before {
            content: '';
            display: inline-block;
            width: 10px; height: 10px;
            border-radius: 2px;
            margin-right: 4px;
            vertical-align: middle;
        }
        .area-legend .used-dot::before  { background: #3b82f6; }
        .area-legend .new-dot::before   { background: #f59e0b; }
        .area-legend .free-dot::before  { background: #e5e7eb; }

        /* Unit code badge */
        .unit-code-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1d4ed8;
            border-radius: 8px;
            padding: 10px 16px;
            font-size: 18px;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .unit-code-label {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 6px;
        }
    </style>
</head>
<body>
    <jsp:include page="/Common/Layout/header.jsp" />
    <jsp:include page="/message/popupMessage.jsp" />
    <div class="d-flex min-vh-100">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="flex-grow-1 p-4">
            <div class="container max-w-750">

                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/warehouse/detail?id=${warehouseId}"
                       class="text-decoration-none text-muted fw-bold">
                        <i class="fas fa-arrow-left me-1"></i> Back to Warehouse
                    </a>
                </div>

                <%-- Error message --%>
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

                    <%-- ── Area stats bar ── --%>
                    <c:if test="${warehouseArea > 0}">
                        <div class="area-stat">
                            <div class="area-stat-row">
                                <span>Warehouse total area</span>
                                <span><fmt:formatNumber value="${warehouseArea}" pattern="#,##0.#"/> m³</span>
                            </div>
                            <div class="area-stat-row">
                                <span>Already allocated</span>
                                <span style="color: #3b82f6;"><fmt:formatNumber value="${usedArea}" pattern="#,##0.#"/> m³</span>
                            </div>
                            <div class="area-stat-row">
                                <span>Remaining available</span>
                                <span style="color: ${remainingArea <= 0 ? '#dc2626' : '#16a34a'};">
                                    <fmt:formatNumber value="${remainingArea}" pattern="#,##0.#"/> m³
                                </span>
                            </div>

                            <%-- Progress bar --%>
                            <div class="area-bar-wrap">
                                <div class="area-bar-used"
                                     id="usedBar"
                                     style="width: ${warehouseArea > 0 ? (usedArea / warehouseArea * 100) : 0}%">
                                </div>
                            </div>
                            <div class="area-bar-wrap" style="margin-top: 3px;">
                                <div class="area-bar-new" id="newBar" style="width: 0%"></div>
                            </div>

                            <div class="area-legend mt-2">
                                <span class="used-dot">Used (<fmt:formatNumber value="${usedArea / warehouseArea * 100}" pattern="0.#"/>%)</span>
                                <span class="new-dot">This unit (0%)</span>
                                <span class="free-dot">Free (<fmt:formatNumber value="${remainingArea / warehouseArea * 100}" pattern="0.#"/>%)</span>
                            </div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/warehouse/detail" method="POST">
                        <input type="hidden" name="action"      value="${empty u ? 'insert' : 'update'}">
                        <input type="hidden" name="unitId"      value="${u.unitId}">
                        <input type="hidden" name="warehouseId" value="${warehouseId}">

                        <%-- ── Unit Code (auto-generated, read-only) ── --%>
                        <div class="mb-4">
                            <div class="unit-code-label">
                                <i class="fas fa-tag me-1"></i>
                                Unit Code <span class="text-success">(auto-generated)</span>
                            </div>
                            <div class="unit-code-badge">
                                <i class="fas fa-warehouse" style="font-size: 16px;"></i>
                                <c:choose>
                                    <c:when test="${empty u}">${generatedCode}</c:when>
                                    <c:otherwise>${u.unitCode}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                     <%-- ── Area ── --%>
                        <div class="row mb-4">
                            <div class="col-md-12">
                                <label class="form-label fw-bold text-dark">
                                    Area (m³) <span class="text-danger">*</span>
                                    <c:if test="${warehouseArea > 0}">
                                        <small class="text-muted fw-normal">
                                            (max <fmt:formatNumber value="${remainingArea}" pattern="#,##0.#"/>)
                                        </small>
                                    </c:if>
                                </label>
                                <input type="number" step="0.1" min="10"
                                       max="${remainingArea > 0 ? remainingArea : ''}"
                                       name="area" id="areaInput"
                                       class="form-control"
                                       value="${u.area}"
                                       required placeholder="0.0"
                                       oninput="updateAreaBar(this.value)">
                                <div class="form-text mt-2" id="areaHint"></div>
                              <div class="mt-3 p-3 bg-white border rounded shadow-sm">
    <div class="d-flex justify-content-between align-items-center">
        <span class="text-muted fw-bold">
            <i class="fas fa-wallet me-1 text-primary"></i> Estimated Rent Price
        </span>
        <span id="estimatedPrice" class="fs-4 fw-bold text-success">0 ₫</span>
    </div>
    <div class="text-end text-muted" style="font-size: 12px;">
        (Base price: <fmt:formatNumber value="${warehousePrice}" pattern="#,##0"/> ₫/m³)
    </div>
</div>
                            </div>
                        </div>

                        <%-- ── Status ── --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Status</label>
                            <c:choose>
                                <c:when test="${empty u}">
                                    <%-- Chế độ ADD: Hiện ô không tương tác được --%>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white text-success">
                                            <i class="fas fa-check-circle"></i>
                                        </span>
                                        <input type="text" class="form-control bg-light" value="Available (Default)" readonly>
                                    </div>
                                    <input type="hidden" name="status" value="1">
                                </c:when>
                                <c:otherwise>
                                    <%-- Chế độ EDIT: Cho phép sửa --%>
                                    <select name="status" class="form-select">
                                        <option value="1" ${u.status == 1 ? 'selected' : ''}>Available</option>
                                        <option value="2" ${u.status == 2 ? 'selected' : ''}>Under Maintenance</option>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <%-- ── Description ── --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Description</label>
                            <textarea name="description" class="form-control" rows="4"
                                      maxlength="255" placeholder="Enter unit details...">${u.description}</textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/warehouse/detail?id=${warehouseId}"
                               class="btn btn-light border px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">
                                <i class="fas fa-check me-1"></i>
                                ${empty u ? 'Create Unit' : 'Save Changes'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Đã bọc dấu nháy đơn và dùng parseFloat/parseInt kèm giá trị mặc định || 0
    // Cách này đảm bảo không bao giờ bị lỗi SyntaxError dù backend gửi xuống giá trị null
    var warehouseArea  = parseFloat('${empty warehouseArea ? 0 : warehouseArea}') || 0;
    var usedArea       = parseFloat('${empty usedArea ? 0 : usedArea}') || 0;
    var remainingArea  = parseFloat('${empty remainingArea ? 0 : remainingArea}') || 0;
    
    // Lưu ý: Đảm bảo tên biến ở đây khớp với tên bạn đã setAttribute() bên Servlet
    var warehousePrice = parseInt('${empty warehousePrice ? 0 : warehousePrice}') || 0;

    function updateAreaBar(val) {
        var newArea = parseFloat(val) || 0;
        var newBar  = document.getElementById('newBar');
        var hint    = document.getElementById('areaHint');
        var priceEl = document.getElementById('estimatedPrice'); 

        // --- Cập nhật giá tiền ---
        if (priceEl) {
            var estimatedPrice = newArea * warehousePrice;
            
            // Format tiền tệ VND chuẩn xác
            priceEl.innerText = new Intl.NumberFormat('vi-VN', { 
                style: 'currency', 
                currency: 'VND' 
            }).format(estimatedPrice);
        }

        // --- Cập nhật thanh Progress Bar ---
        if (!newBar || warehouseArea <= 0) return;

        var newPct = Math.min((newArea / warehouseArea) * 100, 100);
        newBar.style.width = newPct + '%';

        if (newArea > remainingArea) {
            hint.innerHTML = '<span class="text-danger"><i class="fas fa-exclamation-circle me-1"></i>'
                + 'Vượt quá diện tích cho phép (' + remainingArea.toFixed(1) + 'm³ còn lại)</span>';
            newBar.style.background = '#dc2626';
        } else {
            hint.innerHTML = '<span class="text-success"><i class="fas fa-check-circle me-1"></i>'
                + (remainingArea - newArea).toFixed(1) + 'm³ sẽ còn lại sau khi thêm ô này</span>';
            newBar.style.background = '#f59e0b';
        }
    }

    // Kích hoạt ngay khi load trang để hiển thị thanh progress bar cho chế độ Edit
    window.addEventListener('DOMContentLoaded', function() {
        var areaInput = document.getElementById('areaInput');
        if (areaInput && areaInput.value) {
            updateAreaBar(areaInput.value);
        }
    });
</script>
</body>
</html>
