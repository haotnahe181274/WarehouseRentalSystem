<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>
    <title>Staff Check</title>

    <style>

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f6f8;
            margin: 40px;
        }

        .container {
            max-width: 900px;
            margin: auto;
        }

        /* ---------- HEADER INFO ---------- */

        .header-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
        }

        .header-item {
            font-size: 14px;
        }

        .header-item b {
            display: block;
            font-size: 16px;
            margin-top: 4px;
        }

        /* ---------- CHECK LIST ---------- */

        .check-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .check-title {
            font-size: 18px;
            margin-bottom: 15px;
        }

        .item-box {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;

            display: flex;
            align-items: center;
            gap: 15px;
        }

        .item-icon {
            width: 45px;
            height: 45px;
            background: #f1f3f5;
            border-radius: 6px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 20px;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .item-sub {
            font-size: 13px;
            color: #777;
        }

        .item-inputs {
            display: flex;
            gap: 15px;
        }

        .item-inputs input {
            width: 100px;
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .item-inputs select {
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        /* ---------- FOOTER ---------- */

        .footer {
            margin-top: 20px;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        button {
            background: #111827;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background: black;
        }

        .back {
            margin-top: 20px;
        }

    </style>

</head>


<body>

<div class="container">

    <!-- ===== HEADER INFORMATION ===== -->

    <div class="header-card">

        <div class="header-item">
            Request ID
            <b>#${checkRequest.id}</b>
        </div>

        <div class="header-item">
            Type
            <b>${checkRequest.requestType}</b>
        </div>

        <div class="header-item">
            WarehouseID
            <b>${checkRequest.warehouseId}</b>
        </div>

        <div class="header-item">
            UnitID
            <b>${checkRequest.unitId}</b>
        </div>

    </div>


    <!-- ===== FORM CHECK ITEM ===== -->

    <form action="${pageContext.request.contextPath}/staffCheck" method="post">

        <input type="hidden" name="assignmentId" value="${assignmentId}">
        <input type="hidden" name="requestId" value="${checkRequest.id}">


        <div class="check-card">

            <div class="check-title">
                Item Check List
            </div>


            <!-- ===== LOOP ITEMS ===== -->

            <c:forEach var="i" items="${checkRequest.items}">

                <div class="item-box">

                    <!-- ITEM ICON -->

                    <div class="item-icon">
                        📦
                    </div>


                    <!-- ITEM INFORMATION -->

                    <div class="item-info">

                        <div class="item-name">
                            ${i.item.itemName}
                        </div>

                        <div class="item-sub">
                            Required Qty: ${i.quantity}
                        </div>

                    </div>


                    <!-- INPUT AREA -->

                    <div class="item-inputs">

                        <!-- QUANTITY -->

                        <div>
                            <label>Qty</label><br>

                            <input
                                type="number"
                                name="processed_${i.id}"
                                min="0"
                                max="${i.quantity}"
                                value="${i.processedQuantity != null ? i.processedQuantity : i.quantity}"
                                required
                            >
                        </div>


                        <!-- CONDITION -->

                        
                    </div>

                </div>

            </c:forEach>



            <!-- ===== FOOTER ===== -->

            <div class="footer">

                <div>
                    Items: ${checkRequest.items.size()}
                </div>

                <button type="submit">
                    Complete Check
                </button>

            </div>

        </div>

    </form>


    <!-- BACK BUTTON -->

    <div class="back">
        <a href="staffTask">← Back to Task</a>
    </div>

</div>

</body>
</html>