<%-- Document : blog-list Created on : Mar 6, 2026, 10:48:14 PM Author : hao23 --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Blog List - WareSpace</title>
            <%@ include file="/Common/Layout/header.jsp" %>
                
        </head>

        <body style="background-color: #f8f9fa;">
            <div class="blog-container">
                <h1 style="text-align: center; margin-bottom: 40px;">Warehouse Management & Rentals Blog</h1>

                <c:if test="${empty blogList}">
                    <p style="text-align: center; color: #7f8c8d;">No blog posts available at the moment.</p>
                </c:if>

                <c:forEach items="${blogList}" var="post">
                    <div class="blog-card">
                        <h2 class="blog-title">${post.title}</h2>
                        <div class="blog-meta">
                            <span>Category: <strong>${post.categoryName}</strong></span> |
                            <span>Views: ${post.viewCount}</span> |
                            <span>Published on: ${post.createdAt}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </body>

        </html>