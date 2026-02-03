<%-- 
    Document   : card
    Created on : Jan 27, 2026, 1:37:27 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="warehouse-grid">

    <c:forEach items="${warehouses}" var="w">
        <div class="warehouse-card">

            <!-- IMAGE -->
            <div class="warehouse-image">
                <img
                    src="${pageContext.request.contextPath}/resources/warehouse/image/${imageMap[w.warehouseId]}"
                    onerror="this.src='${pageContext.request.contextPath}/resources/warehouse/image/default.jpg';"
                    alt="warehouse image"
                    />

                
            </div>

            <!-- CONTENT -->
            <div class="warehouse-content">

                <div class="warehouse-info">
                    <!-- NAME -->
                    <h3 class="warehouse-name" title="${w.name}">
                        ${w.name}
                    </h3>

                    <!-- ADDRESS -->
                    <p class="warehouse-address">
                        <i class="fa-solid fa-location-dot"></i>
                        ${w.address}
                    </p>

                    <!-- PRICE -->
                    <c:if test="${w.minPrice > 0}">
                        <div class="warehouse-price">
                            &gt;
                            <fmt:formatNumber value="${w.minPrice}" type="number" groupingUsed="true"/>
                            <span>đ/month</span>
                        </div>
                    </c:if>

                    <!-- AREA -->
                    <c:if test="${w.minArea > 0}">
                        <div class="warehouse-area">
                            <i class="fa-solid fa-ruler-combined"></i>
                            From ${w.minArea} m²
                        </div>
                    </c:if>

                    <!-- TYPE BADGE -->
                    <c:if test="${w.warehouseType != null}">
                        <div class="warehouse-type">
                            <i class="fa-solid fa-warehouse"></i>
                            ${w.warehouseType.typeName}
                        </div>
                    </c:if>
                </div>

                <!-- BUTTON -->
                <a href="warehouse-detail.jsp" class="warehouse-button">
                    View Details
                </a>

            </div>
        </div>
    </c:forEach>

</div>

<!-- EMPTY STATE -->
<c:if test="${empty warehouses}">
    <div class="warehouse-empty">
        <h3>No warehouse found.</h3>
    </div>
</c:if>


<style>

    /* ===== GRID LAYOUT ===== */
    .warehouse-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 24px;
    }

    /* ===== CARD ===== */
    .warehouse-card {
        background: #fff;
        border-radius: 18px;
        overflow: hidden;

        display: flex;
        flex-direction: column;

        height: 100%; /* QUAN TRỌNG */
        border: 1px solid #e5e7eb;
    }



    .warehouse-type {
        align-self: flex-end; 

        margin-top: 10px;

        background: #f5f5f5;
        color: #111;

        padding: 6px 12px;
        border-radius: 999px;

        font-size: 13px;
        font-weight: 500;

        display: inline-flex;
        align-items: center;
        gap: 6px;
    }

    /* ===== IMAGE ===== */
    .warehouse-image {
        height: 220px;
        width: 100%;
        object-fit: cover;
    }

    .warehouse-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        position: relative;
    }



    /* ===== CONTENT ===== */
    .warehouse-content {
        padding: 16px 18px 18px;

        display: flex;
        flex-direction: column;
        gap: 6px; /* NÉN KHOẢNG CÁCH */

        flex: 1; /* ĐẨY BUTTON XUỐNG DƯỚI */
    }

    /* ===== INFO ===== */
    .warehouse-name {
        font-size: 16px;
        font-weight: 700;
        margin: 0 0 6px;
    }

    .warehouse-address {
        font-size: 14px;
        color: #6b7280;
        margin-bottom: 10px;
        display: flex;
        gap: 6px;
        align-items: center;
    }

    .warehouse-price {
        font-size: 22px;
        font-weight: 800;
        margin-bottom: 6px;
    }

    .warehouse-price span {
        font-size: 14px;
        font-weight: 400;
        color: #6b7280;
    }

    .warehouse-area {
        font-size: 14px;
        color: #6b7280;
        display: flex;
        align-items: center;
        gap: 6px;
    }



    /* ===== BUTTON ===== */
    .warehouse-button {
        margin-top: 16px;
        text-align: center;
        padding: 12px;
        background: #111827;
        color: #fff;
        border-radius: 999px;
        text-decoration: none;
        font-weight: 600;
    }

    .warehouse-button:hover {
        background: #000;
    }

    /* ===== EMPTY ===== */
    .warehouse-empty {
        text-align: center;
        padding: 60px 0;
        color: #9ca3af;
    }

    .warehouse-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 28px;
    }


</style>