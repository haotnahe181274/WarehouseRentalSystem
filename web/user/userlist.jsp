<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>User Management</title>
        <style>
            body{
                font-family: Arial, sans-serif;
                padding: 20px;
                background: #f5f6fa;
            }
            h2{
                margin-bottom: 15px;
            }
            .top-bar{
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #fff;
                padding: 12px 15px;
                border-radius: 6px;
                margin-bottom: 15px;
            }
            .filters{
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .filters input,
            .filters select{
                padding: 6px 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .btn{
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
            }
            .btn-add{
                background: black;
                color: white;
            }
            .btn-block{
                background: #ff4d4f;
                color: white;
            }
            .btn-unblock{
                background: #52c41a;
                color: white;
            }
            table{
                width: 100%;
                background: #fff;
                border-collapse: collapse;
                border-radius: 6px;
                overflow: hidden;
            }
            th, td{
                padding: 10px;
                border-bottom: 1px solid #eee;
                text-align: left;
            }
            th{
                background: #fafafa;
            }
        </style>
    </head>
    <script>
        let timer;
        function delaySubmit(input){
            clearTimeout(timer);
            timer = setTimeout(() => {
                input.form.submit();
            }, 500);
        }
    </script>
    <body>

        <h2>User List</h2>

        <div class="top-bar">
            <!-- Filter -->
            <form class="filters" action="${pageContext.request.contextPath}/user/list" method="get">
                <!-- Search -->
                <input type="text" name="keyword" placeholder="Search by name" value="${param.keyword}" onkeyup="delaySubmit(this)">
                <!-- Status -->
                <select name="status" onchange="this.form.submit()">
                    <option value="">All Status</option>
                    <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                    <option value="0" ${param.status == '0' ? 'selected' : ''}>Blocked</option>
                </select>
                <!-- Type -->
                <select name="filterType" onchange="this.form.submit()">
                    <option value="">All Type</option>
                    <option value ="INTERNAL" ${param.filterType == 'INTERNAL' ? 'selected' : ''}>INTERNAL</option>
                    <option value="RENTER" ${param.filterType == 'RENTER' ? 'selected' : ''}>RENTER</option>
                </select>
                <!-- SORT -->
                <select name="sort" onchange="this.form.submit()">
                    <option value="">Sort By Name</option>
                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>A -> Z</option>
                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Z -> A</option>
                </select>
                
            </form>
                <!-- Add new user -->
                        
                    <a href="${pageContext.request.contextPath}/user/list?action=add&type=INTERNAL" class="btn btn-add">Add New User</a>
                
        </div>

        <table>
            <tr>
                <th>Avatar</th>
                <th>Username</th>

                <th>Role</th>
                <th>Type</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>

            <c:forEach var="u" items="${users}">
                <tr>
                    <td>
                        <c:if test="${not empty u.image}">
                            <img src="${pageContext.request.contextPath}/resources/user/${u.image}"
                                 width="40" height="40" style="border-radius:50%">
                        </c:if>
                    </td>

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
                        <fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>

                    <!-- Actions -->
                    <td>
                        <a href="${pageContext.request.contextPath}/user/list?action=view&id=${u.id}&type=${u.type}">View</a>

                        <c:if test="${u.type == 'INTERNAL'}">
                            | <a href="${pageContext.request.contextPath}/user/list?action=edit&id=${u.id}&type=${u.type}">Update</a>
                        </c:if>

                        <form action="list" method="post" style="display:inline">
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
                    </td>
                </tr>
            </c:forEach>
        </table>

    </body>
</html>
