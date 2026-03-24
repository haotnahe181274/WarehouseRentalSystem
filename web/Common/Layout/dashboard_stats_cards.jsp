    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <%-- TÍNH NĂNG PHÂN QUYỀN LỚP COMPONENT: Chỉ hiển thị nếu là Admin hoặc Manager --%>
    <c:if test="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'Admin'}">

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box"><i class="fa-solid fa-users"></i></div>
                      
                    </div>
                    <div class="stat-value">${totalUsers != null ? totalUsers : '0'}</div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box"><i class="fa-solid fa-warehouse"></i></div>
                     
                    </div>
                    <div class="stat-value">${totalWarehouses != null ? totalWarehouses : '0'}</div>
                    <div class="stat-label">Total Warehouses</div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box"><i class="fa-regular fa-calendar-check"></i></div>
                      
                    </div>
                    <div class="stat-value">${totalBookings != null ? totalBookings : '0'}</div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box"><i class="fa-solid fa-dollar-sign"></i></div> 
                    </div>
                    <div class="stat-value">$${monthlyRevenue != null ? monthlyRevenue : '0'}</div>
                    <div class="stat-label">Monthly Revenue</div>
                </div>
            </div>

        </div>
    </c:if>

    <%-- TÍNH NĂNG PHÂN QUYỀN LỚP COMPONENT: Cho Staff trong Overview (Overview = Overview) --%>
    <c:if test="${sessionScope.user.role == 'Staff'}">
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card task-card pending">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box" style="background-color: #fef3c7; color: #d97706;">
                            <i class="fa-solid fa-spinner fa-spin-pulse"></i>
                        </div>
                    </div>
                    <div class="stat-value text-warning">${pendingTasks != null ? pendingTasks : '0'}</div>
                    <div class="stat-label">Task đang thực hiện</div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card task-card completed">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="icon-box" style="background-color: #d1fae5; color: #059669;">
                            <i class="fa-solid fa-check-double"></i>
                        </div>
                    </div>
                    <div class="stat-value text-success">${completedTasks != null ? completedTasks : '0'}</div>
                    <div class="stat-label">Task đã hoàn thiện</div>
                </div>
            </div>
        </div>
    </c:if>



