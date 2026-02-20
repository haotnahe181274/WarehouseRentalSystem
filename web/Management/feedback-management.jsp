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

    <style>
        body {
            
            background: #f5f7fb;
            font-family: 'Inter', sans-serif;
        }

        /* ===== Layout riêng cho trang này ===== */
        .feedback-layout {
            display: flex;
            align-items: flex-start;
           
        }

        /* Sidebar giữ nguyên width của nhóm */
        .feedback-layout .sidebar {
            width: 220px;
            min-height: calc(100vh - 60px);
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

        /* ===== Feedback card ===== */
        .feedback-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px 24px;
            margin-bottom: 16px;
        }

        .fc-top {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .fc-user {
            display: flex;
            gap: 12px;
        }

        .fc-avatar {
            width: 40px;
            height: 40px;
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

        .fc-comment {
            font-size: 14px;
            color: #374151;
        }

        /* Response */
        .fc-response {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px;
            margin-top: 12px;
            font-size: 14px;
        }

        /* Reply */
        .reply-form {
            margin-top: 12px;
        }

        .btn-reply {
            background: #111827;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 14px;
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

        .empty-state {
            text-align: center;
            padding: 60px;
            color: #9ca3af;
        }
    </style>
</head>

<body>

    <!-- Header (giữ nguyên của nhóm) -->
    <jsp:include page="/Common/Layout/header.jsp" />

    <!-- Layout riêng -->
    <div class="feedback-layout">

        <!-- Sidebar (giữ nguyên của nhóm) -->
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">

            <h1 class="page-title">Feedback Management</h1>
            <p class="page-subtitle">View and respond to renter feedback across all warehouses</p>

            <!-- Filter -->
            <div class="filter-bar">
                <select id="filterStatus" onchange="filterFeedback()">
                    <option value="all">All Status</option>
                    <option value="pending">Pending Reply</option>
                    <option value="replied">Replied</option>
                </select>

                <select id="filterRating" onchange="filterFeedback()">
                    <option value="all">All Ratings</option>
                    <option value="5">5 Stars</option>
                    <option value="4">4 Stars</option>
                    <option value="3">3 Stars</option>
                    <option value="2">2 Stars</option>
                    <option value="1">1 Star</option>
                </select>

                <input type="text" id="filterSearch"
                       placeholder="Search by warehouse or renter..."
                       oninput="filterFeedback()" style="max-width:300px;">
            </div>

            <!-- Empty -->
            <c:if test="${empty feedbackList}">
                <div class="empty-state">
                    <i class="fa-regular fa-comment-dots fa-2x"></i>
                    <p>No feedback received yet.</p>
                </div>
            </c:if>

            <!-- Feedback list -->
            <div id="feedbackContainer">
                <c:forEach items="${feedbackList}" var="f">

                    <div class="feedback-card"
                         data-rating="${f.rating}"
                         data-status="${not empty feedbackResponses[f.feedbackId] ? 'replied' : 'pending'}"
                         data-search="${f.contract.warehouse.name} ${f.anonymous ? 'Anonymous' : f.renter.fullName}">

                        <div class="fc-top">
                            <div class="fc-user">
                                <div class="fc-avatar">
                                    <i class="fa-solid fa-user"></i>
                                </div>
                                <div>
                                    <div class="fc-name">
                                        <c:choose>
                                            <c:when test="${f.anonymous}">Anonymous</c:when>
                                            <c:otherwise>${f.renter.fullName}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="fc-warehouse-badge">
                                        ${f.contract.warehouse.name}
                                    </span>
                                </div>
                            </div>

                            <div style="text-align:right;">
                                <div class="fc-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa-solid fa-star"
                                           style="${i <= f.rating ? '' : 'opacity:0.2'}"></i>
                                    </c:forEach>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty feedbackResponses[f.feedbackId]}">
                                        <span class="status-badge-replied">Replied</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge-pending">Pending</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <p class="fc-comment">${f.comment}</p>

                        <!-- Response -->
                        <c:set var="resp" value="${feedbackResponses[f.feedbackId]}" />
                        <c:if test="${not empty resp}">
                            <div class="fc-response">
                                <strong>${resp.internalUser.fullName}</strong>
                                <p class="mb-0">${resp.responseText}</p>
                            </div>
                        </c:if>

                        <!-- Reply -->
                        <c:if test="${empty resp}">
                            <div class="reply-form">
                                <form action="${pageContext.request.contextPath}/feedbackManagement" method="post">
                                    <input type="hidden" name="action" value="reply">
                                    <input type="hidden" name="feedbackId" value="${f.feedbackId}">
                                    <div class="d-flex gap-2">
                                        <textarea name="responseText" class="form-control"
                                                  rows="2" required></textarea>
                                        <button type="submit" class="btn-reply">
                                            Reply
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                    </div>

                </c:forEach>
            </div>

        </div>
    </div>

    <script>
        function filterFeedback() {
            const status = document.getElementById('filterStatus').value;
            const rating = document.getElementById('filterRating').value;
            const search = document.getElementById('filterSearch').value.toLowerCase();
            const cards = document.querySelectorAll('.feedback-card');

            cards.forEach(card => {
                let show = true;

                if (status !== 'all' && card.dataset.status !== status) show = false;
                if (rating !== 'all' && card.dataset.rating !== rating) show = false;
                if (search && !card.dataset.search.toLowerCase().includes(search)) show = false;

                card.style.display = show ? '' : 'none';
            });
        }
    </script>

</body>
</html>