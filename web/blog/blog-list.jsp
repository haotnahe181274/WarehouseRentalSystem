<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Blog Management - WareSpace</title>
            <%@ include file="/Common/Layout/header.jsp" %>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="background-color: #f0f2f5;">
            <div style="max-width: 680px; margin: 40px auto; padding: 0 16px;">
                <!-- Header Card -->
                <div class="post-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="margin: 0; font-weight: 700; color: var(--fb-text);">
                        <i class="fas fa-newspaper"></i> ${pageTitle != null ? pageTitle : "My Posts"}
                    </h3>
                    <c:if test="${canManage}">
                        <a href="blog-crud?action=create" class="btn-post"
                            style="width: auto; padding: 8px 20px; font-size: 14px;">
                            <i class="fas fa-plus"></i> New Post
                        </a>
                    </c:if>
                </div>

                <c:if test="${empty blogList}">
                    <div class="post-card" style="text-align: center; color: var(--fb-secondary-text); padding: 40px;">
                        <i class="far fa-newspaper" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                        <p style="margin: 0;">No blog posts available at the moment.</p>
                    </div>
                </c:if>

                <c:forEach items="${blogList}" var="post">
                    <div class="post-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <h4 style="margin: 0 0 6px 0; font-weight: 600; color: var(--fb-text);">${post.title}
                                </h4>
                                <div style="font-size: 13px; color: var(--fb-secondary-text);">
                                    <span class="badge"
                                        style="background: #e7f3ff; color: var(--fb-accent); padding: 3px 10px; border-radius: 12px; font-weight: 500;">${post.categoryName}</span>
                                    &bull; ${post.createdAt}
                                </div>
                            </div>
                        </div>

                        <div
                            style="display: flex; gap: 8px; margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--fb-hover);">
                            <a href="blog-crud?action=view&id=${post.postId}"
                                style="flex: 1; text-align: center; padding: 8px; border-radius: 6px; background: var(--fb-bg); color: var(--fb-accent); text-decoration: none; font-weight: 600; font-size: 14px; transition: background 0.2s;">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <c:if test="${canManage}">
                                <a href="blog-crud?action=edit&id=${post.postId}"
                                    style="flex: 1; text-align: center; padding: 8px; border-radius: 6px; background: var(--fb-bg); color: var(--fb-secondary-text); text-decoration: none; font-weight: 600; font-size: 14px; transition: background 0.2s;">
                                    <i class="fas fa-pen"></i> Edit
                                </a>
                                <a href="blog-crud?action=delete&id=${post.postId}"
                                    onclick="return confirm('Are you sure you want to delete this post?')"
                                    style="flex: 1; text-align: center; padding: 8px; border-radius: 6px; background: #ffebee; color: #d32f2f; text-decoration: none; font-weight: 600; font-size: 14px; transition: background 0.2s;">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <jsp:include page="/Common/Layout/footer.jsp" />
        </body>

        </html>