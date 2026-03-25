<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


            <!DOCTYPE html>
            <html>

            <head>


                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-stats.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">

                <style>
                   
                    .btn-block { background: #ff4d4f; color: white; }
                    .btn-unblock { background: #52c41a; color: white; }
                    .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
                    .dt-controls-left { margin-bottom: 20px; }
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
                                    class="btn btn-add">Add Staff</a>
                            </c:if>
                        </div>

                        <h3>User Management</h3>

                        <div class="stats-container">
                            <jsp:include page="/Common/Layout/stats_cards.jsp">
                                <jsp:param name="label1" value="Total User" />
                                <jsp:param name="value1" value="${totalUsers}" />
                                <jsp:param name="icon1" value="fa-solid fa-users" />
                                <jsp:param name="color1" value="primary" />

                                <jsp:param name="label2" value="Internal User" />
                                <jsp:param name="value2" value="${internalUsers}" />
                                <jsp:param name="icon2" value="fa-solid fa-user-tie" />
                                <jsp:param name="color2" value="info" />

                                <jsp:param name="label3" value="Renter" />
                                <jsp:param name="value3" value="${renterUsers}" />
                                <jsp:param name="icon3" value="fa-solid fa-user-tag" />
                                <jsp:param name="color3" value="success" />
                            </jsp:include>
                        </div>

                        <div class="management-card">

                            

                           
                            <div class="filter-bar">
                                <form action="${pageContext.request.contextPath}/user/list" method="get" id="filterForm"
                                    class="filter-bar">

                                    <!-- Hidden input to store pageLength -->
                                    <input type="hidden" name="pageSize" id="pageSizeInput">

                                    <select name="filterType" onchange="submitFilter()">
                                        <option value="All">All Types</option>
                                        <option value="INTERNAL" ${filterType=='INTERNAL' ? 'selected' : '' }>Internal
                                        </option>
                                        <option value="RENTER" ${filterType=='RENTER' ? 'selected' : '' }>Renter
                                        </option>
                                    </select>

                                    <select name="filterStatus" onchange="submitFilter()">
                                        <option value="All">All Status</option>
                                        <option value="1" ${filterStatus==1 ? 'selected' : '' }>Active</option>
                                        <option value="0" ${filterStatus==0 ? 'selected' : '' }>Blocked</option>
                                    </select>

                                    <c:if test="${filterType == 'INTERNAL'}">
                                        <select name="filterRole" onchange="submitFilter()">
                                            <option value="All">All Roles</option>
                                            <option value="Admin" ${filterRole=='Admin' ? 'selected' : '' }>Admin
                                            </option>
                                            <option value="Manager" ${filterRole=='Manager' ? 'selected' : '' }>Manager
                                            </option>
                                            <option value="Staff" ${filterRole=='Staff' ? 'selected' : '' }>Staff
                                            </option>
                                        </select>
                                    </c:if>

                                    <c:if
                                        test="${(filterType != null && filterType != 'All') || (filterStatus != null) || (filterRole != null && filterRole != 'All')}">
                                        <a href="${pageContext.request.contextPath}/user/list" class="btn-reset">
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
                                                    width="40" height="40"
                                                    style="border-radius:50%; object-fit: cover;">
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
                                                        <c:if test="${u.role ne 'Admin' && u.role ne 'Manager'}">
                                                            <form action="${pageContext.request.contextPath}/user/list"
                                                                method="post" style="display:inline">
                                                                <input type="hidden" name="id" value="${u.id}">
                                                                <input type="hidden" name="type" value="${u.type}">

                                                                <c:if test="${u.status == 1}">
                                                                    <input type="hidden" name="action" value="block">
                                                                    <button class="btn btn-sm btn-outline-danger"
                                                                        type="submit">
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
                                        lengthMenu: [5, 10, 25, 50],
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


                                    var addBtn = $('.top-bar .btn-add');
                                    if (addBtn.length) {
                                        addBtn.detach();
                                        $('#userTable_filter').append(addBtn);
                                    }


                                    var filterBar = $('.filter-bar').first();
                                    var lengthDiv = $('#userTable_length');
                                    var filterDiv = $('#userTable_filter');

                                    if (filterBar.length && lengthDiv.length && filterDiv.length) {
                                        var bottomRow = $('<div class="dt-controls-bottom-row"></div>');
                                        lengthDiv.before(bottomRow);
                                        bottomRow.append(lengthDiv);
                                        bottomRow.append(filterDiv);
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