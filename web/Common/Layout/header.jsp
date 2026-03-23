<%-- Document : header
     Created on : Feb 2, 2026, 2:40:52 PM
     Author     : ad
     Updated    : Improved notification & user dropdown UI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<nav class="app-header">

    <a class="app-header__logo" href="${pageContext.request.contextPath}/homepage">
        WareSpace
    </a>

    <ul class="app-header__menu">
        <li class="app-header__menu-item">
            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/homepage">Homepage</a>
        </li>
        <li class="app-header__menu-item">
            <a class="app-header__menu-link" href="${pageContext.request.contextPath}/discuss">Discussion</a>
        </li>
        <c:if test="${not empty sessionScope.user}">
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/blog">My Posts</a>
            </li>
        </c:if>
        <c:if test="${sessionScope.userType == 'RENTER'}">
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/rentList">My Rental</a>
            </li>
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/contract">Contract</a>
            </li>
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/itemlist">List Item</a>
            </li>
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/send-support-message">Support</a>
            </li>
        </c:if>

        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <c:if test="${sessionScope.role == 'Admin'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="dashboard">Admin</a>
                </li>
            </c:if>
            <c:if test="${sessionScope.role == 'Staff'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="dashboard">Staff</a>
                </li>
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="${pageContext.request.contextPath}/support">Support</a>
                </li>
            </c:if>
            <c:if test="${sessionScope.role == 'Manager'}">
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="dashboard">Manager</a>
                </li>
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link" href="${pageContext.request.contextPath}/support">Support</a>
                </li>
            </c:if>
        </c:if>

        <c:if test="${sessionScope.userType == 'RENTER' || isHomepage}">
            <li class="app-header__menu-item">
                <a class="app-header__menu-link" href="${pageContext.request.contextPath}/Common/homepage/about.jsp">About us</a>
            </li>
        </c:if>
    </ul>

    <ul class="app-header__user">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">

                <!-- ===== NOTIFICATION ===== -->
                <li class="app-header__notification">
                    <div class="app-header__noti-trigger">
                        <svg class="app-header__noti-bell" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                        </svg>
                        <c:if test="${unreadCount > 0}">
                            <span class="app-header__noti-badge">${unreadCount}</span>
                        </c:if>
                    </div>

                    <div class="app-header__noti-dropdown">
                        <div class="app-header__noti-header">
                            <span class="app-header__noti-title">Notifications</span>
                            <button id="markAllReadBtn" class="app-header__noti-mark-all"
                                    onclick="markAllRead(event)"
                                    ${empty notiList or unreadCount == 0 ? 'disabled' : ''}>
                                Mark all as read
                            </button>
                        </div>

                        <ul class="app-header__noti-list">
                            <c:choose>
                                <c:when test="${empty notiList}">
                                    <li class="app-header__noti-empty">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="32" height="32">
                                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                                            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                                        </svg>
                                        <span>No new notifications</span>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="noti" items="${notiList}">
                                        <li class="app-header__noti-item ${noti.read ? '' : 'unread'}">
                                            <a href="${pageContext.request.contextPath}${noti.linkUrl}" class="app-header__noti-link">
                                                <div class="app-header__noti-icon ${noti.getIconClass()}">
                                                    <i class="fas ${noti.getIconName()}"></i>
                                                </div>
                                                <div class="app-header__noti-content">
                                                    <p class="app-header__noti-text">${noti.message}</p>
                                                    <span class="app-header__noti-time">${noti.getTimeAgo()}</span>
                                                </div>
                                                <c:if test="${!noti.read}">
                                                    <span class="app-header__noti-dot"></span>
                                                </c:if>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>

                        <div class="app-header__noti-footer">
                            <a href="${pageContext.request.contextPath}/notifications">View all notifications</a>
                        </div>
                    </div>
                </li>

                <!-- ===== USER DROPDOWN ===== -->
                <li class="app-header__user-info">
                    <div class="app-header__user-trigger">
                        <img class="app-header__avatar"
                             src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image}"
                             width="32" height="32"
                             onerror="this.src='${pageContext.request.contextPath}/resources/user/image/default.jpg'">
                        <span class="app-header__username">${sessionScope.user.name}</span>
                        <svg class="app-header__chevron" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="6 9 12 15 18 9"/>
                        </svg>
                    </div>

                    <ul class="app-header__dropdown">
                        <li class="app-header__dropdown-user-info">
                            <span class="app-header__dropdown-user-name">${sessionScope.user.name}</span>
                            <span class="app-header__dropdown-user-role">${sessionScope.userType}</span>
                        </li>

                        <li class="app-header__dropdown-item">
                            <a class="app-header__dropdown-link" href="${pageContext.request.contextPath}/profile">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                                </svg>
                                My Profile
                            </a>
                        </li>

                        <c:if test="${sessionScope.userType == 'RENTER'}">
                            <li class="app-header__dropdown-item">
                                <a class="app-header__dropdown-link" href="${pageContext.request.contextPath}/payments">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                        <rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/>
                                    </svg>
                                    My Payment
                                </a>
                            </li>
                        </c:if>

                        <li class="app-header__dropdown-divider"></li>

                        <li class="app-header__dropdown-item app-header__dropdown-item--danger">
                            <a class="app-header__dropdown-link" href="${pageContext.request.contextPath}/logout">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                                    <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
                                </svg>
                                Logout
                            </a>
                        </li>
                    </ul>
                </li>

            </c:when>
            <c:otherwise>
                <li class="app-header__menu-item">
                    <a class="app-header__menu-link app-header__login-btn"
                       href="${pageContext.request.contextPath}/login">Login</a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<style>
     /* ===== GLOBAL RESET (ensures consistent layout on ALL pages) ===== */
    *, *::before, *::after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    html, body {
        margin: 0;
        padding: 0;
    }

    body {
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        color: #111;
        min-height: 100vh;
    }

    /* ===== HEADER BASE ===== */
    .app-header,
    .app-header * {
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
    }
    /* ===== HEADER BASE ===== */
    .app-header {
        width: 100%;
        display: flex;
        align-items: center;
        padding: 12px 24px;
        border-bottom: 1px solid #e5e7eb;
        font-size: 14px;
        background: #ffffff;
        position: sticky;
        top: 0;
        z-index: 1000;
        gap: 8px;
    }

    .app-header__logo {
        font-weight: 700;
        font-size: 20px;
        color: #000;
        text-decoration: none;
        margin-right: 32px;
    }

    .app-header__menu,
    .app-header__user {
        display: flex;
        align-items: center;
        list-style: none;
        padding: 0;
        margin: 0;
        gap: 4px;
    }

    .app-header__user {
        margin-left: auto;
        gap: 8px;
    }

    .app-header__menu-link {
        display: block;
        padding: 6px 12px;
        border-radius: 6px;
        color: #374151;
        text-decoration: none;
        font-weight: 500;
        font-size: 14px;
        transition: background 0.15s;
    }

    .app-header__menu-link:hover {
        background-color: #f3f4f6;
        color: #111827;
    }

    .app-header__login-btn {
        font-weight: 600;
        background: #111827;
        color: #fff !important;
        border-radius: 50px;
        padding: 6px 18px;
    }

    .app-header__login-btn:hover {
        background: #374151 !important;
    }

    /* ==========================================
       NOTIFICATION
    ========================================== */
    .app-header__notification {
        position: relative;
    }

    .app-header__noti-trigger {
        position: relative;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: 1px solid #e5e7eb;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #6b7280;
        cursor: pointer;
        transition: background 0.15s, border-color 0.15s;
    }

    .app-header__noti-trigger:hover {
        background: #f3f4f6;
        border-color: #d1d5db;
        color: #111827;
    }

    .app-header__noti-bell {
        width: 17px;
        height: 17px;
    }

    .app-header__noti-badge {
        position: absolute;
        top: -4px;
        right: -4px;
        background: #ef4444;
        color: #fff;
        font-size: 10px;
        font-weight: 700;
        min-width: 17px;
        height: 17px;
        border-radius: 9px;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #fff;
        padding: 0 3px;
    }

    .app-header__noti-dropdown {
        position: absolute;
        top: calc(100% + 10px);
        right: -8px;
        width: 340px;
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.10);
        display: none;
        flex-direction: column;
        z-index: 10000;
        overflow: hidden;
        animation: notiDropIn 0.18s ease;
    }

    @keyframes notiDropIn {
        from { opacity: 0; transform: translateY(-6px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    .app-header__notification.open .app-header__noti-dropdown {
        display: flex;
    }

    .app-header__noti-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 14px 16px 10px;
    }

    .app-header__noti-title {
        font-size: 14px;
        font-weight: 700;
        color: #111827;
    }

    .app-header__noti-mark-all {
        font-size: 12px;
        font-weight: 500;
        color: #3b82f6;
        text-decoration: none;
        padding: 3px 8px;
        border-radius: 6px;
        transition: background 0.15s;
        background: none;
        border: none;
        cursor: pointer;
        font-family: inherit;
    }

    .app-header__noti-mark-all:hover:not(:disabled) {
        background: #eff6ff;
        color: #1d4ed8;
    }

    .app-header__noti-mark-all:disabled {
        color: #d1d5db;
        cursor: default;
    }

    .app-header__noti-list {
        list-style: none;
        padding: 0;
        margin: 0;
        max-height: 300px;
        overflow-y: auto;
        border-top: 1px solid #f3f4f6;
    }

    .app-header__noti-list::-webkit-scrollbar { width: 4px; }
    .app-header__noti-list::-webkit-scrollbar-thumb {
        background: #e5e7eb;
        border-radius: 4px;
    }

    .app-header__noti-empty {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        padding: 28px 16px;
        color: #9ca3af;
        font-size: 13px;
    }

    .app-header__noti-item {
        border-bottom: 1px solid #f9fafb;
    }

    .app-header__noti-item.unread {
        background-color: #f0f7ff;
    }

    .app-header__noti-item:last-child {
        border-bottom: none;
    }

    .app-header__noti-link {
        display: flex;
        align-items: flex-start;
        gap: 12px;
        padding: 12px 16px;
        text-decoration: none;
        color: inherit;
        transition: background 0.12s;
    }

    .app-header__noti-link:hover {
        background: #f9fafb;
    }

    .app-header__noti-icon {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        flex-shrink: 0;
    }

    /* Icon color classes — match your noti.getIconClass() values */
    .app-header__noti-icon.bg-primary   { background: #dbeafe; color: #1d4ed8; }
    .app-header__noti-icon.bg-success   { background: #dcfce7; color: #16a34a; }
    .app-header__noti-icon.bg-warning   { background: #fef3c7; color: #d97706; }
    .app-header__noti-icon.bg-danger    { background: #fee2e2; color: #dc2626; }
    .app-header__noti-icon.bg-info      { background: #e0f2fe; color: #0369a1; }
    .app-header__noti-icon.bg-secondary { background: #f3f4f6; color: #6b7280; }

    .app-header__noti-content {
        flex: 1;
        min-width: 0;
    }

    .app-header__noti-text {
        font-size: 13px;
        color: #111827;
        margin: 0 0 3px;
        line-height: 1.4;
    }

    .app-header__noti-time {
        font-size: 11px;
        color: #9ca3af;
    }

    .app-header__noti-dot {
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: #3b82f6;
        flex-shrink: 0;
        margin-top: 5px;
    }

    .app-header__noti-footer {
        padding: 10px 16px;
        text-align: center;
        border-top: 1px solid #f3f4f6;
        background: #fafafa;
    }

    .app-header__noti-footer a {
        font-size: 13px;
        font-weight: 600;
        color: #3b82f6;
        text-decoration: none;
    }

    .app-header__noti-footer a:hover {
        text-decoration: underline;
    }

    /* ==========================================
       USER DROPDOWN
    ========================================== */
    .app-header__user-info {
        position: relative;
        z-index: 9999;
    }

    .app-header__user-trigger {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 5px 10px 5px 5px;
        border-radius: 8px;
        border: 1px solid transparent;
        cursor: pointer;
        transition: background 0.15s, border-color 0.15s;
        background: transparent;
    }

    .app-header__user-trigger:hover {
        background: #f3f4f6;
        border-color: #e5e7eb;
    }

    .app-header__user-info.open .app-header__user-trigger {
        background: #f3f4f6;
        border-color: #e5e7eb;
    }

    .app-header__avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
        flex-shrink: 0;
    }

    .app-header__username {
        font-size: 14px;
        font-weight: 500;
        color: #111827;
        white-space: nowrap;
    }

    .app-header__chevron {
        width: 14px;
        height: 14px;
        color: #9ca3af;
        transition: transform 0.2s ease;
        flex-shrink: 0;
    }

    .app-header__user-info.open .app-header__chevron {
        transform: rotate(180deg);
    }

    .app-header__dropdown {
        position: absolute;
        top: calc(100% + 8px);
        right: 0;
        width: 210px;
        list-style: none;
        padding: 6px;
        margin: 0;
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.10);
        display: none;
        flex-direction: column;
        z-index: 10000;
        animation: notiDropIn 0.18s ease;
    }

    .app-header__user-info.open .app-header__dropdown {
        display: flex;
    }

    /* User info block at top of dropdown */
    .app-header__dropdown-user-info {
        display: flex;
        flex-direction: column;
        padding: 10px 12px 10px;
        border-bottom: 1px solid #f3f4f6;
        margin-bottom: 4px;
    }

    .app-header__dropdown-user-name {
        font-size: 14px;
        font-weight: 600;
        color: #111827;
    }

    .app-header__dropdown-user-role {
        font-size: 12px;
        color: #9ca3af;
        margin-top: 1px;
        text-transform: capitalize;
    }

    .app-header__dropdown-item a,
    .app-header__dropdown-link {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 8px 12px;
        border-radius: 6px;
        text-decoration: none;
        color: #111827;
        font-size: 13px;
        font-weight: 500;
        transition: background 0.12s;
    }

    .app-header__dropdown-item a svg,
    .app-header__dropdown-link svg {
        width: 15px;
        height: 15px;
        flex-shrink: 0;
        color: #9ca3af;
    }

    .app-header__dropdown-item a:hover,
    .app-header__dropdown-link:hover {
        background: #f3f4f6;
    }

    .app-header__dropdown-divider {
        height: 1px;
        background: #f3f4f6;
        margin: 4px 0;
    }

    .app-header__dropdown-item--danger a,
    .app-header__dropdown-item--danger .app-header__dropdown-link {
        color: #dc2626;
    }

    .app-header__dropdown-item--danger a svg,
    .app-header__dropdown-item--danger .app-header__dropdown-link svg {
        color: #dc2626;
    }

    .app-header__dropdown-item--danger a:hover,
    .app-header__dropdown-item--danger .app-header__dropdown-link:hover {
        background: #fee2e2;
    }
</style>

<script>
(function () {

    // ── Hover dropdown (notification + user menu) ──────────────
    function setupHoverDropdown(wrapEl) {
        var closeTimer = null;
        wrapEl.addEventListener('mouseenter', function () {
            if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
            wrapEl.classList.add('open');
        });
        wrapEl.addEventListener('mouseleave', function () {
            closeTimer = setTimeout(function () {
                wrapEl.classList.remove('open');
            }, 120);
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var notiWrap = document.querySelector('.app-header__notification');
        if (notiWrap) setupHoverDropdown(notiWrap);

        var userWrap = document.querySelector('.app-header__user-info');
        if (userWrap) setupHoverDropdown(userWrap);
    });

})();

// ── Mark all as read (AJAX) ────────────────────────────────────
var contextPath = '${pageContext.request.contextPath}';

function markAllRead(e) {
    e.preventDefault();

    var btn = document.getElementById('markAllReadBtn');
    if (!btn || btn.disabled) return;

    btn.disabled = true;
    btn.textContent = 'Marking...';

    fetch(contextPath + '/mark-all-read', {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function (res) {
        if (res.ok) {
            // 1. Xóa badge số đỏ trên chuông
            var badge = document.querySelector('.app-header__noti-badge');
            if (badge) badge.remove();

            // 2. Xóa chấm xanh trên từng item
            document.querySelectorAll('.app-header__noti-dot').forEach(function (dot) {
                dot.remove();
            });

            // 3. Xóa nền xanh nhạt của item unread
            document.querySelectorAll('.app-header__noti-item.unread').forEach(function (item) {
                item.classList.remove('unread');
            });

            // 4. Đổi text button
            btn.textContent = 'All read ✓';
            btn.style.color = '#9ca3af';
            btn.style.cursor = 'default';
        } else {
            btn.disabled = false;
            btn.textContent = 'Mark all as read';
        }
    })
    .catch(function () {
        btn.disabled = false;
        btn.textContent = 'Mark all as read';
    });
}
</script>
