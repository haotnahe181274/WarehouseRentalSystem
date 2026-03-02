<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>${w.name} | WRS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />

    <style>
        body { font-family: Arial, sans-serif; background: #f5f6fa; }
        .layout { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 24px; background: #f5f7fb; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); background: white; }
        
        /* Gallery & Zone */
        .main-img-frame { height: 400px; overflow: hidden; border-radius: 12px; }
        .main-img-frame img { width: 100%; height: 100%; object-fit: cover; }
        .thumb-img { height: 80px; width: 100%; object-fit: cover; border-radius: 8px; cursor: pointer; opacity: 0.6; transition: 0.2s; }
        .thumb-img:hover { opacity: 1; border: 2px solid #3b82f6; }
        .zone-card { border: 1px solid #e5e7eb; border-radius: 8px; padding: 15px; background: #fff; transition: 0.2s; }
        .zone-card:hover { border-color: #3b82f6; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .status-badge { font-size: 12px; font-weight: 600; padding: 2px 8px; border-radius: 9999px; }
        .status-available { background: #d1fae5; color: #065f46; }
        .status-occupied { background: #fee2e2; color: #991b1b; }

        /* Form Sidebar */
        .right-sidebar { position: sticky; top: 20px; z-index: 10; }
        .btn-submit { background: #111827; color: white; width: 100%; padding: 12px; transition: 0.2s; }
        .btn-submit:hover { background: #1f2937; color: white; transform: translateY(-1px); }

        /* Tùy chỉnh Calendar Nhỏ Gọn */
        .fc { font-size: 0.85rem; } 
        .fc .fc-button { padding: 0.3rem 0.6rem !important; font-size: 0.8rem !important; text-transform: capitalize; }
        .fc-daygrid-day-frame { min-height: 2.5rem !important; } 
        .fc-event { border: none !important; border-radius: 4px !important; }
        .fc-daygrid-day-number { text-decoration: none !important; color: #4b5563 !important; font-weight: 500; }
        .fc-day:not(.fc-day-other) { cursor: pointer; }
        .fc-day-other .fc-bg-event { display: none !important; }
        .fc-day-other .fc-event-title { display: none !important; }
    </style>
</head>

<body>

    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="layout">


        <div class="main-content">

            <div class="bg-white border-bottom py-4 mb-4">
                <div class="container d-flex justify-content-between align-items-center">
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="fas fa-warehouse fs-4 text-primary"></i>
                            <h2 class="fw-bold mb-0">${w.name}</h2>
                        </div>
                        <p class="text-muted mb-0 mt-1 ms-1"><i class="fas fa-map-marker-alt me-1"></i> ${w.address}</p>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${w.status == 1}">
                                <span class="badge bg-success rounded-pill px-3 py-2 fs-6">
                                    <i class="fas fa-check-circle me-1"></i> Available
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary rounded-pill px-3 py-2 fs-6">
                                    <i class="fas fa-tools me-1"></i> Maintenance
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="container pb-5">
                <div class="row">

                    <div class="col-lg-8">

                        <div class="card-custom p-3 mb-4">
                            <h5 class="fw-bold mb-3">Warehouse Gallery</h5>
                            <c:set var="mainDisplayUrl" value="default-placeholder.jpg" />
                            <c:if test="${not empty images}">
                                <c:set var="mainDisplayUrl" value="${images[0].imageUrl}" />
                                <c:forEach items="${images}" var="item">
                                    <c:if test="${item.primary}">
                                        <c:set var="mainDisplayUrl" value="${item.imageUrl}" />
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <div class="main-img-frame mb-3 text-center border bg-light rounded"
                                 style="height: 400px; display: flex; align-items: center; justify-content: center;">
                                <img src="${pageContext.request.contextPath}/resources/warehouse/image/${mainDisplayUrl}"
                                     id="displayImg" style="max-height: 100%; max-width: 100%; object-fit: contain;"
                                     onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                            </div>

                            <div class="row g-2">
                                <c:forEach items="${images}" var="img">
                                    <div class="col-3 col-md-2">
                                        <div class="border rounded p-1" style="cursor: pointer;">
                                            <img src="${pageContext.request.contextPath}/resources/warehouse/image/${img.imageUrl}"
                                                 class="thumb-img w-100" style="height: 60px; object-fit: cover;"
                                                 onclick="changeImage(this.src)"
                                                 onerror="this.src='https://via.placeholder.com/80x80'">
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold mb-0">Floor Plan View <span class="text-muted fs-6 fw-normal ms-2">(Nhấn vào Storage Unit để xem lịch trống)</span></h5>
                                
                                <c:if test="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'manager'}">
                                    <button class="btn btn-sm btn-dark" data-bs-toggle="modal" data-bs-target="#addZoneModal">
                                        <i class="fa fa-plus"></i> Add New Storage Unit
                                    </button>
                                </c:if>
                                </div>

                            <div class="row g-3">
                                <c:forEach items="${units}" var="u">
                                    <div class="col-md-4">
                                        <div class="zone-card h-100 d-flex flex-column justify-content-between"
                                             id="zone-card-${u.unitId}"
                                             style="cursor: pointer;"
                                             onclick="viewCalendarForUnit(${u.unitId}, '${u.unitCode}')">
                                            <div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <h6 class="fw-bold text-dark">${u.unitCode}</h6>
                                                    <c:choose>
                                                        <c:when test="${u.status == 1}">
                                                            <span class="status-badge status-available">Available</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-occupied">Occupied</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <p class="small text-muted mb-3" style="min-height: 40px;">${u.description}</p>
                                                <h5 class="fw-bold text-dark mb-0">
                                                    <fmt:formatNumber value="${u.area}" />
                                                    <span class="fs-6 text-muted">sq ft</span>
                                                </h5>
                                            </div>
                                            <div class="mt-3 pt-3 border-top">
                                                <small class="fw-bold text-primary fs-6">
                                                    <fmt:formatNumber value="${u.pricePerUnit}" /> VND <span class="text-muted fw-normal">/tháng</span>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                    </div> <div class="col-lg-4">
                        <div class="right-sidebar"> 

                            <div class="card-custom p-3 mb-3" id="calendarWidget" style="display: none;">
                                
                                <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                    <h6 class="fw-bold mb-0" id="calendarTitle">Lịch trống</h6>
                                    <button class="btn btn-sm btn-light border text-muted" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCalendar" aria-expanded="true">
                                        <i class="fas fa-chevron-up" id="toggleIcon"></i> Ẩn/Hiện
                                    </button>
                                </div>
                                
                                <div class="collapse show" id="collapseCalendar">
                                    <div class="row g-2 mt-1 mb-3">
                                        <div class="col-6">
                                            <select id="selectMonth" class="form-select form-select-sm border-secondary text-dark fw-bold">
                                                <option value="01">Tháng 1</option>
                                                <option value="02">Tháng 2</option>
                                                <option value="03">Tháng 3</option>
                                                <option value="04">Tháng 4</option>
                                                <option value="05">Tháng 5</option>
                                                <option value="06">Tháng 6</option>
                                                <option value="07">Tháng 7</option>
                                                <option value="08">Tháng 8</option>
                                                <option value="09">Tháng 9</option>
                                                <option value="10">Tháng 10</option>
                                                <option value="11">Tháng 11</option>
                                                <option value="12">Tháng 12</option>
                                            </select>
                                        </div>
                                        <div class="col-6">
                                            <select id="selectYear" class="form-select form-select-sm border-secondary text-dark fw-bold"></select>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-center align-items-center mb-2" style="font-size: 0.75rem;">
                                        <span class="me-3"><i class="fa fa-square text-white border border-secondary me-1"></i> Ngày trống</span>
                                        <span><i class="fa fa-square me-1" style="color: #ffb3ba;"></i> Đã được thuê</span>
                                    </div>
                                    
                                    <div id="bookingCalendar"></div>
                                </div>
                            </div>

                            <c:if test="${sessionScope.user.role != 'Admin' && sessionScope.user.role != 'admin' && sessionScope.user.role != 'Manager' && sessionScope.user.role != 'manager'}">
                                
                                <div class="card-custom p-4 text-center mt-3">
                                    <h5 class="fw-bold mb-2">Bạn muốn thuê kho này?</h5>
                                    <p class="text-muted small mb-4">Nhấn vào nút bên dưới để chuyển sang trang tạo yêu cầu Đặt thuê chi tiết.</p>
                                    
                                    <a href="${pageContext.request.contextPath}/createRentRequest?id=${w.warehouseId}" class="btn btn-submit rounded-pill fw-bold">
                                        <i class="fas fa-file-contract me-2"></i> Đi tới trang Đặt Thuê
                                    </a>
                                </div>

                            </c:if>
                            </div> 
                    </div> 

                </div> 
                
                <jsp:include page="/feedback.jsp">
                    <jsp:param name="embedded" value="true" />
                </jsp:include>

            </div> 
        </div> 
    </div> 
    
    <jsp:include page="/Common/Layout/footer.jsp" />

    <div class="modal fade" id="addZoneModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title">Thêm Ô Chứa Mới (Storage Unit)</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/warehouse/unit" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="warehouseId" value="${w.warehouseId}">
                        <div class="mb-3">
                            <label class="form-label">Mã Storage Unit (Ví dụ: SU-A1)</label>
                            <input type="text" name="unitCode" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Diện tích (sq ft)</label>
                                <input type="number" step="0.1" name="area" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giá thuê (VND)</label>
                                <input type="number" name="price" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="1">Available (Trống)</option>
                                <option value="2">Occupied (Đã thuê)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả đặc điểm</label>
                            <textarea name="description" class="form-control" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu Storage Unit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>

    <script>
        var allZoneEvents = ${empty unitEventsJson ? '{}' : unitEventsJson};
        var calendar;
        var currentSelectedUnitId = null;

        document.addEventListener('DOMContentLoaded', function () {
            
            var yearSelect = document.getElementById('selectYear');
            var currentYear = new Date().getFullYear();
            
            for (var i = currentYear - 1; i <= currentYear + 15; i++) { 
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = 'Năm ' + i;
                yearSelect.appendChild(opt);
            }

            var calendarEl = document.getElementById('bookingCalendar');
            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                height: 'auto',
                firstDay: 1, 
                showNonCurrentDates: false, 
                fixedWeekCount: false,
                
                buttonText: {
                    today: 'Hôm nay'
                },
                
                headerToolbar: {
                    left: 'today', 
                    center: '',
                    right: 'prev,next' 
                },
                events: [],
                
                datesSet: function(info) {
                    var date = info.view.currentStart;
                    var m = date.getMonth() + 1;
                    var y = date.getFullYear();
                    
                    document.getElementById('selectMonth').value = m < 10 ? '0' + m : m;
                    document.getElementById('selectYear').value = y;
                }
            });

            calendar.render();

            function jumpToDate() {
                var m = document.getElementById('selectMonth').value;
                var y = document.getElementById('selectYear').value;
                calendar.gotoDate(y + '-' + m + '-01'); 
            }
            
            document.getElementById('selectMonth').addEventListener('change', jumpToDate);
            document.getElementById('selectYear').addEventListener('change', jumpToDate);


            var myCollapsible = document.getElementById('collapseCalendar')
            myCollapsible.addEventListener('hide.bs.collapse', function () {
                document.getElementById('toggleIcon').className = 'fas fa-chevron-down';
            })
            myCollapsible.addEventListener('show.bs.collapse', function () {
                document.getElementById('toggleIcon').className = 'fas fa-chevron-up';
            })
        });

        function viewCalendarForUnit(unitId, unitCode) {
            currentSelectedUnitId = unitId; 

            document.querySelectorAll('.zone-card').forEach(card => card.style.borderColor = '#e5e7eb');
            document.getElementById('zone-card-' + unitId).style.borderColor = '#3b82f6';

            var widget = document.getElementById('calendarWidget');
            widget.style.display = 'block'; 
            
            var bsCollapse = new bootstrap.Collapse(document.getElementById('collapseCalendar'), { toggle: false });
            bsCollapse.show();
            
            setTimeout(function() { calendar.updateSize(); }, 200); 

            document.getElementById('calendarTitle').innerHTML = 'Lịch Storage Unit: <span class="text-primary">' + unitCode + '</span>';

            calendar.removeAllEvents();
            if (allZoneEvents[unitId] && allZoneEvents[unitId].length > 0) {
                allZoneEvents[unitId].forEach(function (eventData) {
                    delete eventData.title; 
                    eventData.allDay = true;
                    eventData.display = 'background';
                    eventData.color = '#ffb3ba'; 
                    calendar.addEvent(eventData);
                });
            }
        }

        function changeImage(src) {
            document.getElementById('displayImg').src = src;
        }
    </script>

</body>
</html>