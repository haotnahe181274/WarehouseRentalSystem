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
        <meta charset="UTF-8">
        <title>WareSpace - Warehouse Rental</title>

        <!-- Font Awesome  -->
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <!-- CSS tự viết -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homepage.css">
    </head>

    <body>

        <jsp:include page="/Common/Layout/header.jsp" />

        <!-- BANNER -->
        <jsp:include page="banner.jsp" />

        <!-- MAIN -->
        <div class="page-container">
            <div class="page-grid">

                <!-- FILTER -->
                <aside class="sidebar">
                    <jsp:include page="search.jsp" />
                </aside>

                <!-- CONTENT -->
                <main class="content">

                    <!-- HEADER -->
                    <div class="content-header">
                        <h2>
                            Available Warehouses
                            <span>(${totalItems} results)</span>
                        </h2>

                        <div class="sort-box">

                            <form method="get" action="homepage" class="sort-form">
                                <!-- giữ filter -->
                                <input type="hidden" name="keyword" value="${param.keyword}">
                                <input type="hidden" name="location" value="${param.location}">
                                <input type="hidden" name="typeId" value="${param.typeId}">
                                <input type="hidden" name="minPrice" value="${param.minPrice}">
                                <input type="hidden" name="maxPrice" value="${param.maxPrice}">
                                <input type="hidden" name="minArea" value="${param.minArea}">
                                <input type="hidden" name="maxArea" value="${param.maxArea}">
                                <input type="hidden" name="page" value="1">

                                <select name="sort" onchange="this.form.submit()">
                                    <option value="">Sort by Price</option>
                                    <option value="price_asc"
                                            ${param.sort == 'price_asc' ? 'selected' : ''}>
                                        Low → High
                                    </option>
                                    <option value="price_desc"
                                            ${param.sort == 'price_desc' ? 'selected' : ''}>
                                        High → Low
                                    </option>
                                </select>
                            </form>


                            <form method="get" action="homepage" class="sort-form">
                                <!-- giữ filter -->
                                <input type="hidden" name="keyword" value="${param.keyword}">
                                <input type="hidden" name="location" value="${param.location}">
                                <input type="hidden" name="typeId" value="${param.typeId}">
                                <input type="hidden" name="minPrice" value="${param.minPrice}">
                                <input type="hidden" name="maxPrice" value="${param.maxPrice}">
                                <input type="hidden" name="minArea" value="${param.minArea}">
                                <input type="hidden" name="maxArea" value="${param.maxArea}">
                                <input type="hidden" name="page" value="1">

                                <select name="sort" onchange="this.form.submit()">
                                    <option value="">Sort by Area</option>
                                    <option value="area_asc"
                                            ${param.sort == 'area_asc' ? 'selected' : ''}>
                                        Small → Large
                                    </option>
                                    <option value="area_desc"
                                            ${param.sort == 'area_desc' ? 'selected' : ''}>
                                        Large → Small
                                    </option>
                                </select>
                            </form>

                            <form method="get" action="homepage" class="sort-form">
                                <!-- giữ filter -->
                                <input type="hidden" name="keyword" value="${param.keyword}">
                                <input type="hidden" name="location" value="${param.location}">
                                <input type="hidden" name="typeId" value="${param.typeId}">
                                <input type="hidden" name="minPrice" value="${param.minPrice}">
                                <input type="hidden" name="maxPrice" value="${param.maxPrice}">
                                <input type="hidden" name="minArea" value="${param.minArea}">
                                <input type="hidden" name="maxArea" value="${param.maxArea}">
                                <input type="hidden" name="page" value="1">

                                <select name="sort" onchange="this.form.submit()">
                                    <option value="">Sort by Name</option>
                                    <option value="name_asc"
                                            ${param.sort == 'name_asc' ? 'selected' : ''}>
                                        A → Z
                                    </option>
                                    <option value="name_desc"
                                            ${param.sort == 'name_desc' ? 'selected' : ''}>
                                        Z → A
                                    </option>
                                </select>
                            </form>
                        </div>




                    </div>

                    <!-- CARD LIST -->
                    <jsp:include page="card.jsp" />

                    <!-- PAGINATION -->
                    <jsp:include page="pagination.jsp" />

                </main>
            </div>
        </div>

        <jsp:include page="/Common/Layout/footer.jsp" />


        <style>


            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
                color: #111;
                background: #fff;
            }

            /* PAGE */
            .page-container {
                max-width: 1600px;   /* hoặc 100% nếu bạn muốn full */
                margin: 0 auto;
                padding: 32px 24px;  /* giảm padding ngang */
            }

            /* GRID */
            .page-grid {
                display: grid;
                grid-template-columns: 25% 1fr;
                gap: 32px;
            }

            /* SIDEBAR */


            .sidebar {
                align-self: flex-start;
                margin-top: 50px;   /* lùi xuống nhẹ */
            }

            /* CONTENT */
            .content {
                width: 100%;
            }

            /* HEADER */
            .content-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
            }

            .content-header h2 {
                font-size: 20px;
                font-weight: 700;
            }

            .content-header h2 span {
                font-size: 14px;
                font-weight: 400;
                color: #6b7280;
            }

            /* SORT */

            .sort-box {
                display: flex;
                gap: 12px;
            }

            .sort-form select {
                padding: 8px 14px;
                font-size: 14px;
                border: 1px solid #d1d5db;
                border-radius: 10px;
                background: #fff;
                cursor: pointer;
            }


            .sort-box select:focus {
                outline: none;
                border-color: #111;
            }

            /* hover thì hiện dropdown */
            .sort-item:hover .sort-menu {
                display: block;
            }



        </style>


    </body>
</html>



