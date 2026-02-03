<%-- 
    Document   : pagination
    Created on : Jan 27, 2026, 1:37:12 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<c:if test="${totalPages > 1}">
    <nav class="pagination-wrapper">
        <ul class="pagination">

            <!-- PREVIOUS -->
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a href="${paginationUrl}?page=${currentPage - 1}${queryString}">
                    &laquo;
                </a>
            </li>

            <!-- PAGE NUMBERS -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a href="${paginationUrl}?page=${i}${queryString}">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a href="${paginationUrl}?page=${currentPage + 1}${queryString}">
                    &raquo;
                </a>
            </li>

        </ul>
    </nav>
</c:if>

<style>

    .pagination-wrapper {
        display: flex;
        justify-content: center;
        margin-top: 40px;
    }

    .pagination {
        display: flex;
        list-style: none;
        padding: 0;
        gap: 8px;
    }

    .page-item a {
        display: inline-flex;
        align-items: center;
        justify-content: center;

        min-width: 40px;
        height: 40px;

        border-radius: 10px;
        border: 1px solid #e5e7eb;

        text-decoration: none;
        font-size: 14px;
        font-weight: 600;

        color: #111;
        background: #fff;

    }

    /* Hover */
    .page-item:not(.disabled):not(.active) a:hover {
        background: #111;
        color: #fff;
    }

    /* Active */
    .page-item.active a {
        background: #111;
        color: #fff;
        border-color: #111;
    }

    /* Disabled */
    .page-item.disabled a {
        pointer-events: none;
        
    }


</style>


