<%-- 
    Document   : pagination
    Created on : Jan 27, 2026, 1:37:12 PM
    Author     : ad
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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


