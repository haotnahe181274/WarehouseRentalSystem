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


        <%-- 2. THÊM BANNER Ở ĐÂY (Phần tiêu đề và search bar lớn) --%>
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
                        <h4 class="fw-bold">Available Warehouses 
                            <span class="text-muted fw-normal">(${totalItems} results)</span>
                        </h4>
                        <%-- Dropdown Sort By có thể để ở đây --%>
                    </div>



                    <%-- 5. Gọi file Card. File này sẽ tự lo vòng lặp c:forEach bên trong nó --%>
                    <jsp:include page="card.jsp" /> 


                    <%-- 6. Phân trang --%>
                    <jsp:include page="pagination.jsp" />
                </div>
            </div>
        </div>



        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>


</body>
</html>
