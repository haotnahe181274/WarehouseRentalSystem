    <%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <!DOCTYPE html>
    <html>
    <head>
        <title>Warehouse List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

        <style>
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
            .status-active   { background: #e6fffa; color: #047481; }
            .status-inactive { background: #fef2f2; color: #991b1b; }

            /* ── Top bar: title + Add button ── */
            .page-top-bar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
            }

            .page-top-bar h3 {
                margin: 0;
                font-size: 20px;
                font-weight: 700;
                color: #111827;
            }

            .btn-add-warehouse {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 8px 18px;
                background: #111827;
                color: #fff;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                transition: background 0.15s;
            }

            .btn-add-warehouse:hover {
                background: #374151;
                color: #fff;
                text-decoration: none;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/Common/Layout/header.jsp" />
        <jsp:include page="/message/popupMessage.jsp" />
        <div class="layout">
            <jsp:include page="/Common/Layout/sidebar.jsp" />

            <div class="main-content">

                <%-- ── Page title + Add button ── --%>
                <div class="page-top-bar">
                    <h3>Warehouse Management</h3>
                    <c:if test="${sessionScope.role == 'Manager' || sessionScope.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/warehouse?action=add"
                           class="btn-add-warehouse">
                            <i class="fa-solid fa-plus"></i> Add Warehouse
                        </a>
                    </c:if>
                </div>

                <%-- ── Stats cards ── --%>
                <div class="stats-container mb-4">
                    <jsp:include page="/Common/Layout/stats_cards.jsp">
                        <jsp:param name="label1" value="Total Warehouse" />
                        <jsp:param name="value1" value="${totalWarehouses}" />
                        <jsp:param name="icon1"  value="fa-solid fa-warehouse" />
                        <jsp:param name="color1" value="primary" />

                        <jsp:param name="label2" value="Active" />
                        <jsp:param name="value2" value="${activeWarehouses}" />
                        <jsp:param name="icon2"  value="fa-solid fa-circle-check" />
                        <jsp:param name="color2" value="success" />

                        <jsp:param name="label3" value="Inactive" />
                        <jsp:param name="value3" value="${inactiveWarehouses}" />
                        <jsp:param name="icon3"  value="fa-solid fa-circle-xmark" />
                        <jsp:param name="color3" value="danger" />
                    </jsp:include>
                </div>

                <div class="management-card">

                    <%-- ── Filter bar ── --%>
                    <form action="${pageContext.request.contextPath}/warehouse"
                          method="get" id="filterForm" class="filter-bar">

                        <select name="status" onchange="submitFilter()">
                            <option value="All">All Status</option>
                            <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Active</option>
                            <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Inactive</option>
                        </select>

                        <c:if test="${not empty filterStatus && filterStatus != 'All'}">
                            <a href="${pageContext.request.contextPath}/warehouse" class="btn-reset">Reset</a>
                        </c:if>
                    </form>

                    <%-- ── Table ── --%>
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
                                            <c:if test="${sessionScope.role == 'Manager' || sessionScope.role == 'Admin'}">
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


                </div><%-- End management-card --%>
            </div>
        </div>

        <jsp:include page="/Common/Layout/footer.jsp" />

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script>
            $(document).ready(function () {
                // Hủy instance cũ nếu tồn tại (tránh lỗi "Cannot reinitialise DataTable")
                if ($.fn.DataTable.isDataTable('#warehouseTable')) {
                    $('#warehouseTable').DataTable().destroy();
                }

                $('#warehouseTable').DataTable({
                    "columnDefs": [
                        { "orderable": false, "targets": [1, 6] }
                    ],
                    "order": [[0, "desc"]],
                    lengthMenu: [5, 10, 25, 50],
                    "language": {
                        "search": "Search:",
                        "lengthMenu": "_MENU_",
                        "info": "Showing _START_ to _END_ of _TOTAL_ warehouses",
                        "paginate": {
                            "first": "First",
                            "last": "Last",
                            "next": "Next",
                            "previous": "Previous"
                        }
                    }
                });

                // Gom filter bar + length dropdown + search vào cùng 1 dòng
                var filterBar = $('.filter-bar').first();
                var lengthDiv = $('#warehouseTable_length');
                var filterDiv = $('#warehouseTable_filter');

                // Di chuyển nút Add Warehouse vào cạnh ô Search
                var addBtn = $('.btn-add-warehouse');
                if (addBtn.length) {
                    addBtn.detach();
                    filterDiv.append(addBtn);
                }

                if (filterBar.length && lengthDiv.length && filterDiv.length) {
                    var bottomRow = $('<div class="dt-controls-bottom-row"></div>');
                    lengthDiv.before(bottomRow);
                    bottomRow.append(lengthDiv);
                    bottomRow.append(filterDiv);
                    filterBar.insertBefore(bottomRow);
                }
            });

            function submitFilter() {
                document.getElementById('filterForm').submit();
            }
        </script>
    </body>
    </html>
