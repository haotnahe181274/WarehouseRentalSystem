<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


            <!DOCTYPE html>
            <html>

            <head>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

                <style>
                    .layout {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        padding: 24px;
                        background: #f5f7fb;
                    }

                    body {
                        font-family: Arial, sans-serif;

                        background: #f5f6fa;
                    }

                    h3 {
                        margin-bottom: 15px;
                    }

                    .top-bar {
                        display: none;
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

                    .btn-block {
                        background: #ff4d4f;
                        color: white;
                    }

                    .btn-unblock {
                        background: #52c41a;
                        color: white;
                    }

                    table.dataTable {
                        width: 100% !important;
                        background: #fff;
                        border-radius: 6px;
                        overflow: hidden;
                    }

                    .btn-add:hover {
                        background: #e0e0e0;
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

                        <h3 style="font-weight: 600; color: #111827;">User List</h3>

                        <!-- Filter Section -->
                        <!-- Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/user/list" method="get" id="filterForm"
                                style="display: flex; gap: 10px; align-items: center;">

                                <!-- Hidden input to store pageLength -->
                                <input type="hidden" name="pageSize" id="pageSizeInput">

                                <select name="filterType" onchange="submitFilter()"
                                    style="padding: 8px 12px; border-radius: 6px; border: 1px solid #d1d5db; background-color: #fff; color: #374151; font-size: 14px; outline: none; cursor: pointer;">
                                    <option value="All">All Types</option>
                                    <option value="INTERNAL" ${filterType=='INTERNAL' ? 'selected' : '' }>Internal
                                    </option>
                                    <option value="RENTER" ${filterType=='RENTER' ? 'selected' : '' }>Renter</option>
                                </select>

                                <select name="filterStatus" onchange="submitFilter()"
                                    style="padding: 8px 12px; border-radius: 6px; border: 1px solid #d1d5db; background-color: #fff; color: #374151; font-size: 14px; outline: none; cursor: pointer;">
                                    <option value="All">All Status</option>
                                    <option value="1" ${filterStatus==1 ? 'selected' : '' }>Active</option>
                                    <option value="0" ${filterStatus==0 ? 'selected' : '' }>Blocked</option>
                                </select>

                                <c:if test="${filterType == 'INTERNAL'}">
                                    <select name="filterRole" onchange="submitFilter()"
                                        style="padding: 8px 12px; border-radius: 6px; border: 1px solid #d1d5db; background-color: #fff; color: #374151; font-size: 14px; outline: none; cursor: pointer;">
                                        <option value="All">All Roles</option>
                                        <option value="Admin" ${filterRole=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option value="Manager" ${filterRole=='Manager' ? 'selected' : '' }>Manager
                                        </option>
                                        <option value="Staff" ${filterRole=='Staff' ? 'selected' : '' }>Staff</option>
                                    </select>
                                </c:if>

                                <c:if
                                    test="${(filterType != null && filterType != 'All') || (filterStatus != null) || (filterRole != null && filterRole != 'All')}">
                                    <a href="${pageContext.request.contextPath}/user/list"
                                        style="padding: 8px 16px; border-radius: 6px; background-color: black; color: white; text-decoration: none; font-size: 14px; font-weight: 500; transition: background-color 0.2s;">
                                        Reset
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
                                            <span class="badge-role">${u.role}</span>
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
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/user/list?action=view&id=${u.id}&type=${u.type}"
                                                    class="btn btn-sm btn-outline-primary">
                                                    <i class="fa-solid fa-eye"></i> View
                                                </a>



                                                <c:if test="${sessionScope.role == 'Admin'}">
                                                    <form action="${pageContext.request.contextPath}/user/list"
                                                        method="post" style="display:inline">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <input type="hidden" name="type" value="${u.type}">

                                                        <c:if test="${u.status == 1}">
                                                            <input type="hidden" name="action" value="block">
                                                            <button class="btn btn-sm btn-outline-danger" type="submit">
                                                                <i class="fa-solid fa-ban"></i> Block
                                                            </button>
                                                        </c:if>

                                                        <c:if test="${u.status == 0}">
                                                            <input type="hidden" name="action" value="unblock">
                                                            <button class="btn btn-sm btn-outline-success"
                                                                type="submit">
                                                                <i class="fa-solid fa-unlock"></i> Unblock
                                                            </button>
                                                        </c:if>
                                                    </form>
                                                </c:if>
                                            </div>
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


                </div>
                <jsp:include page="/Common/Layout/footer.jsp" />


            </body>

            </html>