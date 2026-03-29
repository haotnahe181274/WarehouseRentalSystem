<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>${w.name} | WRS</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />

                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background: #f5f6fa;
                    }

                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        padding: 24px;
                        background: #f5f7fb;
                    }

                    .card-custom {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                        background: white;
                    }

                    .main-img-frame {
                        height: 400px;
                        overflow: hidden;
                        border-radius: 12px;
                    }

                    .main-img-frame img {
                        width: 100%;
                        height: 100%;
                        object-fit: contain;
                    }

                    .thumb-img {
                        height: 80px;
                        width: 100%;
                        object-fit: cover;
                        border-radius: 8px;
                        cursor: pointer;
                        opacity: 0.6;
                        transition: 0.2s;
                    }

                    .thumb-img:hover {
                        opacity: 1;
                        border: 2px solid #3b82f6;
                    }

                    .zone-card {
                        border: 1px solid #e5e7eb;
                        border-radius: 8px;
                        padding: 15px;
                        background: #fff;
                        transition: 0.2s;
                        position: relative;
                    }

                    .zone-card:hover {
                        border-color: #3b82f6;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .right-sidebar {
                        position: sticky;
                        top: 20px;
                        z-index: 10;
                    }

                    .btn-submit {
                        background: #111827;
                        color: white;
                        width: 100%;
                        padding: 12px;
                        transition: 0.2s;
                        border-radius: 50px;
                        text-decoration: none;
                        display: block;
                        font-weight: 600;
                        text-align: center;
                    }

                    .btn-submit:hover {
                        background: #1f2937;
                        color: white;
                        transform: translateY(-1px);
                    }

                    .fc {
                        font-size: 0.85rem;
                    }

                    .fc .fc-button {
                        padding: 0.3rem 0.6rem !important;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/Common/Layout/header.jsp" />
                <jsp:include page="/message/popupMessage.jsp" />
                <div class="layout">
                    <%-- Xác định quyền hạn --%>
                        <c:set var="isStaff"
                            value="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'Admin' }" />

                        <c:if test="${isStaff}">
                            <jsp:include page="/Common/Layout/sidebar.jsp" />
                        </c:if>

                        <div class="main-content">
                            <c:if test="${not empty sessionScope.successMsg}">
                                <div class="container mt-2 mb-3">
                                    <div class="alert alert-success alert-dismissible fade show shadow-sm border-0"
                                        role="alert">
                                        <i class="fas fa-check-circle me-2 fs-5 align-middle"></i>
                                        <span class="align-middle fw-bold">${sessionScope.successMsg}</span>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </div>
                                <c:remove var="successMsg" scope="session" />
                            </c:if>

                            <div class="bg-white border-bottom py-4 mb-4">
                                <div class="container d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="fas fa-warehouse fs-4 text-primary"></i>
                                            <h2 class="fw-bold mb-0">${w.name}</h2>
                                        </div>
                                        <p class="text-muted mb-0 mt-1 ms-1"><i class="fas fa-map-marker-alt me-1"></i>
                                            ${w.address}</p>
                                    </div>
                                </div>
                            </div>

                            <div class="container pb-5">
                                <div class="row">
                                    <div class="col-lg-8">
                                        <div class="card-custom p-3 mb-4">
                                            <h5 class="fw-bold mb-3">Warehouse Gallery</h5>
                                            <c:set var="mainUrl"
                                                value="${not empty images ? images[0].imageUrl : 'default.jpg'}" />
                                            <c:forEach items="${images}" var="item">
                                                <c:if test="${item.primary}">
                                                    <c:set var="mainUrl" value="${item.imageUrl}" />
                                                </c:if>
                                            </c:forEach>
                                            <div class="main-img-frame mb-3 text-center border bg-light rounded">
                                                <img src="${pageContext.request.contextPath}/resources/warehouse/image/${mainUrl}"
                                                    id="displayImg"
                                                    onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                                            </div>
                                            <div class="row g-2">
                                                <c:forEach items="${images}" var="img">
                                                    <div class="col-3 col-md-2">
                                                        <div class="border rounded p-1" style="cursor: pointer;">
                                                            <img src="${pageContext.request.contextPath}/resources/warehouse/image/${img.imageUrl}"
                                                                class="thumb-img w-100" style="height: 60px;"
                                                                onclick="changeImage(this.src)"
                                                                onerror="this.src='https://via.placeholder.com/80x80'">
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div class="mb-4">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <div>
                                                    <h5 class="fw-bold mb-0">Floor Plan View
                                                        <span class="text-muted fs-6 fw-normal ms-2">(Click to view
                                                            calendar)</span>
                                                    </h5>
                                                </div>

                                                <%-- Chỉ Manager/Admin mới thấy nút thêm mới --%>
                                                    <c:if test="${isStaff}">
                                                        <div class="d-flex gap-2">
                                                            <a href="${pageContext.request.contextPath}/warehouse/detail?action=addUnit&warehouseId=${w.warehouseId}"
                                                                class="btn btn-sm btn-dark shadow-sm">
                                                                <i class="fa fa-plus-circle me-1"></i> Add New Storage
                                                                Unit
                                                            </a>
                                                        </div>
                                                    </c:if>
                                            </div>

                                            <div class="card-custom p-3 mb-3 bg-light border border-light">
                                                <form action="${pageContext.request.contextPath}/warehouse/detail"
                                                    method="GET" class="row align-items-end g-2">
                                                    <input type="hidden" name="id" value="${w.warehouseId}">
                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold small text-muted mb-1">Start
                                                            Date</label>
                                                        <input type="date" name="searchStart" id="searchStart"
                                                            class="form-control form-control-sm" value="${searchStart}"
                                                            required>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold small text-muted mb-1">End
                                                            Date</label>
                                                        <input type="date" name="searchEnd" id="searchEnd"
                                                            class="form-control form-control-sm" value="${searchEnd}"
                                                            required>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <button type="submit"
                                                            class="btn btn-primary btn-sm w-100 fw-bold"><i
                                                                class="fas fa-search me-1"></i> Find Available</button>
                                                    </div>
                                                    <div class="col-md-1 text-end">
                                                        <a href="${pageContext.request.contextPath}/warehouse/detail?id=${w.warehouseId}"
                                                            class="btn btn-light btn-sm border w-100"><i
                                                                class="fas fa-undo"></i></a>
                                                    </div>
                                                </form>
                                            </div>

                                            <div class="row g-3">
                                                <c:choose>
                                                    <c:when test="${empty units}">
                                                        <div class="col-12 text-center py-5">
                                                            <i class="fas fa-box-open fs-1 text-muted mb-3 d-block"></i>
                                                            <h5 class="text-danger fw-bold">No Storage Units Available
                                                            </h5>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${units}" var="u">
                                                            <%-- ĐIỀU KIỆN HIỂN THỊ: Renter chỉ thấy unit active,
                                                                Manager thấy tất cả --%>
                                                                <c:if test="${u.status != 2 || isStaff}">
                                                                    <div class="col-md-4">
                                                                        <div class="zone-card h-100 d-flex flex-column justify-content-between"
                                                                            id="zone-card-${u.unitId}"
                                                                            style="cursor: pointer; ${u.status == 0 ? 'opacity: 0.5; border: 1px dashed #dc3545;' : ''}"
                                                                            onclick="viewCalendarForUnit(${u.unitId}, '${u.unitCode}')">
                                                                            <div>
                                                                                <div
                                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                                    <h6 class="fw-bold text-dark mt-1">
                                                                                        ${u.unitCode}
                                                                                        <c:if test="${u.status == 0}">
                                                                                            <span
                                                                                                class="badge bg-danger ms-1"
                                                                                                style="font-size: 0.65rem;">Hidden</span>
                                                                                        </c:if>
                                                                                    </h6>
                                                                                    <c:if test="${isStaff}">
                                                                                        <a href="${pageContext.request.contextPath}/warehouse/detail?action=editUnit&unitId=${u.unitId}&warehouseId=${w.warehouseId}"
                                                                                            class="btn btn-sm btn-outline-primary py-0 px-2"
                                                                                            onclick="event.stopPropagation();">
                                                                                            <i
                                                                                                class="fas fa-edit fs-7"></i>
                                                                                        </a>
                                                                                    </c:if>
                                                                                </div>
                                                                                <p class="small text-muted mb-3"
                                                                                    style="min-height: 40px;">
                                                                                    ${u.description}</p>
                                                                                <h5 class="fw-bold text-dark mb-0">
                                                                                    <fmt:formatNumber
                                                                                        value="${u.area}" /> <span
                                                                                        class="fs-6 text-muted">
                                                                                        m³</span>
                                                                                </h5>
                                                                            </div>
                                                                            <div
                                                                                class="mt-3 pt-3 border-top text-primary fw-bold">
                                                                                <fmt:formatNumber
                                                                                    value="${u.pricePerUnit}" /> VND
                                                                                <span
                                                                                    class="text-muted fw-normal">/month</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-4">
                                        <div class="right-sidebar">
                                            <div class="card-custom p-3 mb-3" id="calendarWidget"
                                                style="display: none;">
                                                <div
                                                    class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                                    <h6 class="fw-bold mb-0" id="calendarTitle">Calendar</h6>
                                                    <button class="btn btn-sm btn-light border text-muted" type="button"
                                                        data-bs-toggle="collapse"
                                                        data-bs-target="#collapseCalendar">Show/Hide</button>
                                                </div>
                                                <div class="collapse show" id="collapseCalendar">
                                                    <div class="row g-2 mt-1 mb-3">
                                                        <div class="col-6">
                                                            <select id="selectMonth"
                                                                class="form-select form-select-sm border-secondary fw-bold">
                                                                <option value="01">Jan</option>
                                                                <option value="02">Feb</option>
                                                                <option value="03">Mar</option>
                                                                <option value="04">Apr</option>
                                                                <option value="05">May</option>
                                                                <option value="06">Jun</option>
                                                                <option value="07">Jul</option>
                                                                <option value="08">Aug</option>
                                                                <option value="09">Sep</option>
                                                                <option value="10">Oct</option>
                                                                <option value="11">Nov</option>
                                                                <option value="12">Dec</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-6"><select id="selectYear"
                                                                class="form-select form-select-sm border-secondary fw-bold"></select>
                                                        </div>
                                                    </div>
                                                    <div id="bookingCalendar"></div>
                                                </div>
                                            </div>
                                            <c:if test="${!isStaff}">
                                                <div class="card-custom p-4 text-center">
                                                    <h5 class="fw-bold mb-3">Want to rent?</h5>
                                                    <a href="${pageContext.request.contextPath}/createRentRequest?id=${w.warehouseId}"
                                                        class="btn-submit">Request Rent</a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <jsp:include page="/feedback">
                                    <jsp:param name="warehouseId" value="${w.warehouseId}" />
                                    <jsp:param name="embedded" value="true" />
                                </jsp:include>
                            </div>
                        </div>
                </div>

                <jsp:include page="/Common/Layout/footer.jsp" />


                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
                <script>
                    var allZoneEvents = ${ empty unitEventsJson ?'{}': unitEventsJson };
                    var calendar;

                    document.addEventListener('DOMContentLoaded', function () {
                        // Validate Date Input
                        const startInp = document.getElementById('searchStart');
                        const endInp = document.getElementById('searchEnd');
                        if (startInp && endInp) {
                            const today = new Date().toISOString().split('T')[0];
                            startInp.setAttribute('min', today);
                            endInp.setAttribute('min', today);
                            startInp.addEventListener('change', () => { endInp.setAttribute('min', startInp.value); if (endInp.value < startInp.value) endInp.value = startInp.value; });
                        }

                        // Year Select
                        var yearSelect = document.getElementById('selectYear');
                        var currY = new Date().getFullYear();
                        for (var i = currY - 1; i <= currY + 10; i++) {
                            var opt = document.createElement('option'); opt.value = i; opt.text = i; yearSelect.add(opt);
                        }

                        // Calendar
                        var calendarEl = document.getElementById('bookingCalendar');
                        calendar = new FullCalendar.Calendar(calendarEl, {
                            initialView: 'dayGridMonth', height: 'auto', firstDay: 1, showNonCurrentDates: false, fixedWeekCount: false,
                            headerToolbar: { left: 'today', center: '', right: 'prev,next' },
                            datesSet: function (info) {
                                var d = info.view.currentStart;
                                document.getElementById('selectMonth').value = String(d.getMonth() + 1).padStart(2, '0');
                                document.getElementById('selectYear').value = d.getFullYear();
                            }
                        });
                        calendar.render();

                        function jump() { calendar.gotoDate(document.getElementById('selectYear').value + '-' + document.getElementById('selectMonth').value + '-01'); }
                        document.getElementById('selectMonth').addEventListener('change', jump);
                        document.getElementById('selectYear').addEventListener('change', jump);
                    });

                    function viewCalendarForUnit(unitId, unitCode) {
                        document.querySelectorAll('.zone-card').forEach(c => c.style.borderColor = '#e5e7eb');
                        document.getElementById('zone-card-' + unitId).style.borderColor = '#3b82f6';
                        document.getElementById('calendarWidget').style.display = 'block';
                        document.getElementById('calendarTitle').innerHTML = 'Unit: ' + unitCode;
                        calendar.removeAllEvents();
                        if (allZoneEvents[unitId]) {
                            allZoneEvents[unitId].forEach(e => {
                                var ev = Object.assign({}, e); delete ev.title; ev.allDay = true; ev.display = 'background'; ev.color = '#ffb3ba';
                                calendar.addEvent(ev);
                            });
                        }
                        setTimeout(() => calendar.updateSize(), 200);
                    }
                    function changeImage(src) { document.getElementById('displayImg').src = src; }
                </script>
            </body>

            </html>