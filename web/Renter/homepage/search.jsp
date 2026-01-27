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
        <input type="hidden" name="location" value="${param.location}">
        <input type="hidden" name="maxPrice" value="${param.maxPrice}">

        <div class="mb-4">
            <h6 class="fw-bold mb-3">Warehouse Type</h6>
            <c:forEach items="${warehouseTypes}" var="t">
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" name="typeId" 
                           value="${t.warehouseTypeId}" id="type${t.warehouseTypeId}" 
                           onchange="this.form.submit()"
                           ${param.typeId == t.warehouseTypeId ? 'checked' : ''}>
                    <label class="form-check-label d-flex justify-content-between w-100" for="type${t.warehouseTypeId}">
                        ${t.typeName}
                    </label>
                </div>
            </c:forEach>
        </div>

        <hr class="my-4">

        <div class="mb-4">
            <h6 class="fw-bold mb-3">Availability</h6>
            <div class="form-check mb-2">
                <input class="form-check-input" type="checkbox" name="status" value="1" id="statusActive" 
                       onchange="this.form.submit()" ${param.status == '1' ? 'checked' : ''}>
                <label class="form-check-label" for="statusActive">Available Now</label>
            </div>
            <div class="form-check mb-2">
                <input class="form-check-input" type="checkbox" name="status" value="2" id="statusFull" 
                       onchange="this.form.submit()" ${param.status == '2' ? 'checked' : ''}>
                <label class="form-check-label" for="statusFull">Currently Full</label>
            </div>
        </div>

        <hr class="my-4">

        <div class="mb-4">
            <h6 class="fw-bold mb-3">Area Size</h6>
            <select name="maxArea" class="form-select form-select-sm" onchange="this.form.submit()">
                <option value="">Any Size</option>
                <option value="50" ${param.maxArea == '50' ? 'selected' : ''}>Under 50 sq ft</option>
                <option value="100" ${param.maxArea == '100' ? 'selected' : ''}>Under 100 sq ft</option>
                <option value="500" ${param.maxArea == '500' ? 'selected' : ''}>Under 500 sq ft</option>
            </select>
        </div>
    </form>
</div>
