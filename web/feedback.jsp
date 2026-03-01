<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>

        <c:if test="${param.embedded != 'true'}">
            <!DOCTYPE html>
            <html>

            <head>
                <title>Feedback Warehouse ${warehouseId}</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </c:if>

        <style>
            /* Reviews Card */
            .reviews-card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                margin-bottom: 20px;
                overflow: hidden;
            }

            .reviews-header {
                padding: 14px 20px;
                border-bottom: 1px solid #e5e7eb;
                font-size: 18px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .reviews-body {
                padding: 16px 20px;
            }

            .empty-text {
                color: #9ca3af;
                font-size: 14px;
            }

            /* Feedback Item */
            .feedback-item {
                padding: 12px 0;
                border-bottom: 1px solid #f3f4f6;
            }

            .feedback-item:last-child {
                border-bottom: none;
            }

            .feedback-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 4px;
            }

            .feedback-author {
                font-weight: 600;
                font-size: 15px;
            }

            .feedback-stars {
                display: flex;
                gap: 2px;
            }

            .feedback-stars .star {
                color: #d1d5db;
                font-size: 16px;
            }

            .feedback-stars .star.filled {
                color: #f59e0b;
            }

            .feedback-comment {
                font-size: 14px;
                color: #374151;
                margin: 6px 0 4px 0;
                line-height: 1.5;
            }

            .feedback-date {
                font-size: 12px;
                color: #9ca3af;
            }

            /* Response Box */
            .response-box {
                margin-top: 10px;
                margin-left: 20px;
                padding: 10px 14px;
                background: #f3f4f6;
                border-left: 3px solid #3b82f6;
                border-radius: 6px;
            }

            .response-box .resp-author {
                font-weight: 600;
                font-size: 13px;
                color: #1e40af;
                margin-bottom: 3px;
            }

            .response-box .resp-text {
                font-size: 14px;
                color: #374151;
                margin: 3px 0;
            }

            .response-box .resp-date {
                font-size: 12px;
                color: #9ca3af;
            }

            /* Reply Form */
            .reply-form {
                margin-top: 8px;
                margin-left: 20px;
            }

            .reply-form textarea {
                width: 100%;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                padding: 8px 12px;
                font-size: 14px;
                font-family: inherit;
                resize: vertical;
                min-height: 50px;
                outline: none;
                transition: border-color 0.2s;
            }

            .reply-form textarea:focus {
                border-color: #3b82f6;
            }

            .reply-form button {
                margin-top: 6px;
                padding: 6px 16px;
                background: #3b82f6;
                color: #fff;
                border: none;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
            }

            .reply-form button:hover {
                background: #2563eb;
            }

            /* Feedback Submit Form */
            .submit-card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 20px;
            }

            .submit-header {
                padding: 14px 20px;
                background: #111827;
                color: #fff;
                font-size: 18px;
                font-weight: 700;
            }

            .submit-body {
                padding: 16px 20px;
            }

            .form-group {
                margin-bottom: 14px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 4px;
            }

            .form-group select,
            .form-group textarea {
                width: 100%;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                padding: 8px 12px;
                font-size: 14px;
                font-family: inherit;
                outline: none;
                transition: border-color 0.2s;
            }

            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #3b82f6;
            }

            .checkbox-row {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 14px;
                font-size: 14px;
                color: #374151;
            }

            .checkbox-row input[type="checkbox"] {
                width: 16px;
                height: 16px;
                accent-color: #3b82f6;
            }

            .fb-btn-submit {
                padding: 10px 24px;
                background: #3b82f6;
                color: #fff;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
            }

            .fb-btn-submit:hover {
                background: #2563eb;
            }

            /* Warning */
            .warning-box {
                padding: 12px 16px;
                background: #fef3c7;
                border: 1px solid #fcd34d;
                border-radius: 8px;
                color: #92400e;
                font-size: 14px;
            }
        </style>

        <c:if test="${param.embedded != 'true'}">

            <body
                style="font-family: Arial, sans-serif; background: #f5f6fa; padding: 24px; color: #1f2937; margin: 0;">
                <div style="max-width: 800px; margin: 0 auto;">
                    <h1 style="font-size: 24px; font-weight: 700; margin-bottom: 16px;">Feedback for Warehouse
                        #${warehouseId}</h1>
                    <a href="homepage"
                        style="display:inline-block;padding:8px 16px;background:#6b7280;color:#fff;text-decoration:none;border-radius:6px;font-size:14px;font-weight:600;margin-bottom:20px;"><i
                            class="fas fa-arrow-left"></i> Back to Home</a>
        </c:if>

        <!-- Feedback List -->
        <div class="reviews-card">
            <div class="reviews-header"><i class="fas fa-comments"></i> Reviews</div>
            <div class="reviews-body">
                <c:if test="${empty feedbackList}">
                    <p class="empty-text">No feedback yet.</p>
                </c:if>
                <c:forEach items="${feedbackList}" var="f">
                    <div class="feedback-item" id="feedback-${f.feedbackId}">
                        <div class="feedback-top">
                            <span class="feedback-author">
                                <c:choose>
                                    <c:when test="${f.anonymous}">Anonymous</c:when>
                                    <c:otherwise>${f.renter.fullName}</c:otherwise>
                                </c:choose>
                            </span>
                            <div class="feedback-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <span class="star ${i <= f.rating ? 'filled' : ''}">&#9733;</span>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="feedback-comment">${f.comment}</p>
                        <span class="feedback-date">Posted on: ${f.feedbackDate}</span>

                        <!-- Response Section -->
                        <c:set var="userResponse" value="${feedbackResponses[f.feedbackId]}" />
                        <c:if test="${not empty userResponse}">
                            <div class="response-box">
                                <div class="resp-author"><i class="fas fa-reply"></i>
                                    ${userResponse.internalUser.fullName}</div>
                                <p class="resp-text">${userResponse.responseText}</p>
                                <span class="resp-date">Replied on: ${userResponse.responseDate}</span>
                            </div>
                        </c:if>

                        <c:if test="${empty userResponse and canReply}">
                            <div class="reply-form">
                                <form action="${pageContext.request.contextPath}/feedback" method="post">
                                    <input type="hidden" name="action" value="reply">
                                    <input type="hidden" name="warehouseId" value="${warehouseId}">
                                    <input type="hidden" name="feedbackId" value="${f.feedbackId}">
                                    <textarea name="responseText" rows="2" placeholder="Write a reply..."
                                        required></textarea>
                                    <button type="submit">Reply</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Feedback Form -->
        <c:if test="${canFeedback}">
            <div class="submit-card">
                <div class="submit-header"><i class="fas fa-pen"></i> Leave a Feedback</div>
                <div class="submit-body">
                    <form action="${pageContext.request.contextPath}/feedback" method="post">
                        <input type="hidden" name="warehouseId" value="${warehouseId}">

                        <div class="form-group">
                            <label for="fb-rating">Rating (1-5)</label>
                            <select name="rating" id="fb-rating" required>
                                <option value="5">5 - Excellent</option>
                                <option value="4">4 - Good</option>
                                <option value="3">3 - Average</option>
                                <option value="2">2 - Poor</option>
                                <option value="1">1 - Terrible</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="fb-comment">Comment</label>
                            <textarea name="comment" id="fb-comment" rows="3" required></textarea>
                        </div>

                        <div class="checkbox-row">
                            <input type="checkbox" name="anonymous" id="fb-anonymous">
                            <label for="fb-anonymous" style="font-weight:normal;">Post anonymously</label>
                        </div>

                        <button type="submit" class="fb-btn-submit">Submit Feedback</button>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${not canFeedback and not canReply}">
            <div class="warning-box">
                You can only leave feedback if you have an active contract for this warehouse.
            </div>
        </c:if>

        <c:if test="${param.embedded != 'true'}">
            </div>
            </body>

            </html>
        </c:if>