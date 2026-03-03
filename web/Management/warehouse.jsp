<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Warehouse List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <style>
        .layout { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 24px; background: #f5f7fb; }
        
        /* Ẩn các công cụ lúc đầu, JS sẽ hiện chúng vào trong bảng DataTables */
        .top-bar-hidden { display: none; } 
        
        /* DataTables Custom Styling */
        #warehouseTable_filter { display: flex !important; align-items: center; gap: 10px; }
        #warehouseTable_length { display: flex !important; align-items: center; gap: 15px; float: none !important; }
        
        /* Container chứa LengthMenu và Filter */
        .dt-controls-left { display: flex; align-items: center; gap: 15px; float: left; }
        
        /* Buttons Style */
        .btn-add { background: black; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; border: none; font-size: 14px; }
        .btn-add:hover { background: #333; color: white; }
        .btn-reset { padding: 6px 12px; background: black; color: white; border-radius: 4px; text-decoration: none; font-size: 14px; }
        
        /* Filter Select */
        .filter-select { padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; font-size: 14px; background: white; color: #333; cursor: pointer; }

        /* Image Thumbnail */
        .warehouse-thumbnail { width: 80px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; }
        
        /* Table Style */
        table.dataTable { width: 100% !important; background: #fff; border-radius: 6px; overflow: hidden; border-collapse: collapse !important; margin-top: 15px !important; }
        table.dataTable th { background: #fafafa; padding: 12px; border-bottom: 2px solid #eee; font-weight: 600; color: #374151; }
        table.dataTable td { padding: 10px; vertical-align: middle; border-bottom: 1px solid #eee; color: #4b5563; }
        
        h3 { font-weight: 600; color: #111827; margin-bottom: 20px; }
    </style>
</head>

<body>

    <jsp:include page="/Common/Layout/header.jsp"/>
    <div class="layout">
        <jsp:include page="/Common/Layout/sidebar.jsp"/>

        <div class="main-content">
            
            <h3>Warehouse List</h3>

            <div class="top-bar-hidden">
                <c:if test="${sessionScope.role == 'Manager'}">
                    <a href="${pageContext.request.contextPath}/warehouse?action=add" class="btn-add">
                        <i class="fa-solid fa-plus"></i> Add Warehouse
                    </a>
                </c:if>

                <div class="filter-section">
                    <form action="${pageContext.request.contextPath}/warehouse" method="get" id="filterForm" style="display: flex; gap: 10px; align-items: center; margin: 0;">
                        <select name="status" class="filter-select" onchange="this.form.submit()">
                            <option value="All">All Status</option>
                            <option value="1" ${filterStatus=='1'?'selected':''}>Active</option>
                            <option value="0" ${filterStatus=='0'?'selected':''}>Inactive</option>
                        </select>

                        <c:if test="${not empty filterStatus && filterStatus != 'All'}">
                            <a href="${pageContext.request.contextPath}/warehouse" class="btn-reset">Reset</a>
                        </c:if>
                    </form>
                </div>
            </div>

            <table id="warehouseTable" class="display">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Type</th> <th>Address</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="w" items="${warehouseList}">
                        <tr>
                            <td>${w.warehouseId}</td>
                            
                            <td>
                                <img src="${pageContext.request.contextPath}/resources/warehouse/image/${warehouseImages[w.warehouseId]}" 
                                     class="warehouse-thumbnail"
                                     onerror="this.src='${pageContext.request.contextPath}/resources/warehouse/image/default-warehouse.jpg'">
                            </td>
                            
                            <td>${w.name}</td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${not empty w.warehouseType and not empty w.warehouseType.typeName}">
                                        <span class="badge bg-info text-dark">${w.warehouseType.typeName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td>${w.address}</td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${w.status == 1}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td>
                                <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${w.warehouseId}" class="text-primary text-decoration-none fw-bold">View</a>
                                <c:if test="${sessionScope.role == 'Manager'}">
                                    | <a href="${pageContext.request.contextPath}/warehouse?action=edit&id=${w.warehouseId}" class="text-warning text-decoration-none fw-bold">Edit</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script>
        $(document).ready(function () {
            // Khởi tạo DataTables
            var table = $('#warehouseTable').DataTable({
                "columnDefs": [
                    // Cột 1 là Image, Cột 6 là Action -> Tắt sắp xếp (Do mảng index bắt đầu từ 0)
                    { "orderable": false, "targets": [1, 6] }, 
                    { "width": "50px", "targets": 0 } // Cột ID nhỏ lại
                ],
                "order": [[2, "asc"]], // Mặc định sort theo cột Name (index 2) tăng dần
                "pageLength": 5, // Số dòng mặc định mỗi trang
                "lengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                "language": {
                    "search": "Search:",
                    "lengthMenu": "Show _MENU_ entries",
                    "info": "Showing _START_ to _END_ of _TOTAL_ warehouses"
                }
            });

            // --- DOM MANIPULATION: Di chuyển các nút vào trong DataTables layout ---

            // 1. Di chuyển nút "Add Warehouse" vào cạnh ô Search (Góc phải trên)
            var addBtn = $('.top-bar-hidden .btn-add');
            if (addBtn.length) {
                $('#warehouseTable_filter').append(addBtn);
            }

            // 2. Di chuyển "Filter Status" vào cạnh ô chọn số trang (Góc trái trên)
            var filterSec = $('.filter-section');
            var lengthDiv = $('#warehouseTable_length');

            if (filterSec.length && lengthDiv.length) {
                // Tạo một div wrapper để nhóm 2 thành phần này lại với nhau
                var wrapper = $('<div class="dt-controls-left"></div>');
                lengthDiv.before(wrapper); 
                wrapper.append(lengthDiv); 
                wrapper.append(filterSec); 
            }
        });
    </script>

</body>
</html>