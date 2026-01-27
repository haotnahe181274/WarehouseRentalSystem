<%-- 
    Document   : banner
    Created on : Jan 27, 2026, 1:36:36 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-5 mb-5 hero-header" 
     style="background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), 
            url('${pageContext.request.contextPath}/resources/renter/image/banner.jpg'); 
            background-size: cover; background-position: center; min-height: 500px;">
    
    <div class="container py-5">
        <div class="row g-5 align-items-center">
            <div class="col-md-12 col-lg-7">
                <h1 class="mb-3 display-3 text-white fw-bold">Find & Book <br> Warehouse Space</h1>
                <p class="mb-4 text-white fs-5">Search thousands of warehouses across regions</p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-11">
                <div class="bg-white p-4 rounded-3 shadow">
                    <form action="homepage" method="GET" id="filterForm">
                        <div class="row g-3">
                            <div class="col-md-3 border-end">
                                <label class="form-label fw-bold small text-muted">Location/Region</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-0"><i class="fa fa-map-marker-alt text-primary"></i></span>
                                    <input type="text" name="location" class="form-control border-0" 
                                           placeholder="Enter city or region" value="${param.location}">
                                </div>
                            </div>

                            <div class="col-md-3 border-end">
                                <label class="form-label fw-bold small text-muted">Warehouse Type</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-0"><i class="fa fa-warehouse text-primary"></i></span>
                                    <select name="typeId" class="form-select border-0">
                                        <option value="0">All Types</option>
                                        <c:forEach items="${warehouseTypes}" var="t">
                                            <option value="${t.warehouse_type_id}" ${param.typeId == t.warehouse_type_id ? 'selected' : ''}>
                                                ${t.type_name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-3 border-end">
                                <label class="form-label fw-bold small text-muted">Max Area (sq ft)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-0"><i class="fa fa-ruler-combined text-primary"></i></span>
                                    <input type="number" name="maxArea" class="form-control border-0" 
                                           placeholder="Max sq ft" value="${param.maxArea}">
                                </div>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-muted">Max Price</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-0"><i class="fa fa-dollar-sign text-primary"></i></span>
                                    <input type="number" name="maxPrice" class="form-control border-0" 
                                           placeholder="$/month" value="${param.maxPrice}">
                                </div>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-12 text-center">
                                <button type="submit" class="btn btn-dark w-100 py-3 rounded-2 fw-bold" style="background-color: #1a1a1a;">
                                    <i class="fa fa-search me-2"></i> Search Warehouses
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>