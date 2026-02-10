<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Incident Report</title>

    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; }
        .layout {
            display: flex;
            align-items: flex-start;
        }
        .container {
            flex: 1;
            padding: 24px;
            background: #f5f7fb;
        h2 { text-align: center; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: bold; margin-bottom: 6px; }
        input, select, textarea {
            width: 100%; padding: 10px;
            border-radius: 4px; border: 1px solid #ccc;
        }
        textarea { resize: vertical; }
        input[readonly] { background: #f1f1f1; }
        .btn {
            background: #007bff; color: #fff;
            padding: 10px 18px; border: none;
            border-radius: 4px; cursor: pointer;
        }
        .btn:hover { background: #0056b3; }
        .row { display: flex; gap: 20px; }
        .row .form-group { flex: 1; }
    </style>
</head>
<body>
<jsp:include page="/Common/Layout/header.jsp" />
<div class="layout">   
<jsp:include page="/Common/Layout/sidebar.jsp" />
<div class="container">
    <h2>Incident Report</h2>

    <form action="staffReport" method="post">
        <!-- TYPE -->
        <div class="form-group">
            <label>Incident Type</label>
            <select name="type" required>
                <option value="">-- Select Incident Type --</option>
                <option>Inventory Issue</option>
                <option>Damaged Goods</option>
                <option>Lost Item</option>
                <option>Fire Alarm</option>
                <option>Water Leak</option>
                <option>Power Outage</option>
                <option>Security Issue</option>
            </select>
        </div>

        <!-- DESCRIPTION -->
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="4" required></textarea>
        </div>

        <!-- STAFF & WAREHOUSE -->
        <div class="row">
            <div class="form-group">
                <label>Reported By</label>
                <input type="text"
                       value="${sessionScope.user.fullName}"
                       readonly />
            </div>


            <div class="form-group">
                <label>Warehouse</label>
                <input type="text"
                       value="${warehouseName}"
                       readonly />
            </div>


        </div>

        <div style="text-align:center; margin-top: 25px;">
            <button class="btn" type="submit">Submit Report</button>
        </div>
    </form>
</div>
 </div>                      
<jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>
