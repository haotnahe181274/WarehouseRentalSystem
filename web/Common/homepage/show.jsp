<%-- 
    Document   : show
    Created on : Jan 27, 2026, 7:58:47 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <title>WareSpace - Warehouse Rental</title>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp" />


        <%-- 2. THÊM BANNER  --%>
        <jsp:include page="banner.jsp" />

        <div class="container py-5">
            <div class="row">
                <%-- 3. Cột bên trái: Bộ lọc (Filters) --%>
                <div class="col-lg-3">
                    <jsp:include page="search.jsp" />
                </div>

                <%-- 4. Cột bên phải: Danh sách sản phẩm --%>
                <div class="col-lg-9">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold">
                            Available Warehouses
                            <span class="text-muted fw-normal">(${totalItems} results)</span>
                        </h4>

                        <form method="get" action="homepage">

                            <!-- giữ lại filter -->
                            <input type="hidden" name="keyword" value="${param.keyword}">
                            <input type="hidden" name="location" value="${param.location}">
                            <input type="hidden" name="typeId" value="${param.typeId}">
                            <input type="hidden" name="minPrice" value="${param.minPrice}">
                            <input type="hidden" name="maxPrice" value="${param.maxPrice}">
                            <input type="hidden" name="minArea" value="${param.minArea}">
                            <input type="hidden" name="maxArea" value="${param.maxArea}">
                            <input type="hidden" name="page" value="1"> <!-- reset page -->

                            <select name="sort" class="form-select"
                                    style="width: 220px;"
                                    onchange="this.form.submit()">

                                <option value="">Sort by</option>

                                <option value="price_asc"
                                        ${param.sort == 'price_asc' ? 'selected' : ''}>
                                    Price: Low → High
                                </option>

                                <option value="price_desc"
                                        ${param.sort == 'price_desc' ? 'selected' : ''}>
                                    Price: High → Low
                                </option>

                                <option value="area_asc"
                                        ${param.sort == 'area_asc' ? 'selected' : ''}>
                                    Area: Small → Large
                                </option>

                                <option value="area_desc"
                                        ${param.sort == 'area_desc' ? 'selected' : ''}>
                                    Area: Large → Small
                                </option>
                            </select>
                        </form>
                    </div>



                    <%-- 5. Gọi file Card --%>
                    <jsp:include page="card.jsp" /> 


                    <%-- 6. Phân trang --%>
                    <jsp:include page="pagination.jsp" />
                </div>
            </div>
        </div>
                <jsp:include page="/Common/Layout/footer.jsp" />



        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>


</body>
</html>
