<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        .noti-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .noti-page-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #111827;
        }

        .noti-filter-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .noti-filter-btn {
            padding: 6px 16px;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            background: #fff;
            font-size: 13px;
            font-weight: 500;
            color: #6b7280;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.15s;
        }

        .noti-filter-btn:hover {
            background: #f3f4f6;
            color: #111827;
            text-decoration: none;
        }

        .noti-filter-btn.active {
            background: #111827;
            color: #fff;
            border-color: #111827;
        }

        .noti-mark-all-btn {
            margin-left: auto;
            padding: 6px 16px;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            background: #fff;
            font-size: 13px;
            font-weight: 500;
            color: #3b82f6;
            cursor: pointer;
            transition: all 0.15s;
        }

        .noti-mark-all-btn:hover:not(:disabled) {
            background: #eff6ff;
            border-color: #bfdbfe;
        }

        .noti-mark-all-btn:disabled {
            color: #9ca3af;
            cursor: default;
        }

        /* ── Notification list ── */
        .noti-list {
            display: flex;
            flex-direction: column;
            gap: 0;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
        }

        .noti-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 16px 20px;
            border-bottom: 1px solid #f3f4f6;
            text-decoration: none;
            color: inherit;
            transition: background 0.12s;
            position: relative;
        }

        .noti-item:last-child {
            border-bottom: none;
        }

        .noti-item:hover {
            background: #f9fafb;
            text-decoration: none;
            color: inherit;
        }

        .noti-item.unread {
            background: #f0f7ff;
        }

        .noti-item.unread:hover {
            background: #e8f1fd;
        }

        /* Unread bar bên trái */
        .noti-item.unread::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: #3b82f6;
            border-radius: 0;
        }

        .noti-icon {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .noti-icon.bg-primary   { background: #dbeafe; color: #1d4ed8; }
        .noti-icon.bg-success   { background: #dcfce7; color: #16a34a; }
        .noti-icon.bg-warning   { background: #fef3c7; color: #d97706; }
        .noti-icon.bg-danger    { background: #fee2e2; color: #dc2626; }
        .noti-icon.bg-info      { background: #e0f2fe; color: #0369a1; }
        .noti-icon.bg-secondary { background: #f3f4f6; color: #6b7280; }

        .noti-body {
            flex: 1;
            min-width: 0;
        }

        .noti-title {
            font-size: 14px;
            font-weight: 600;
            color: #111827;
            margin: 0 0 4px;
            line-height: 1.4;
        }

        .noti-message {
            font-size: 13px;
            color: #6b7280;
            margin: 0 0 6px;
            line-height: 1.5;
        }

        .noti-item.unread .noti-title  { color: #1e3a5f; }
        .noti-item.unread .noti-message { color: #374151; }

        .noti-meta {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .noti-time {
            font-size: 12px;
            color: #9ca3af;
        }

        .noti-type-badge {
            font-size: 11px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 10px;
        }

        .noti-type-badge.SUCCESS { background: #dcfce7; color: #166534; }
        .noti-type-badge.WARNING { background: #fef3c7; color: #92400e; }
        .noti-type-badge.INFO    { background: #dbeafe; color: #1e40af; }
        .noti-type-badge.DANGER  { background: #fee2e2; color: #991b1b; }

        .noti-unread-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #3b82f6;
            flex-shrink: 0;
            margin-top: 18px;
        }

        /* ── Empty state ── */
        .noti-empty {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 24px;
            color: #9ca3af;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            gap: 12px;
        }

        .noti-empty svg {
            opacity: 0.35;
        }

        .noti-empty p {
            margin: 0;
            font-size: 14px;
        }

        /* ── Summary bar ── */
        .noti-summary {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .noti-summary strong {
            color: #111827;
        }
    </style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="layout">
        <c:set var="isStaff"
                            value="${sessionScope.user.role == 'Manager' || sessionScope.user.role == 'manager' }" />

                        <c:if test="${isStaff}">
                            <jsp:include page="/Common/Layout/sidebar.jsp" />
                        </c:if>

        <div class="main-content">

            <!-- Page header -->
            <div class="noti-page-header">
                <h3>
                    <i class="fa-solid fa-bell" style="color: #6b7280; margin-right: 8px;"></i>
                    Notifications
                    <c:if test="${unreadCount > 0}">
                        <span style="
                            display: inline-flex; align-items: center; justify-content: center;
                            background: #ef4444; color: #fff;
                            font-size: 12px; font-weight: 700;
                            min-width: 22px; height: 22px;
                            border-radius: 11px; padding: 0 6px;
                            margin-left: 8px; vertical-align: middle;">
                            ${unreadCount}
                        </span>
                    </c:if>
                </h3>
            </div>

            <!-- Filter bar -->
            <div class="noti-filter-bar">
                <a href="${pageContext.request.contextPath}/notifications"
                   class="noti-filter-btn ${empty param.filter ? 'active' : ''}">
                    All
                </a>
                <a href="${pageContext.request.contextPath}/notifications?filter=unread"
                   class="noti-filter-btn ${param.filter == 'unread' ? 'active' : ''}">
                    Unread
                    <c:if test="${unreadCount > 0}">
                        <span style="
                            background: #3b82f6; color: #fff;
                            font-size: 10px; font-weight: 700;
                            padding: 1px 5px; border-radius: 8px;
                            margin-left: 4px;">
                            ${unreadCount}
                        </span>
                    </c:if>
                </a>
                <a href="${pageContext.request.contextPath}/notifications?filter=SUCCESS"
                   class="noti-filter-btn ${param.filter == 'SUCCESS' ? 'active' : ''}">
                    <i class="fa-solid fa-circle-check" style="color: #16a34a;"></i> Success
                </a>
                <a href="${pageContext.request.contextPath}/notifications?filter=WARNING"
                   class="noti-filter-btn ${param.filter == 'WARNING' ? 'active' : ''}">
                    <i class="fa-solid fa-triangle-exclamation" style="color: #d97706;"></i> Warning
                </a>
                <a href="${pageContext.request.contextPath}/notifications?filter=INFO"
                   class="noti-filter-btn ${param.filter == 'INFO' ? 'active' : ''}">
                    <i class="fa-solid fa-circle-info" style="color: #0369a1;"></i> Info
                </a>

                <!-- Mark all as read button -->
                <button id="markAllReadBtn"
                        class="noti-mark-all-btn"
                        onclick="markAllRead(event)"
                        ${unreadCount == 0 ? 'disabled' : ''}>
                    <i class="fa-solid fa-check-double"></i> Mark all as read
                </button>
            </div>

            <!-- Summary -->
            <c:if test="${not empty allNotiList}">
                <div class="noti-summary">
                    Showing <strong>${allNotiList.size()}</strong> notifications
                    <c:if test="${not empty param.filter}">
                        — filtered by <strong>${param.filter}</strong>
                    </c:if>
                </div>
            </c:if>

            <!-- Notification list -->
            <c:choose>
                <c:when test="${empty allNotiList}">
                    <div class="noti-empty">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="1.5">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                        </svg>
                        <p>No notifications found</p>
                        <c:if test="${not empty param.filter}">
                            <a href="${pageContext.request.contextPath}/notifications"
                               style="font-size: 13px; color: #3b82f6;">View all notifications</a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="noti-list" id="notiList">
                        <c:forEach var="noti" items="${allNotiList}">
                            <a href="${pageContext.request.contextPath}${noti.linkUrl}"
                               class="noti-item ${noti.read ? '' : 'unread'}"
                               data-id="${noti.notificationId}">

                                <!-- Icon -->
                                <div class="noti-icon ${noti.getIconClass()}">
                                    <i class="fas ${noti.getIconName()}"></i>
                                </div>

                                <!-- Content -->
                                <div class="noti-body">
                                    <p class="noti-title">${noti.title}</p>
                                    <p class="noti-message">${noti.message}</p>
                                    <div class="noti-meta">
                                        <span class="noti-time">
                                            <i class="fa-regular fa-clock" style="margin-right: 3px;"></i>
                                            ${noti.getTimeAgo()}
                                        </span>
                                        <span class="noti-type-badge ${noti.type}">${noti.type}</span>
                                    </div>
                                </div>

                                <!-- Unread dot -->
                                <c:if test="${!noti.read}">
                                    <span class="noti-unread-dot"></span>
                                </c:if>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div><!-- end main-content -->
    </div><!-- end layout -->

    <jsp:include page="/Common/Layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        var contextPath = '${pageContext.request.contextPath}';

        function markAllRead(e) {
            e.preventDefault();
            var btn = document.getElementById('markAllReadBtn');
            if (!btn || btn.disabled) return;

            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Marking...';

            fetch(contextPath + '/mark-all-read', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(function (res) {
                if (res.ok) {
                    // Xóa badge đỏ trên header
                    var badge = document.querySelector('.app-header__noti-badge');
                    if (badge) badge.remove();

                    // Xóa unread trên tất cả item trong trang này
                    document.querySelectorAll('.noti-item.unread').forEach(function (item) {
                        item.classList.remove('unread');
                    });
                    document.querySelectorAll('.noti-unread-dot').forEach(function (dot) {
                        dot.remove();
                    });
                    // Xóa badge unread trong dropdown header
                    document.querySelectorAll('.app-header__noti-dot').forEach(function (dot) {
                        dot.remove();
                    });
                    document.querySelectorAll('.app-header__noti-item.unread').forEach(function (item) {
                        item.classList.remove('unread');
                    });

                    btn.innerHTML = '<i class="fa-solid fa-check-double"></i> All read';
                    btn.style.color = '#9ca3af';

                    // Cập nhật counter trong page header
                    var counter = document.querySelector('.noti-page-header span[style*="background: #ef4444"]');
                    if (counter) counter.remove();

                    // Cập nhật badge trong filter "Unread"
                    var unreadBadge = document.querySelector('.noti-filter-btn span[style*="#3b82f6"]');
                    if (unreadBadge) unreadBadge.remove();
                } else {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-check-double"></i> Mark all as read';
                }
            })
            .catch(function () {
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-check-double"></i> Mark all as read';
            });
        }
    </script>
</body>
</html>
