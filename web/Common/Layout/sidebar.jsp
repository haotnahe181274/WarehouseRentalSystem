<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <style>
            /* ===== SIDEBAR ===== */
            .sidebar {
                width: 220px;
                background: black;
                color: white;
                flex-shrink: 0;
            }

            .sidebar-inner {
                /* Sticky positioning so it stops when the flex container (layout) ends */
                position: sticky;
                top: 60px;
                /* sit just below the header */
                max-height: calc(100vh - 60px);
                overflow-y: auto;
            }


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

            /* Active */
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
        </style>

        <!-- ===== SIDEBAR ===== -->
        <div class="sidebar">
            <div class="sidebar-inner">
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

                        <li><a href="${pageContext.request.contextPath}/user/list">Users Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/warehouse">Warehouses Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/rentList">Rental Requests</a></li>
                        <li><a href="${pageContext.request.contextPath}/contract"> Contracts Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/feedbackManagement">Feedback Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/incident">Reports Management</a></li>
                    </c:if>

                    <!-- MANAGER -->
                    <c:if test="${sessionScope.role == 'Manager'}">

                        <li><a href="${pageContext.request.contextPath}/user/list">Users Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/warehouse">Warehouses Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/rentList">Rental Requests</a></li>
                        <li><a href="${pageContext.request.contextPath}/contract"> Contracts Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/staffAssignment">Staff Assignment Management</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/feedbackManagement">Feedback Management</a></li>
                        <li><a href="${pageContext.request.contextPath}/incident">Reports Management</a></li>
                    </c:if>

                    <!-- STAFF -->
                    <c:if test="${sessionScope.role == 'Staff'}">

                        <li><a href="${pageContext.request.contextPath}/staffTask">Tasks</a></li>
                        <li><a href="${pageContext.request.contextPath}/staffCheck">Inventory Check</a></li>
                        <li><a href="${pageContext.request.contextPath}/incident"> Incidents</a></li>
                    </c:if>

                </ul>



            </div>
        </div>