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
                    body {
                        font-family: Arial, sans-serif;
                        background: #f5f6fa;
                    }

                    /* Layout */
                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        padding: 24px;
                        background: #f5f7fb;
                    }

                    /* Card */
                    .card-custom {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                        background: white;
                    }

                    /* Gallery */
                    .main-img-frame {
                        height: 400px;
                        overflow: hidden;
                        border-radius: 12px;
                    }

                    .main-img-frame img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .thumb-img {
                        height: 80px;
                        width: 100%;
                        object-fit: cover;
                        border-radius: 8px;
                        cursor: pointer;
                        opacity: 0.6;
                        transition: 0.2s;
                    }

                    .thumb-img:hover {
                        opacity: 1;
                        border: 2px solid #3b82f6;
                    }

                    /* Zone */
                    .zone-card {
                        border: 1px solid #e5e7eb;
                        border-radius: 8px;
                        padding: 15px;
                        background: #fff;
                        transition: 0.2s;
                    }

                    .zone-card:hover {
                        border-color: #3b82f6;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .status-badge {
                        font-size: 12px;
                        font-weight: 600;
                        padding: 2px 8px;
                        border-radius: 9999px;
                    }

                    .status-available {
                        background: #d1fae5;
                        color: #065f46;
                    }

                    .status-occupied {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    /* Booking */
                    .booking-sidebar {
                        position: sticky;
                        top: 20px;
                    }

                    .btn-submit {
                        background: #111827;
                        color: white;
                        width: 100%;
                        padding: 12px;
                    }

                    .btn-submit:hover {
                        background: #1f2937;
                        color: white;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/Common/Layout/header.jsp" />

                <div class="layout">

                    <jsp:include page="/Common/Layout/sidebar.jsp" />

                    <!-- MAIN CONTENT -->
                    <div class="main-content">

                        <!-- Warehouse Header -->
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
                                            <span class="badge bg-success rounded-pill px-3 py-2">
                                                <i class="fas fa-check-circle me-1"></i> Available
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill px-3 py-2">
                                                Maintenance
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                            </div>
                        </div>

                        <div class="card-custom p-3 mb-4">
                            <h5 class="fw-bold mb-3">Warehouse Gallery</h5>

                            <c:set var="mainDisplayUrl" value="default-placeholder.jpg" />

                            <c:if test="${not empty images}">
                                <%-- Mặc định lấy ảnh đầu tiên trong list --%>
                                    <c:set var="mainDisplayUrl" value="${images[0].imageUrl}" />

                                    <%-- Nếu muốn xịn hơn: Tìm ảnh nào có primary=true thì ưu tiên lấy --%>
                                        <c:forEach items="${images}" var="item">
                                            <c:if test="${item.primary}">
                                                <c:set var="mainDisplayUrl" value="${item.imageUrl}" />
                                            </c:if>
                                        </c:forEach>
                            </c:if>

                            <div class="main-img-frame mb-3 text-center border bg-light rounded"
                                style="height: 400px; overflow: hidden; display: flex; align-items: center; justify-content: center;">
                                <img src="${pageContext.request.contextPath}/resources/warehouse/image/${mainDisplayUrl}"
                                    id="displayImg" style="max-height: 100%; max-width: 100%; object-fit: contain;"
                                    onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                            </div>

                            <div class="row g-2">
                                <c:forEach items="${images}" var="img">
                                    <div class="col-3 col-md-2">
                                        <div class="border rounded p-1" style="cursor: pointer;">
                                            <img src="${pageContext.request.contextPath}/resources/warehouse/image/${img.imageUrl}"
                                                class="thumb-img w-100" style="height: 60px; object-fit: cover;"
                                                onclick="changeImage(this.src)"
                                                onerror="this.src='https://via.placeholder.com/80x80'">
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <script>
                            function changeImage(src) {
                                document.getElementById('displayImg').src = src;
                            }
                        </script>
                        <!-- Zones -->
                        <div class="mb-4">
                            <h5 class="fw-bold">Floor Plan View</h5>

                            <div class="row g-3">
                                <c:forEach items="${units}" var="u">
                                    <div class="col-md-4">

                                        <div class="zone-card h-100 d-flex flex-column justify-content-between">

                                            <div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <h6 class="fw-bold">${u.unitCode}</h6>

                                                    <c:choose>
                                                        <c:when test="${u.status == 1}">
                                                            <span class="status-badge status-available">
                                                                Available
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-occupied">
                                                                Occupied
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <p class="small text-muted">${u.description}</p>

                                                <h5 class="fw-bold">
                                                    <fmt:formatNumber value="${u.area}" />
                                                    <span class="fs-6 text-muted">sq ft</span>
                                                </h5>
                                            </div>

                                            <div class="mt-3 pt-2 border-top">
                                                <small class="fw-bold text-primary">
                                                    <fmt:formatNumber value="${u.pricePerUnit}" /> VND
                                                </small>
                                            </div>

                                        </div>

                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                    </div>

                    <!-- RIGHT -->
                    <div class="col-lg-4">

                        <div class="card-custom p-4 booking-sidebar">

                            <h5 class="fw-bold">Booking & Declaration</h5>

                            <form action="rent-request" method="POST">

                                <input type="hidden" name="warehouseId" value="${w.warehouseId}">

                                <div class="mb-3">
                                    <label>Start Date</label>
                                    <input type="date" name="startDate" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label>End Date</label>
                                    <input type="date" name="endDate" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label>Selected Zones</label>

                                    <div class="border rounded p-2 bg-light" style="max-height:150px;overflow-y:auto;">

                                        <c:forEach items="${units}" var="u">
                                            <c:if test="${u.status == 1}">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="selectedUnits"
                                                        value="${u.unitId}">
                                                    <label class="form-check-label small">
                                                        ${u.unitCode}
                                                    </label>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label>Additional Requirements</label>
                                    <textarea name="note" class="form-control" rows="3"></textarea>
                                </div>

                                <button class="btn btn-submit">
                                    Submit Request
                                </button>

                            </form>

                        </div>

                    </div>

                </div>


                <!-- Feedback Section -->
                <jsp:include page="/feedback.jsp">
                    <jsp:param name="embedded" value="true" />
                </jsp:include>

                <button class="btn btn-sm btn-dark mb-3" data-bs-toggle="modal" data-bs-target="#addZoneModal">
                    <i class="fa fa-plus"></i> Add New Zone
                </button>

                <div class="modal fade" id="addZoneModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-dark text-white">
                                <h5 class="modal-title">Thêm Ô Chứa Mới (Zone)</h5>
                                <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/warehouse/unit" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="warehouseId" value="${w.warehouseId}">

                                    <div class="mb-3">
                                        <label class="form-label">Mã Zone (Ví dụ: ZONE-A1)</label>
                                        <input type="text" name="unitCode" class="form-control" required>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Diện tích (sq ft)</label>
                                            <input type="number" step="0.1" name="area" class="form-control" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Giá thuê (VND)</label>
                                            <input type="number" name="price" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Trạng thái</label>
                                        <select name="status" class="form-select">
                                            <option value="1">Available (Trống)</option>
                                            <option value="2">Occupied (Đã thuê)</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mô tả đặc điểm</label>
                                        <textarea name="description" class="form-control" rows="2"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Lưu Zone</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                </div>




                </div>
                <!-- END MAIN CONTENT -->

                </div>
                <!-- END LAYOUT -->



                <jsp:include page="/Common/Layout/footer.jsp" />

                <script>
                    function changeImage(src) {
                        document.getElementById("displayImg").src = src;
                    }
                </script>

            </body>

            </html>