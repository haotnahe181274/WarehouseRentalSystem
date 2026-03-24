<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" /><%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* ===== Cấu trúc Sidebar tổng thể ===== */
    .sidebar {
        width: 250px;
        background-color: #ffffff;
        color: #374151;
        flex-shrink: 0;
        box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }

    .sidebar-inner {
        position: sticky;
        top: 60px;
        max-height: calc(100vh - 60px);
        overflow-y: auto;
        display: flex;
        flex-direction: column;
    }

    /* ===== Tiêu đề Sidebar (MỚI) ===== */
    .sidebar-header {
        padding: 24px 20px 10px;
        font-size: 18px;
        font-weight: 700;
        color: #1f2937;
        border-bottom: 1px solid #e5e7eb;
    }

    /* ===== MENU ===== */
    .sidebar-menu {
        list-style: none;
        padding: 12px;
        margin: 0;
        flex: 1;
    }

    .menu-title {
        font-size: 12px;
        color: #6b7280;
        margin: 20px 0 8px 8px;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 600;
    }

    .sidebar-menu li {
        margin-bottom: 6px;
    }

    .sidebar-menu li a {
        color: #4b5563;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 12px; /* Tăng gap để icon cách văn bản */
        padding: 10px 16px;
        border-radius: 8px;
        font-size: 14.5px;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    /* CSS cho icon bên trong liên kết */
    .sidebar-menu li a i {
        font-size: 16px;
        width: 18px; /* Giữ cho các icon có độ rộng cố định để căn chỉnh đều */
        text-align: center;
        color: #9ca3af; /* Màu xám nhạt hơn cho icon chưa active */
    }

    /* Hover */
    .sidebar-menu li a:hover {
        background-color: #f3f4f6;
        color: #1f2937;
    }
    
    .sidebar-menu li a:hover i {
        color: #6b7280; /* Icon đậm hơn một chút khi hover */
    }

    /* Active */
    .sidebar-menu li a.active {
        background-color: #f3f4f6; /* Nền xanh nhạt trong hình bạn cung cấp */
        color: #111827;
        font-weight: 600;
    }

    .sidebar-menu li a.active i {
        color: #3b82f6; /* Icon active có màu xanh dương */
    }

    /* ===== FOOTER (tùy chọn) ===== */
    .sidebar-footer {
        padding: 16px;
        border-top: 1px solid #e5e7eb;
        margin-top: auto;
    }

    .logout a {
        color: #ef4444;
        font-weight: 600;
    }
</style>

<div class="sidebar">
    <div class="sidebar-inner">

        <ul class="sidebar-menu">

            <c:if test="${sessionScope.role == 'Admin'}">
          
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active"><i class="fa-solid fa-tachometer-alt"></i> Overview</a></li>
                <li><a href="${pageContext.request.contextPath}/user/list"><i class="fa-solid fa-users"></i> Users Management</a></li>
                <li><a href="${pageContext.request.contextPath}/warehouse"><i class="fa-solid fa-warehouse"></i> Warehouses Management</a></li>
                <li><a href="${pageContext.request.contextPath}/rentList"><i class="fa-solid fa-clipboard-list"></i> Rental Requests</a></li>
                <li><a href="${pageContext.request.contextPath}/contract"><i class="fa-solid fa-file-signature"></i> Contracts Management</a></li>
                <li><a href="${pageContext.request.contextPath}/feedbackManagement"><i class="fa-solid fa-comments"></i> Feedback Management</a></li>
                <li><a href="${pageContext.request.contextPath}/incident"><i class="fa-solid fa-triangle-exclamation"></i> Reports Management</a></li>
                <li><a href="${pageContext.request.contextPath}/category-management"><i class="fa-solid fa-tags"></i> Blog Categories</a></li>
            </c:if>

            <c:if test="${sessionScope.role == 'Manager'}">
 
                <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fa-solid fa-tachometer-alt"></i> Overview</a></li>
                <li><a href="${pageContext.request.contextPath}/user/list"><i class="fa-solid fa-users"></i> Users Management</a></li>
                <li><a href="${pageContext.request.contextPath}/warehouse"><i class="fa-solid fa-warehouse"></i> Warehouses Management</a></li>
                <li><a href="${pageContext.request.contextPath}/rentList"><i class="fa-solid fa-clipboard-list"></i> Rental Requests</a></li>
                <li><a href="${pageContext.request.contextPath}/contract"><i class="fa-solid fa-file-signature"></i> Contracts Management</a></li>
                <li><a href="${pageContext.request.contextPath}/feedbackManagement"><i class="fa-solid fa-comments"></i> Feedback Management</a></li>
                <li><a href="${pageContext.request.contextPath}/incident"><i class="fa-solid fa-triangle-exclamation"></i> Reports Management</a></li>
                <li><a href="${pageContext.request.contextPath}/category-management"><i class="fa-solid fa-tags"></i> Blog Categories</a></li>
            </c:if>

            <c:if test="${sessionScope.role == 'Staff'}">
                <li><a href="${pageContext.request.contextPath}/staffTask"><i class="fa-solid fa-list-check"></i> Tasks</a></li>
                <li><a href="${pageContext.request.contextPath}/incident"><i class="fa-solid fa-triangle-exclamation"></i> Incidents</a></li>
            </c:if>

        </ul>

        </div>
</div>