<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Feedback Warehouse ${warehouseId}</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="container mt-4">

            <h1>Feedback for Warehouse #${warehouseId}</h1>

            <div class="mb-3">
                <a href="homepage" class="btn btn-secondary">Back to Home</a>
            </div>

            <!-- Feedback List -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3>Reviews</h3>
                </div>
                <div class="card-body">
                    <c:if test="${empty feedbackList}">
                        <p class="text-muted">No feedback yet.</p>
                    </c:if>
                    <c:forEach items="${feedbackList}" var="f">
                        <div class="border-bottom pb-2 mb-2">
                            <div class="d-flex justify-content-between">
                                <strong>
                                    <c:choose>
                                        <c:when test="${f.anonymous}">Anonymous</c:when>
                                        <c:otherwise>${f.renter.fullName}</c:otherwise>
                                    </c:choose>
                                </strong>
                                <span class="badge bg-warning text-dark">Rating: ${f.rating}/5</span>
                            </div>
                            <p class="mt-1">${f.comment}</p>
                            <small class="text-muted">Posted on: ${f.feedbackDate}</small>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Feedback Form -->
            <c:if test="${canFeedback}">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3>Leave a Feedback</h3>
                    </div>
                    <div class="card-body">
                        <form action="feedback" method="post">
                            <input type="hidden" name="warehouseId" value="${warehouseId}">

                            <div class="mb-3">
                                <label for="rating" class="form-label">Rating (1-5)</label>
                                <select class="form-select" name="rating" id="rating" required>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Average</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Terrible</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="comment" class="form-label">Comment</label>
                                <textarea class="form-control" name="comment" id="comment" rows="3" required></textarea>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" name="anonymous" id="anonymous">
                                <label class="form-check-label" for="anonymous">Post anonymously</label>
                            </div>

                            <button type="submit" class="btn btn-primary">Submit Feedback</button>
                        </form>
                    </div>
                </div>
            </c:if>

            <c:if test="${not canFeedback}">
                <div class="alert alert-warning">
                    You can only leave feedback if you have an active contract for this warehouse.
                </div>
            </c:if>

        </body>

        </html>