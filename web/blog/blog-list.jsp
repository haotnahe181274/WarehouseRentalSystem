<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Blog Management - WareSpace</title>
            <%@ include file="/Common/Layout/header.jsp" %>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <style>
                    .blog-container {
                        max-width: 1200px;
                        margin: 40px auto;
                        padding: 20px;
                    }

                    .blog-table {
                        width: 100%;
                        background: #fff;
                        border-radius: 8px;
                        overflow: hidden;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        border-collapse: collapse;
                    }

                    .blog-table th,
                    .blog-table td {
                        padding: 15px;
                        text-align: left;
                        border-bottom: 1px solid #eee;
                    }

                    .blog-table th {
                        background-color: #f8f9fa;
                        font-weight: 600;
                        color: #2c3e50;
                    }

                    .action-btns {
                        display: flex;
                        gap: 10px;
                    }

                    .btn-create {
                        margin-bottom: 20px;
                    }
                </style>
        </head>

        <body style="background-color: #f8f9fa;">
            <div class="blog-container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Blog Management</h1>
                    <a href="blog-crud?action=create" class="btn btn-primary btn-create">
                        <i class="fas fa-plus"></i> Create New Blog
                    </a>
                </div>

                <c:if test="${empty blogList}">
                    <div class="alert alert-info text-center">No blog posts available at the moment.</div>
                </c:if>

                <c:if test="${not empty blogList}">
                    <table class="blog-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Views</th>
                                <th>Published Date</th>
                                <th style="width: 200px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${blogList}" var="post">
                                <tr>
                                    <td>${post.postId}</td>
                                    <td><strong>${post.title}</strong></td>
                                    <td><span class="badge bg-secondary">${post.categoryName}</span></td>
                                    <td>${post.viewCount}</td>
                                    <td class="text-muted">${post.createdAt}</td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="blog-crud?action=view&id=${post.postId}"
                                                class="btn btn-sm btn-outline-primary" title="View">
                                                View
                                            </a>
                                            <a href="blog-crud?action=edit&id=${post.postId}"
                                                class="btn btn-sm btn-outline-secondary" title="Edit">
                                                Edit
                                            </a>
                                            <a href="blog-crud?action=delete&id=${post.postId}"
                                                class="btn btn-sm btn-outline-danger" title="Delete"
                                                onclick="return confirm('Are you sure you want to delete this post?')">
                                                Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </body>

        </html>