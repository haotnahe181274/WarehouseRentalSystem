<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Blog Management - WareSpace</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
    <style>
        .blog-badge-cat {
            background: #eff6ff;
            color: #1d4ed8;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .blog-actions { display: flex; gap: 8px; align-items: center; }
        .blog-actions a { color: #374151; }
        .blog-actions a:hover { color: #111827; }
        .blog-actions .action-delete { color: #b91c1c; }
    </style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp" />
    <jsp:include page="/message/popupMessage.jsp" />

    <div class="layout">
        <c:if test="${sessionScope.userType == 'INTERNAL'}">
            <jsp:include page="/Common/Layout/sidebar.jsp" />
        </c:if>

        <div class="main-content">
            <h3><i class="fa-solid fa-newspaper" style="margin-right: 8px; color: #6b7280;"></i>${pageTitle != null ? pageTitle : "My Posts"}</h3>

            <div class="management-card">
                <table id="blogTable" style="width:100%">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${blogList}" var="post">
                            <tr>
                                <td style="font-weight: 600;">${post.title}</td>
                                <td>
                                    <span class="blog-badge-cat">${post.categoryName}</span>
                                </td>
                                <td style="font-size: 13px; color: #6b7280;">${post.createdAt}</td>
                                <td>
                                    <div class="blog-actions">
                                        <a href="blog-crud?action=view&id=${post.postId}" title="View">
                                            <i class="fa-solid fa-eye"></i></a>
                                        <c:if test="${canManage}">
                                            <a href="blog-crud?action=edit&id=${post.postId}" title="Edit">
                                                <i class="fa-solid fa-pen"></i></a>
                                            <a href="blog-crud?action=delete&id=${post.postId}"
                                               class="action-delete"
                                               onclick="return confirm('Are you sure you want to delete this post?')"
                                               title="Delete"><i class="fa-solid fa-trash"></i></a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#blogTable').DataTable({
                pageLength: 5,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                dom: '<"dt-controls-top"lf>rt<"dt-controls-bottom"ip>',
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search posts...",
                    lengthMenu: "_MENU_ entries per page"
                },
                order: [[2, "desc"]]
            });
        });
    </script>
</body>
</html>
