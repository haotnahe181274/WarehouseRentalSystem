<%-- 
    Document   : pagination
    Created on : Jan 27, 2026, 1:37:12 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style>
    /* Tổng thể thanh phân trang */
    .pagination .page-item .page-link {
        color: #000;              /* Chữ màu đen */
        background-color: #fff;   /* Nền màu trắng */
        border: 1px solid #dee2e6; /* Viền xám nhạt */
        transition: all 0.3s ease;
    }

    /* Hiệu ứng khi di chuột qua (Hover) */
    .pagination .page-item .page-link:hover {
        background-color: #000;   /* Nền chuyển sang đen */
        color: #fff;              /* Chữ chuyển sang trắng */
        border-color: #000;
    }

    /* Trạng thái trang đang chọn (Active) */
    .pagination .page-item.active .page-link {
        background-color: #000;   /* Nền đen */
        border-color: #000;       /* Viền đen */
        color: #fff;              /* Chữ trắng */
    }

    /* Trạng thái bị vô hiệu hóa (Disabled) */
    .pagination .page-item.disabled .page-link {
        color: #6c757d;           /* Chữ xám */
        background-color: #fff;
        border-color: #dee2e6;
    }

    /* Loại bỏ viền xanh mặc định khi click (Focus) */
    .page-link:focus {
        box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.25);
    }
</style>

<c:if test="${totalPages > 1}">
    <nav class="mt-5 d-flex justify-content-center">
        <ul class="pagination">

            <!-- PREVIOUS -->
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="homepage?page=${currentPage - 1}&${pageContext.request.queryString}">
                    &laquo;
                </a>
            </li>

            <!-- PAGE NUMBERS -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="homepage?page=${i}&${pageContext.request.queryString}">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="homepage?page=${currentPage + 1}&${pageContext.request.queryString}">
                    &raquo;
                </a>
            </li>

        </ul>
    </nav>
</c:if>


