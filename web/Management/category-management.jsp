<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Category Management - WareSpace</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blog-fb.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            margin: 0; 
            overflow-x: hidden; 
        }
        .wrapper { 
            display: flex; 
            width: 100%; 
            min-height: 100vh; 
        }
        .wrapper > :first-child { 
            width: 260px; 
            min-width: 260px;
            height: 100vh;
            position: sticky;
            top: 0;
            z-index: 1020;
            background-color: #0b0f19; 
        }
        .main-panel { 
            flex: 1; 
            min-width: 0; 
            display: flex; 
            flex-direction: column; 
        }
        .main-content { 
            padding: 24px; 
            flex: 1; 
        }
        .management-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .post-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 24px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--fb-border);
            border-radius: 6px;
            outline: none;
        }
        .form-control:focus {
            border-color: var(--fb-accent);
        }
        .btn-submit {
            background: var(--fb-accent);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
        }
        .error-msg {
            color: #d32f2f;
            font-size: 14px;
            margin-top: 5px;
        }
        .success-msg {
            color: #2e7d32;
            font-size: 14px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body style="background-color: #f0f2f5;">
    <div class="wrapper">
        <jsp:include page="/Common/Layout/sidebar.jsp" />
        
        <div class="main-panel">
            <jsp:include page="/Common/Layout/header.jsp" />
            
            <div class="main-content">
                <div class="management-container">
                    <!-- Add Category Section -->
                    <div class="post-card">
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

                    <!-- Categories Table Section -->
                    <div class="post-card">
                        <h3 style="margin: 0 0 20px 0; font-weight: 700;">All Categories</h3>
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
        </div>
    </div>

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
