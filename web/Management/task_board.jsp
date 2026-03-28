<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task Board</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        /* ── Badges ── */
        .badge-type {
            display: inline-block; padding: 3px 9px; border-radius: 5px;
            font-size: 11px; font-weight: 600;
        }
        .badge-checkin  { background: #dbeafe; color: #1e40af; }
        .badge-checkout { background: #fef3c7; color: #92400e; }
        .badge-general  { background: #f3f4f6; color: #6b7280; }

        .badge-status { padding: 3px 9px; border-radius: 5px; font-size: 11px; font-weight: 600; }
        .status-pending   { background: #fef3c7; color: #d97706; }
        .status-completed { background: #dcfce7; color: #16a34a; }
        .status-overdue   { background: #fee2e2; color: #dc2626; }

        /* ── Page top bar ── */
        .page-top-bar {
            display: flex; align-items: center;
            justify-content: space-between; margin-bottom: 20px;
        }
        .page-top-bar h3 { margin: 0; font-size: 20px; font-weight: 700; color: #111827; }

        /* ── Table ── */
        #taskTable td { vertical-align: middle; font-size: 13px; }
        #taskTable td:nth-child(6) {
            max-width: 220px; overflow: hidden;
            text-overflow: ellipsis; white-space: nowrap;
        }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 48px 24px; color: #9ca3af; }
        .empty-state i { font-size: 36px; margin-bottom: 12px; display: block; }
    </style>
</head>
<body>

<jsp:include page="/Common/Layout/header.jsp"/>
<jsp:include page="/message/popupMessage.jsp"/>

<div class="layout">
    <jsp:include page="/Common/Layout/sidebar.jsp"/>

    <div class="main-content">

        <!-- ── Page title ── -->
        <div class="page-top-bar">
            <h3>
                <i class="fa-solid fa-clipboard-list" style="color:#6b7280;margin-right:8px;font-size:18px;"></i>
                Task Board
            </h3>
        </div>

        <!-- ── Stats cards ── -->
        <div class="stats-container mb-4">
            <jsp:include page="/Common/Layout/stats_cards.jsp">
                <jsp:param name="label1" value="Total tasks" />
                <jsp:param name="value1" value="${totalTasks}" />
                <jsp:param name="icon1"  value="fa-solid fa-list-check" />
                <jsp:param name="color1" value="primary" />

                <jsp:param name="label2" value="Completed" />
                <jsp:param name="value2" value="${completedTasks}" />
                <jsp:param name="icon2"  value="fa-solid fa-circle-check" />
                <jsp:param name="color2" value="success" />

                <jsp:param name="label3" value="In progress" />
                <jsp:param name="value3" value="${pendingTasks}" />
                <jsp:param name="icon3"  value="fa-solid fa-spinner" />
                <jsp:param name="color3" value="info" />

                <jsp:param name="label4" value="Overdue" />
                <jsp:param name="value4" value="${overdueTasks}" />
                <jsp:param name="icon4"  value="fa-solid fa-triangle-exclamation" />
                <jsp:param name="color4" value="danger" />
            </jsp:include>
        </div>

        <div class="management-card">

            <!-- ── Filter bar ── -->
            <div id="taskFilterBar" class="filter-bar">
                <select id="filterType" onchange="applyFilters()">
                    <option value="all">All Types</option>
                    <option value="1">Check-in</option>
                    <option value="2">Check-out</option>
                    <option value="0">General</option>
                </select>

                <select id="filterStatus" onchange="applyFilters()">
                    <option value="all">All Status</option>
                    <option value="completed">Completed</option>
                    <option value="pending">In progress</option>
                    <option value="overdue">Overdue</option>
                </select>

                <a href="#" onclick="resetFilters(); return false;" class="btn-reset">Reset</a>
            </div>

            <!-- ── Table ── -->
            <c:choose>
                <c:when test="${empty taskList}">
                    <div class="empty-state">
                        <i class="fa-solid fa-inbox"></i>
                        <p>No assignments found in the system.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table id="taskTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Staff</th>
                                <th>Warehouse</th>
                                <th>Unit</th>
                                <th>Type</th>
                                <th>Description</th>
                                <th>Start date</th>
                                <th>Due date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${taskList}">
                                <tr data-type="${t.assignmentType}"
                                    data-status="${not empty t.completedAt ? 'completed' : (t.overdue ? 'overdue' : 'pending')}">
                                    <td>#${t.assignmentId}</td>
                                    <td><strong>${not empty t.staffName ? t.staffName : 'Unassigned'}</strong></td>
                                    <td>${t.warehouseName}</td>
                                    <td>${not empty t.unitCode ? t.unitCode : '—'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.assignmentType == 1}">
                                                <span class="badge-type badge-checkin">Check-in</span>
                                            </c:when>
                                            <c:when test="${t.assignmentType == 2}">
                                                <span class="badge-type badge-checkout">Check-out</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-type badge-general">General</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td title="${t.description}">${t.description}</td>
                                    <td>${t.startedDate}</td>
                                    <td>${t.dueDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.completedAt}">
                                                <span class="badge-status status-completed">Completed</span>
                                            </c:when>
                                            <c:when test="${t.overdue}">
                                                <span class="badge-status status-overdue">Overdue</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status status-pending">In progress</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

        </div><%-- End management-card --%>
    </div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var table;

    $(document).ready(function () {
        if ($.fn.DataTable.isDataTable('#taskTable')) {
            $('#taskTable').DataTable().destroy();
        }

        table = $('#taskTable').DataTable({
            "columnDefs": [
                { "orderable": false, "targets": [4, 8] }
            ],
            "order": [[0, "desc"]],
            lengthMenu: [5, 10, 25, 50],
            "language": {
                "search":     "Search:",
                "lengthMenu": "_MENU_",
                "info":       "Showing _START_ to _END_ of _TOTAL_ tasks",
                "paginate": {
                    "first": "First", "last": "Last",
                    "next": "Next",   "previous": "Previous"
                },
                "emptyTable": "No tasks match the selected filters."
            }
        });

        // Move filter bar + length + search into one row
        var filterBar = $('#taskFilterBar');
        var lengthDiv = $('#taskTable_length');
        var filterDiv = $('#taskTable_filter');

        if (filterBar.length && lengthDiv.length && filterDiv.length) {
            var bottomRow = $('<div class="dt-controls-bottom-row"></div>');
            lengthDiv.before(bottomRow);
            bottomRow.append(lengthDiv);
            bottomRow.append(filterDiv);
            filterBar.insertBefore(bottomRow);
        }
    });

    // Client-side filter by type and status using data-* attributes
    function applyFilters() {
        var typeVal   = document.getElementById('filterType').value;
        var statusVal = document.getElementById('filterStatus').value;

        // Custom DataTables search via $.fn.dataTable.ext.search
        $.fn.dataTable.ext.search = [];

        $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
            var row = table.row(dataIndex).node();
            if (!row) return true;

            var rowType   = $(row).data('type').toString();
            var rowStatus = $(row).data('status').toString();

            var typeMatch   = (typeVal   === 'all' || rowType   === typeVal);
            var statusMatch = (statusVal === 'all' || rowStatus === statusVal);

            return typeMatch && statusMatch;
        });

        table.draw();
    }

    function resetFilters() {
        document.getElementById('filterType').value   = 'all';
        document.getElementById('filterStatus').value = 'all';
        $.fn.dataTable.ext.search = [];
        table.draw();
    }
</script>
</body>
</html>
