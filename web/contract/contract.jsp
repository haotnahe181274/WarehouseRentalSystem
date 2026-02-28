<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Chi tiết hợp đồng</title>

    <style>
        body {font-family: Arial;background-color:#f4f6f9;margin:0;}
        .header {
            background:#2c3e50;color:white;
            padding:20px 40px;
            display:flex;justify-content:space-between;
        }
        .status {
            padding:5px 15px;
            border-radius:20px;
            font-size:14px;
            background:#2ecc71;
        }
        .container {
            padding:40px;background:white;
            margin:30px auto;width:90%;
            border-radius:10px;
        }
        h3 {color:#2980b9;border-bottom:1px solid #ddd;}
        .row {display:flex;justify-content:space-between;}
        .box {width:48%;}
        .info p {margin:8px 0;}
        .highlight {
            background:#f1f2f6;
            padding:20px;
            border-radius:8px;
            margin-top:15px;
        }
        .price {color:red;font-weight:bold;font-size:18px;}
        .actions {text-align:center;margin-top:30px;}
        .btn {
            padding:10px 25px;border:none;
            border-radius:6px;cursor:pointer;margin:5px;
            color:white;
        }
        .agree{background:#27ae60;}
        .reject{background:#e74c3c;}
        .pdf{background:#3498db;}
    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div>
        MÃ HĐ: ${contractDetail.contractId}
    </div>

    <div>
        <c:choose>
            <c:when test="${contractDetail.status == 1}">
                <span class="status">Đã đồng ý</span>
            </c:when>
            <c:when test="${contractDetail.status == 2}">
                <span class="status" style="background:#e74c3c;">Đã từ chối</span>
            </c:when>
            <c:otherwise>
                <span class="status" style="background:#f39c12;">Chờ xác nhận</span>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="container">

    <!-- BÊN A & B -->
    <div class="row">

        <!-- BÊN A -->
        <div class="box">
            <h3>BÊN CHO THUÊ (BÊN A)</h3>

            <c:choose>
                <c:when test="${not empty contractDetail.managerName}">
                    <div class="info">
                        <p><b>Công ty:</b> Warehouse Rental System</p>
                        <p><b>Đại diện:</b> ${contractDetail.managerName}</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <p style="color:#f39c12;">
                        Hợp đồng đang chờ Manager xác nhận
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- BÊN B -->
        <div class="box">
            <h3>BÊN THUÊ (BÊN B)</h3>

            <div class="info">
                <p><b>Họ và tên:</b> ${contractDetail.renterName}</p>
                <p><b>Email:</b> ${contractDetail.renterEmail}</p>
                <p><b>Điện thoại:</b> ${contractDetail.renterPhone}</p>
            </div>
        </div>

    </div>

    <br>

    <!-- KHO -->
    <h3>CHI TIẾT KHO BÃI & TÀI CHÍNH</h3>

    <p><b>Địa điểm kho:</b> ${contractDetail.warehouseAddress}</p>

    <div class="highlight">
        <p><b>Thời hạn thuê:</b>
            ${contractDetail.startDate}
            →
            ${contractDetail.endDate}
        </p>

        <p>
            <b>Giá thuê hàng tháng:</b>
            <span class="price">
                ${contractDetail.price} VNĐ/tháng
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

    <!-- BUTTON -->
    <div class="actions">

        <form action="contract" method="post" style="display:inline;">
            <input type="hidden" name="contractId"
                   value="${contractDetail.contractId}"/>

            <button type="submit" name="action"
                    value="agree" class="btn agree">
                Đồng ý
            </button>

            <button type="submit" name="action"
                    value="reject" class="btn reject">
                Từ chối
            </button>
        </form>

        <form action="exportPdf" method="get" style="display:inline;">
            <input type="hidden" name="contractId"
                   value="${contractDetail.contractId}"/>

            <button type="submit" class="btn pdf">
                Xuất File PDF
            </button>
        </form>

    </div>

</div>

</body>
</html>