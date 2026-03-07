<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>${post != null ? 'Edit Blog' : 'Create Blog'} - WareSpace</title>
            <%@ include file="/Common/Layout/header.jsp" %>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <style>
                    .form-container {
                        max-width: 700px;
                        margin: 40px auto;
                        padding: 30px;
                        background: #fff;
                        border-radius: 8px;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        font-weight: 600;
                        color: #2c3e50;
                    }

                    .form-control {
                        width: 100%;
                        padding: 10px;
                        border: 1px solid var(--border-color);
                        border-radius: 4px;
                        font-size: 1rem;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: var(--primary-color);
                        box-shadow: 0 0 0 2px rgba(13, 110, 253, 0.25);
                    }

                    textarea.form-control {
                        min-height: 200px;
                        resize: vertical;
                    }

                    .btn-submit {
                        width: 100%;
                        margin-top: 20px;
                    }
                </style>
        </head>

        <body style="background-color: #f8f9fa;">
            <div class="form-container">
                <h2 class="mb-4">${post != null ? 'Edit' : 'Create'} Blog Post</h2>
                <form action="blog-crud" method="post">
                    <input type="hidden" name="id" value="${post.postId}">
                    <input type="hidden" name="action" value="${post != null ? 'update' : 'create'}">

                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" id="title" name="title" class="form-control" value="${post.title}" required
                            placeholder="Enter blog title">
                    </div>

                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <select id="categoryId" name="categoryId" class="form-control" required>
                            <option value="" disabled selected>Select a category</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}" ${post.categoryId==cat.categoryId ? 'selected' : '' }>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="content">Content</label>
                        <textarea id="content" name="content" class="form-control" required
                            placeholder="Write your blog content here...">${post.content}</textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit">
                        ${post != null ? 'Update Post' : 'Create Post'}
                    </button>
                    <a href="blog" class="btn btn-outline-secondary btn-submit"
                        style="display: block; text-align: center; margin-top: 10px;">Cancel</a>
                </form>
            </div>
        </body>

        </html>