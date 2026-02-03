<%-- 
    Document   : header
    Created on : Feb 2, 2026, 2:40:52 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">

        <!-- LOGO -->
        <a class="navbar-brand fw-bold" href="homepage">
            WareSpace
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <!-- HOME -->
                <li class="nav-item">
                    <a class="nav-link" href="homepage">Home</a>
                </li>

                <!-- RENTER MENU -->
                <c:if test="${sessionScope.role == 'RENTER'}">

                    <li class="nav-item">
                        <a class="nav-link" href="my-rentals">My Rentals</a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="contracts">Contracts</a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="payments">Payments</a>
                    </li>

                </c:if>

                <!-- ABOUT -->
                <li class="nav-item">
                    <a class="nav-link" href="aboutUs">About us</a>
                </li>

            </ul>

            <!-- AUTH -->
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <span class="nav-link">
                                Hi, ${sessionScope.user.name}
                            </span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout">Logout</a>
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

