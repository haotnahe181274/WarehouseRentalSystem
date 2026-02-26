<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Feedback Management</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
                <style>
                    body {
                        margin: 0;
                        background: #f5f7fb;
                        font-family: 'Inter', sans-serif;
                    }

                    /* ===== Layout ===== */
                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        padding: 30px;
                    }

                    /* ===== Page title ===== */
                    .page-title {
                        font-size: 24px;
                        font-weight: 700;
                        color: #111827;
                        margin-bottom: 4px;
                    }

                    .page-subtitle {
                        color: #6b7280;
                        font-size: 14px;
                        margin-bottom: 24px;
                    }

                    /* ===== Filter bar ===== */
                    .filter-bar {
                        display: flex;
                        gap: 12px;
                        margin-bottom: 24px;
                        align-items: center;
                    }

                    .filter-bar select {
                        border: 1px solid #d1d5db;
                        border-radius: 8px;
                        padding: 8px 12px;
                        font-size: 14px;
                        background: #fff;
                    }

                    /* Reset button */
                    #btnReset {
                        background: #111827;
                        color: #fff;
                        border: none;
                        border-radius: 20px;
                        padding: 8px 20px;
                        font-size: 13px;
                        cursor: pointer;
                        transition: all .2s;
                    }

                    #btnReset:hover {
                        background: #1f2937;
                    }

                    /* ===== DataTable overrides ===== */
                    #feedbackTable {
                        border-collapse: collapse;
                        width: 100%;
                        font-size: 14px;
                    }

                    #feedbackTable thead th {
                        background: #f9fafb;
                        color: #374151;
                        font-weight: 600;
                        padding: 12px 14px;
                        border-bottom: 2px solid #e5e7eb;
                    }

                    #feedbackTable tbody td {
                        padding: 12px 14px;
                        border-bottom: 1px solid #f3f4f6;
                        vertical-align: middle;
                    }

                    #feedbackTable tbody tr:hover {
                        background: #f0f4ff;
                    }

                    .dataTables_wrapper .dataTables_filter input {
                        border: 1px solid #d1d5db;
                        border-radius: 8px;
                        padding: 6px 12px;
                        font-size: 14px;
                        outline: none;
                    }

                    .dataTables_wrapper .dataTables_length select {
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        padding: 4px 8px;
                        font-size: 14px;
                    }

                    /* ===== Table cell elements ===== */
                    .fc-avatar {
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        background: #f3f4f6;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #9ca3af;
                        font-size: 13px;
                    }

                    .fc-name {
                        font-weight: 600;
                        font-size: 14px;
                    }

                    .fc-warehouse-badge {
                        background: #eef2ff;
                        color: #4338ca;
                        padding: 2px 8px;
                        border-radius: 999px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .fc-stars {
                        color: #f59e0b;
                        font-size: 14px;
                    }

                    /* Response */
                    .fc-response {
                        background: #f9fafb;
                        border: 1px solid #e5e7eb;
                        border-radius: 8px;
                        padding: 12px;
                        font-size: 13px;
                    }

                    /* Reply form */
                    .reply-form textarea {
                        font-size: 13px;
                    }

                    .btn-reply {
                        background: #4f46e5;
                        color: #fff;
                        border: none;
                        border-radius: 8px;
                        padding: 8px 16px;
                        font-size: 13px;
                        cursor: pointer;
                        transition: background .2s;
                    }

                    .btn-reply:hover {
                        background: #4338ca;
                    }

                    /* Status badges */
                    .status-badge-replied {
                        background: #d1fae5;
                        color: #065f46;
                        padding: 4px 10px;
                        border-radius: 999px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .status-badge-pending {
                        background: #fef3c7;
                        color: #92400e;
                        padding: 4px 10px;
                        border-radius: 999px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 60px;
                        color: #9ca3af;
                    }
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/Common/Layout/header.jsp" />

                <!-- Layout giống các trang khác -->
                <div class="layout">

                    <!-- Sidebar (giữ nguyên của nhóm) -->
                    <jsp:include page="/Common/Layout/sidebar.jsp" />

                    <!-- Main Content -->
                    <div class="main-content">

                        <h1 class="page-title">Feedback Management</h1>
                        <p class="page-subtitle">View and respond to renter feedback across all warehouses</p>

                        <!-- Filter -->
                        <div class="filter-bar">
                            <select id="filterStatus">
                                <option value="">All Status</option>
                                <option value="Pending">Pending Reply</option>
                                <option value="Replied">Replied</option>
                            </select>

                            <select id="filterRating">
                                <option value="">All Ratings</option>
                                <option value="5">5 Stars</option>
                                <option value="4">4 Stars</option>
                                <option value="3">3 Stars</option>
                                <option value="2">2 Stars</option>
                                <option value="1">1 Star</option>
                            </select>
                            <button id="btnReset" class="btn btn-sm btn-outline-danger" style="display:none;"
                                type="button">
                                <i class="fa-solid fa-rotate-left"></i> Reset
                            </button>
                        </div>

                        <!-- Empty -->
                        <c:if test="${empty feedbackList}">
                            <div class="empty-state">
                                <i class="fa-regular fa-comment-dots fa-2x"></i>
                                <p>No feedback received yet.</p>
                            </div>
                        </c:if>

                        <!-- Feedback Table -->
                        <c:if test="${not empty feedbackList}">
                            <table id="feedbackTable" class="display" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Renter</th>
                                        <th>Warehouse</th>
                                        <th>Rating</th>
                                        <th>Comment</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${feedbackList}" var="f">
                                        <c:set var="resp" value="${feedbackResponses[f.feedbackId]}" />
                                        <tr>
                                            <td>
                                                <div class="fc-user" style="display:flex;gap:8px;align-items:center;">
                                                    <div class="fc-avatar"><i class="fa-solid fa-user"></i></div>
                                                    <div class="fc-name">
                                                        <c:choose>
                                                            <c:when test="${f.anonymous}">Anonymous</c:when>
                                                            <c:otherwise>${f.renter.fullName}</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fc-warehouse-badge">${f.contract.warehouse.name}</span>
                                            </td>
                                            <td data-order="${f.rating}">
                                                <div class="fc-stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fa-solid fa-star"
                                                            style="${i <= f.rating ? '' : 'opacity:0.2'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>${f.comment}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty resp}">
                                                        <span class="status-badge-replied">Replied</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge-pending">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty resp}">
                                                        <button
                                                            class="btn btn-sm btn-outline-secondary btn-toggle-response"
                                                            type="button" onclick="toggleResponse(this)">
                                                            <i class="fa-solid fa-eye"></i> View
                                                        </button>
                                                        <div class="fc-response" style="display:none;margin-top:8px;">
                                                            <strong>${resp.internalUser.fullName}</strong>
                                                            <p class="mb-0">${resp.responseText}</p>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-outline-primary btn-toggle-reply"
                                                            type="button" onclick="toggleReply(this)">
                                                            <i class="fa-solid fa-reply"></i> Reply
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <!-- Reply form row (hidden by default, shown below comment) -->
                                        <c:if test="${empty resp}">
                                            <tr class="reply-row" style="display:none;">
                                                <td colspan="6" style="padding:0 14px 14px 14px; background:#f9fafb;">
                                                    <div class="reply-form">
                                                        <form
                                                            action="${pageContext.request.contextPath}/feedbackManagement"
                                                            method="post">
                                                            <input type="hidden" name="action" value="reply">
                                                            <input type="hidden" name="feedbackId"
                                                                value="${f.feedbackId}">
                                                            <div class="d-flex gap-2 align-items-start"
                                                                style="padding-top:8px;">
                                                                <textarea name="responseText" class="form-control"
                                                                    rows="2" placeholder="Type your reply..."
                                                                    required></textarea>
                                                                <button type="submit" class="btn-reply">
                                                                    Reply
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>

                    </div>
                </div>

                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

                <script>
                    $(document).ready(function () {
                        // Store reply rows before DataTables init (they have colspan and break DT)
                        var replyRows = {};
                        $('#feedbackTable .reply-row').each(function () {
                            var prevTr = $(this).prev('tr');
                            var idx = prevTr.index();
                            replyRows[idx] = $(this).detach();
                        });

                        var table = $('#feedbackTable').DataTable({
                            pageLength: 10,
                            lengthMenu: [5, 10, 25, 50],
                            order: [[2, 'desc']],
                            language: {
                                search: "Search:",
                                lengthMenu: "Show _MENU_ entries",
                                info: "Showing _START_ to _END_ of _TOTAL_ feedback",
                                paginate: {
                                    first: "First",
                                    last: "Last",
                                    next: "Next",
                                    previous: "Previous"
                                }
                            },
                            columnDefs: [
                                { orderable: false, targets: [5] }
                            ],
                            drawCallback: function () {
                                // Re-attach reply rows after each draw
                                var api = this.api();
                                api.rows({ page: 'current' }).every(function () {
                                    var row = this.node();
                                    var origIdx = this.index();
                                    if (replyRows[origIdx]) {
                                        $(row).after(replyRows[origIdx]);
                                    }
                                });
                            }
                        });

                        // Show/hide reset button
                        function toggleResetBtn() {
                            var hasFilter = $('#filterStatus').val() !== '' || $('#filterRating').val() !== '';
                            $('#btnReset').toggle(hasFilter);
                        }

                        // Filter by Status (column 4)
                        $('#filterStatus').on('change', function () {
                            table.column(4).search(this.value).draw();
                            toggleResetBtn();
                        });

                        // Filter by Rating (column 2)
                        $('#filterRating').on('change', function () {
                            table.column(2).search(this.value).draw();
                            toggleResetBtn();
                        });

                        // Reset all filters
                        $('#btnReset').on('click', function () {
                            $('#filterStatus').val('');
                            $('#filterRating').val('');
                            table.columns().search('').draw();
                            $(this).hide();
                        });
                    });

                    function toggleResponse(btn) {
                        var div = btn.nextElementSibling;
                        div.style.display = div.style.display === 'none' ? 'block' : 'none';
                    }

                    function toggleReply(btn) {
                        var currentRow = btn.closest('tr');
                        var replyRow = currentRow.nextElementSibling;
                        if (replyRow && replyRow.classList.contains('reply-row')) {
                            replyRow.style.display = replyRow.style.display === 'none' ? 'table-row' : 'none';
                        }
                    }
                </script>
                <jsp:include page="/Common/Layout/footer.jsp" />
            </body>

            </html>