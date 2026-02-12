<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${w.name} | WRS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { background-color: #f3f4f6; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        
        /* Custom Card Style */
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); background: white; }
        
        /* Gallery */
        .main-img-frame { height: 400px; overflow: hidden; border-radius: 12px; }
        .main-img-frame img { width: 100%; height: 100%; object-fit: cover; }
        .thumb-img { height: 80px; width: 100%; object-fit: cover; border-radius: 8px; cursor: pointer; opacity: 0.6; transition: 0.2s; }
        .thumb-img:hover, .thumb-img.active { opacity: 1; border: 2px solid #3b82f6; }

        /* Floor Plan (Zones) */
        .zone-card { border: 1px solid #e5e7eb; border-radius: 8px; padding: 15px; transition: all 0.2s; background: #fff; }
        .zone-card:hover { border-color: #3b82f6; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .status-badge { font-size: 0.75rem; font-weight: 600; padding: 2px 8px; border-radius: 9999px; }
        .status-available { background-color: #d1fae5; color: #065f46; } /* Màu xanh */
        .status-occupied { background-color: #fee2e2; color: #991b1b; } /* Màu đỏ */

        /* Booking Form Right Side */
        .booking-sidebar { position: sticky; top: 20px; }
        .form-label { font-size: 0.875rem; font-weight: 600; color: #374151; }
        .btn-submit { background-color: #111827; color: white; padding: 12px; border-radius: 6px; width: 100%; font-weight: 500; }
        .btn-submit:hover { background-color: #1f2937; color: white; }
    </style>
</head>
<body>

<div class="bg-white border-bottom py-4 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <div class="d-flex align-items-center gap-2">
                <i class="fas fa-warehouse fs-4"></i>
                <h2 class="fw-bold mb-0">${w.name}</h2>
            </div>
            <p class="text-muted mb-0 mt-1 ms-1">${w.address}</p>
        </div>
        <div>
            <c:choose>
                <c:when test="${w.status == 1}">
                    <span class="badge bg-success rounded-pill px-3 py-2"><i class="fas fa-check-circle me-1"></i> Available</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary rounded-pill px-3 py-2">Maintenance</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<div class="container pb-5">
    <div class="row">
        
        <div class="col-lg-8">
            <div class="card-custom p-3 mb-4">
                <h5 class="fw-bold mb-3">Warehouse Gallery</h5>
                <div class="main-img-frame mb-3">
                    <img src="${mainImg}" id="displayImg" alt="Warehouse Image">
                </div>
                <div class="row g-2">
                    <c:forEach items="${imgs}" var="img">
                        <div class="col-3 col-md-2">
                            <img src="${img.imageUrl}" class="thumb-img" onclick="changeImage(this.src)">
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="mb-4">
                <h5 class="fw-bold">Floor Plan View</h5>
                <p class="text-muted small">Interactive layout with available zones</p>
                
                <div class="row g-3">
                    <c:forEach items="${units}" var="u">
                        <div class="col-md-4">
                            <div class="zone-card h-100 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="fw-bold mb-0">${u.unitCode}</h6>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="status-badge status-available">Available</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-occupied">Occupied</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="small text-muted mb-1">${u.description}</p>
                                    <h5 class="fw-bold mb-0"><fmt:formatNumber value="${u.area}" /> <span class="fs-6 fw-normal text-muted">sq ft</span></h5>
                                </div>
                                <div class="mt-3 pt-2 border-top">
                                    <small class="fw-bold text-primary"><fmt:formatNumber value="${u.price}" /> VND</small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="card-custom p-4 bg-light">
                <div class="d-flex align-items-center">
                    <i class="fas fa-truck-loading fs-2 text-secondary me-3"></i>
                    <div>
                        <h6 class="fw-bold mb-0">Loading Docks</h6>
                        <small class="text-muted">Thông tin bến bãi có thể xem chi tiết trong mô tả</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card-custom p-4 booking-sidebar">
                <h5 class="fw-bold mb-1">Booking & Declaration</h5>
                <p class="text-muted small mb-4">Complete your warehouse reservation</p>

                <form action="rent-request" method="POST">
                    <input type="hidden" name="warehouseId" value="${w.warehouseId}">
                    
                    <div class="mb-3">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Selected Zones</label>
                        <div class="border rounded p-2 bg-light" style="max-height: 150px; overflow-y: auto;">
                            <c:forEach items="${units}" var="u">
                                <c:if test="${u.status == 1}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="selectedUnits" value="${u.unitId}" id="chk_${u.unitId}">
                                        <label class="form-check-label small" for="chk_${u.unitId}">
                                            ${u.unitCode} - <fmt:formatNumber value="${u.area}"/> sq ft
                                        </label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Additional Requirements</label>
                        <textarea name="note" class="form-control" rows="3" placeholder="Describe special requirements..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-submit">Submit Request</button>
                    <div class="text-center mt-3">
                        <small class="text-muted" style="font-size: 0.75rem">Request will be processed within 24 hours</small>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<script>
    function changeImage(src) {
        document.getElementById('displayImg').src = src;
    }
</script>

</body>
</html>