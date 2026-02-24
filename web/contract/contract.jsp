<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Chi tiết hợp đồng</title>

    <style>
        body {
            font-family: Arial;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .status {
            background-color: #2ecc71;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .container {
            padding: 40px;
            background: white;
            margin: 30px auto;
            width: 90%;
            border-radius: 10px;
        }

        h3 {
            color: #2980b9;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }

        .row {
            display: flex;
            justify-content: space-between;
        }

        .box {
            width: 48%;
        }

        .info p {
            margin: 8px 0;
        }

        .highlight {
            background: #f1f2f6;
            padding: 20px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .price {
            color: red;
            font-weight: bold;
            font-size: 18px;
        }

        .actions {
            text-align: center;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
        }

        .agree {
            background-color: #27ae60;
            color: white;
        }

        .reject {
            background-color: #e74c3c;
            color: white;
        }

        .pdf {
            background-color: #3498db;
            color: white;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div>
        MÃ HĐ: ${contract.contractId}
    </div>

    <div>
        <c:choose>
            <c:when test="${contract.status == 1}">
                <span class="status">Đã đồng ý</span>
            </c:when>
            <c:when test="${contract.status == 2}">
                <span class="status" style="background:#e74c3c;">Đã từ chối</span>
            </c:when>
            <c:otherwise>
                <span class="status" style="background:#f39c12;">Chờ xác nhận</span>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="container">

    <!-- BÊN A - BÊN B -->
    <div class="row">
        <div class="box">
            <h3>BÊN CHO THUÊ (BÊN A)</h3>
            <div class="info">
                <p><b>Công ty:</b> ${ownerName}</p>
                <p><b>Đại diện:</b> ${ownerRep}</p>
                <p><b>MST:</b> ${ownerTax}</p>
                <p><b>Địa chỉ:</b> ${ownerAddress}</p>
            </div>
        </div>

        <div class="box">
            <h3>BÊN THUÊ (BÊN B)</h3>
            <div class="info">
                <p><b>Công ty:</b> ${contract.renter.renterName}</p>
                <p><b>Email:</b> ${contract.renter.renterEmail}</p>
                <p><b>Điện thoại:</b> ${contract.renter.renterPhone}</p>
            </div>
        </div>
    </div>

    <br>

    <!-- CHI TIẾT KHO -->
    <h3>CHI TIẾT KHO BÃI & TÀI CHÍNH</h3>

    <p><b>Địa điểm kho:</b> ${contract.warehouse.location}</p>

    <div class="highlight">
        <p><b>Diện tích thuê:</b> ${contract.warehouse.capacity} m²</p>
        <p><b>Thời hạn thuê:</b> ${contract.startDate} → ${contract.endDate}</p>
        <p>
            <b>Giá thuê hàng tháng:</b>
            <span class="price">
                ${contract.price} VNĐ/tháng
            </span>
        </p>
    </div>

    <br>

    <!-- ĐIỀU KHOẢN -->
    <h3>ĐIỀU KHOẢN CHÍNH</h3>
    <ul>
        <li>Giá trên chưa bao gồm VAT và chi phí điện nước.</li>
        <li>Bên B thanh toán tiền thuê vào ngày 05 hàng tháng.</li>
        <li>Trách nhiệm PCCC thuộc về Bên B trong suốt thời gian vận hành.</li>
    </ul>

    <!-- ACTION BUTTONS -->
    <div class="actions">

        <!-- Form Đồng ý / Từ chối -->
        <form action="contract" method="post" style="display:inline;">
            <input type="hidden" name="contractId" value="${contract.contractId}"/>

            <button type="submit" name="action" value="agree" class="btn agree">
                Đồng ý
            </button>

            <button type="submit" name="action" value="reject" class="btn reject">
                Từ chối
            </button>
        </form>

        <!-- Xuất PDF -->
        <form action="exportPdf" method="get" style="display:inline;">
            <input type="hidden" name="contractId" value="${contract.contractId}"/>
            <button type="submit" class="btn pdf">
                Xuất File PDF
            </button>
        </form>

    </div>

</div>

</body>
</html>