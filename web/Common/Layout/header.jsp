<%-- Document : header Created on : Feb 2, 2026, 2:40:52 PM Author : ad --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<nav class="app-header">

    <a class="app-header__logo" href="${pageContext.request.contextPath}/homepage">
        WareSpace
    </a>

    <ul class="app-header__menu">
        <li class="app-header__menu-item">
            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/homepage">Homepage</a>
        </li>

        <c:if test="${sessionScope.userType == 'RENTER'}">
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/rentList">My Rental</a>
            </li>
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/contract">Contract</a>
            </li>
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/itemlist">List Item</a>
            </li>
        </c:if>

        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <c:if test="${sessionScope.role == 'Admin'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Admin</a>
                </li>
            </c:if>
            <c:if test="${sessionScope.role == 'Staff'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Staff</a>
                </li>
            </c:if>
            <c:if test="${sessionScope.role == 'Manager'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Manager</a>
                </li>
            </c:if>
        </c:if>

        <c:if test="${sessionScope.userType == 'RENTER' || isHomepage}">
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/Common/homepage/about.jsp">About us</a>
            </li>
        </c:if>
    </ul>

    <ul class="app-header__user">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                
                <li class="app-header__notification">
                    <a href="${pageContext.request.contextPath}/notifications" class="app-header__noti-trigger">
                        <i class="fa-solid fa-bell fs-5"></i>
                        
                        <%-- <c:if test="${not empty sessionScope.unreadNotiCount && sessionScope.unreadNotiCount > 0}"> --%>
                            <span class="app-header__noti-badge">3</span>
                        <%-- </c:if> --%>
                    </a>
                </li>
                <li class="app-header__user-info">
                    <div class="app-header__user-trigger app-header__user-box">
                        <img class="app-header__avatar"
                            src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image}"
                            width="32" height="32"
                            onerror="this.src='${pageContext.request.contextPath}/resources/user/image/default.jpg'">
                        <span class="app-header__username">${sessionScope.user.name}</span>
                    </div>

                    <ul class="app-header__dropdown app-header__user-box">
                        <li class="app-header__dropdown-item">
                            <a class="app-header__dropdown-link" href="${pageContext.request.contextPath}/profile">My Profile</a>
                        </li>
                        <c:if test="${sessionScope.userType == 'RENTER'}">
                            <li class="app-header__dropdown-item">
                                <a class="app-header__dropdown-link" href="${pageContext.request.contextPath}/payments">My Payment</a>
                            </li>
                        </c:if>
                        <li class="app-header__dropdown-item">
                            <a class="app-header__dropdown-link text-danger" href="${pageContext.request.contextPath}/logout">Logout</a>
                        </li>
                    </ul>
                </li>
            </c:when>

            <c:otherwise>
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link fw-bold bg-dark text-white px-3" style="border-radius: 50px;" href="${pageContext.request.contextPath}/login">Login</a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<style>
    /* ===== HEADER ===== */
    .app-header {
        width: 100%;
        display: flex;
        align-items: center;
        padding: 12px 24px;
        border-bottom: 1px solid #ddd;
        font-family: Arial, sans-serif;
        background: #ffffff;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    /* ===== LOGO ===== */
    .app-header__logo {
        font-weight: 700;
        font-size: 20px;
        color: #000;
        text-decoration: none;
        margin-right: 40px;
    }

    /* ===== MENU & USER LIST ===== */
    .app-header__menu,
    .app-header__user {
        display: flex;
        align-items: center;
        list-style: none;
        padding: 0;
        margin: 0;
        gap: 12px;
    }

    .app-header__menu-link {
        display: block;
        padding: 6px 12px;
        border-radius: 6px;
        color: #000;
        text-decoration: none;
        font-weight: 500;
    }

    .app-header__menu-link:hover {
        background-color: #f2f2f2;
    }

    /* ===== USER (RIGHT SIDE) ===== */
    .app-header__user {
        margin-left: auto;
        gap: 16px; /* Tăng khoảng cách giữa chuông và avatar */
    }


    /* ==========================================
       START CSS CHO NOTIFICATION BELL
       ========================================== */
    .app-header__notification {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .app-header__noti-trigger {
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        color: #4b5563; /* Màu xám đen */
        text-decoration: none;
        transition: background-color 0.2s;
    }

    .app-header__noti-trigger:hover {
        background-color: #f3f4f6; /* Nền xám nhạt khi hover */
        color: #111827; /* Đổi màu icon đậm lên */
    }

    /* Chấm đỏ báo số lượng */
    .app-header__noti-badge {
        position: absolute;
        top: 0px;
        right: 0px;
        background-color: #ef4444; /* Đỏ */
        color: white;
        font-size: 10px;
        font-weight: bold;
        padding: 2px 5px;
        border-radius: 10px;
        min-width: 16px;
        text-align: center;
        border: 2px solid #ffffff; /* Viền trắng để cắt nền */
    }
    /* ==========================================
       END CSS CHO NOTIFICATION BELL
       ========================================== */


    /* ===== USER DROPDOWN ===== */
    .app-header__user-info {
        position: relative;
        z-index: 9999;
    }

    .app-header__user-trigger {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 10px;
        border-radius: 5px;
        cursor: pointer;
    }

    .app-header__user-trigger:hover {
        background-color: #f2f2f2;
    }

    .app-header__avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
    }

    .app-header__username {
        font-size: 15px;
        font-weight: 500;
        white-space: nowrap;
    }

    .app-header__dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        list-style: none;
        display: none;
        flex-direction: column;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        min-width: 160px;
        padding: 6px 0;
        z-index: 10000;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .app-header__dropdown-link {
        display: block;
        padding: 8px 16px;
        color: #000;
        text-decoration: none;
    }

    .app-header__dropdown-link:hover {
        background-color: #f2f2f2;
    }

    .app-header__user-info:hover .app-header__dropdown {
        display: flex;
    }

    .app-header__user-box {
        min-width: 170px;
    }
</style>