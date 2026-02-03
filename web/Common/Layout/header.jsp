<%-- Document : header Created on : Feb 2, 2026, 2:40:52 PM Author : ad --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
                <div class="container-fluid">

                    <!-- LOGO -->
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/homepage">
                        WareSpace
                    </a>

                    <div class="collapse navbar-collapse">

                        <!-- LEFT MENU -->
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                            <!-- HOME (ALL ROLE) -->
                            <li class="nav-item">
                                <a class="nav-link" href="homepage">Home</a>
                            </li>

                            <!-- RENTER ONLY -->
                            <c:if test="${sessionScope.userType == 'RENTER'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="my-rentals">My Rentals</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="contracts">Contracts</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="payments">Payments</a>
                                </li>
                                <!-- ABOUT -->
                                <li class="nav-item">
                                    <a class="nav-link" href="aboutUs">About us</a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                <c:if test="${sessionScope.role == 'Admin'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="dashboard">Demo</a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.role == 'Staff'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="manage-warehouses">Demo</a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.role == 'Manager'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="manage-warehouses">Demo</a>
                                    </li>
                                </c:if>
                            </c:if>


                        </ul>

                        <!-- RIGHT USER -->
                        <ul class="navbar-nav ms-auto">

                            <c:choose>


                                <c:when test="${not empty sessionScope.user}">
                                    <li class="nav-item dropdown">

                                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                                            role="button" data-bs-toggle="dropdown">

                                            <!-- AVATAR -->
                                            <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image}"
                                                class="rounded-circle me-2" width="32" height="32"
                                                onerror="this.src='${pageContext.request.contextPath}/resources/user/image/default.jpg'">

                                            <!-- NAME -->
                                            <span>${sessionScope.user.name}</span>
                                        </a>

                                        <!-- DROPDOWN MENU -->
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm">

                                            <li>
                                                <a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/user/list?action=view&id=${sessionScope.user.id}&type=${sessionScope.user.type}">
                                                    My Profile
                                                </a>
                                            </li>

                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>

                                            <li>
                                                <a class="dropdown-item text-danger"
                                                    href="${pageContext.request.contextPath}/logout">
                                                    Logout
                                                </a>
                                            </li>

                                        </ul>
                                    </li>
                                </c:when>


                                <c:otherwise>
                                    <li class="nav-item">
                                        <a class="nav-link" href="login">Login</a>
                                    </li>
                                </c:otherwise>

                            </c:choose>

                        </ul>

                    </div>
                </div>
            </nav>