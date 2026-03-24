<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Discuss - WareSpace</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="background-color: #f0f2f5;">
            <jsp:include page="/Common/Layout/header.jsp" />
            <div class="discuss-layout">
                <div class="feed-column">
                    <!-- Create Post Box -->
                    <div class="post-card create-post-card">
                        <div class="create-post-header">
                            <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image != null ? sessionScope.user.image : 'default.jpg'}"
                                class="author-img">
                            <button type="button" class="create-post-trigger" onclick="toggleCreateModal()">What's on
                                your mind, ${sessionScope.user.fullName}?</button>
                        </div>
                    </div>

                    <c:if test="${empty blogList}">
                        <div class="post-card text-center">
                            <p class="text-muted">No posts found in this category.</p>
                        </div>
                    </c:if>

                    <c:forEach items="${blogList}" var="post">
                        <div class="post-card" id="post-${post.postId}">
                            <div class="post-header">
                                <img src="${pageContext.request.contextPath}/resources/user/image/${post.authorImage != null ? post.authorImage : 'default.jpg'}"
                                    class="author-img" alt="Author">
                                <div class="author-info">
                                    <span class="author-name">${post.authorName}</span>
                                    <span class="post-meta">${post.createdAt} • ${post.categoryName}</span>
                                </div>
                            </div>

                            <div class="post-content">
                                <h3 class="post-title">${post.title}</h3>
                                <div class="post-text">${post.content}</div>
                            </div>

                            <div class="post-stats">
                                <div>
                                    <span id="like-count-${post.postId}">${post.likeCount}</span> likes •
                                    <span id="comment-count-${post.postId}">${post.commentCount}</span> comments
                                </div>
                            </div>

                            <div class="post-actions">
                                <div class="action-item ${post.isLikedByUser ? 'active' : ''}"
                                    onclick="toggleLike(${post.postId})">
                                    <i class="fa${post.isLikedByUser ? 's' : 'r'} fa-thumbs-up"></i> Like
                                </div>
                                <div class="action-item" onclick="toggleComments(${post.postId})">
                                    <i class="far fa-comment"></i> Comment
                                </div>
                            </div>

                            
                            <div class="comment-section" id="comment-section-${post.postId}">
                                <div class="comment-list" id="comment-list-${post.postId}"></div>
                                <div class="comment-input-area mt-2">
                                    <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image != null ? sessionScope.user.image : 'default.jpg'}"
                                        class="author-img" style="width: 32px; height: 32px;">
                                    <div class="input-group" style="flex:1;">
                                        <input type="text" class="comment-input" placeholder="Write a comment..."
                                            id="comment-input-${post.postId}"
                                            onkeypress="handleComment(event, ${post.postId})">
                                        <button class="btn-send-comment" onclick="submitComment(${post.postId})">
                                            <i class="fas fa-paper-plane"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    
                    <jsp:include page="/Common/homepage/pagination.jsp" />
                </div>

             
                <div class="sidebar-column">
                    <c:if test="${not empty sessionScope.user}">
                        <div class="post-card" style="margin-bottom: 12px; padding: 12px;">
                            <a href="${pageContext.request.contextPath}/blog" class="btn-post" 
                               style="text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                <i class="fas fa-user-edit"></i> My Posts
                            </a>
                        </div>
                    </c:if>
                    <div class="category-card">
                        <h4>Categories</h4>
                        <ul class="category-list">
                            <li class="${selectedCategory == null ? 'active' : ''}">
                                <a href="discuss">All Categories</a>
                            </li>
                            <c:forEach items="${categories}" var="cat">
                                <li class="${selectedCategory == cat.categoryId ? 'active' : ''}">
                                    <a href="discuss?categoryId=${cat.categoryId}">${cat.categoryName}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>

            
            <div id="createPostModal" class="modal-overlay">
                <div class="modal-content-fb">
                    <div class="modal-header-fb">
                        <h3>Create Post</h3>
                        <span class="close-modal" onclick="toggleCreateModal()">&times;</span>
                    </div>
                    <div class="modal-body-fb">
                        <div class="author-header">
                            <img src="${pageContext.request.contextPath}/resources/user/image/${sessionScope.user.image != null ? sessionScope.user.image : 'default.jpg'}"
                                class="author-img">
                            <div class="author-info" style="margin-left: 12px;">
                                <div class="author-name">${sessionScope.user.fullName}</div>
                                <select id="createPostCategory" class="category-select">
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.categoryId}">${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <input type="text" id="createPostTitle" class="modal-title-input"
                            placeholder="Put a title here...">
                        <textarea id="createPostContent" class="modal-textarea"
                            placeholder="What's on your mind, ${sessionScope.user.fullName}?"></textarea>
                        <button class="btn-post" onclick="submitPost()">Post</button>
                    </div>
                </div>
            </div>

            <script>
                function toggleCreateModal() {
                    const modal = document.getElementById('createPostModal');
                    modal.style.display = (modal.style.display === 'flex') ? 'none' : 'flex';
                }

                function submitPost() {
                    const title = document.getElementById('createPostTitle').value.trim();
                    const content = document.getElementById('createPostContent').value.trim();
                    const catId = document.getElementById('createPostCategory').value;

                    if (!title || !content) {
                        alert('Please fill in both title and content');
                        return;
                    }

                    fetch('blog-action', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: `action=create&title=\${encodeURIComponent(title)}&content=\${encodeURIComponent(content)}&categoryId=\${catId}`
                    })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                location.reload();
                            }
                        });
                }

                function toggleLike(postId) {
                    fetch('blog-action', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'action=like&postId=' + postId
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                const postEl = document.getElementById('post-' + postId);
                                const likeBtn = postEl.querySelector('.action-item');
                                const icon = likeBtn.querySelector('i');
                                const countSpan = document.getElementById('like-count-' + postId);
                                let count = parseInt(countSpan.textContent);

                                if (data.isLiked) {
                                    likeBtn.classList.add('active');
                                    icon.className = 'fas fa-thumbs-up';
                                    countSpan.textContent = count + 1;
                                } else {
                                    likeBtn.classList.remove('active');
                                    icon.className = 'far fa-thumbs-up';
                                    countSpan.textContent = count - 1;
                                }
                            }
                        });
                }

                function toggleComments(postId) {
                    const section = document.getElementById('comment-section-' + postId);
                    if (section.style.display === 'block') {
                        section.style.display = 'none';
                    } else {
                        section.style.display = 'block';
                        loadComments(postId);
                    }
                }

                function loadComments(postId) {
                    const container = document.getElementById('comment-list-' + postId);
                    fetch('blog-action?action=getComments&postId=' + postId)
                        .then(res => res.json())
                        .then(comments => {
                            const commentsHtml = comments.filter(c => c.parentCommentId == 0).map(c => {
                                const replies = comments.filter(r => r.parentCommentId == c.commentId);
                                const imgName = (c.userImage && c.userImage !== 'null' && c.userImage !== '') ? c.userImage : 'default.jpg';
                                const imgPath = '${pageContext.request.contextPath}/resources/user/image/' + imgName;

                                return `
                                    <div class="comment-item">
                                        <img src="\${imgPath}" alt="User" class="author-img" style="width:32px; height:32px;">
                                        <div class="comment-body-wrapper">
                                            <div class="comment-bubble">
                                                <div class="comment-author">\${c.userName}</div>
                                                <div class="comment-text">\${c.content}</div>
                                            </div>
                                            <div class="comment-actions">
                                                <span class="reply-btn" onclick="toggleReplyForm(\${c.commentId}, \${postId})">Reply</span>
                                                <span>\${c.createdAt}</span>
                                                
                                            </div>
                                            <div id="reply-form-\${c.commentId}" class="reply-form mt-2" style="display:none; margin-left: 12px;">
                                                <div class="input-group input-group-sm">
                                                    <input type="text" id="reply-input-\${c.commentId}" class="comment-input" placeholder="Write a reply...">
                                                    <button class="btn-send-comment" onclick="submitComment(\${postId}, \${c.commentId})">
                                                        <i class="fas fa-paper-plane"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="replies-list">
                                                \${replies.map(r => {
                                                    const rImgName = (r.userImage && r.userImage !== 'null' && r.userImage !== '') ? r.userImage : 'default.jpg';
                                                    const rImgPath = '${pageContext.request.contextPath}/resources/user/image/' + rImgName;
                                                    return `
                                    <div class="comment-item">
                                        <img src="\${rImgPath}" alt="User" class="author-img" style="width:24px; height:24px;">
                                        <div class="comment-body-wrapper">
                                            <div class="comment-bubble">
                                                <div class="comment-author" style="font-size:12px;">\${r.userName}</div>
                                                <div class="comment-text" style="font-size:13px;">\${r.content}</div>
                                            </div>
                                            <div class="comment-actions" style="margin-left: 0; font-size: 11px;">
                                                <span>\${r.createdAt}</span>
                                                <span class="reply-btn" style="margin-left: 8px;" onclick="toggleReplyForm(\${c.commentId}, \${postId})">Reply</span>
                                            </div>
                                        </div>
                                    </div>
                                `;
                                                }).join('')}
                                            </div>
                                        </div>
                                    </div>
                                `;
                            }).join('');
                            container.innerHTML = commentsHtml || '<p class="text-muted small p-2">No comments yet.</p>';
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

                function submitComment(postId, parentCommentId = null) {
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

                    fetch('blog-action', {
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