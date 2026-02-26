<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


            <!DOCTYPE html>
            <html>

            <head>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

                <style>
                    body {
                        margin: 0;
                        background: #f5f7fb;
                        font-family: 'Inter', sans-serif;
                    }

                    /* ===== Layout ===== */
                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        padding: 30px;
                    }

                    /* ===== Page title ===== */
                    .page-title {
                        font-size: 24px;
                        font-weight: 700;
                        color: #111827;
                        margin-bottom: 4px;
                    }

                    .page-subtitle {
                        color: #6b7280;
                        font-size: 14px;
                        margin-bottom: 24px;
                    }

                    /* ===== Filter bar ===== */
                    .filter-bar {
                        display: flex;
                        gap: 12px;
                        margin-bottom: 24px;
                        align-items: center;
                    }

                    .filter-bar select {
                        border: 1px solid #d1d5db;
                        border-radius: 8px;
                        padding: 8px 12px;
                        font-size: 14px;
                        background: #fff;
                    }

                    /* Reset button */
                    .btn-reset {
                        background: #111827;
                        color: #fff;
                        border: none;
                        border-radius: 20px;
                        padding: 8px 20px;
                        font-size: 13px;
                        cursor: pointer;
                        transition: all .2s;
                        text-decoration: none;
                        display: inline-block;
                    }

                    .btn-reset:hover {
                        background: #1f2937;
                        color: #fff;
                    }

                    .top-bar {
                        display: none;
                    }

                    /* ===== DataTable overrides ===== */
                    #userTable {
                        border-collapse: collapse;
                        width: 100%;
                        font-size: 14px;
                    }

                    #userTable thead th {
                        background: #f9fafb;
                        color: #374151;
                        font-weight: 600;
                        padding: 12px 14px;
                        border-bottom: 2px solid #e5e7eb;
                    }

                    #userTable tbody td {
                        padding: 12px 14px;
                        border-bottom: 1px solid #f3f4f6;
                        vertical-align: middle;
                    }

                    #userTable tbody tr:hover {
                        background: #f0f4ff;
                    }

                    .dataTables_wrapper .dataTables_filter input {
                        border: 1px solid #d1d5db;
                        border-radius: 8px;
                        padding: 6px 12px;
                        font-size: 14px;
                        outline: none;
                    }

                    .dataTables_wrapper .dataTables_length select {
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        padding: 4px 8px;
                        font-size: 14px;
                    }

                    #userTable_filter {
                        display: flex !important;
                        align-items: center;
                        gap: 10px;
                    }

                    #userTable_length {
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

                    /* ===== Action buttons ===== */
                    .btn {
                        padding: 6px 12px;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                        text-decoration: none;
                    }

                    .btn-add {
                        background: #111827;
                        color: #fff;
                        border-radius: 8px;
                        font-size: 13px;
                        padding: 8px 16px;
                        transition: background .2s;
                    }

                    .btn-add:hover {
                        background: #1f2937;
                        color: #fff;
                    }

                    .btn-block {
                        background: #ff4d4f;
                        color: white;
                        border-radius: 6px;
                    }

                    .btn-unblock {
                        background: #52c41a;
                        color: white;
                        border-radius: 6px;
                    }

                    table.dataTable {
                        width: 100% !important;
                        background: #fff;
                        border-radius: 6px;
                        overflow: hidden;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/Common/Layout/header.jsp" />

                <div class="layout">

                    <jsp:include page="/Common/Layout/sidebar.jsp" />
                    <div class="main-content">

                        <div class="top-bar">
                            <c:if test="${sessionScope.role == 'Admin'}">
                                <a href="${pageContext.request.contextPath}/user/list?action=add&type=INTERNAL"
                                    class="btn btn-add">Add New User</a>
                            </c:if>
                        </div>

                        <h1 class="page-title">User List</h1>
                        <p class="page-subtitle">Manage all users in the system</p>

                        <!-- Filter Section -->
                        <!-- Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/user/list" method="get" id="filterForm"
                                class="filter-bar">

                                <!-- Hidden input to store pageLength -->
                                <input type="hidden" name="pageSize" id="pageSizeInput">

                                <select name="filterType" onchange="submitFilter()">
                                    <option value="All">All Types</option>
                                    <option value="INTERNAL" ${filterType=='INTERNAL' ? 'selected' : '' }>Internal
                                    </option>
                                    <option value="RENTER" ${filterType=='RENTER' ? 'selected' : '' }>Renter</option>
                                </select>

                                <select name="filterStatus" onchange="submitFilter()">
                                    <option value="All">All Status</option>
                                    <option value="1" ${filterStatus==1 ? 'selected' : '' }>Active</option>
                                    <option value="0" ${filterStatus==0 ? 'selected' : '' }>Blocked</option>
                                </select>

                                <c:if test="${filterType == 'INTERNAL'}">
                                    <select name="filterRole" onchange="submitFilter()">
                                        <option value="All">All Roles</option>
                                        <option value="Admin" ${filterRole=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option value="Manager" ${filterRole=='Manager' ? 'selected' : '' }>Manager
                                        </option>
                                        <option value="Staff" ${filterRole=='Staff' ? 'selected' : '' }>Staff</option>
                                    </select>
                                </c:if>

                                <c:if
                                    test="${(filterType != null && filterType != 'All') || (filterStatus != null) || (filterRole != null && filterRole != 'All')}">
                                    <a href="${pageContext.request.contextPath}/user/list" class="btn-reset">
                                        <i class="fa-solid fa-rotate-left"></i> Reset
                                    </a>
                                </c:if>
                            </form>
                        </div>

                        <table id="userTable">
                            <thead>
                                <tr>
                                    <th>Avatar</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Type</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>

                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <!-- Avatar -->
                                        <td>
                                            <img src="${pageContext.request.contextPath}/resources/user/image/${u.image}"
                                                width="40" height="40" style="border-radius:50%; object-fit: cover;">
                                        </td>
                                        <!-- Username -->
                                        <td>${u.name}</td>


                                        <!-- Role -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.type == 'INTERNAL'}">
                                                    ${u.role}
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Type -->
                                        <td>${u.type}</td>

                                        <!-- Status -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.status == 1}">
                                                    Active
                                                </c:when>
                                                <c:otherwise>
                                                    Blocked
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Created At -->
                                        <td>
                                            <fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                        </td>

                                        <!-- Actions -->
                                        <td>
                                            <a
                                                href="${pageContext.request.contextPath}/user/list?action=view&id=${u.id}&type=${u.type}">View</a>


                                            <c:if test="${u.type == 'INTERNAL' && sessionScope.role == 'Admin'}">

                                                | <a
                                                    href="${pageContext.request.contextPath}/user/list?action=edit&id=${u.id}&type=${u.type}">Update</a>
                                            </c:if>


                                            <c:if test="${sessionScope.role == 'Admin'}">
                                                <form action="${pageContext.request.contextPath}/user/list"
                                                    method="post" style="display:inline">
                                                    <input type="hidden" name="id" value="${u.id}">
                                                    <input type="hidden" name="type" value="${u.type}">

                                                    <c:if test="${u.status == 1}">
                                                        <input type="hidden" name="action" value="block">
                                                        <button class="btn btn-block" type="submit">Block</button>
                                                    </c:if>

                                                    <c:if test="${u.status == 0}">
                                                        <input type="hidden" name="action" value="unblock">
                                                        <button class="btn btn-unblock" type="submit">Unblock</button>
                                                    </c:if>
                                                </form>
                                            </c:if>

                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- jQuery + DataTables JS -->
                        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                        <script>
                            $(document).ready(function () {
                                $('#userTable').DataTable({
                                    "columnDefs": [
                                        { "orderable": false, "targets": [0, 6] }
                                    ],
                                    "order": [[1, "asc"]],
                                    "pageLength": ${ not empty param.pageSize ? param.pageSize : 10 },
                                    "language": {
                                    "search": "Search:",
                                    "lengthMenu": "_MENU_",
                                    "info": "Showing _START_ to _END_ of _TOTAL_ users",
                                    "paginate": {
                                        "first": "First",
                                        "last": "Last",
                                        "next": "Next",
                                        "previous": "Previous"
                                    }
                                }
                                });

                            // Move Add New User button next to Search
                            var addBtn = $('.top-bar .btn-add');
                            if (addBtn.length) {
                                addBtn.detach();
                                $('#userTable_filter').append(addBtn);
                            }

                            // Move Filter Section next to Show Entries
                            var filterSec = $('.filter-section');
                            var lengthDiv = $('#userTable_length');

                            if (filterSec.length && lengthDiv.length) {
                                filterSec.detach();
                                // Wrap length and filter in a container
                                var wrapper = $('<div class="dt-controls-left"></div>');
                                lengthDiv.before(wrapper);
                                wrapper.append(lengthDiv);
                                wrapper.append(filterSec);
                            }
                            });

                            function submitFilter() {
                                var table = $('#userTable').DataTable();
                                var len = table.page.len();
                                $('#pageSizeInput').val(len);
                                document.getElementById('filterForm').submit();
                            }
                        </script>



                    </div>


                </div>
                <jsp:include page="/Common/Layout/footer.jsp" />


            </body>

            </html>