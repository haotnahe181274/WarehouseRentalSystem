<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Chi tiết hợp đồng</title>

<style>
body{font-family:Arial;background:#f4f6f9;margin:0;}

.header{
    background:#2c3e50;
    color:white;
    padding:20px 40px;
    display:flex;
    justify-content:space-between;
}

.status{
    padding:6px 16px;
    border-radius:20px;
    font-size:14px;
    color:white;
}

.container{
    padding:40px;
    background:white;
    margin:30px auto;
    width:90%;
    border-radius:10px;
}

h3{color:#2980b9;border-bottom:1px solid #ddd;}

.row{display:flex;justify-content:space-between;}
.box{width:48%;}
.info p{margin:8px 0;}

.highlight{
    background:#f1f2f6;
    padding:20px;
    border-radius:8px;
    margin-top:15px;
}

.price{
    color:red;
    font-weight:bold;
    font-size:18px;
}

.actions{text-align:center;margin-top:30px;}

.btn{
    padding:10px 25px;
    border:none;
    border-radius:6px;
    cursor:pointer;
    margin:5px;
    color:white;
}

.agree{background:#27ae60;}
.reject{background:#e74c3c;}
.pdf{background:#3498db;}
</style>
</head>

<body>

<c:choose>
<c:when test="${not empty contract}">

<!-- ================= HEADER ================= -->
<div class="header">

    <div>MÃ HĐ: ${contract.contractId}</div>

    <div>
        <c:choose>

            <c:when test="${contract.status == 0}">
                <span class="status" style="background:#f39c12">
                    Chờ Manager duyệt
                </span>
            </c:when>

            <c:when test="${contract.status == 1}">
                <span class="status" style="background:#2980b9">
                    Chờ Renter xác nhận
                </span>
            </c:when>

            <c:when test="${contract.status == 3}">
                <span class="status" style="background:#2ecc71">
                    Hợp đồng có hiệu lực
                </span>
            </c:when>

            <c:otherwise>
                <span class="status" style="background:#e74c3c">
                    Đã từ chối
                </span>
            </c:otherwise>

        </c:choose>
    </div>

</div>


<!-- ================= CONTENT ================= -->
<div class="container">

    <div class="row">

    <!-- ================= BÊN A ================= -->
    <div class="box">
    <h3>BÊN CHO THUÊ (BÊN A)</h3>

    <c:choose>


        <c:when test="${contract.status >= 1}">
            <div class="info">
                <p><b>Công ty:</b> Warehouse Rental System</p>
                <p><b>Đại diện:</b> ${contract.managerName}</p>
                <p><b>Email:</b> ${contract.managerEmail}</p>
                <p><b>Điện thoại:</b> ${contract.managerPhone}</p>
            </div>
        </c:when>

        <c:otherwise>
            <p style="color:#f39c12;">
                Hợp đồng đang chờ Manager xác nhận
            </p>
        </c:otherwise>

    </c:choose>
    </div>


    <!-- ================= BÊN B ================= -->
    <div class="box">
    <h3>BÊN THUÊ (BÊN B)</h3>

    <div class="info">
        <p><b>Họ tên:</b> ${contract.renterName}</p>
        <p><b>Email:</b> ${contract.renterEmail}</p>
        <p><b>Điện thoại:</b> ${contract.renterPhone}</p>
    </div>

    </div>

    </div>

    <br>

    <h3>CHI TIẾT KHO BÃI & TÀI CHÍNH</h3>

    <p><b>Tên kho:</b> ${contract.warehouseName}</p>
    <p><b>Địa chỉ:</b> ${contract.warehouseAddress}</p>

    <div class="highlight">

    <p>
    <b>Thời hạn thuê:</b>
    ${contract.startDate} → ${contract.endDate}
    </p>

    <p>
    <b>Giá thuê:</b>
    <span class="price">${contract.price} VNĐ/tháng</span>
    </p>

    </div>

    <br>

    <h3>ĐIỀU KHOẢN CHÍNH</h3>
    <ul>
    <li>Giá chưa bao gồm VAT và điện nước.</li>
    <li>Thanh toán vào ngày 05 hàng tháng.</li>
    <li>Bên B chịu trách nhiệm PCCC.</li>
    </ul>


    <!-- ================= ACTION BUTTON ================= -->
    <!-- ================= ACTION BUTTON ================= -->
<div class="actions">

<!-- ===== MANAGER ===== -->
<c:if test="${sessionScope.role eq 'Manager' and contract.status == 0}">
<form action="contract-detail" method="post" style="display:inline;">
    <input type="hidden" name="contractId"
           value="${contract.contractId}"/>

    <button type="submit" name="action"
            value="agree" class="btn agree">
        Manager Đồng ý
    </button>

    <button type="submit" name="action"
            value="reject" class="btn reject">
        Manager Từ chối
    </button>
</form>
</c:if>


<!-- ===== RENTER ===== -->
<c:if test="${sessionScope.userType eq 'RENTER' and contract.status == 1}">
<form action="contract-detail" method="post" style="display:inline;">
    <input type="hidden" name="contractId"
           value="${contract.contractId}"/>

    <button type="submit" name="action"
            value="agree" class="btn agree">
        Đồng ý hợp đồng
    </button>

    <button type="submit" name="action"
            value="reject" class="btn reject">
        Từ chối
    </button>
</form>
</c:if>

</div>

    </div>

    </c:when>

    <c:otherwise>
    <h2 style="text-align:center;color:red;margin-top:50px;">
    Không tìm thấy hợp đồng!
    </h2>
    </c:otherwise>
    </c:choose>

</body>
</html>