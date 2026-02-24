<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check In / Check Out Request</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #111; }
            .check-container { max-width: 800px; margin: 40px auto; background: #fff; padding: 24px 28px;
                               border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
            h2 { margin-top: 0; margin-bottom: 20px; color: #111; }
            .section { margin-bottom: 20px; }
            label { font-weight: bold; color: #222; }
            select, input[type="number"] { padding: 6px 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%; box-sizing: border-box; }
            .table { width: 100%; border-collapse: collapse; margin-top: 8px; }
            .table th, .table td { padding: 8px 10px; border-bottom: 1px solid #e5e5e5; text-align: left; }
            .table thead { background: #111; color: #fff; }
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
                <form action="${pageContext.request.contextPath}/createCheckRequest" method="post">
                    <input type="hidden" name="mode" value="${mode}"/>
                    <input type="hidden" name="unitId" value="${selectedUnitId}"/>

                    <div class="section">
                        <label>Items (only items from rent requests of this unit's warehouse)</label><br/>
                        <c:choose>
                            <c:when test="${empty selectedUnitId}">
                                <p class="hint">Please select a unit above to see available items.</p>
                            </c:when>
                            <c:when test="${empty items}">
                                <p class="hint">No items found for rent requests of this unit.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Item</th>
                                            <th>Description</th>
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
                                                <td>
                                                    <input type="number" name="quantity" min="0" value="0" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                               
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
            </c:if>

            <!-- VIEW MODE -->
            <c:if test="${pageMode eq 'view'}">
                <div class="section">
                    <p><strong>Request ID:</strong> ${checkRequest.id}</p>
                    <p><strong>Date:</strong> ${checkRequest.requestDate}</p>
                    <p><strong>Warehouse:</strong> ${checkRequest.warehouse.name}</p>
                    <p><strong>Unit:</strong> ${checkRequest.unit.unitCode}</p>
                </div>

                <div class="section">
                    <label>Items</label><br/>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Description</th>
                                <th>Requested Qty</th>
                                <th>Processed Qty</th>
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

