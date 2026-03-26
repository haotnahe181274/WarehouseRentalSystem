<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Blog Management - WareSpace</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <!-- DataTables CSS -->
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
                <style>
                    .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                        background: var(--fb-accent) !important;
                        color: white !important;
                        border: none !important;
                        border-radius: 4px;
                    }
                    .dataTables_wrapper .dataTables_filter input {
                        border: 1px solid var(--fb-border) !important;
                        border-radius: 20px !important;
                        padding: 5px 15px !important;
                        margin-bottom: 10px !important;
                    }
                    table.dataTable {
                        border-collapse: collapse !important;
                        border: none !important;
                    }
                    table.dataTable thead th {
                        border-bottom: 2px solid var(--fb-hover) !important;
                        padding: 12px 16px !important;
                    }
                    table.dataTable tbody td {
                        border-bottom: 1px solid var(--fb-hover) !important;
                        padding: 12px 16px !important;
                        background: transparent !important;
                    }
                </style>
        </head>

        <body style="background-color: #f0f2f5;">
            <jsp:include page="/Common/Layout/header.jsp" />
            <jsp:include page="/message/popupMessage.jsp" />
            <div style="max-width: 900px; margin: 40px auto; padding: 0 16px;">
                <!-- Header Card -->
                <div class="post-card">
                    <h3 style="margin: 0; font-weight: 700; color: var(--fb-text);">
                        <i class="fas fa-newspaper"></i> ${pageTitle != null ? pageTitle : "My Posts"}
                    </h3>
                </div>

                <div class="post-card">
                    <table id="blogTable" class="display" style="width:100%">
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
                                        <span class="badge"
                                              style="background: #e7f3ff; color: var(--fb-accent); padding: 3px 10px; border-radius: 12px; font-weight: 500;">
                                              ${post.categoryName}
                                        </span>
                                    </td>
                                    <td style="font-size: 13px; color: var(--fb-secondary-text);">${post.createdAt}</td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <a href="blog-crud?action=view&id=${post.postId}" title="View"
                                               style="color: var(--fb-accent);"><i class="fas fa-eye"></i></a>
                                            <c:if test="${canManage}">
                                                <a href="blog-crud?action=edit&id=${post.postId}" title="Edit"
                                                   style="color: var(--fb-secondary-text);"><i class="fas fa-pen"></i></a>
                                                <a href="blog-crud?action=delete&id=${post.postId}" 
                                                   onclick="return confirm('Are you sure you want to delete this post?')" 
                                                   title="Delete" style="color: #d32f2f;"><i class="fas fa-trash"></i></a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            <script>
                $(document).ready(function() {
                    $('#blogTable').DataTable({
                        "pageLength": 5,
                        "lengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                        "language": {
                            "search": "_INPUT_",
                            "searchPlaceholder": "Search posts..."
                        },
                        "order": [[2, "desc"]]
                    });
                });
            </script>
            </div>

            <jsp:include page="/Common/Layout/footer.jsp" />
        </body>

        </html>