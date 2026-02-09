<%-- 
    Document   : search
    Created on : Jan 27, 2026, 1:36:58 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="filter-sidebar">

    <div class="filter-header">
        <h4>Filters</h4>
        <a href="${pageContext.request.contextPath}/homepage">Clear All</a>
    </div>

    <form action="homepage" method="GET">

        <!-- RENT DATE -->
        <div class="filter-group">
            <label>Rental Period</label>

            <div class="date-row">
                <input type="date" name="startDate" value="${param.startDate}">
                <input type="date" name="endDate" value="${param.endDate}">
            </div>
        </div>

        <!-- LOCATION -->
        <div class="filter-group">
            <label>Location</label>
            <select name="location">
                <option value="">All locations</option>
                <c:forEach items="${locations}" var="l">
                    <option value="${l}" ${param.location == l ? 'selected' : ''}>
                        ${l}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr>

        <!-- TYPE -->
        <div class="filter-group">
            <label>Warehouse Type</label>
            <select name="typeId">
                <option value="">All types</option>
                <c:forEach items="${warehouseTypes}" var="t">
                    <option value="${t.warehouseTypeId}"
                            ${param.typeId == t.warehouseTypeId ? 'selected' : ''}>
                        ${t.typeName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr>

        <!-- AREA -->
        <div class="filter-group">
            <label>Area (m²)</label>
            <div class="filter-row">
                <input type="number" step="0.01" name="minArea"
                       placeholder="Min" value="${param.minArea}">
                <input type="number" step="0.01" name="maxArea"
                       placeholder="Max" value="${param.maxArea}">
            </div>
        </div>

        <hr>

        <!-- PRICE -->
        <div class="filter-group">
            <label>Price (VND)</label>
            <div class="filter-row">
                <input type="number" step="1000" name="minPrice"
                       placeholder="Min" value="${param.minPrice}">
                <input type="number" step="1000" name="maxPrice"
                       placeholder="Max" value="${param.maxPrice}">
            </div>
        </div>

        <!-- APPLY -->
        <button class="filter-button" type="submit">
            Apply filters
        </button>

    </form>
</div>
<style>

    /* ===== SIDEBAR ===== */
    .filter-sidebar {
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 16px;
        padding: 16px;
        width: 100%;
    }

    /* HEADER */
    .filter-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }

    .filter-header h4 {
        font-size: 16px;
        font-weight: 700;
        margin: 0;
    }

    .filter-header a {
        font-size: 13px;
        color: #6b7280;
        text-decoration: none;
    }

    .filter-header a:hover {
        text-decoration: underline;
    }

    /* GROUP */
    .filter-group {
        margin-bottom: 14px;
    }

    .filter-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 6px;
    }

    /* INPUT & SELECT */
    .filter-group input,
    .filter-group select {
        width: 100%;
        padding: 8px 10px;
        font-size: 13px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        outline: none;
    }

    .filter-group input:focus,
    .filter-group select:focus {
        border-color: #111;
    }

    /* ROW (MIN / MAX) */
    .filter-row {
        display: flex;
        gap: 8px;
    }

    /* DIVIDER */
    .filter-sidebar hr {
        border: none;
        border-top: 1px solid #e5e7eb;
        margin: 14px 0;
    }

    /* BUTTON */
    .filter-button {
        width: 100%;
        margin-top: 12px;
        padding: 10px 0;

        background: #111;
        color: #fff;

        border: none;
        border-radius: 999px;

        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }

    .filter-button:hover {
        background: #000;
    }
    /* DATE ROW */
    .date-row {
        display: flex;
        gap: 10px;
    }

    .date-row input {
        flex: 1;
    }



</style>