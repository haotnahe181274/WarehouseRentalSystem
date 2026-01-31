<%-- 
    Document   : card
    Created on : Jan 27, 2026, 1:37:27 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .warehouse-card {
        height: 430px;
        display: flex;
        flex-direction: column;
        border-radius: 16px;
        overflow: hidden;
    }

    .card-img-container {
        position: relative;
        height: 210px;
        overflow: hidden;
    }

    .card-img-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .card-title-fixed {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .price-text {
        font-size: 22px;
        font-weight: 700;
    }

    .area-text {
        font-size: 14px;
        color: #6c757d;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .type-badge-bottom {
    position: absolute;
    bottom: 64px; /* 🔼 đẩy lên cao hơn nút */
    right: 14px;
    padding: 6px 10px;
    border-radius: 10px;
    font-size: 13px;
    background: #f1f1f1;
    display: flex;
    align-items: center;
    gap: 6px;
}

</style>

<div class="row g-4">

    <c:forEach items="${warehouses}" var="w">
        <div class="col-lg-4 col-md-6">

            <div class="card warehouse-card shadow-sm border-0">

                <!-- ===== IMAGE ===== -->
                <div class="card-img-container">

                    <img src="${pageContext.request.contextPath}/resources/renter/image/${imageMap[w.warehouseId]}"
                         onerror="this.src='${pageContext.request.contextPath}/resources/renter/image/default.jpg';"
                         alt="warehouse image">

                    <!-- STATUS -->
                    <c:if test="${w.status == 1}">
                        <span class="badge bg-success position-absolute top-0 end-0 m-2">
                            Available
                        </span>
                    </c:if>

                    

                </div>

                <!-- ===== BODY ===== -->
                <div class="card-body d-flex flex-column justify-content-between">

                    <div>
                        <!-- NAME -->
                        <h6 class="fw-bold mb-1 card-title-fixed" title="${w.name}">
                            ${w.name}
                        </h6>

                        <!-- ADDRESS -->
                        <p class="text-muted small mb-2 card-title-fixed">
                            <i class="fa-solid fa-location-dot me-1"></i>
                            ${w.address}
                        </p>

                        <!-- PRICE -->
                        <c:if test="${w.minPrice > 0}">
                            <div class="price-text mb-1">
                                &gt;
                                <fmt:formatNumber value="${w.minPrice}" type="number" groupingUsed="true"/>
                                <span class="fs-6 fw-normal text-muted">đ/month</span>
                            </div>
                        </c:if>

                        <!-- AREA -->
                        <c:if test="${w.minArea > 0}">
                            <div class="area-text">
                                <i class="fa-solid fa-ruler-combined"></i>
                                From ${w.minArea} m²
                            </div>
                        </c:if>

                        <c:if test="${w.minPrice <= 0 && w.minArea <= 0}">
                            <div class="text-muted small">
                                Contact for details
                            </div>
                        </c:if>
                        
                        <!-- WAREHOUSE TYPE (BOTTOM RIGHT) -->
                    <c:if test="${w.warehouseType != null}">
                        <div class="type-badge-bottom">
                            <i class="fa-solid fa-warehouse"></i>
                            ${w.warehouseType.typeName}
                        </div>
                    </c:if>
                    </div>

                    <!-- BUTTON -->
                    <div class="mt-3">
                        <a href="warehouse-detail?id=${w.warehouseId}"
                           class="btn btn-dark w-100 rounded-pill">
                            View Details
                        </a>
                    </div>

                </div>
            </div>

        </div>
    </c:forEach>

</div>

<!-- EMPTY STATE -->
<c:if test="${empty warehouses}">
    <div class="text-center text-muted mt-5 py-5 w-100">
        <h5>No warehouse found.</h5>
    </div>
</c:if>
