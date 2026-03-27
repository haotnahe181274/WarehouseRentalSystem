<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>${post != null ? 'Edit Blog' : 'Create Blog'} - WareSpace</title>
            <%@ include file="/Common/Layout/header.jsp" %>
            <jsp:include page="/message/popupMessage.jsp" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="background-color: #f0f2f5;">
            <div style="max-width: 680px; margin: 40px auto; padding: 0 16px;">
                <!-- Post Card -->
                <div class="post-card">
                    <div class="post-header">
                        <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image != null ? sessionScope.user.image : 'default.jpg'}"
                            class="author-img" alt="Author">
                        <div class="author-info">
                            <span class="author-name">${sessionScope.user.fullName}</span>
                            <span class="post-meta">${post != null ? 'Editing Post' : 'Creating New Post'}</span>
                        </div>
                    </div>

                    <form action="blog-crud" method="post">
                        <input type="hidden" name="id" value="${post.postId}">
                        <input type="hidden" name="action" value="${post != null ? 'update' : 'create'}">

                        <!-- Title -->
                        <div style="margin-bottom: 12px;">
                            <input type="text" name="title" value="${post.title}" required
                                placeholder="Put a title here..." class="modal-title-input">
                        </div>

                        <!-- Category -->
                        <div style="margin-bottom: 12px;">
                            <select name="categoryId" required class="category-select"
                                style="width: 100%; padding: 8px 12px; font-size: 14px;">
                                <option value="" disabled selected>Select a category</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.categoryId}" ${post.categoryId==cat.categoryId ? 'selected'
                                        : '' }>
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Content -->
                        <div style="margin-bottom: 16px;">
                            <textarea name="content" required
                                placeholder="What's on your mind, ${sessionScope.user.fullName}?" class="modal-textarea"
                                style="min-height: 200px;">${post.content}</textarea>
                        </div>

                        <button type="submit" class="btn-post">
                            <i class="fas ${post != null ? 'fa-save' : 'fa-paper-plane'}"></i>
                            ${post != null ? 'Update Post' : 'Create Post'}
                        </button>
                        <a href="blog" class="btn-post"
                            style="display: block; text-align: center; margin-top: 10px; background: #e4e6eb; color: #050505; text-decoration: none;">
                            Cancel
                        </a>
                    </form>
                </div>
            </div>

            <jsp:include page="/Common/Layout/footer.jsp" />
        </body>

        </html>