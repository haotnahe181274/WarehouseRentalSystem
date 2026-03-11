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
                    <li class="app-header__menu-item">
                        <a class="app-header__menu-link" href="${pageContext.request.contextPath}/discuss">Discussion</a>
                    </li>
                    <c:if test="${not empty sessionScope.user}">
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/post">My
                                Posts</a>
                        </li>
                    </c:if>
                    <c:if test="${sessionScope.userType == 'RENTER'}">
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/rentList">My
                                Rental</a>
                        </li>
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link"
                                href="${pageContext.request.contextPath}/contract">Contract</a>
                        </li>
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/itemlist">List
                                Item</a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.userType == 'INTERNAL'}">
                        <c:if test="${sessionScope.role == 'Admin'}">
                            <li class="app-header__menu-item">
                                <a class="app-header__menu-link"
                                    href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Admin</a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.role == 'Staff'}">
                            <li class="app-header__menu-item">
                                <a class="app-header__menu-link"
                                    href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Staff</a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.role == 'Manager'}">
                            <li class="app-header__menu-item">
                                <a class="app-header__menu-link"
                                    href="${pageContext.request.contextPath}/Common/Layout/dashboard.jsp">Manager</a>
                            </li>
                        </c:if>
                    </c:if>

                    <c:if test="${sessionScope.userType == 'RENTER' || isHomepage}">
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link"
                                href="${pageContext.request.contextPath}/Common/homepage/about.jsp">About us</a>
                        </li>
                    </c:if>
                </ul>

                <ul class="app-header__user">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">

                            <li class="app-header__notification">
    <div class="app-header__noti-trigger">
        <i class="fa-solid fa-bell fs-5"></i>
        <c:if test="${unreadCount > 0}">
            <span class="app-header__noti-badge">${unreadCount}</span>
        </c:if>
    </div>

    <div class="app-header__noti-dropdown">
        <div class="app-header__noti-header">
            <h6 class="m-0 fw-bold">Notifications</h6>
            <a href="${pageContext.request.contextPath}/mark-all-read" style="font-size: 12px; color: #3b82f6; text-decoration: none;">Mark all as read</a>
        </div>

        <ul class="app-header__noti-list">
            <c:choose>
                <c:when test="${empty notiList}">
                    <li class="p-3 text-center text-muted">No new notifications</li>
                </c:when>
                <c:otherwise>
                    <c:forEach var="noti" items="${notiList}">
                        <li class="app-header__noti-item ${noti.read ? '' : 'unread'}">
                            <a href="${pageContext.request.contextPath}${noti.linkUrl}" class="app-header__noti-link">
                                <div class="app-header__noti-icon ${noti.getIconClass()} text-white">
                                    <i class="fas ${noti.getIconName()}"></i>
                                </div>
                                <div class="app-header__noti-content">
                                    <p class="app-header__noti-text">${noti.message}</p>
                                    <span class="app-header__noti-time">${noti.getTimeAgo()}</span>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </ul>
        <div class="app-header__noti-footer">
            <a href="${pageContext.request.contextPath}/notifications">View all notifications</a>
        </div>
    </div>
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
                                        <a class="app-header__dropdown-link"
                                            href="${pageContext.request.contextPath}/profile">My Profile</a>
                                    </li>
                                    <c:if test="${sessionScope.userType == 'RENTER'}">
                                        <li class="app-header__dropdown-item">
                                            <a class="app-header__dropdown-link"
                                                href="${pageContext.request.contextPath}/payments">My Payment</a>
                                        </li>
                                    </c:if>
                                    <li class="app-header__dropdown-item">
                                        <a class="app-header__dropdown-link text-danger"
                                            href="${pageContext.request.contextPath}/logout">Logout</a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>

                        <c:otherwise>
                            <li class="app-header__menu-item">
                                <a class="app-header__menu-link fw-bold bg-dark text-white px-3"
                                    style="border-radius: 50px;"
                                    href="${pageContext.request.contextPath}/login">Login</a>
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

                .app-header__logo {
                    font-weight: 700;
                    font-size: 20px;
                    color: #000;
                    text-decoration: none;
                    margin-right: 40px;
                }

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

                .app-header__user {
                    margin-left: auto;
                    gap: 16px;
                }

                /* ==========================================
       START NOTIFICATION DROPDOWN
       ========================================== */
                .app-header__notification {
                    position: relative;
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
                    color: #4b5563;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .app-header__noti-trigger:hover {
                    background-color: #f3f4f6;
                    color: #111827;
                }

                .app-header__noti-badge {
                    position: absolute;
                    top: 0px;
                    right: 0px;
                    background-color: #ef4444;
                    color: white;
                    font-size: 10px;
                    font-weight: bold;
                    padding: 2px 5px;
                    border-radius: 10px;
                    min-width: 16px;
                    text-align: center;
                    border: 2px solid #ffffff;
                }

                /* DROPDOWN CONTAINER */
                .app-header__noti-dropdown {
                    position: absolute;
                    top: 120%;
                    right: -10px;
                    width: 320px;
                    background: #fff;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                    display: none;
                    flex-direction: column;
                    z-index: 10000;
                    overflow: hidden;
                }

                /* Show dropdown on hover */
                .app-header__notification:hover .app-header__noti-dropdown {
                    display: flex;
                }

                .app-header__noti-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 12px 16px;
                    border-bottom: 1px solid #eee;
                    background-color: #fafafa;
                }

                .app-header__noti-list {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                    max-height: 300px;
                    overflow-y: auto;
                }

                .app-header__noti-item {
                    border-bottom: 1px solid #f1f1f1;
                }

                .app-header__noti-item.unread {
                    background-color: #f0f7ff;
                    /* Highlight unread messages */
                }

                .app-header__noti-item:last-child {
                    border-bottom: none;
                }

                .app-header__noti-link {
                    display: flex;
                    align-items: flex-start;
                    padding: 12px 16px;
                    text-decoration: none;
                    color: #333;
                    transition: background-color 0.2s;
                }

                .app-header__noti-link:hover {
                    background-color: #f9fafb;
                }

                .app-header__noti-icon {
                    width: 32px;
                    height: 32px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 12px;
                    flex-shrink: 0;
                    font-size: 14px;
                }

                .app-header__noti-content {
                    flex: 1;
                }

                .app-header__noti-text {
                    font-size: 13px;
                    margin: 0 0 4px 0;
                    line-height: 1.4;
                }

                .app-header__noti-time {
                    font-size: 11px;
                    color: #888;
                }

                .app-header__noti-footer {
                    padding: 10px;
                    text-align: center;
                    border-top: 1px solid #eee;
                    background-color: #fafafa;
                }

                .app-header__noti-footer a {
                    font-size: 13px;
                    font-weight: 600;
                    color: #3b82f6;
                    text-decoration: none;
                }

                .app-header__noti-footer a:hover {
                    text-decoration: underline;
                }

                /* ==========================================
       END NOTIFICATION DROPDOWN
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