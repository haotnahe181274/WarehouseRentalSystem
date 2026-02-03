<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Warehouse List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .layout { display: flex; align-items: flex-start; }
        .main-content { flex: 1; padding: 24px; background: #f5f7fb; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 12px 15px; border-radius: 6px; margin-bottom: 15px; }
        .filters { display: flex; gap: 10px; align-items: center; }
        .filters input, .filters select { padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-add { background: black; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; }
        table { width: 100%; background: #fff; border-collapse: collapse; border-radius: 6px; overflow: hidden; }
        th, td { padding: 10px; border-bottom: 1px solid #eee; }
        th { background: #fafafa; }
       .container-custom {
    width: 100%;
}
        .btn-reset { padding: 6px 12px; background: #6c757d; color: white; border-radius: 4px; text-decoration: none; border: none; }
        .warehouse-thumbnail {
        width: 100px;         /* Chiều rộng cố định */
        height: 70px;         /* Chiều cao cố định */
        object-fit: cover;    /* QUAN TRỌNG: Cắt ảnh vừa khung, không bị méo/dẹt */
        border-radius: 5px;   /* Bo góc nhẹ cho đẹp */
        border: 1px solid #e0e0e0; /* Viền mỏng */
    }
    
    /* Căn giữa ảnh trong ô bảng */
    td {
        vertical-align: middle;
    }
    </style>
</head>

<body>

<jsp:include page="/Common/Layout/header.jsp"/>
<div class="layout">
    <jsp:include page="/Common/Layout/sidebar.jsp"/>

    <div class="main-content container-custom">

        <div class="top-bar">
            <form class="filters" action="${pageContext.request.contextPath}/warehouse" method="get">
                <input type="text" name="keyword" placeholder="Search warehouse name"
                       value="${param.keyword}" onkeyup="delaySubmit(this)">

                <select name="status" onchange="this.form.submit()">
                    <option value="">All Status</option>
                    <option value="1" ${param.status=='1'?'selected':''}>Active</option>
                    <option value="0" ${param.status=='0'?'selected':''}>Inactive</option>
                </select>

                <select name="sort" onchange="this.form.submit()">
                    <option value="">Sort By Name</option>
                    <option value="asc" ${param.sort=='asc'?'selected':''}>A → Z</option>
                    <option value="desc" ${param.sort=='desc'?'selected':''}>Z → A</option>
                </select>

                <c:if test="${not empty param.keyword or not empty param.status or not empty param.sort}">
                    <a href="${pageContext.request.contextPath}/warehouse" class="btn-reset">Reset</a>
                </c:if>
            </form>

            <c:if test="${sessionScope.role == 'Admin'}">
                <a href="${pageContext.request.contextPath}/warehouse?action=add" class="btn-add">
                    Add Warehouse
                </a>
            </c:if>
        </div>

        <h3>Warehouse List</h3>

       <table>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Address</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <c:forEach var="w" items="${warehouseList}">
                <tr>
                    <td>${w.warehouseId}</td>
                    
                    <td>
                        <img src="${pageContext.request.contextPath}/resources/warehouse/image/${warehouseImages[w.warehouseId]}" 
                             alt="Warehouse" 
                             class="warehouse-thumbnail"
                             onerror="this.src='${pageContext.request.contextPath}/resources/warehouse/image/default-warehouse.jpg'">
                    </td>

                    <td>${w.name}</td>
                    <td>${w.address}</td>
                    <td>
                        <span class="badge ${w.status == 1 ? 'bg-success' : 'bg-secondary'}">
                            ${w.status == 1 ? 'Active' : 'Inactive'}
                        </span>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${w.warehouseId}" class="text-primary text-decoration-none">View</a>

                        <c:if test="${sessionScope.role == 'Admin'}">
                            | <a href="${pageContext.request.contextPath}/warehouse?action=edit&id=${w.warehouseId}" class="text-warning text-decoration-none">Edit</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <div class="mt-3">
             <jsp:include page="/Common/homepage/pagination.jsp" />
        </div>

    </div>
</div>

<jsp:include page="/Common/Layout/footer.jsp"/>

<script>
    let timer;
    function delaySubmit(input){
        clearTimeout(timer);
        timer = setTimeout(() => {
            input.form.submit();
        }, 500);
    }
</script>

</body>
</html>