<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Feedback Management</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

                <style>
                    /* Page-specific styles only — shared styles in management-layout.css */
                    .fc-user { display: flex; gap: 10px; align-items: center; }
                    .fc-avatar { width: 32px; height: 32px; border-radius: 50%; background: #f3f4f6; display: flex; align-items: center; justify-content: center; color: #9ca3af; }
                    .fc-name { font-weight: 600; font-size: 14px; }
                    .fc-stars { color: #f59e0b; font-size: 13px; }
                    .fc-comment { font-size: 14px; color: #374151; }
                    .status-badge-replied { background: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 600; }
                    .status-badge-pending { background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 600; }
                    .reply-box { margin-top: 10px; background: #f9fafb; padding: 10px; border-radius: 8px; border: 1px solid #e5e7eb; font-size: 13px; }
                    .btn-view { background: #111827; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 13px; cursor: pointer; text-decoration: none; display: inline-block; }
                    .empty-state { text-align: center; padding: 60px; color: #9ca3af; }
                    .dt-controls-row { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px; flex-wrap: wrap; gap: 15px; }
                    .dt-controls-row label { margin-bottom: 0 !important; }
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/Common/Layout/header.jsp" />
                <jsp:include page="/message/popupMessage.jsp" />
                <!-- Layout giống các trang khác -->
                <div class="layout">

                    <!-- Sidebar (giữ nguyên của nhóm) -->
                    <jsp:include page="/Common/Layout/sidebar.jsp" />

                    <!-- Main Content -->
                    <div class="main-content">
                        <h3>Feedback Management</h3>

                        <div class="stats-container">
                            <jsp:include page="/Common/Layout/stats_cards.jsp">
                                <jsp:param name="label1" value="Total Feedback" />
                                <jsp:param name="value1" value="${totalFeedback}" />
                                <jsp:param name="icon1" value="fa-solid fa-comments" />
                                <jsp:param name="color1" value="primary" />

                                <jsp:param name="label2" value="Pending" />
                                <jsp:param name="value2" value="${pendingFeedback}" />
                                <jsp:param name="icon2" value="fa-solid fa-clock-rotate-left" />
                                <jsp:param name="color2" value="warning" />

                                <jsp:param name="label3" value="Replied" />
                                <jsp:param name="value3" value="${repliedFeedback}" />
                                <jsp:param name="icon3" value="fa-solid fa-comment-dots" />
                                <jsp:param name="color3" value="success" />
                            </jsp:include>
                        </div>

                        <div class="management-card">

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
                                <a href="${pageContext.request.contextPath}/feedbackManagement" class="btn-reset"
                                    id="btnReset" style="display: none;">Reset</a>
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
                                                            <i
                                                                class="fa-solid fa-star <c:if test='${i > f.rating}'>opacity-20</c:if>"></i>
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
                        </div> <!-- End management-card -->
                    </div> <!-- End main-content -->
                </div> <!-- End layout -->

                    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                    <script>
                        $(document).ready(function () {
                            let table = $('#feedbackTable').DataTable({
                                order: [[0, 'desc']],
                                pageLength: 10,
                                dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
                                language: {
                                    search: "Search:",
                                    lengthMenu: "_MENU_ entries per page"
                                }
                            });

                            // Apply Filters
                            $('#statusFilter, #ratingFilter').on('change', function () {
                                let status = $('#statusFilter').val();
                                let rating = $('#ratingFilter').val();

                                table.column(4).search(status);
                                table.column(2).search(rating);
                                table.draw();
                            });
                        });
                    </script>

                    <jsp:include page="/Common/Layout/footer.jsp" />
            </body>

            </html>