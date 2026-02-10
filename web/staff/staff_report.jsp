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
    <h2>Create Incident Report</h2>

    <c:if test="${not empty error}"><p style="color:red;">${error}</p></c:if>
    <c:if test="${param.success == 1}"><p style="color:green;">Report submitted successfully!</p></c:if>

    <form action="staffReport" method="post">
        <div class="row">
            <div class="form-group">
                <label>Reported By</label>
                <input type="text" value="${sessionScope.user.fullName}" readonly style="background:#eee;"/>
            </div>

            <div class="form-group">
                <label>Warehouse</label>
                <input type="text" value="${whName}" readonly style="background:#eee;" placeholder="No warehouse assigned"/>
                
                <input type="hidden" name="warehouse_id" value="${whId}" />
            </div>
        </div>

        <div class="form-group">
            <label>Incident Type</label>
            <select name="type" required ${empty whId ? 'disabled' : ''}>
                <option value="">-- Select Type --</option>
                <option>Inventory Issue</option>
                <option>Damaged Goods</option>
                <option>Security Issue</option>
            </select>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="4" required ${empty whId ? 'disabled' : ''}></textarea>
        </div>

        <div style="text-align:center;">
            <button class="btn" type="submit" ${empty whId ? 'disabled' : ''}>Submit Report</button>
        </div>
    </form>
</div>
 </div>                      
<jsp:include page="/Common/Layout/footer.jsp" />
</body>
</html>
