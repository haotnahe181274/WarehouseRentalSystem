<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    Generic Statistics Cards Component
    Parameters:
    - label1, value1, icon1
    - label2, value2, icon2
    - label3, value3, icon3
    - label4, value4, icon4
--%>

<div class="row g-4 mb-4">
    <c:if test="${not empty param.label1}">
        <div class="col-md">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="icon-box ${not empty param.color1 ? param.color1 : 'primary'}"><i class="${not empty param.icon1 ? param.icon1 : 'fa-solid fa-chart-line'}"></i></div>
                </div>
                <div class="stat-value">${not empty param.value1 ? param.value1 : '0'}</div>
                <div class="stat-label">${param.label1}</div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.label2}">
        <div class="col-md">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="icon-box ${not empty param.color2 ? param.color2 : 'success'}"><i class="${not empty param.icon2 ? param.icon2 : 'fa-solid fa-chart-line'}"></i></div>
                </div>
                <div class="stat-value">${not empty param.value2 ? param.value2 : '0'}</div>
                <div class="stat-label">${param.label2}</div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.label3}">
        <div class="col-md">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="icon-box ${not empty param.color3 ? param.color3 : 'warning'}"><i class="${not empty param.icon3 ? param.icon3 : 'fa-solid fa-chart-line'}"></i></div>
                </div>
                <div class="stat-value">${not empty param.value3 ? param.value3 : '0'}</div>
                <div class="stat-label">${param.label3}</div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.label4}">
        <div class="col-md">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="icon-box ${not empty param.color4 ? param.color4 : 'info'}"><i class="${not empty param.icon4 ? param.icon4 : 'fa-solid fa-chart-line'}"></i></div>
                </div>
                <div class="stat-value">${not empty param.value4 ? param.value4 : '0'}</div>
                <div class="stat-label">${param.label4}</div>
            </div>
        </div>
    </c:if>
</div>
