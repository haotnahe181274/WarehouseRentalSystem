<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Category Management - WareSpace</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
    <style>
        /* Page-specific styles only — shared styles in management-layout.css */
        :root {
            --fb-accent: #1a73e8;
            --fb-border: #e2e8f0;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--fb-border);
            border-radius: 6px;
            outline: none;
            font-size: 14px;
        }
        .form-control:focus { border-color: var(--fb-accent); }
        .btn-submit {
            background: var(--fb-accent);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-submit:hover { background: #1557b0; }
        .error-msg { color: #d32f2f; font-size: 14px; margin-top: 5px; }
        .success-msg { color: #2e7d32; font-size: 14px; margin-bottom: 15px; }
        .action-item {
            font-size: 14px;
            font-weight: 600;
            color: #4b5563;
            text-decoration: none;
            transition: color 0.2s;
            border: none;
            background: none;
            cursor: pointer;
        }
        .action-item:hover { color: #1a73e8; }
    </style>
</head>
<body>
    <jsp:include page="/Common/Layout/header.jsp" />
    <jsp:include page="/message/popupMessage.jsp" />
    <div class="layout">
        <jsp:include page="/Common/Layout/sidebar.jsp" />
        
        <div class="main-content">
            <h3>Blog Category Management</h3>
                    <!-- Add Category Section -->
                    <div class="management-card">
                        <h3 style="margin: 0 0 20px 0; font-weight: 700;">Add New Category</h3>
                        <c:if test="${not empty error}">
                            <div class="error-msg" style="margin-bottom: 15px;">${error}</div>
                        </c:if>
                        <c:if test="${not empty param.success}">
                            <div class="success-msg">${param.success}</div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="error-msg" style="margin-bottom: 15px;">${param.error}</div>
                        </c:if>
                        
                        <form action="category-management" method="POST">
                            <input type="hidden" name="action" value="add">
                            <div class="form-group" style="display: flex; gap: 10px;">
                                <input type="text" name="categoryName" class="form-control" placeholder="Enter category name" required>
                                <button type="submit" class="btn-submit">Add</button>
                            </div>
                        </form>
                    </div>

                   
                    <div class="management-card">
                        <h3>All Categories</h3>
                        <table id="categoryTable" class="display" style="width:100%">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">ID</th>
                                    <th>Category Name</th>
                                    <th style="width: 25%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${categories}" var="cat">
                                    <tr>
                                        <td>${cat.categoryId}</td>
                                        <td>
                                            <form id="edit-form-${cat.categoryId}" action="category-management" method="POST" style="display: none;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                                <input type="text" name="categoryName" value="${cat.categoryName}" class="form-control" style="padding: 5px;">
                                            </form>
                                            <span id="display-name-${cat.categoryId}">${cat.categoryName}</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 10px;">
                                                <button type="button" onclick="editCategory(${cat.categoryId})" id="edit-btn-${cat.categoryId}" class="action-item" style="border:none; background:none; color: var(--fb-secondary-text); padding:0;">
                                                    <i class="fas fa-pen"></i> Edit
                                                </button>
                                                <button type="button" onclick="saveCategory(${cat.categoryId})" id="save-btn-${cat.categoryId}" style="display: none; border:none; background:none; color: var(--fb-accent); padding:0; font-weight: 600;">
                                                    Save
                                                </button>
                                                <a href="category-management?action=delete&id=${cat.categoryId}" 
                                                   onclick="return confirm('Are you sure you want to delete this category? This may affect existing posts.')" 
                                                   style="color: #d32f2f; text-decoration: none; font-size: 14px; font-weight: 600;">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
        </div>
    </div>
    <jsp:include page="/Common/Layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#categoryTable').DataTable({
                "pageLength": 10,
                "language": {
                    "search": "_INPUT_",
                    "searchPlaceholder": "Search categories..."
                }
            });
        });

        function editCategory(id) {
            document.getElementById('display-name-' + id).style.display = 'none';
            document.getElementById('edit-btn-' + id).style.display = 'none';
            document.getElementById('edit-form-' + id).style.display = 'block';
            document.getElementById('save-btn-' + id).style.display = 'inline-block';
        }

        function saveCategory(id) {
            document.getElementById('edit-form-' + id).submit();
        }
    </script>
</body>
</html>
