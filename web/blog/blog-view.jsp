<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${post.title} - WareSpace Blog</title>
        <%@ include file="/Common/Layout/header.jsp" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
            <style>
                .view-container {
                    max-width: 800px;
                    margin: 40px auto;
                    padding: 30px;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .view-title {
                    font-size: 2.5rem;
                    margin-bottom: 20px;
                    color: #2c3e50;
                }

                .view-meta {
                    color: #7f8c8d;
                    font-size: 0.9rem;
                    margin-bottom: 30px;
                    padding-bottom: 15px;
                    border-bottom: 1px solid #eee;
                }

                .view-content {
                    line-height: 1.8;
                    font-size: 1.1rem;
                    color: #34495e;
                    white-space: pre-wrap;
                }

                .back-link {
                    display: inline-block;
                    margin-top: 30px;
                }
            </style>
    </head>

    <body style="background-color: #f8f9fa;">
        <div class="view-container">
            <h1 class="view-title">${post.title}</h1>
            <div class="view-meta d-flex justify-content-between">
                <div>
                    <span>Category: <strong>${post.categoryName}</strong></span> |
                    <span>Published on: ${post.createdAt}</span>
                </div>
                <div>
                    <span>Views: ${post.viewCount}</span>
                </div>
            </div>
            <div class="view-content">${post.content}</div>

            <a href="blog" class="btn btn-outline-secondary back-link">
                <i class="fas fa-arrow-left"></i> Back to List
            </a>
        </div>
    </body>

    </html>