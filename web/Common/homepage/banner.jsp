<%-- 
    Document   : banner
    Created on : Jan 27, 2026, 1:36:36 PM
    Author     : ad
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="hero-banner"
     style="background-image:
     linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
     url('${pageContext.request.contextPath}/resources/warehouse/image/banner_new.jpg');">

    <div class="hero-banner__content">

        <!-- ===== TEXT ===== -->
        <div class="hero-banner__text">
            <h1 class="hero-banner__title">
                Find & Book <br>
                Warehouse Space
            </h1>
            <p class="hero-banner__subtitle">
                Search thousands of warehouses across regions
            </p>
        </div>

        <!-- ===== SEARCH BOX ===== -->
        <div class="hero-search">
            <form action="homepage" method="GET" class="hero-search__form">

                <!-- INPUT -->
                <div class="hero-search__field">
                    <label class="hero-search__label">
                        Warehouse name
                    </label>

                    <div class="hero-search__input-wrapper">
                        <i class="fa fa-warehouse hero-search__icon"></i>

                        <input type="text"
                               name="keyword"
                               class="hero-search__input"
                               placeholder="Enter warehouse name..."
                               value="${param.keyword}">
                    </div>
                </div>

                <!-- BUTTON -->
                <button type="submit" class="hero-search__button">
                    <i class="fa fa-search"></i>
                    Search Warehouses
                </button>

            </form>
        </div>

    </div>
</div>


<style>
    /* ===== HERO BANNER ===== */
    .hero-banner {
        min-height: 550px;
        background-size: cover;
        background-position: center;
        display: flex;
        align-items: center;
    }

    .hero-banner__content {
        width: 100%;
        max-width: 1300px;
        margin: 0 auto;
        padding: 60px 20px;
    }

    /* ===== TEXT ===== */
    .hero-banner__text {
        max-width: 700px;
        margin-bottom: 40px;
    }

    .hero-banner__title {
        color: #fff;
        font-size: 60px;
        font-weight: 700;
        margin-bottom: 16px;
    }

    .hero-banner__subtitle {
        color: #fff;
        font-size: 18px;
        opacity: 0.9;
    }

    /* ===== SEARCH BOX ===== */
    .hero-search {
        display: flex;
        justify-content: center;
    }

    .hero-search__form {
        background: #fff;
        width: 100%;
        max-width: 1100px;
        padding: 32px;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
    }

    /* ===== FIELD ===== */
    .hero-search__field {
        margin-bottom: 20px;
    }

    .hero-search__label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #666;
        margin-bottom: 6px;
    }

    .hero-search__input-wrapper {
        display: flex;
        align-items: center;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 12px 16px;
    }

    .hero-search__icon {
        font-size: 18px;
        color: #333;
        margin-right: 12px;
    }

    .hero-search__input {
        border: none;
        outline: none;
        width: 100%;
        font-size: 16px;
    }

    /* ===== BUTTON ===== */
    .hero-search__button {
        width: 100%;
        padding: 16px;
        border: none;
        border-radius: 8px;
        background: #1f2428;
        color: #fff;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .hero-search__button:hover {
        background: #000;
    }


</style>