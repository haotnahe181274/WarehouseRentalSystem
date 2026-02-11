<%-- 
    Document   : about
    Created on : Feb 9, 2026, 9:25:48 PM
    Author     : ad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp" />

        <div class="about-container"> 
            <!-- ABOUT --> 
            <section class="about-section"> 
                <h2 class="section-title">About Warehouse Rental System</h2> 
                <div class="about-content"> 
                    <img src="${pageContext.request.contextPath}/resources/warehouse/image/about.jpg" alt="Warehouse System"> 
                    <p> Warehouse Rental System là nền tảng hỗ trợ kết nối giữa người có nhu cầu thuê kho và các đơn vị cung cấp kho bãi. Chúng tôi giúp việc tìm kiếm, quản lý và thuê kho trở nên nhanh chóng, minh bạch và tiện lợi hơn. </p> 
                </div> 
            </section> 
            <!-- WHY CHOOSE US --> 
            <section class="why-section"> 
                <h2 class="section-title">Why Choose Us?</h2> 
                <ul class="why-list"> 
                    <li>Quản lý kho và yêu cầu thuê kho tập trung</li> 
                    <li>Giao diện thân thiện, dễ sử dụng</li> 
                    <li>Minh bạch thông tin kho và giá thuê</li> 
                </ul> 
            </section> 
            <!-- CONTACT --> 
            <section class="contact-section"> 
                <div class="contact-info"> 
                    <h3>Contact Us</h3> 
                    <p>📍 Trường Đại Học FPT, Khu CNC Hòa Lạc, Hà Nội</p> 
                    <p>📧 warehouse_system@gmail.com</p> 
                    <p>📞 +84 123 456 789</p> 
                    <a class="map-link" href="https://www.google.com/maps/place/Tr%C6%B0%E1%BB%9Dng+%C4%90%E1%BA%A1i+h%E1%BB%8Dc+FPT+H%C3%A0+N%E1%BB%99i/" target="_blank"> View on Google Maps → </a> 
                </div>
                <div class=""> 
                    <img style ="width: 500px" src="${pageContext.request.contextPath}/resources/warehouse/image/fpt.jpg" alt="Warehouse System"> 
                    
                </div> 

            </section> 
        </div>

        <jsp:include page="/Common/Layout/footer.jsp" />

        <style>

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            .about-container {
                max-width: 1100px;
                margin: 0 auto;
                padding: 60px 20px;
                font-family: 'Open Sans', sans-serif;
            }
            .section-title {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 30px;
                color: #222;
                text-align: center;
            }
            /* ABOUT SECTION */
            .about-content {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 40px;
                align-items: center;
            }
            .about-content img {
                width: 100%;
                border-radius: 14px;
                box-shadow: 0 12px 30px rgba(0,0,0,0.15);
            }
            .about-content p {
                font-size: 16px;
                line-height: 1.8;
                color: #555;
            }
            /* WHY CHOOSE US */
            .why-section {
                margin-top: 80px;
            }
            .why-list {
                max-width: 700px;
                margin: 0 auto;
                list-style: none;
                padding: 0;
            }
            .why-list li {
                background: #f8f9fa;
                margin-bottom: 15px;
                padding: 15px 20px;
                border-radius: 10px;
                font-size: 16px;
                box-shadow: 0 6px 15px rgba(0,0,0,0.05);
                position: relative;
            }
            .why-list li::before {
                content: "✔";
                color: #0d6efd;
                font-weight: bold;
                margin-right: 10px;
            }
            /* CONTACT */
            .contact-section {
                margin-top: 70px;
                display: grid;
                grid-template-columns: 1.1fr 1.4fr; /* map to hơn */
                gap: 30px;
                background: #f8f9fa;
                padding: 30px 35px;
                border-radius: 16px;
                
                align-items: center;
            }
            .contact-info h3 {
                font-size: 24px;
                margin-bottom: 20px;
            }
            .contact-info p {
                font-size: 15px;
                margin-bottom: 10px;
                color: #444;
            }

        </style>
    </body>
</html>
