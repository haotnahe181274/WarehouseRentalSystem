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

        <style>
            body { background-color: #f8f9fa; overflow-x: hidden; }
            .wrapper { display: flex; width: 100%; min-height: 100vh; }
            .main-panel { flex: 1; min-width: 0; display: flex; flex-direction: column; }
            .main-content { padding: 24px; flex: 1; }
            .stat-card { border: 1px solid #eef0f2; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); background: #fff; padding: 20px; height: 100%; }
            .icon-box { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; background-color: #f3f4f6; border-radius: 8px; color: #4b5563; font-size: 1.2rem; }
            .stat-value { font-size: 1.8rem; font-weight: 700; margin-top: 15px; margin-bottom: 5px; color: #111827; }
            .stat-label { color: #6b7280; font-size: 0.9rem; }
            .trend-up { color: #10b981; font-weight: 600; font-size: 0.9rem; }
            .chart-container { border: 1px solid #eef0f2; border-radius: 12px; background: #fff; padding: 20px; margin-top: 24px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
            .task-card { border-left: 5px solid; }
            .task-card.pending { border-left-color: #f59e0b; }
            .task-card.completed { border-left-color: #10b981; }
        </style>
    </head>
    <body>
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="wrapper" style="display: flex; min-height: calc(100vh - [chiều_cao_header]);">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="main-panel" style="flex: 1;">
            <div class="main-content">
                <h2 class="mb-4 fw-bold">Dashboard</h2>
                <jsp:include page="dashboard_stats_cards.jsp" />
                <jsp:include page="dashboard_charts.jsp" />
            </div>
            <jsp:include page="/Common/Layout/footer.jsp" />
        </div>
    </div>
</body>
</html>