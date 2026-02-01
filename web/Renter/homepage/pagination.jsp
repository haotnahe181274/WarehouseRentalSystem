<%-- 
    Document   : pagination
    Created on : Jan 27, 2026, 1:37:12 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style>

    .pagination {
        list-style: none;
        padding-left: 0;
        display: flex;
    }

    .pagination .page-item {
        margin-left: -1px; /* ghép viền sát nhau */
    }

    .pagination .page-link {
        display: block;
        padding: 8px 14px;
        color: #000;
        background-color: #fff;
        border: 1px solid #dee2e6;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    /* hover */
    .pagination .page-link:hover {
        background-color: #000;
        color: #fff;
        border-color: #000;
    }

    /* active */
    .pagination .page-item.active .page-link {
        background-color: #000;
        color: #fff;
        border-color: #000;
        cursor: default;
    }

    /* disabled */
    .pagination .page-item.disabled .page-link {
        color: #adb5bd;
        pointer-events: none;
        background-color: #fff;
        border-color: #dee2e6;
    }

    /* bo tròn 2 đầu */
    .pagination .page-item:first-child .page-link {
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
    }

    .pagination .page-item:last-child .page-link {
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;
    }

</style>

<c:if test="${totalPages > 1}">
    <nav class="mt-5 d-flex justify-content-center">
        <ul class="pagination">

            <!-- PREVIOUS -->
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${paginationUrl}?page=${currentPage - 1}${queryString}">
                    &laquo;
                </a>
            </li>

            <!-- PAGE NUMBERS -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${paginationUrl}?page=${i}${queryString}">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="${paginationUrl}?page=${currentPage + 1}${queryString}">
                    &raquo;
                </a>
            </li>

        </ul>
    </nav>
</c:if>



