<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>System Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
        <style>
            /* Page-specific styles only */
            .chart-container {
                border: 1px solid var(--mgmt-border);
                border-radius: var(--mgmt-radius);
                background: var(--mgmt-card-bg);
                padding: 20px;
                margin-top: 24px;
                box-shadow: var(--mgmt-shadow);
            }
        </style>
    </head>
    <body>
    <jsp:include page="/Common/Layout/header.jsp" />
    <jsp:include page="/message/popupMessage.jsp" />
    <div class="layout">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="main-content">
            <h3>Dashboard</h3>
             <div class="stats-container mb-4">
            <jsp:include page="/Common/Layout/stats_cards.jsp">
                    <jsp:param name="label1" value="Total Users" />
                    <jsp:param name="value1" value="${totalUsers != null ? totalUsers : '0'}" />
                    <jsp:param name="icon1"  value="fa-solid fa-users" /> 
                    <jsp:param name="color1" value="primary" />

                    <jsp:param name="label2" value="Total Warehouses" />
                    <jsp:param name="value2" value="${totalWarehouses != null ? totalWarehouses : '0'}" />
                    <jsp:param name="icon2"  value="fa-solid fa-warehouse" />
                    <jsp:param name="color2" value="success" />

                    <jsp:param name="label3" value="Total Bookings" />
                    <jsp:param name="value3" value="${totalBookings != null ? totalBookings : '0'}" />
                    <jsp:param name="icon3"  value="fa-solid fa-calendar-check" /> 
                    <jsp:param name="color3" value="success" />
                    
                    <jsp:param name="label4" value="Monthly Revenue" />
                    <jsp:param name="value4" value="${monthlyRevenue != null ? monthlyRevenue : '0'}" />
                    <jsp:param name="icon4"  value="fa-solid fa-sack-dollar" /> 
                    <jsp:param name="color4" value="primary" />
                </jsp:include>
            </div>
            <jsp:include page="dashboard_charts.jsp" />
        </div>
    </div>
    <jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>