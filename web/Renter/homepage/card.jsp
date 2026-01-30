<%-- 
    Document   : card
    Created on : Jan 27, 2026, 1:37:27 PM
    Author     : ad
--%>


<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* Ép tất cả card trong danh sách có cùng chiều cao */
    .warehouse-card {
        height: 380px; /* Bạn có thể tăng giảm con số này cho vừa mắt */
        display: flex;
        flex-direction: column;
    }
    /* Ép ảnh không bị méo và cùng cỡ */
    .card-img-container {
        height: 200px;
        overflow: hidden;
    }
    .card-img-container img {
        height: 100%;
        width: 100%;
        object-fit: cover;
    }
    /* Khống chế tên kho chỉ hiện trên 1 dòng, tránh đẩy hàng */
    .card-title-fixed {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
</style>

<div class="row g-4">
    <c:forEach items="${warehouses}" var="w">
        <div class="col-lg-4 col-md-6">
            <div class="card warehouse-card shadow-sm border-0 rounded-4">
                
                <div class="position-relative card-img-container">
                    <img src="${pageContext.request.contextPath}/resources/renter/image/${imageMap[w.warehouseId]}"
                         class="rounded-top-4"
                         alt="warehouse image"
                         onerror="this.src='${pageContext.request.contextPath}/resources/renter/image/default.jpg';">

                    <c:if test="${w.status == 1}">
                        <span class="badge position-absolute top-0 start-0 m-2 bg-success">Active</span>
                    </c:if>
                </div>

                <div class="card-body d-flex flex-column justify-content-between">
                    <div>
                        <h6 class="fw-bold mb-1 card-title-fixed" title="${w.name}">${w.name}</h6>
                        <p class="text-muted small mb-2 card-title-fixed">
                            <i class="fa-solid fa-location-dot"></i> ${w.address}
                        </p>
                    </div>

                    <div class="mt-2">
                        <c:choose>
                            <c:when test="${w.status == 1}">
                                <a href="warehouse-detail?id=${w.warehouseId}" 
                                   class="btn btn-dark w-100 rounded-pill">View Details</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary w-100 rounded-pill" disabled>Not Available</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${empty warehouses}">
    <div class="text-center text-muted mt-5 py-5 w-100">
        <h5>No warehouse found.</h5>
    </div>
</c:if>