<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Warehouse List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

    <style>
        /* Page-specific styles only — shared styles in management-layout.css */
        .warehouse-thumbnail {
            width: 60px;
            height: 45px;
            object-fit: cover;
            border-radius: 6px;
        }
        .badge-status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-active { background: #e6fffa; color: #047481; }
        .status-inactive { background: #fef2f2; color: #991b1b; }
    </style>
</head>

<body>
    <jsp:include page="/Common/Layout/header.jsp" />

    <div class="layout">
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="main-content">
            <h3>Warehouse Management</h3>

            <div class="stats-container mb-4">
                <jsp:include page="/Common/Layout/stats_cards.jsp">
                    <jsp:param name="label1" value="Total Warehouse" />
                    <jsp:param name="value1" value="${totalWarehouses}" />
                    <jsp:param name="icon1" value="fa-solid fa-warehouse" />
                    <jsp:param name="color1" value="primary" />

                    <jsp:param name="label2" value="Active" />
                    <jsp:param name="value2" value="${activeWarehouses}" />
                    <jsp:param name="icon2" value="fa-solid fa-circle-check" />
                    <jsp:param name="color2" value="success" />

                    <jsp:param name="label3" value="Inactive" />
                    <jsp:param name="value3" value="${inactiveWarehouses}" />
                    <jsp:param name="icon3" value="fa-solid fa-circle-xmark" />
                    <jsp:param name="color3" value="danger" />
                </jsp:include>
            </div>

            <div class="management-card">

                <form action="${pageContext.request.contextPath}/warehouse" method="get" id="filterForm" class="filter-bar">
                    
                    <select name="pageSize" onchange="submitFilter()">
                        <option value="5" ${param.pageSize == '5' ? 'selected' : ''}>5 records/page</option>
                        <option value="10" ${(empty param.pageSize or param.pageSize == '10') ? 'selected' : ''}>10 records/page</option>
                        <option value="25" ${param.pageSize == '25' ? 'selected' : ''}>25 records/page</option>
                        <option value="50" ${param.pageSize == '50' ? 'selected' : ''}>50 records/page</option>
                    </select>

                    <select name="status" onchange="submitFilter()">
                        <option value="All">All Status</option>
                        <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Active</option>
                        <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Inactive</option>
                    </select>

                    <c:if test="${not empty filterStatus && filterStatus != 'All'}">
                        <a href="${pageContext.request.contextPath}/warehouse" class="btn-reset">Reset</a>
                    </c:if>
                </form>

                <table id="warehouseTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Thumbnail</th>
                            <th>Warehouse Name</th>
                            <th>Type</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                <tbody>
                    <c:forEach var="w" items="${warehouseList}">
                        <tr>
                            <td>#${w.warehouseId}</td>
                            <td>
                                <img src="${pageContext.request.contextPath}/resources/warehouse/image/${warehouseImages[w.warehouseId]}" 
                                     class="warehouse-thumbnail"
                                     onerror="this.src='${pageContext.request.contextPath}/resources/images/no-image.png'">
                            </td>
                            <td style="font-weight: 600;">${w.name}</td>
                            <td>${w.warehouseType.typeName}</td>
                            <td style="max-width: 250px;">${w.address}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${w.status == 1}">
                                        <span class="badge-status status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status status-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons" style="display: flex; gap: 10px;">
                                    <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${w.warehouseId}" 
                                       style="color: #3b82f6; text-decoration: none; font-weight: 500;">
                                        <i class="fa-solid fa-eye"></i> View
                                    </a>
                                    <c:if test="${sessionScope.role == 'Manager'}">
                                        <a href="${pageContext.request.contextPath}/warehouse?action=edit&id=${w.warehouseId}" 
                                           style="color: #f59e0b; text-decoration: none; font-weight: 500;">
                                            <i class="fa-solid fa-pen-to-square"></i> Edit
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <jsp:include page="/Common/homepage/pagination.jsp" />

                </div> <!-- End management-card -->
        </div>
    </div>

    <jsp:include page="/Common/Layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function () {
            // 1. Khởi tạo DataTable (Đã tắt phân trang)
            var table = $('#warehouseTable').DataTable({
                "paging": false,       // Tắt phân trang của DataTable
                "info": false,         // Tắt text "Showing 1 to 10..."
                "columnDefs": [
                    { "orderable": false, "targets": [1, 6] } // Disable sorting for Image and Actions
                ],
                "order": [[0, "desc"]], // Default sort by ID
                "language": {
                    "search": "Search:"
                }
            });

            // 2. Di chuyển nút "Add" sang phải cùng thanh Search
            var addBtn = $('.top-bar .btn-add');
            if (addBtn.length) {
                addBtn.detach();
                $('#warehouseTable_filter').append(addBtn);
            }

            // 3. Gom chung Filter Status + PageSize và Search vào cùng một dòng
            // Tương tự user management
            var filterBar = $('.filter-bar').first();
            var filterDiv = $('#warehouseTable_filter');

            if (filterBar.length && filterDiv.length) {
                var bottomRow = $('<div class="dt-controls-bottom-row"></div>');
                $('#warehouseTable').before(bottomRow);
                
                bottomRow.append(filterBar); // Dropdowns và Reset bên trái
                bottomRow.append(filterDiv); // Search + Add bên phải
            }
        });

        // 4. Submit form khi người dùng đổi lựa chọn ở thẻ select
        function submitFilter() {
            document.getElementById('filterForm').submit();
        }
    </script>
</body>
</html>