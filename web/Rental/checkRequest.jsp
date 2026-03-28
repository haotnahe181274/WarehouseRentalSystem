<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check In / Check Out Request</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style-utils.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/management-layout.css">
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #111; }
            .error-banner{
                margin: 14px auto 0;
                max-width: 800px;
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
                padding: 10px 12px;
                border-radius: 10px;
                font-size: 14px;
            }
            .check-container { max-width: 800px; margin: 40px auto; background: #fff; padding: 24px 28px;
                               border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
            h2 { margin-top: 0; margin-bottom: 20px; color: #111; }
            .section { margin-bottom: 20px; }
            label { font-weight: bold; color: #222; }
            select, input[type="number"] { padding: 6px 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%; box-sizing: border-box; }
            .btn { padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; font-weight: bold; }
            .btn-approve { background-color: #111; color: #fff; }
            .btn-approve:hover { background-color: #222; }
            .btn-reject { background-color: #e5e5e5; color: #111; }
            .btn-reject:hover { background-color: #d4d4d4; }
            a.btn { text-decoration: none; display: inline-block; }
            .hint { font-size: 12px; color: #555; margin-top: 4px; }
        </style>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>
        <jsp:include page="/message/popupMessage.jsp" />
        <c:if test="${not empty quantityError}">
            <div id="formError" class="error-banner">${quantityError}</div>
        </c:if>

        <div class="check-container">
            <c:set var="pageMode" value="${empty pageMode ? (empty checkRequest ? 'create' : 'view') : pageMode}" />
            <c:set var="mode" value="${mode}" />
            <h2>
                <c:choose>
                    <c:when test="${pageMode eq 'view'}">
                        <c:choose>
                            <c:when test="${mode eq 'OUT'}">Check Out Request Detail</c:when>
                            <c:otherwise>Check In Request Detail</c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${mode eq 'OUT'}">New Check Out Request</c:when>
                            <c:otherwise>New Check In Request</c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </h2>

            <!-- CREATE MODE -->
            <c:if test="${pageMode eq 'create'}">
                <!-- Bước 1: chọn unit (GET, để lọc item theo unit/warehouse) -->
                <form action="${pageContext.request.contextPath}/createCheckRequest" method="get" class="section">
                    <input type="hidden" name="mode" value="${mode}"/>
                    <label>Unit (only active contracts)</label><br/>
                    <select name="unitId" required onchange="this.form.submit()">
                        <option value="">-- Select unit --</option>
                        <c:forEach items="${activeUnits}" var="u">
                            <option value="${u.unitId}" <c:if test="${selectedUnitId == u.unitId}">selected</c:if>>
                                ${u.warehouse.name} - ${u.unitCode} (${u.warehouse.address})
                            </option>
                        </c:forEach>
                    </select>
                    
                </form>

                <!-- Bước 2: chọn nhiều item + quantity (POST) -->
                <form action="${pageContext.request.contextPath}/createCheckRequest" method="post" id="checkRequestForm">
                    <input type="hidden" name="mode" value="${mode}"/>
                    <input type="hidden" name="unitId" value="${selectedUnitId}"/>

                    <div class="section">
                        <label>Days & Items</label><br/>
                        <c:choose>
                            <c:when test="${empty selectedUnitId}">
                                <p class="hint">Please select a unit above to see available items.</p>
                            </c:when>
                            <c:when test="${empty items}">
                                <p class="hint">No items available for this unit.</p>
                            </c:when>
                            <c:otherwise>
                                <div id="dayBlocks">
                                    <div class="day-block">
                                        <div style="display:flex; gap:12px; align-items:end; margin-bottom:12px;">
                                            <div style="flex:1;">
                                                <label>Check date</label><br/>
                                                <input type="date" class="day-date" required />
                                            </div>
                                            <button type="button" class="btn btn-reject" style="height:36px;" onclick="removeDayBlock(this)">Remove</button>
                                        </div>

                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Item</th>
                                                    <th>Description</th>
                                                    <c:if test="${mode eq 'OUT'}">
                                                        <th>In Stock</th>
                                                    </c:if>
                                                    <th>Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${items}" var="it">
                                                    <tr>
                                                        <td>
                                                            ${it.itemName}
                                                            <input type="hidden" name="itemId" value="${it.itemId}"/>
                                                        </td>
                                                        <td>${it.description}</td>
                                                        <c:if test="${mode eq 'OUT'}">
                                                            <td>${availableQtyMap[it.itemId]}</td>
                                                        </c:if>
                                                        <td>
                                                            <input type="hidden" name="checkDate" class="row-check-date" value=""/>
                                                            <input type="number"
                                                                   name="quantity"
                                                                   min="0"
                                                                   value="0"
                                                                   <c:if test="${mode eq 'OUT'}">max="${availableQtyMap[it.itemId]}"</c:if> />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div style="margin-top:12px;">
                                    <button type="button" class="btn btn-approve" onclick="addDayBlock()">Add another day</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="margin-top:20px;">
                        <button type="submit" class="btn btn-approve">
                            <c:choose>
                                <c:when test="${mode eq 'OUT'}">Create Check Out Request</c:when>
                                <c:otherwise>Create Check In Request</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/itemlist" class="btn btn-reject">Cancel</a>
                    </div>
                </form>

                <script>
                    function fillCheckDates() {
                        const blocks = document.querySelectorAll('#dayBlocks .day-block');
                        for (const block of blocks) {
                            const dateInput = block.querySelector('.day-date');
                            const dateVal = dateInput ? dateInput.value : '';
                            const anyQtyPositive = Array.from(block.querySelectorAll('input[name="quantity"]'))
                                    .some(inp => parseInt(inp.value || '0', 10) > 0);

                            // Nếu không có item nào có quantity > 0 thì không bắt buộc phải chọn ngày.
                            if (!anyQtyPositive) continue;

                            if (!dateVal) {
                                const err = document.getElementById('formError');
                                const msg = 'Bạn phải chọn ngày check-in/check-out cho các ngày có nhập số lượng > 0.';
                                if (err) err.textContent = msg;
                                else alert(msg);
                                return false;
                            }

                            block.querySelectorAll('input.row-check-date').forEach(h => h.value = dateVal);
                        }
                        return true;
                    }

                    function addDayBlock() {
                        const container = document.getElementById('dayBlocks');
                        if (!container) return;
                        const first = container.querySelector('.day-block');
                        if (!first) return;

                        const clone = first.cloneNode(true);
                        clone.querySelectorAll('.day-date').forEach(d => d.value = '');
                        clone.querySelectorAll('input.row-check-date').forEach(h => h.value = '');
                        container.appendChild(clone);
                    }

                    function removeDayBlock(btn) {
                        const container = document.getElementById('dayBlocks');
                        if (!container) return;
                        const blocks = container.querySelectorAll('.day-block');
                        if (blocks.length <= 1) return; // giữ lại ít nhất 1 ngày
                        const block = btn.closest('.day-block');
                        if (block) block.remove();
                    }

                    (function () {
                        const form = document.getElementById('checkRequestForm');
                        if (!form) return;
                        form.addEventListener('submit', function (e) {
                            if (!fillCheckDates()) e.preventDefault();
                        });
                    })();
                </script>
            </c:if>

            <!-- VIEW MODE -->
            <c:if test="${pageMode eq 'view'}">
                <div class="section">
                    <p><strong>Request ID:</strong> ${checkRequest.id}</p>
                    <p><strong>Date:</strong> <fmt:formatDate value="${checkRequest.requestDate}" pattern="yyyy-MM-dd"/></p>
                    <p><strong>Warehouse:</strong> ${checkRequest.warehouse.name}</p>
                    <p><strong>Unit:</strong> ${checkRequest.unit.unitCode}</p>
                </div>

                <div class="section">
                    
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Description</th>
                                <th>Requested Quantity</th>
                                <th>Processed Quantity</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${checkRequest.items}" var="ci">
                                <tr>
                                    <td>${ci.item.itemName}</td>
                                    <td>${ci.item.description}</td>
                                    <td>${ci.quantity}</td>
                                    <td><c:out value="${ci.processedQuantity}" default="-" /></td>
                                    <td>${ci.status}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top:20px;">
                    <a href="${pageContext.request.contextPath}/checkRequestList" class="btn btn-reject">Back to List</a>
                </div>
            </c:if>
        </div>

        <jsp:include page="/Common/Layout/footer.jsp"/>
    </body>
    </html>

