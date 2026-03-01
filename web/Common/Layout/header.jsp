<%-- Document : header Created on : Feb 2, 2026, 2:40:52 PM Author : ad --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


            <nav class="app-header">

                <!-- LOGO -->
                <a class="app-header__logo" href="${pageContext.request.contextPath}/homepage">
                    WareSpace
                </a>

                <!-- LEFT MENU -->
                <ul class="app-header__menu">
                    <li class="app-header__menu-item">
                        <a class="app-header__menu-link" href="${pageContext.request.contextPath}/homepage">Homepage</a>
                    </li>

                    <c:if test="${sessionScope.userType == 'RENTER'}">
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/rentList">My
                                Rental</a>
                        </li>
                        <li class="app-header__menu-item">
                            <a class="app-header__menu-link"
                                href="${pageContext.request.contextPath}/contracts">Contract</a>
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
                                href="${pageContext.request.contextPath}/Common/homepage/about.jsp">
                                About us
                            </a>
                        </li>
                    </c:if>
                </ul>

                <!-- RIGHT USER -->
                <ul class="app-header__user">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="app-header__user-info">
                                <div class="app-header__user-trigger app-header__user-box">
                                    <img class="app-header__avatar"
                                        src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image}"
                                        width="32" height="32"
                                        onerror="this.src='${pageContext.request.contextPath}/resources/user/image/default.jpg'">

                                    <span class="app-header__username">
                                        ${sessionScope.user.name}
                                    </span>
                                </div>

                                <ul class="app-header__dropdown app-header__user-box">

                                    <li class="app-header__dropdown-item">
                                        <a class="app-header__dropdown-link"
                                            href="${pageContext.request.contextPath}/profile">
                                            My Profile
                                        </a>
                                    </li>

                                    <!-- Nếu là RENTER thì thêm My Payment -->
                                    <c:if test="${sessionScope.userType == 'RENTER'}">
                                        <li class="app-header__dropdown-item">
                                            <a class="app-header__dropdown-link"
                                                href="${pageContext.request.contextPath}/payments">
                                                My Payment
                                            </a>
                                        </li>
                                    </c:if>

                                    <li class="app-header__dropdown-item">
                                        <a class="app-header__dropdown-link"
                                            href="${pageContext.request.contextPath}/logout">
                                            Logout
                                        </a>
                                    </li>

                                </ul>
                            </li>
                        </c:when>

                        <c:otherwise>
                            <li class="app-header__menu-item">
                                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/login">
                                    Login
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <!-- RENTER ONLY -->

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

                /* ===== MENU LINK ===== */
                .app-header__menu-link {
                    display: block;
                    padding: 6px 12px;
                    border-radius: 6px;

                    color: #000;
                    text-decoration: none;
                }

                .app-header__menu-link:hover {
                    background-color: #f2f2f2;
                }

                /* ===== USER (RIGHT SIDE) ===== */
                .app-header__user {
                    margin-left: auto;
                }

                .app-header__user-info {
                    position: relative;
                    z-index: 9999;
                }

                /* clickable area (avatar + name) */
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

                /* avatar */
                .app-header__avatar {
                    width: 32px;
                    height: 32px;
                    border-radius: 50%;
                    object-fit: cover;
                }

                /* username */
                .app-header__username {
                    font-size: 15px;
                    font-weight: 500;
                    white-space: nowrap;
                }

                /* ===== DROPDOWN ===== */
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

                /* dropdown link */
                .app-header__dropdown-link {
                    display: block;
                    padding: 8px 16px;

                    color: #000;
                    text-decoration: none;
                }



                .app-header__dropdown-item {
                    list-style: none;
                }

                .app-header__dropdown-link:hover {
                    background-color: #f2f2f2;
                }

                /* show dropdown on hover user */
                .app-header__user-info:hover .app-header__dropdown {
                    display: flex;
                }

                .app-header__user-box {
                    min-width: 170px;
                }

                /* trigger */
                .app-header__user-trigger {
                    justify-content: center;
                }
            </style>