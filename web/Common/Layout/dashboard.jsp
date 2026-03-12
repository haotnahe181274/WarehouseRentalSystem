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
            body { 
                background-color: #f8f9fa; 
                margin: 0; 
                overflow-x: hidden; 
            }
            
            /* Cấu trúc chia đôi màn hình: Trái (Sidebar) - Phải (Main Panel) */
            .wrapper { 
                display: flex; 
                width: 100%; 
                min-height: 100vh; 
            }
            
            /* Cố định Sidebar bên trái */
            .wrapper > :first-child { 
                width: 260px; 
                min-width: 260px;
                height: 100vh;
                position: sticky;
                top: 0;
                z-index: 1020;
                background-color: #0b0f19; 
            }

            /* Main panel chứa Header và Content */
            .main-panel { 
                flex: 1; 
                min-width: 0; 
                display: flex; 
                flex-direction: column; 
            }

            /* Đảm bảo Header không tràn sang Sidebar */
            .main-panel > :first-child {
                position: sticky;
                top: 0;
                z-index: 1010;
                background-color: #ffffff; 
                box-shadow: 0 2px 4px rgba(0,0,0,0.02); 
            }

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
        <div class="wrapper">
            <jsp:include page="/Common/Layout/sidebar.jsp" />

            <div class="main-panel">
                
                <jsp:include page="/Common/Layout/header.jsp" />

                <div class="main-content">
                    <h2 class="mb-4 fw-bold">Dashboard</h2>

                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'Admin'}">
                            
                            <div class="row g-4">
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="icon-box"><i class="fa-solid fa-users"></i></div>
                                            <span class="trend-up">+12.5%</span>
                                        </div>
                                        <div class="stat-value">${totalUsers != null ? totalUsers : '0'}</div>
                                        <div class="stat-label">Total Users</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="icon-box"><i class="fa-solid fa-warehouse"></i></div>
                                            <span class="trend-up">+8.2%</span>
                                        </div>
                                        <div class="stat-value">${activeWarehouses != null ? activeWarehouses : '0'}</div>
                                        <div class="stat-label">Active Warehouses</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="icon-box"><i class="fa-regular fa-calendar-check"></i></div>
                                            <span class="trend-up">+15.3%</span>
                                        </div>
                                        <div class="stat-value">${totalBookings != null ? totalBookings : '0'}</div>
                                        <div class="stat-label">Total Bookings</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="icon-box"><i class="fa-solid fa-dollar-sign"></i></div>
                                            <span class="trend-up">+22.1%</span>
                                        </div>
                                        <div class="stat-value">$${monthlyRevenue != null ? monthlyRevenue : '0'}</div>
                                        <div class="stat-label">Monthly Revenue</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="chart-container">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <div>
                                                <h5 class="fw-bold mb-1">Monthly Revenue</h5>
                                                <small class="text-muted">Revenue trends in the current year</small>
                                            </div>
                                        </div>
                                        <canvas id="revenueChart" height="200"></canvas>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="chart-container">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <div>
                                                <h5 class="fw-bold mb-1">Total Bookings</h5>
                                                <small class="text-muted">Booking trends in the current year</small>
                                            </div>
                                        </div>
                                        <canvas id="bookingChart" height="200"></canvas>
                                    </div>
                                </div>
                            </div>

                            <script>
                                const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                                new Chart(revenueCtx, {
                                    type: 'line',
                                    data: {
                                        labels: ${revenueLabels != null ? revenueLabels : "['No Data']"},
                                        datasets: [{
                                            label: 'Revenue (VND)',
                                            data: ${revenueData != null ? revenueData : "[0]"},
                                            borderColor: '#10b981',
                                            backgroundColor: 'rgba(16, 185, 129, 0.05)',
                                            borderWidth: 2,
                                            fill: true,
                                            tension: 0.3
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: { legend: { display: false } },
                                        scales: {
                                            y: { 
                                                beginAtZero: true,
                                                ticks: { 
                                                    callback: function(value) { return (value / 1000000) + 'M'; } 
                                                }
                                            }
                                        }
                                    }
                                });

                                const bookingCtx = document.getElementById('bookingChart').getContext('2d');
                                new Chart(bookingCtx, {
                                    type: 'bar',
                                    data: {
                                        labels: ${bookingLabels != null ? bookingLabels : "['No Data']"},
                                        datasets: [{
                                            label: 'Bookings',
                                            data: ${bookingData != null ? bookingData : "[0]"},
                                            backgroundColor: '#6b7280',
                                            borderRadius: 4
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: { legend: { display: false } },
                                        scales: {
                                            y: { 
                                                beginAtZero: true,
                                                ticks: { stepSize: 1 } // Ép trục Y chỉ hiện số nguyên (1, 2, 3...)
                                            }
                                        }
                                    }
                                });
                            </script>
                        </c:when>

                        <c:when test="${sessionScope.user.role == 'Staff'}">
                            <div class="row g-4 mt-2">
                                <div class="col-md-6">
                                    <div class="stat-card task-card pending">
                                        <div class="d-flex align-items-center">
                                            <div class="icon-box" style="background-color: #fef3c7; color: #d97706;">
                                                <i class="fa-solid fa-spinner fa-spin-pulse"></i>
                                            </div>
                                            <div class="ms-4">
                                                <div class="stat-label text-uppercase fw-bold">Task đang thực hiện</div>
                                                <div class="stat-value text-warning mb-0">${pendingTasks != null ? pendingTasks : '0'}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="stat-card task-card completed">
                                        <div class="d-flex align-items-center">
                                            <div class="icon-box" style="background-color: #d1fae5; color: #059669;">
                                                <i class="fa-solid fa-check-double"></i>
                                            </div>
                                            <div class="ms-4">
                                                <div class="stat-label text-uppercase fw-bold">Task đã hoàn thiện</div>
                                                <div class="stat-value text-success mb-0">${completedTasks != null ? completedTasks : '0'}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info mt-4" role="alert">
                               <i class="fa-solid fa-circle-info me-2"></i> Chúc bạn một ngày làm việc hiệu quả! Hãy kiểm tra danh sách <a href="staffTask.jsp" class="alert-link">Nhiệm vụ của tôi</a> để biết chi tiết công việc hôm nay.
                            </div>
                        </c:when>
                    </c:choose>
                </div>

                <jsp:include page="/Common/Layout/footer.jsp" />
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>