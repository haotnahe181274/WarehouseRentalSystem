<%-- 
    Document   : dashboard
    Created on : Feb 3, 2026, 6:55:18 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <style>
            .container {
    margin-left: 250px !important;
    margin-right: 0 !important;
    max-width: calc(100% - 250px) !important;
    padding-top: 20px;
}

        </style>
        <jsp:include page="/Common/Layout/header.jsp" />
        <jsp:include page="/Common/Layout/sidebar.jsp" />

        <div class="container">
            <h1>Dashboard</h1>
        </div>
    </body>
</html>
