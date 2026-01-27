<%-- 
    Document   : card
    Created on : Jan 27, 2026, 1:37:27 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card h-100 shadow-sm border-0 position-relative">
    <span class="position-absolute top-0 end-0 m-3 badge ${product.status == 1 ? 'bg-success' : 'bg-secondary'}">
        ${product.status == 1 ? 'Available' : 'Full'}
    </span>

    <div class="fruite-img" style="height: 200px; overflow: hidden;">
        <img src="${pageContext.request.contextPath}/resources/renter/image/${product.warehouseImage.image_url != null ? product.warehouseImage.image_url : 'default.jpg'}" 
             class="card-img-top w-100 h-100 object-fit-cover" alt="${product.name}">
    </div>

    <div class="card-body">
        <h5 class="card-title fw-bold text-dark">${product.name}</h5>
        <p class="text-muted small mb-2">
            <i class="fas fa-map-marker-alt me-1"></i> ${product.address}
        </p>
        
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span class="h5 fw-bold text-primary mb-0">
                $<fmt:formatNumber value="${product.minPrice}" type="number"/> 
                <small class="text-muted fw-normal">/month</small>
            </span>
        </div>

        <div class="row g-2 mb-3 text-muted small">
            <div class="col-6">
                <i class="fas fa-ruler-combined me-1"></i> ${product.totalArea} sq ft
            </div>
            <div class="col-6 text-end">
                <i class="fas fa-warehouse me-1"></i> ${product.warehouseType.typeName}
            </div>
        </div>

        <a href="detail?id=${product.warehouseId}" class="btn btn-dark w-100 py-2 fw-bold">View Details</a>
    </div>
</div>