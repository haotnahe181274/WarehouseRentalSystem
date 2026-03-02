<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Feedback Management</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

                <style>
                    body {
                        margin: 0;
                        background: #f5f7fb;
                        font-family: 'Inter', sans-serif;
                    }

                    /* ===== Layout giống các trang management khác ===== */
                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    /* Main content nằm bên phải sidebar */
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

                    /* ===== Filter ===== */
                    .filter-bar {
                        display: flex;
                        gap: 12px;
                        margin-bottom: 24px;
                        align-items: center;
                    }

                    .filter-bar select,
                    .filter-bar input {
                        border: 1px solid #d1d5db;
                        border-radius: 8px;
                        padding: 8px 12px;
                        font-size: 14px;
                        background: #fff;
                    }

                    /* Table Styling */
                    table.dataTable {
                        width: 100% !important;
                        background: white;
                        border-radius: 12px;
                        overflow: hidden;
                        border: 1px solid #e5e7eb;
                        border-collapse: collapse;
                        margin-top: 20px;
                    }

                    table.dataTable thead th {
                        background: #f9fafb;
                        color: #4b5563;
                        font-weight: 600;
                        border-bottom: 1px solid #e5e7eb !important;
                        padding: 12px 16px;
                    }

                    table.dataTable tbody td {
                        padding: 16px;
                        border-bottom: 1px solid #f3f4f6;
                        vertical-align: top;
                    }

                    .fc-user {
                        display: flex;
                        gap: 10px;
                        align-items: center;
                    }

                    .fc-avatar {
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        background: #f3f4f6;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #9ca3af;
                    }

                    .fc-name {
                        font-weight: 600;
                        font-size: 14px;
                    }

                    .fc-stars {
                        color: #f59e0b;
                        font-size: 13px;
                    }

                    .fc-comment {
                        font-size: 14px;
                        color: #374151;
                    }

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

                    .reply-box {
                        margin-top: 10px;
                        background: #f9fafb;
                        padding: 10px;
                        border-radius: 8px;
                        border: 1px solid #e5e7eb;
                        font-size: 13px;
                    }

                    .btn-view {
                        background: #111827;
                        color: white;
                        border: none;
                        padding: 6px 12px;
                        border-radius: 6px;
                        font-size: 13px;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-block;
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

                        <!-- Filters -->
                        <div class="filter-bar">
                            <select id="filterStatus">
                                <option value="">All Status</option>
                                <option value="Pending">Pending</option>
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
                        </div>

                        <c:if test="${not empty feedbackList}">
                            <table id="feedbackTable">
                                <thead>
                                    <tr>
                                        <th>User</th>
                                        <th>Warehouse</th>
                                        <th>Rating</th>
                                        <th>Content</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${feedbackList}" var="f">
                                        <c:set var="resp" value="${feedbackResponses[f.feedbackId]}" />
                                        <tr>
                                            <td>
                                                <div class="fc-user">
                                                    <div class="fc-avatar"><i class="fa-solid fa-user"></i></div>
                                                    <div class="fc-name">${f.anonymous ? 'Anonymous' :
                                                        f.renter.fullName}</div>
                                                </div>
                                            </td>
                                            <td>${f.contract.warehouse.name}</td>
                                            <td data-order="${f.rating}">
                                                <span style="display:none;">${f.rating}</span>
                                                <div class="fc-stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fa-solid fa-star"
                                                            style="${i <= f.rating ? '' : 'opacity:0.2'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="fc-comment">${f.comment}</div>
                                                <c:if test="${not empty resp}">
                                                    <div class="reply-box">
                                                        <strong>Reply from ${resp.internalUser.fullName}:</strong>
                                                        <p style="margin:4px 0 0 0;">${resp.responseText}</p>
                                                    </div>
                                                </c:if>
                                            </td>
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
                                                <a href="${pageContext.request.contextPath}/warehouse/detail?id=${f.contract.warehouse.warehouseId}#feedback-${f.feedbackId}"
                                                    class="btn-view">
                                                    <i class="fa-solid fa-eye"></i> View & Reply
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>

                        <c:if test="${empty feedbackList}">
                            <div class="empty-state">
                                <i class="fa-regular fa-comment-dots fa-3x" style="margin-bottom:15px;"></i>
                                <p>No feedback found.</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                <script>
                    $(document).ready(function () {
                        var table = $('#feedbackTable').DataTable({
                            pageLength: 10,
                            lengthMenu: [5, 10, 25, 50],
                            order: [[4, 'asc']], // Pending first
                            language: {
                                search: "Search:",
                                lengthMenu: "_MENU_",
                                info: "Showing _START_ to _END_ of _TOTAL_ feedback"
                            },
                            columnDefs: [
                                { orderable: false, targets: [0, 5] }
                            ]
                        });

                        $('#filterStatus').on('change', function () {
                            table.column(4).search(this.value).draw();
                        });

                        $('#filterRating').on('change', function () {
                            table.column(2).search(this.value).draw();
                        });

                        // Position filters next to length menu
                        var filterBar = $('.filter-bar');
                        var lengthDiv = $('#feedbackTable_length');
                        if (filterBar.length && lengthDiv.length) {
                            filterBar.detach();
                            var wrapper = $('<div class="d-flex align-items-center gap-3"></div>');
                            lengthDiv.before(wrapper);
                            wrapper.append(lengthDiv);
                            wrapper.append(filterBar);
                        }
                    });
                </script>

                <jsp:include page="/Common/Layout/footer.jsp" />
            </body>

            </html>