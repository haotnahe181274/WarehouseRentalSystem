<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        #imageSlotList { display:flex; flex-direction:column; gap:10px; margin-bottom:10px; }

        .img-slot {
            display:flex; align-items:center; gap:10px;
            background:#f8f9fa; border:1px solid #dee2e6;
            border-radius:8px; padding:8px 12px;
            transition: border-color .2s, background .2s;
        }
        .img-slot.slot-valid   { border-color:#198754; background:#f0fff4; }
        .img-slot.slot-invalid { border-color:#dc3545; background:#fff5f5; }

        .slot-index {
            min-width:28px; height:28px; border-radius:50%;
            background:#dee2e6; color:#495057;
            font-size:0.78rem; font-weight:700;
            display:flex; align-items:center; justify-content:center; flex-shrink:0;
        }
        .slot-index.is-primary { background:#0d6efd; color:#fff; }

        .slot-col-left { flex:1; }
        .slot-file-input { font-size:0.875rem; width:100%; }
        .slot-feedback { font-size:0.78rem; margin-top:3px; min-height:16px; }

        .thumb-wrap { position:relative; width:54px; flex-shrink:0; }
        .slot-thumb {
            width:54px; height:54px; border-radius:6px; object-fit:cover;
            border:2px solid #dee2e6; display:none;
        }
        .slot-thumb.visible { display:block; border-color:#198754; }

        .primary-dot {
            position:absolute; top:-5px; right:-5px;
            width:14px; height:14px; background:#0d6efd;
            border-radius:50%; border:2px solid #fff; display:none;
        }
        .primary-dot.visible { display:block; }

        .btn-remove-slot {
            background:none; border:none; color:#adb5bd;
            font-size:1rem; cursor:pointer; padding:0 4px;
            flex-shrink:0; transition:color .15s; line-height:1;
        }
        .btn-remove-slot:hover { color:#dc3545; }
        #btnAddSlot { font-size:0.875rem; border-style:dashed; }
        .existing-img-container {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 20px;
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
    border: 1px solid #dee2e6;
}
.existing-img-item {
    position: relative;
    width: 100px;
}
.existing-img-item img {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 5px;
    border: 2px solid #ddd;
}
.existing-img-item .badge {
    position: absolute;
    top: -5px;
    left: -5px;
}
    </style>
</head>
<body>
<jsp:include page="/Common/Layout/header.jsp"/>
<jsp:include page="/message/popupMessage.jsp" />
<div class="d-flex">
    <jsp:include page="/Common/Layout/sidebar.jsp"/>
    <div class="container mt-4" style="max-width:800px;">

        <h3>${empty warehouse ? 'Add New Warehouse' : 'Edit Warehouse'}</h3>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form id="warehouseForm"
              action="${pageContext.request.contextPath}/warehouse"
              method="post" enctype="multipart/form-data" novalidate>

            <c:if test="${not empty warehouse}">
                <input type="hidden" name="id"     value="${warehouse.warehouseId}">
                <input type="hidden" name="action" value="edit">
            </c:if>

            <div class="mb-3">
                <label class="form-label">Warehouse Name <span class="text-danger">*</span></label>
                <input type="text" name="name" class="form-control" value="${warehouse.name}" required>
                <div class="invalid-feedback">Warehouse name is required.</div>
            </div>

            <div class="mb-3">
                <label class="form-label">Address <span class="text-danger">*</span></label>
                <input type="text" name="address" class="form-control" value="${warehouse.address}" required>
                <div class="invalid-feedback">Address is required.</div>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3">${warehouse.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Total Area (m³) <span class="text-danger">*</span>
                    <small class="text-muted fw-normal">— Tổng diện tích của kho</small>
                </label>
                <input type="number" name="totalArea" class="form-control"
                       min="1" step="0.1"
                       value="${warehouse.totalArea > 0 ? warehouse.totalArea : ''}" required>
                <div class="invalid-feedback">Total area is required and must be at least 1 m³.</div>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Price per m³ (VNĐ) <span class="text-danger">*</span>
                </label>
                <input type="number" name="pricePerArea" class="form-control"
                       min="10000" step="1"
                       value="${warehouse.pricePerArea > 0 ? warehouse.pricePerArea : ''}" required>
                <div class="invalid-feedback">Price per m³ must be at least 10,000 VNĐ.</div>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <c:choose>
                    <c:when test="${empty warehouse}">
                        <input type="text" class="form-control bg-light" value="Active (Default)" readonly>
                        <input type="hidden" name="status" value="1">
                    </c:when>
                    <c:otherwise>
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
                    <option value="1" ${not empty warehouse and not empty warehouse.warehouseType and warehouse.warehouseType.warehouseTypeId == 1 ? 'selected' : ''}>Cold Storage</option>
                    <option value="2" ${not empty warehouse and not empty warehouse.warehouseType and warehouse.warehouseType.warehouseTypeId == 2 ? 'selected' : ''}>Normal Storage</option>
                    <option value="3" ${not empty warehouse and not empty warehouse.warehouseType and warehouse.warehouseType.warehouseTypeId == 3 ? 'selected' : ''}>High Security</option>
                </select>
            </div>

            <%-- ══ IMAGES: nhập từng ảnh một ══ --%>
            <div class="mb-4">
                <label class="form-label fw-semibold">
                    Warehouse Images
                    <small class="text-muted fw-normal ms-1">— Maximum 10 pics · .jpg .jpeg .png · max 5 MB/picture</small>
                </label>

                <div id="summaryBar" class="mb-2" style="font-size:0.82rem; color:#6c757d;"></div>
                <div id="imageSlotList"></div>

                
                
                <button type="button" id="btnAddSlot" class="btn btn-outline-primary btn-sm mt-1">
                    <i class="fa-solid fa-plus me-1"></i> Add more
                </button>

                <div class="form-text text-danger mt-2">
                    <i class="fa-solid fa-star fa-xs"></i>
                    First <strong> picture</strong> will be thumbnail.
                </div>

                <div id="imageGlobalError" class="text-danger mt-1" style="font-size:0.85rem; display:none;"></div>
            </div>

            <div class="d-flex gap-2 mt-2 mb-5">
                <button type="submit" id="submitBtn" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Save
                </button>
                <a href="${pageContext.request.contextPath}/warehouse" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/Common/Layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
/* ── Cấu hình ── */
var ALLOWED_TYPES  = ['image/jpeg', 'image/jpg', 'image/png'];
var ALLOWED_EXT_RE = /\.(jpg|jpeg|png)$/i;
var MAX_SIZE_BYTES = 5 * 1024 * 1024;
var MAX_SLOTS      = 10;

/* ── Tham chiếu DOM ── */
var slotList    = document.getElementById('imageSlotList');
var btnAddSlot  = document.getElementById('btnAddSlot');
var summaryBar  = document.getElementById('summaryBar');
var globalError = document.getElementById('imageGlobalError');
var submitBtn   = document.getElementById('submitBtn');
var form        = document.getElementById('warehouseForm');

/*
 * slots[i] = { valid: null | true | false }
 *   null  = chua chon file
 *   true  = hop le
 *   false = co loi
 */
var slots = [];

/* ── Format bytes ── */
function formatBytes(bytes) {
    if (bytes < 1024)        return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

/* ── Cap nhat summary bar + nut Save ── */
function updateSummary() {
    var total = slots.length, valid = 0, invalid = 0, empty = 0;
    for (var i = 0; i < slots.length; i++) {
        if      (slots[i].valid === true)  valid++;
        else if (slots[i].valid === false) invalid++;
        else                               empty++;
    }

    if (total === 0) {
        summaryBar.innerHTML = '';
    } else {
        var parts = [];
        if (valid   > 0) parts.push('<span class="text-success fw-semibold">' + valid   + ' hop le</span>');
        if (invalid > 0) parts.push('<span class="text-danger fw-semibold">'  + invalid + ' loi</span>');
        if (empty   > 0) parts.push('<span class="text-muted">'               + empty   + ' chua chon</span>');
        summaryBar.innerHTML = '<i class="fa-solid fa-images me-1"></i> ' + parts.join(' &nbsp;&middot;&nbsp; ');
    }

    submitBtn.disabled = (invalid > 0);
    btnAddSlot.style.display = (total >= MAX_SLOTS) ? 'none' : '';
}

/* ── Validate 1 file, tra ve chuoi loi hoac rong ── */
function validateFile(file) {
    if (!ALLOWED_EXT_RE.test(file.name) || !ALLOWED_TYPES.includes(file.type)) {
        return 'Dinh dang khong hop le - chi .jpg, .jpeg, .png.';
    }
    if (file.size > MAX_SIZE_BYTES) {
        return 'Dung luong ' + formatBytes(file.size) + ' vuot qua gioi han 5 MB.';
    }
    return '';
}

/* ── Tao 1 hang slot va gan su kien ── */
function addSlot() {
    if (slots.length >= MAX_SLOTS) return;

    var idx = slots.length;
    slots.push({ valid: null });

    /* ── DOM ── */
    var row = document.createElement('div');
    row.className = 'img-slot';

    /* So thu tu */
    var badge = document.createElement('div');
    badge.className = 'slot-index' + (idx === 0 ? ' is-primary' : '');
    badge.textContent = idx + 1;
    badge.title = idx === 0 ? 'Thumbnail chinh' : 'Anh ' + (idx + 1);

    /* Cot trai: input + feedback */
    var colLeft = document.createElement('div');
    colLeft.className = 'slot-col-left';

    var fileInput = document.createElement('input');
    fileInput.type      = 'file';
    fileInput.name      = 'images';
    fileInput.accept    = '.jpg,.jpeg,.png';
    fileInput.className = 'form-control form-control-sm slot-file-input';

    var feedback = document.createElement('div');
    feedback.className = 'slot-feedback';

    colLeft.appendChild(fileInput);
    colLeft.appendChild(feedback);

    /* Thumbnail */
    var thumbWrap = document.createElement('div');
    thumbWrap.className = 'thumb-wrap';

    var thumb = document.createElement('img');
    thumb.className = 'slot-thumb';
    thumb.alt = 'preview';

    var dot = document.createElement('div');
    dot.className = 'primary-dot' + (idx === 0 ? ' visible' : '');
    dot.title = 'Thumbnail chinh';

    thumbWrap.appendChild(thumb);
    thumbWrap.appendChild(dot);

    /* Nut xoa */
    var removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn-remove-slot';
    removeBtn.title = 'Xoa anh nay';
    removeBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';

    row.appendChild(badge);
    row.appendChild(colLeft);
    row.appendChild(thumbWrap);
    row.appendChild(removeBtn);
    slotList.appendChild(row);

    /* ════ Su kien: chon file → validate NGAY ════ */
    (function(slotIdx, rowEl, feedbackEl, thumbEl, dotEl) {

        fileInput.addEventListener('change', function() {
            var file = this.files[0];

            /* Khong chon file / bo chon */
            if (!file) {
                slots[slotIdx].valid = null;
                rowEl.className      = 'img-slot';
                feedbackEl.innerHTML = '';
                thumbEl.className    = 'slot-thumb';
                thumbEl.src          = '';
                updateSummary();
                return;
            }

            var err = validateFile(file);

            if (err) {
                /* LOI */
                slots[slotIdx].valid = false;
                rowEl.className      = 'img-slot slot-invalid';
                feedbackEl.innerHTML =
                    '<span class="text-danger">'
                    + '<i class="fa-solid fa-circle-xmark me-1"></i>'
                    + err + '</span>';
                thumbEl.className = 'slot-thumb';
                thumbEl.src       = '';

            } else {
                /* HOP LE — hien preview */
                slots[slotIdx].valid = true;
                rowEl.className      = 'img-slot slot-valid';
                feedbackEl.innerHTML =
                    '<span class="text-success">'
                    + '<i class="fa-solid fa-circle-check me-1"></i>'
                    + file.name + ' (' + formatBytes(file.size) + ')'
                    + '</span>';

                var reader = new FileReader();
                reader.onload = function(ev) {
                    thumbEl.src       = ev.target.result;
                    thumbEl.className = 'slot-thumb visible';
                };
                reader.readAsDataURL(file);
            }

            updateSummary();
        });

        /* ════ Su kien: xoa slot ════ */
        removeBtn.addEventListener('click', function() {
            slotList.removeChild(rowEl);
            slots.splice(slotIdx, 1);
            rebuildIndices();
            updateSummary();
        });

    }(idx, row, feedback, thumb, dot));

    updateSummary();
}

/* ── Rebuild so thu tu sau khi xoa ── */
function rebuildIndices() {
    var rows = slotList.querySelectorAll('.img-slot');
    for (var i = 0; i < rows.length; i++) {
        var b = rows[i].querySelector('.slot-index');
        b.textContent = i + 1;
        b.className   = 'slot-index' + (i === 0 ? ' is-primary' : '');
        b.title       = i === 0 ? 'Thumbnail chinh' : 'Anh ' + (i + 1);

        var d = rows[i].querySelector('.primary-dot');
        if (i === 0) d.classList.add('visible');
        else         d.classList.remove('visible');
    }
}

/* ── Nut "Them anh" ── */
btnAddSlot.addEventListener('click', function() { addSlot(); });

/* ── Khoi tao: tao san 1 slot ── */
addSlot();

/* ── Validate khi submit ── */
form.addEventListener('submit', function(e) {
    if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
        form.classList.add('was-validated');
        return;
    }
    form.classList.add('was-validated');

    var hasErr = false;
    for (var i = 0; i < slots.length; i++) {
        if (slots[i].valid === false) { hasErr = true; break; }
    }
    if (hasErr) {
        e.preventDefault();
        globalError.style.display = '';
        globalError.innerHTML =
            '<i class="fa-solid fa-triangle-exclamation me-1"></i>'
            + 'Vui long sua cac anh bi loi truoc khi luu.';
        slotList.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
        globalError.style.display = 'none';
    }
});
</script>
</body>
</html>
