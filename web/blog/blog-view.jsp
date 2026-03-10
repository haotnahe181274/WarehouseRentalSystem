<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>${post.title} - WareSpace Blog</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <%@ include file="/Common/Layout/header.jsp" %>
        </head>

        <body style="background-color: #f0f2f5; font-family: Arial, sans-serif;">
            <div style="max-width: 680px; margin: 40px auto; padding: 0 16px;">
                <!-- Post Card -->
                <div class="post-card">
                    <div class="post-header">
                        <img src="${pageContext.request.contextPath}/resources/user/image/${post.authorImage != null ? post.authorImage : 'default.jpg'}"
                            class="author-img" alt="Author">
                        <div class="author-info">
                            <span class="author-name">${post.authorName}</span>
                            <span class="post-meta">${post.createdAt} &bull; ${post.categoryName}</span>
                        </div>
                    </div>

                    <div class="post-content">
                        <h3 class="post-title">${post.title}</h3>
                        <div class="post-text" style="white-space: pre-wrap;">${post.content}</div>
                    </div>

                    <!-- Comment Count -->
                    <div class="post-stats" style="border-top: 1px solid var(--fb-hover);">
                        <div>
                            <i class="far fa-comment"></i>
                            <span id="comment-count-${post.postId}">${post.commentCount}</span> comments
                        </div>
                    </div>

                    <!-- Comment Section -->
                    <div style="border-top: 1px solid #e4e6eb; padding-top: 8px;">
                        <!-- Comment List -->
                        <div id="comment-list-${post.postId}"></div>

                        <!-- Comment Input -->
                        <div
                            style="display: flex !important; flex-direction: row !important; align-items: center !important; gap: 8px; margin-top: 8px;">
                            <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image != null ? sessionScope.user.image : 'default.jpg'}"
                                style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; flex-shrink: 0;">
                            <div
                                style="flex: 1; display: flex !important; flex-direction: row !important; align-items: center !important; gap: 4px;">
                                <input type="text" class="comment-input" placeholder="Write a comment..."
                                    id="comment-input-${post.postId}" onkeypress="handleComment(event, ${post.postId})"
                                    style="flex: 1; min-width: 0; border: none; background: #f0f2f5; border-radius: 20px; padding: 8px 12px; font-size: 14px;">
                                <button onclick="submitComment(${post.postId})"
                                    style="background: none; border: none; color: #1877f2; cursor: pointer; padding: 6px; font-size: 16px;">
                                    <i class="fas fa-paper-plane"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Back Button -->
                <a href="blog"
                    style="display: block; text-align: center; margin-top: 16px; background: #e4e6eb; color: #050505; text-decoration: none; border-radius: 8px; padding: 10px; font-weight: 600;">
                    <i class="fas fa-arrow-left"></i> Back to My Posts
                </a>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    loadComments(${ post.postId });
                });

                function loadComments(postId) {
                    const container = document.getElementById('comment-list-' + postId);
                    fetch('${pageContext.request.contextPath}/blog-action?action=getComments&postId=' + postId)
                        .then(res => res.json())
                        .then(comments => {
                            const ctx = '${pageContext.request.contextPath}';
                            const commentsHtml = comments.filter(c => c.parentCommentId == 0).map(c => {
                                const replies = comments.filter(r => r.parentCommentId == c.commentId);
                                const imgName = (c.userImage && c.userImage !== 'null' && c.userImage !== '') ? c.userImage : 'default.jpg';
                                const imgPath = ctx + '/resources/user/image/' + imgName;

                                let repliesHtml = '';
                                replies.forEach(r => {
                                    const rImgName = (r.userImage && r.userImage !== 'null' && r.userImage !== '') ? r.userImage : 'default.jpg';
                                    const rImgPath = ctx + '/resources/user/image/' + rImgName;
                                    repliesHtml += '<div style="display:flex;gap:8px;margin-top:8px;margin-left:40px;">'
                                        + '<img src="' + rImgPath + '" style="width:24px;height:24px;border-radius:50%;object-fit:cover;flex-shrink:0;">'
                                        + '<div><div style="background:#f0f2f5;padding:6px 10px;border-radius:14px;"><strong style="font-size:12px;">' + r.userName + '</strong><div style="font-size:13px;">' + r.content + '</div></div></div>'
                                        + '</div>';
                                });

                                return '<div style="display:flex;gap:8px;margin-bottom:12px;">'
                                    + '<img src="' + imgPath + '" style="width:32px;height:32px;border-radius:50%;object-fit:cover;flex-shrink:0;">'
                                    + '<div style="flex:1;">'
                                    + '<div style="background:#f0f2f5;padding:8px 12px;border-radius:18px;">'
                                    + '<strong style="font-size:14px;">' + c.userName + '</strong>'
                                    + '<div style="font-size:14px;">' + c.content + '</div>'
                                    + '</div>'
                                    + '<div style="font-size:12px;color:#65676b;margin-top:2px;padding-left:12px;">'
                                    + '<span style="cursor:pointer;font-weight:600;" onclick="toggleReplyForm(' + c.commentId + ',' + postId + ')">Reply</span> &middot; '
                                    + '<span>' + c.createdAt + '</span>'
                                    + '</div>'
                                    + '<div id="reply-form-' + c.commentId + '" style="display:none;margin-top:6px;">'
                                    + '<div style="display:flex;gap:4px;align-items:center;">'
                                    + '<input type="text" id="reply-input-' + c.commentId + '" placeholder="Write a reply..." style="flex:1;border:none;background:#f0f2f5;border-radius:20px;padding:6px 10px;font-size:13px;">'
                                    + '<button onclick="submitComment(' + postId + ',' + c.commentId + ')" style="background:none;border:none;color:#1877f2;cursor:pointer;"><i class="fas fa-paper-plane"></i></button>'
                                    + '</div>'
                                    + '</div>'
                                    + repliesHtml
                                    + '</div>'
                                    + '</div>';
                            }).join('');
                            container.innerHTML = commentsHtml || '<p style="color:#65676b;font-size:14px;padding:8px;">No comments yet.</p>';
                        });
                }

                function toggleReplyForm(commentId, postId) {
                    const form = document.getElementById('reply-form-' + commentId);
                    form.style.display = form.style.display === 'none' ? 'block' : 'none';
                    if (form.style.display === 'block') {
                        document.getElementById('reply-input-' + commentId).focus();
                    }
                }

                function handleComment(event, postId) {
                    if (event.key === 'Enter') {
                        submitComment(postId);
                    }
                }

                function submitComment(postId, parentCommentId) {
                    const inputId = parentCommentId ? 'reply-input-' + parentCommentId : 'comment-input-' + postId;
                    const input = document.getElementById(inputId);
                    const content = input.value.trim();

                    if (!content) return;

                    const params = new URLSearchParams();
                    params.append('action', 'comment');
                    params.append('postId', postId);
                    params.append('content', content);
                    if (parentCommentId) {
                        params.append('parentCommentId', parentCommentId);
                    }

                    fetch('${pageContext.request.contextPath}/blog-action', {
                        method: 'POST',
                        body: params,
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                    })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                input.value = '';
                                if (parentCommentId) {
                                    document.getElementById('reply-form-' + parentCommentId).style.display = 'none';
                                }
                                loadComments(postId);
                                const countSpan = document.getElementById('comment-count-' + postId);
                                countSpan.textContent = parseInt(countSpan.textContent) + 1;
                            }
                        });
                }
            </script>

            <jsp:include page="/Common/Layout/footer.jsp" />
        </body>

        </html>