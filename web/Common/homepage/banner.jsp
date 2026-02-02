<%-- 
    Document   : banner
    Created on : Jan 27, 2026, 1:36:36 PM
    Author     : ad
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid hero-header" 
     style="background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), 
            url('${pageContext.request.contextPath}/resources/warehouse/image/banner_new.jpg'); 
            background-size: cover; background-position: center; min-height: 550px;">

    <div class="container py-5">

        <!-- ===== TITLE ===== -->
        <div class="row g-5 align-items-center mb-4">
            <div class="col-lg-7">
                <h1 class="mb-3 display-3 text-white fw-bold">
                    Find & Book <br> Warehouse Space
                </h1>
                <p class="mb-4 text-white fs-5">
                    Search thousands of warehouses across regions
                </p>
            </div>
        </div>

        <!-- ===== SEARCH BOX ===== -->
        <div class="row justify-content-center">
            <div class="col-lg-11">

                <div class="bg-white p-4 rounded-3 shadow-lg">
                    <form action="homepage" method="GET">

                        <!-- ===== WHITE BAR (NOW: NAME INPUT) ===== -->
                        <div class="row g-3 mb-3">

                            <div class="col-md-12">
                                <label class="form-label fw-bold small text-muted">
                                    Warehouse name
                                </label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-transparent border">
                                        <i class="fa fa-warehouse text-dark"></i><!--
-->                                    </span>
                                    
                                    <input type="text" 
                                           name="keyword" 
                                           class="form-control"
                                           placeholder="Enter warehouse name..."
                                           value="${param.keyword}">
                                </div>
                            </div>

                        </div>

                        <!-- ===== BLACK SEARCH BUTTON (KEEP) ===== -->
                        <div class="row">
                            <div class="col-12">
                                <button type="submit" 
                                        class="btn btn-dark w-100 py-3 rounded-2 fw-bold bg-dark"
                                        >
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

