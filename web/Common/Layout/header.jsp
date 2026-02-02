<%-- 
    Document   : header
    Created on : Feb 2, 2026, 2:40:52 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    

</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home#dentists"></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home#services"></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home#contact"></a>
                    </li>
                </ul>
                
                <div class="d-flex">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <div class="dropdown">
                                <a class="btn btn-outline-primary dropdown-toggle" href="#" role="button" 
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    ${sessionScope.user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                                        <i class="fas fa-tachometer-alt me-2"></i>Bảng Điều Khiển
                                    </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng Xuất
                                    </a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn-login">
                                Đăng Nhập
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

