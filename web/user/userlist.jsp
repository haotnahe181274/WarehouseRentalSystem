<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>User Management</title>

    </head>

    <body>

        <h2>User List</h2>

        <div class="top-bar">
            <div></div>
            <!-- Chỉ admin / internal mới dùng -->
            <a href="${pageContext.request.contextPath}/user/list?action=add&id=${u.id}&type=${u.type}" class="btn btn-add">+ Add New Staff</a>
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
