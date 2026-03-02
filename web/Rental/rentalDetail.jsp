<%--
    Document   : rentalDetail

--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rent Request</title>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>
        <c:set var="mode" value="${mode}" />
        <c:set var="isEdit" value="${mode == 'edit'}" />
        <c:set var="isCreate" value="${mode == 'create'}" />
        <c:set var="isForm" value="${isEdit || isCreate}" />

        <div class="detail-container" id="detailContainer"
             data-warehouse-id="${rr.warehouse.warehouseId}"
             data-request-id="${rr.requestId}"
             data-context-path="${pageContext.request.contextPath}"
             data-mode="${mode}">

            <h2><c:choose><c:when test="${isCreate}">New Rent Request</c:when><c:otherwise>Rent Request Detail</c:otherwise></c:choose></h2>

            <c:if test="${isForm}">
                <form action="${pageContext.request.contextPath}/${isCreate ? 'createRentRequest' : 'rentDetail'}" method="post" id="detailForm">
                    <c:if test="${isCreate}">
                        <input type="hidden" name="warehouseId" value="${rr.warehouse.warehouseId}" />
                    </c:if>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="requestId" value="${rr.requestId}" />
                    </c:if>
                </c:if>

                <!-- META INFO (view / edit only) -->
                <c:if test="${not isCreate}">
                    <div class="meta-info">
                        <p><strong>Request ID:</strong> ${rr.requestId}</p>
                        <p><strong>Request Date:</strong> <fmt:formatDate value="${rr.requestDate}" pattern="dd-MM-yyyy HH:mm"/></p>
                        <p><strong>Status:</strong>
                            <c:choose>
                                <c:when test="${rr.status == 0}"><span class="status-badge status-pending">Pending</span></c:when>
                                <c:when test="${rr.status == 1}"><span class="status-badge status-approved">Approved</span></c:when>
                                <c:when test="${rr.status == 2}"><span class="status-badge status-rejected">Rejected</span></c:when>
                                <c:when test="${rr.status == 3}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
                            </c:choose>
                        </p>
                        <c:if test="${rr.processedDate != null}">
                            <p><strong>Processed Date:</strong> <fmt:formatDate value="${rr.processedDate}" pattern="dd-MM-yyyy HH:mm"/></p>
                        </c:if>
                    </div>
                </c:if>

                <!-- RENTAL DETAILS: warehouse (and renter when not create) -->
                <div class="section-title">Rental Details</div>
                <div class="info-card">
                    <c:if test="${not isCreate && rr.renter != null}">
                        <div class="avatar">
                            <c:choose>
                                <c:when test="${not empty rr.renter.image}">
                                    <img src="${pageContext.request.contextPath}/resources/user/image/${rr.renter.image}" alt="">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/resources/user/image/default.jpg" alt="">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="info-block">
                            <p><strong>Full Name:</strong> ${rr.renter.fullName}</p>
                            <p><strong>Email:</strong> ${rr.renter.email}</p>
                            <p><strong>Phone:</strong> ${rr.renter.phone}</p>
                        </div>
                    </c:if>
                    <div class="info-block">
                        <p><strong>Warehouse:</strong> ${rr.warehouse.name}</p>
                        <p><strong>Address:</strong> ${rr.warehouse.address}</p>
                        <p><strong>Type:</strong> ${rr.warehouse.warehouseType.typeName}</p>
                    </div>
                </div>

                <!-- REQUESTED UNITS: mỗi unit có ngày, diện tích, giá riêng -->
                <div class="section-title">Requested Units</div>
                <c:choose>
                    <c:when test="${isForm}">
                        <div class="units-form-wrapper">
                            <table class="table units-table" id="unitsTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Area (m²)</th>
                                        <th>Price (VND)</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="unitsTableBody">
                                    <c:choose>
                                        <c:when test="${not empty rr.units}">
                                            <c:forEach items="${rr.units}" var="u" varStatus="vs">
                                                <tr class="unit-row" data-index="${vs.index}">
                                                    <td>${vs.index + 1}</td>
                                                    <td><input type="date" name="unitStartDate" class="unit-start" value="<fmt:formatDate value="${u.startDate}" pattern="yyyy-MM-dd"/>" /></td>
                                                    <td><input type="date" name="unitEndDate" class="unit-end" value="<fmt:formatDate value="${u.endDate}" pattern="yyyy-MM-dd"/>" /></td>
                                                    <td>
                                                        <select name="unitArea" class="unit-area">
                                                            <c:forEach items="${areaPriceMap}" var="entry">
                                                                <option value="${entry.key}" data-price="${entry.value}" <c:if test="${entry.key == u.area}">selected</c:if>>${entry.key} m²</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><span class="unit-price-display"><fmt:formatNumber value="${u.rentPrice}" groupingUsed="true"/></span> <input type="hidden" name="unitPrice" class="unit-price" value="${u.rentPrice}" /></td>
                                                    <td><button type="button" class="btn btn-reject btn-remove-unit">Remove</button></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr class="unit-row" data-index="0">
                                                <td>1</td>
                                                <td><input type="date" name="unitStartDate" class="unit-start" /></td>
                                                <td><input type="date" name="unitEndDate" class="unit-end" /></td>
                                                <td>
                                                    <select name="unitArea" class="unit-area">
                                                        <option value="">-- Chọn ngày trước --</option>
                                                        <c:forEach items="${areaPriceMap}" var="entry">
                                                            <option value="${entry.key}" data-price="${entry.value}">${entry.key} m²</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td><span class="unit-price-display"></span> <input type="hidden" name="unitPrice" class="unit-price" value="" /></td>
                                                <td><button type="button" class="btn btn-reject btn-remove-unit">Remove</button></td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            <button type="button" id="addUnitBtn" class="btn btn-approve">Add Unit</button>
                            <p class="unit-total"><strong>Total: <span id="totalPrice">0</span> VND</strong></p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty rr.units}">
                                <table class="table">
                                    <thead>
                                        <tr><th>#</th><th>Start Date</th><th>End Date</th><th>Area</th><th>Price (VND)</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${rr.units}" var="u" varStatus="vs">
                                            <tr>
                                                <td>${vs.index + 1}</td>
                                                <td><fmt:formatDate value="${u.startDate}" pattern="dd-MM-yyyy"/></td>
                                                <td><fmt:formatDate value="${u.endDate}" pattern="dd-MM-yyyy"/></td>
                                                <td>${u.area} m²</td>
                                                <td><fmt:formatNumber value="${u.rentPrice}" groupingUsed="true"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <p class="unit-total"><strong>Total: <fmt:formatNumber value="${rr.totalUnitsPrice}" groupingUsed="true"/> VND</strong></p>
                            </c:when>
                            <c:otherwise>
                                <p class="meta-info">No units in this request.</p>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>

                <!-- ITEM LIST -->
                <div class="section-title">List of Items</div>
                <table class="table" id="itemTable">
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Description</th>


                            <c:if test="${isForm}"><th></th></c:if>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${rr.items}" var="item">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${isForm}">
                                            <input type="text" name="itemName" value="${item.item.itemName}" />
                                        </c:when>
                                        <c:otherwise>${item.item.itemName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isForm}">
                                            <input type="text" name="description" value="${item.item.description}" />
                                        </c:when>
                                        <c:otherwise>${item.item.description}</c:otherwise>
                                    </c:choose>
                                </td>


                                <c:if test="${isForm}">
                                    <td><button type="button" onclick="removeRow(this)" class="btn btn-reject">Delete</button></td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        <c:if test="${isCreate && empty rr.items}">
                            <tr>
                                <td><input type="text" name="itemName" placeholder="Item name" /></td>
                                <td><input type="text" name="description" placeholder="Description" /></td>

                                <td><button type="button" onclick="removeRow(this)" class="btn btn-reject">Delete</button></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <c:if test="${isForm}">
                    <button type="button" onclick="addRow()" class="btn btn-approve">Add Item</button>
                </c:if>

                <!-- MANAGER INFO (view only) -->
                <c:if test="${mode == 'view' && sessionScope.userType == 'INTERNAL' && rr.processedBy != null}">
                    <div class="info-card">
                        <div class="info-block">
                            <p><strong>Processed By:</strong> ${rr.processedBy.fullName}</p>
                            <p><strong>Internal Code:</strong> ${rr.processedBy.internalUserCode}</p>
                        </div>
                    </div>
                </c:if>

                <!-- ACTION BUTTONS -->
                <div class="action-buttons">
                    <c:choose>
                        <c:when test="${isForm}">
                            <button type="submit" class="btn btn-update" onclick="return validateForm()">
                                <c:choose><c:when test="${isCreate}">Submit Request</c:when><c:otherwise>Save Changes</c:otherwise></c:choose>
                                    </button>
                            <c:if test="${isEdit}">
                                <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}" class="btn btn-reject">Exit</a>
                            </c:if>
                            <c:if test="${isCreate}">
                                <a href="${pageContext.request.contextPath}/homepage" class="btn btn-reject">Cancel</a>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${rr.status == 0}">
                                <c:if test="${sessionScope.userType == 'INTERNAL'}">
                                    <form action="${pageContext.request.contextPath}/rentRequestCancel" method="post" style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button class="btn btn-reject">Reject</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/rentRequestApprove" method="post" style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button class="btn btn-approve">Approve</button>
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.userType == 'RENTER'}">
                                    <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}&action=edit" class="btn btn-update">Update</a>
                                    <form action="${pageContext.request.contextPath}/rentRequestCancel" method="post" style="display:inline;">
                                        <input type="hidden" name="requestId" value="${rr.requestId}">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button class="btn btn-cancel">Cancel</button>
                                    </form>
                                </c:if>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/rentList" class="btn btn-approve">Back to List</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${isForm}"></form></c:if>
            </div>

        <jsp:include page="/Common/Layout/footer.jsp"/>

        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f9;
            }
            .detail-container {
                max-width: 1000px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                padding: 30px;
            }
            .section-title {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
                color: #1e293b;
            }
            .info-card {
                display: flex;
                gap: 30px;
                background: #f8fafc;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
            }
            .avatar img {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .info-block {
                flex: 1;
            }
            .info-block p {
                margin: 6px 0;
                font-size: 14px;
            }
            .request-dates {
                display: flex;
                justify-content: space-between;
                background: #f8fafc;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
            }
            .date-box {
                flex: 1;
                text-align: center;
            }
            .date-box strong {
                display: block;
                font-size: 16px;
                margin-top: 5px;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            .table thead {
                background: #1e293b;
                color: white;
            }
            .table th, .table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #e2e8f0;
            }
            .table tbody tr:hover {
                background-color: #f1f5f9;
            }
            .action-buttons {
                margin-top: 25px;
                text-align: right;
            }
            .btn {
                padding: 10px 18px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-weight: bold;
                margin-left: 10px;
            }
            .btn-approve {
                background-color: #0f172a;
                color: white;
            }
            .btn-approve:hover {
                background-color: #1e293b;
            }
            .btn-reject {
                background-color: #e2e8f0;
            }
            .btn-reject:hover {
                background-color: #cbd5e1;
            }
            .btn-update {
                background-color: #facc15;
            }
            .btn-cancel {
                background-color: #ef4444;
                color: white;
            }
            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: bold;
            }
            .status-pending {
                background: #facc15;
            }
            .status-approved {
                background: #22c55e;
                color: white;
            }
            .status-rejected {
                background: #ef4444;
                color: white;
            }
            .status-cancelled {
                background: #64748b;
                color: white;
            }
            .meta-info {
                margin-bottom: 20px;
                font-size: 14px;
            }
            .meta-info p {
                margin: 5px 0;
            }
            .units-table {
                margin-bottom: 15px;
            }
            .units-table th {
                background: #1e293b;
                color: white;
                padding: 10px;
            }
            .units-table td {
                padding: 8px;
                vertical-align: middle;
            }
            .unit-row input[type="date"], .unit-row select {
                width: 100%;
                padding: 6px;
            }
            .unit-total {
                margin-top: 15px;
                font-size: 16px;
            }
        </style>

        <script>
            (function () {
                var box = document.getElementById("detailContainer");
                if (!box)
                    return;
                var base = box.getAttribute("data-context-path");
                var warehouseId = box.getAttribute("data-warehouse-id");
                var isForm = box.getAttribute("data-mode") === "create" || box.getAttribute("data-mode") === "edit";
                if (!isForm)
                    return;

                var tbody = document.getElementById("unitsTableBody");
                if (!tbody)
                    return;

                function loadAreasForRow(row, callback) {
                    var start = row.querySelector(".unit-start").value;
                    var end = row.querySelector(".unit-end").value;
                    var areaSelect = row.querySelector(".unit-area");
                    var priceDisplay = row.querySelector(".unit-price-display");
                    var priceInput = row.querySelector(".unit-price");
                    if (!start || !end) {
                        areaSelect.innerHTML = "<option value=\"\">-- Chọn ngày trước --</option>";
                        if (priceDisplay)
                            priceDisplay.textContent = "";
                        if (priceInput)
                            priceInput.value = "";
                        updateTotal();
                        return;
                    }
                    var url = base + "/warehouseAreaPrice?action=areas&warehouseId=" + warehouseId + "&startDate=" + encodeURIComponent(start) + "&endDate=" + encodeURIComponent(end);
                    fetch(url).then(function (r) {
                        return r.json();
                    }).then(function (areas) {
                        areaSelect.innerHTML = "<option value=\"\">-- Chọn diện tích --</option>";
                        if (Array.isArray(areas)) {
                            for (var i = 0; i < areas.length; i++) {
                                var opt = document.createElement("option");
                                opt.value = areas[i];
                                opt.textContent = areas[i] + " m²";
                                areaSelect.appendChild(opt);
                            }
                        }
                        if (priceDisplay)
                            priceDisplay.textContent = "";
                        if (priceInput)
                            priceInput.value = "";
                        updateTotal();
                        if (callback)
                            callback();
                    });
                }

                function setPriceForRow(row) {
                    var areaSelect = row.querySelector(".unit-area");
                    var priceDisplay = row.querySelector(".unit-price-display");
                    var priceInput = row.querySelector(".unit-price");
                    var opt = areaSelect && areaSelect.options[areaSelect.selectedIndex];
                    if (opt && opt.getAttribute("data-price") !== null && opt.getAttribute("data-price") !== "") {
                        var p = opt.getAttribute("data-price");
                        if (priceDisplay)
                            priceDisplay.textContent = Number(p).toLocaleString("vi-VN");
                        if (priceInput)
                            priceInput.value = p;
                        updateTotal();
                        return;
                    }
                    var area = areaSelect && areaSelect.value;
                    if (!area) {
                        if (priceDisplay)
                            priceDisplay.textContent = "";
                        if (priceInput)
                            priceInput.value = "";
                        updateTotal();
                        return;
                    }
                    var url = base + "/warehouseAreaPrice?action=price&warehouseId=" + warehouseId + "&area=" + encodeURIComponent(area);
                    fetch(url).then(function (r) {
                        return r.json();
                    }).then(function (obj) {
                        var p = obj.price != null ? obj.price : 0;
                        if (priceDisplay)
                            priceDisplay.textContent = Number(p).toLocaleString("vi-VN");
                        if (priceInput)
                            priceInput.value = p;
                        updateTotal();
                    });
                }

                function updateTotal() {
                    var total = 0;
                    tbody.querySelectorAll(".unit-price").forEach(function (inp) {
                        var v = parseFloat(inp.value);
                        if (!isNaN(v))
                            total += v;
                    });
                    var el = document.getElementById("totalPrice");
                    if (el)
                        el.textContent = total.toLocaleString("vi-VN");
                }

                function renumberRows() {
                    tbody.querySelectorAll(".unit-row").forEach(function (row, i) {
                        row.setAttribute("data-index", i);
                        var firstTd = row.querySelector("td:first-child");
                        if (firstTd)
                            firstTd.textContent = i + 1;
                    });
                }

                tbody.addEventListener("change", function (e) {
                    var row = e.target.closest(".unit-row");
                    if (!row)
                        return;
                    if (e.target.classList.contains("unit-start") || e.target.classList.contains("unit-end")) {
                        loadAreasForRow(row);
                    } else if (e.target.classList.contains("unit-area")) {
                        setPriceForRow(row);
                    }
                });

                tbody.addEventListener("click", function (e) {
                    if (!e.target.classList.contains("btn-remove-unit"))
                        return;
                    var row = e.target.closest(".unit-row");
                    if (!row)
                        return;
                    if (tbody.querySelectorAll(".unit-row").length <= 1) {
                        alert("You must have at least one unit.");
                        return;
                    }
                    row.remove();
                    renumberRows();
                    updateTotal();
                });

                document.getElementById("addUnitBtn").addEventListener("click", function () {
                    var firstRow = tbody.querySelector(".unit-row");
                    if (!firstRow)
                        return;
                    var newRow = firstRow.cloneNode(true);
                    newRow.querySelector(".unit-start").value = "";
                    newRow.querySelector(".unit-end").value = "";
                    newRow.querySelector(".unit-area").innerHTML = "<option value=\"\">-- Chọn ngày trước --</option>";
                    newRow.querySelector(".unit-price-display").textContent = "";
                    newRow.querySelector(".unit-price").value = "";
                    tbody.appendChild(newRow);
                    renumberRows();
                    updateTotal();
                });

                tbody.querySelectorAll(".unit-row").forEach(function (row) {
                    var areaSelect = row.querySelector(".unit-area");
                    if (areaSelect && areaSelect.selectedIndex >= 0) {
                        var opt = areaSelect.options[areaSelect.selectedIndex];
                        if (opt && opt.getAttribute("data-price") !== null && opt.getAttribute("data-price") !== "") {
                            setPriceForRow(row);
                        }
                    }
                });
                updateTotal();
            })();
        </script>
        <script>
            function validateForm() {
                var unitRows = document.querySelectorAll("#unitsTableBody .unit-row");
                if (unitRows.length === 0) {
                    alert("You must have at least one unit.");
                    return false;
                }
                for (var i = 0; i < unitRows.length; i++) {
                    var row = unitRows[i];
                    var start = row.querySelector(".unit-start").value;
                    var end = row.querySelector(".unit-end").value;
                    var area = row.querySelector(".unit-area").value;
                    var price = row.querySelector(".unit-price").value;
                    if (!start || !end || !area || !price) {
                        alert("All units must have Start date, End date, Area and Price (select area to get price).");
                        return false;
                    }
                    // End date must be after start date
                    var sd = new Date(start);
                    var ed = new Date(end);
                    var today = new Date();

// Reset giờ về 00:00:00 để so đúng ngày
                    today.setHours(0, 0, 0, 0);

                    if (!isNaN(sd.getTime())) {
                        if (sd < today) {
                            alert("Start date cannot be in the past.");
                            return false;
                        }
                    }

                    if (!isNaN(sd.getTime()) && !isNaN(ed.getTime())) {
                        if (ed <= sd) {
                            alert("End date must be after Start date.");
                            return false;
                        }
                    }
                }
                var itemRows = document.querySelectorAll("#itemTable tbody tr");
                if (itemRows.length === 0) {
                    alert("You must have at least one item.");
                    return false;
                }
                for (var i = 0; i < itemRows.length; i++) {
                    var nameInput = itemRows[i].querySelector("input[name='itemName']");
                    var descInput = itemRows[i].querySelector("input[name='description']");
                    if (nameInput && descInput && (nameInput.value.trim() === "" || descInput.value.trim() === "")) {
                        alert("All item fields must be filled.");
                        return false;
                    }
                }
                return true;
            }
        </script>
        <script>
            function addRow() {
                var table = document.getElementById("itemTable");
                if (!table)
                    return;
                var tbody = table.getElementsByTagName("tbody")[0];
                var row = tbody.insertRow();
                row.innerHTML = '<td><input type="text" name="itemName"></td><td><input type="text" name="description"></td><td><button type="button" onclick="removeRow(this)" class="btn btn-reject">Delete</button></td>';
            }
            function removeRow(button) {
                var row = button.closest("tr");
                if (row)
                    row.remove();
            }
        </script>
    </body>
</html>
