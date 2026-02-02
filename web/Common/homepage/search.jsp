<%-- 
    Document   : search
    Created on : Jan 27, 2026, 1:36:58 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="filter-sidebar bg-white p-3 rounded border">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0" style="font-size: 1.2rem;">Filters</h4>
        <a href="homepage" class="text-muted small text-decoration-none">Clear All</a>
    </div>

    <form action="homepage" id="sideFilterForm" method="GET">

        <!-- ========== LOCATION ========== -->
        <div class="mb-4">
            <h6 class="fw-bold mb-3">Location</h6>
            <select name="location" class="form-select form-select-sm">
                <option value="">All locations</option>
                <c:forEach items="${locations}" var="l">
                    <option value="${l}" ${param.location == l ? 'selected' : ''}>
                        ${l}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr class="my-4">

        <!-- ========== TYPE ========== -->
        <div class="mb-4">
            <h6 class="fw-bold mb-3">Warehouse Type</h6>
            <select name="typeId" class="form-select form-select-sm">
                <option value="">All types</option>
                <c:forEach items="${warehouseTypes}" var="t">
                    <option value="${t.warehouseTypeId}" 
                        ${param.typeId == t.warehouseTypeId ? 'selected' : ''}>
                        ${t.typeName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr class="my-4">

        <!-- ========== AREA ========== -->
        <div class="mb-4">
            <h6 class="fw-bold mb-3">Area (m²)</h6>
            <div class="d-flex gap-2">
                <input type="number" step="0.01" class="form-control form-control-sm"
                       name="minArea" placeholder="Min" value="${param.minArea}">
                <input type="number" step="0.01" class="form-control form-control-sm"
                       name="maxArea" placeholder="Max" value="${param.maxArea}">
            </div>
        </div>

        <hr class="my-4">

        <!-- ========== PRICE ========== -->
        <div class="mb-4">
            <h6 class="fw-bold mb-3">Price (VND)</h6>
            <div class="d-flex gap-2">
                <input type="number" step="1000" class="form-control form-control-sm"
                       name="minPrice" placeholder="Min" value="${param.minPrice}">
                <input type="number" step="1000" class="form-control form-control-sm"
                       name="maxPrice" placeholder="Max" value="${param.maxPrice}">
            </div>
        </div>

        <!-- ========== APPLY BUTTON ========== -->
        <div class="d-grid mt-3">
            <button type="submit" class="btn btn-dark btn-sm">
                Apply filters
            </button>
        </div>

    </form>
</div>
