<%-- 
    Document   : pagination
    Created on : Jan 27, 2026, 1:37:12 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav aria-label="Page navigation" class="mt-5">
    <ul class="pagination justify-content-center align-items-center gap-2">
        
        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
            <a class="page-link rounded-circle border-0 bg-light text-dark" 
               href="?page=${currentPage - 1}&location=${param.location}&type=${param.type}&price=${param.price}">
                <i class="fas fa-chevron-left"></i>
            </a>
        </li>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <li class="page-item">
                <a class="page-link rounded-3 border-0 ${currentPage == i ? 'bg-dark text-white' : 'bg-light text-dark'}" 
                   href="?page=${i}&location=${param.location}&type=${param.type}&price=${param.price}">
                    ${i}
                </a>
            </li>
        </c:forEach>

        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
            <a class="page-link rounded-circle border-0 bg-light text-dark" 
               href="?page=${currentPage + 1}&location=${param.location}&type=${param.type}&price=${param.price}">
                <i class="fas fa-chevron-right"></i>
            </a>
        </li>
    </ul>
</nav>
