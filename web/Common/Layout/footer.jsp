
<%-- 
    Document   : footer
    Created on : Feb 2, 2026, 2:41:06 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<style>
    .footer {
        width: 100%;
        background-color: #1f2428;
        color: #e5e5e5;
        padding: 70px 20px 50px;
        font-family: "Times New Roman", Georgia, serif;
    }

    .footer-content {
        max-width: 900px;
        margin: 0 auto;
        text-align: center;
    }

    /* Title */
    .footer-title {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 32px;
        color: #ffffff;
    }

    /* Text lines */
    .footer-text {
        margin: 10px 0;
        font-size: 17px;
        line-height: 1.6;
    }

    /* About */
    .footer-about {
        margin-top: 28px;
    }

    .footer-about-link {
        font-size: 16px;
        font-weight: 600;
        color: #ffffff;
        text-decoration: none;
    }

    .footer-about-link:hover {
        text-decoration: underline;
    }

    /* Divider */
    .footer-divider {
        width: 70%;
        height: 1px;
        background-color: rgba(255,255,255,0.3);
        margin: 40px auto 30px;
    }

    /* Bottom */
    .footer-bottom-text {
        font-size: 16px;
        margin: 6px 0;
        color: #dcdcdc;
    }

</style>

<div class="footer">
    <div class="footer-content">

        <div class="footer-title">
            Warehouse Rental System
        </div>

        <div class="footer-text">
            Email: warehouse_system@gmail.com
        </div>

        <div class="footer-text">
            Hotline: +84 123 456 789
        </div>

        <div class="footer-text">
            Trường Đại Học FPT, khu công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội
        </div>

        <div class="footer-about">
            <a href="${pageContext.request.contextPath}/Common/homepage/about.jsp"
               class="footer-about-link">
                About us
            </a>
        </div>

        <div class="footer-divider"></div>

        <div class="footer-bottom-text">
            © 2026 Warehouse Rental System
        </div>

        <div class="footer-bottom-text">
            All rights reserved
        </div>

    </div>
</div>
