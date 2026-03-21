<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- TÍNH NĂNG PHÂN QUYỀN LỚP COMPONENT --%>
<c:if test="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'Admin'}">
    
    <div class="row g-4 mt-1">
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
        // Vì file dashboard.jsp (file gốc) đã load thư viện Chart.js ở thẻ <head>, 
        // nên đoạn script ở đây có thể gọi hàm Chart() bình thường.
        
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
                        ticks: { callback: function(value) { return (value / 1000000) + 'M'; } }
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
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });
    </script>

</c:if>