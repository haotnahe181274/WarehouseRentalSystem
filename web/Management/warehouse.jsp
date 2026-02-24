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
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
        }

        h3 {
            margin-bottom: 15px;
        }

        .layout { 
            display: flex; 
            min-height: 100vh; 
        }

        .main-content { 
            flex: 1; 
            padding: 24px; 
            background: #f5f7fb; 
        }
        
        .top-bar-hidden { 
            display: none; 
        }
        
        /* DataTables Customization (Đồng bộ từ User List) */
        #warehouseTable_filter { 
            display: flex !important; 
            align-items: center; 
            gap: 10px; 
        }

        #warehouseTable_length { 
            display: flex !important; 
            align-items: center; 
            gap: 15px; 
            float: none !important; 
        }

        .dt-controls-left { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
            float: left; 
        }

        .filter-section {
            margin-bottom: 0 !important;
        }

        /* Đồng bộ filter inputs từ inline CSS của User List */
        .filter-select { 
            padding: 8px 12px; 
            border-radius: 6px; 
            border: 1px solid #d1d5db; 
            background-color: #fff; 
            color: #374151; 
            font-size: 14px; 
            outline: none; 
            cursor: pointer; 
        }
        
        /* Buttons (Đồng bộ từ User List) */
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-add { 
            background: black; 
            color: white; 
        }

        .btn-add:hover { 
            background: #e0e0e0; 
            color: #000;
        }

        /* Đồng bộ nút Reset từ inline CSS của User List */
        .btn-reset { 
            padding: 8px 16px; 
            border-radius: 6px; 
            background-color: black; 
            color: white; 
            text-decoration: none; 
            font-size: 14px; 
            font-weight: 500; 
            transition: background-color 0.2s; 
        }

        .btn-reset:hover {
            background-color: #333;
            color: white;
        }

        /* Table Style (Đồng bộ từ User List) */
        table.dataTable { 
            width: 100% !important; 
            background: #fff; 
            border-radius: 6px; 
            overflow: hidden; 
        }

        /* Table Image riêng của Warehouse */
        .warehouse-thumbnail { 
            width: 80px; 
            height: 60px; 
            object-fit: cover; 
            border-radius: 4px; 
            border: 1px solid #ddd; 
        }
    </style>
</head>

<body>

    <jsp:include page="/Common/Layout/header.jsp"/>
    <div class="layout">
        <jsp:include page="/Common/Layout/sidebar.jsp"/>

        <div class="main-content">
            
            <h3 style="font-weight: 600; color: #111827;">Warehouse List</h3>

            <div class="top-bar-hidden">
                <c:if test="${sessionScope.role == 'Manager'}">
                    <a href="${pageContext.request.contextPath}/warehouse?action=add" class="btn btn-add">
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
                        <th>Address</th>
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
                    { "orderable": false, "targets": [1, 5] }, // Tắt sort cột Image (1) và Action (5)
                    { "width": "50px", "targets": 0 } // Chỉnh độ rộng cột ID
                ],
                "order": [[2, "asc"]], // Mặc định sort theo cột Name (index 2)
                "pageLength": 5, // Số dòng mỗi trang
                "lengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                "language": {
                    "search": "Search:",
                    "lengthMenu": "_MENU_", // Đồng bộ text với User List
                    "info": "Showing _START_ to _END_ of _TOTAL_ warehouses",
                    "paginate": {
                        "first": "First",
                        "last": "Last",
                        "next": "Next",
                        "previous": "Previous"
                    }
                }
            });

            // --- GIỐNG USERLIST: Di chuyển các nút vào vị trí của DataTables ---

            // 1. Di chuyển nút "Add Warehouse" sang cạnh ô Search
            var addBtn = $('.top-bar-hidden .btn-add');
            if (addBtn.length) {
                $('#warehouseTable_filter').append(addBtn);
            }

            // 2. Di chuyển bộ lọc "Status" sang cạnh phần chọn số trang (Length Menu)
            var filterSec = $('.filter-section');
            var lengthDiv = $('#warehouseTable_length');

            if (filterSec.length && lengthDiv.length) {
                // Tạo một div bao ngoài để gom nhóm
                var wrapper = $('<div class="dt-controls-left"></div>');
                lengthDiv.before(wrapper); 
                wrapper.append(lengthDiv); 
                wrapper.append(filterSec); 
            }
        });
    </script>

</body>
</html>