<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f5f7fb;
    }

    /* ===== SIDEBAR ===== */
    .sidebar {
        width: 220px;
        background: black;
        color: white;

        min-height: 80vh;
        flex-shrink: 0; /* không bị co */

    }

    /* ===== LOGO ===== */
   

    /* ===== MENU ===== */
    .sidebar-menu {
        list-style: none;
        padding: 12px;
        margin: 0;
        flex: 1;
    }

    .menu-title {
        font-size: 11px;
        color: white;
        margin: 16px 0 6px 8px;
        text-transform: uppercase;
    }

    .sidebar-menu li {
        margin-bottom: 4px;
    }

    .sidebar-menu li a {
        color: white;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        border-radius: 10px;
        font-size: 14px;
        transition: 0.2s;
    }

    .sidebar-menu li a:hover {
        background: #1e293b;
    }

    /* Active (nếu sau này muốn) */
    .sidebar-menu li a.active {
        background: #1f2937;
        font-weight: 600;
    }

    /* ===== FOOTER ===== */
    .sidebar-footer {
        padding: 12px;
        border-top: 1px solid #1e293b;
    }

    .logout a {
        color: white;
    }


    /* ===== CONTENT FIX ===== */


</style>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">

    <!-- LOGO -->


    <!-- MENU -->
    <ul class="sidebar-menu">

        <li>
            <a href="${pageContext.request.contextPath}/dashboard">
                Overview
            </a>
        </li>

        <!-- ADMIN -->
        <c:if test="${sessionScope.role == 'Admin'}">
            <div class="menu-title">Admin</div>
            <li><a href="${pageContext.request.contextPath}/user/list">Users</a></li>
            <li><a href="${pageContext.request.contextPath}/warehouse">Warehouses</a></li>

            <li><a href="${pageContext.request.contextPath}/incident">Reports</a></li>
            </c:if>

        <!-- MANAGER -->
        <c:if test="${sessionScope.role == 'Manager'}">
            <div class="menu-title">Manager</div>
            <li><a href="${pageContext.request.contextPath}/user/list">Users</a></li>
            <li><a href="${pageContext.request.contextPath}/warehouse">Warehouses</a></li>
            <li><a href="${pageContext.request.contextPath}/rentList">📩 Rental Requests</a></li>
            <li><a href="${pageContext.request.contextPath}/contract"> Contracts</a></li>
            <li><a href="${pageContext.request.contextPath}/staffAssignment">Staff Assignment</a></li>
            <li><a href="${pageContext.request.contextPath}/incident">Reports</a></li>
            </c:if>

        <!-- STAFF -->
        <c:if test="${sessionScope.role == 'Staff'}">
            <div class="menu-title">Staff</div>
            <li><a href="${pageContext.request.contextPath}/staffTask">Tasks</a></li>
            <li><a href="${pageContext.request.contextPath}/staffCheck">Inventory Check</a></li>
            <li><a href="${pageContext.request.contextPath}/incident"> Incidents</a></li>
            </c:if>

    </ul>



</div>
