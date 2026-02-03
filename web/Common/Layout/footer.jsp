<%-- 
    Document   : footer
    Created on : Feb 2, 2026, 2:41:06 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    .footer {
        background: #1f2428;
        color: #fff;
        padding: 40px 20px;
    }

    .footer-content {
        max-width: 800px;
        margin: 0 auto;
        text-align: center;
    }

    .footer h5 {
        margin-bottom: 15px;
    }

    .footer p {
        margin: 6px 0;
        opacity: 0.85;
    }

    .footer-title {
        margin-top: 25px;
        margin-bottom: 25px;
        font-size: 22px;
        font-weight: 600;
    }

    .footer hr {
        width: 60%;
        margin: 25px auto;
        border: none;
        border-top: 1px solid rgba(255,255,255,0.2);
    }

    .footer-link {
        color: #fff;
        text-decoration: none;
        opacity: 0.9;
    }

    .footer-link:hover {
        opacity: 1;
        text-decoration: underline;
    }
</style>

<div class="footer">
    <div class="footer-content">
        <h3 class="footer-title">Warehouse Rental System</h3>

        <p>Email: warehouse_system@gmail.com</p>
        <p>Hotline: +84 123 456 789</p>
        <p>
            Trường Đại Học FPT, khu công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội
        </p>

        <h5>
            <a href="${pageContext.request.contextPath}/about" class="footer-link">
                About us
            </a>
        </h5>

        <hr>

        <p>© 2026 Warehouse Rental System</p>
        <p>All rights reserved</p>
    </div>
</div>



