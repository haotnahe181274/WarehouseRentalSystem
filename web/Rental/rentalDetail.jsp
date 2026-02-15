<%-- 
    Document   : rentalDetail
    Created on : Feb 11, 2026, 10:06:14 AM
    Author     : ad
    Refactored : edit and view modes only
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="/Common/Layout/header.jsp"/>
        <c:set var="mode" value="${mode}" />
        <c:set var="isEdit" value="${mode == 'edit'}" />

        <div class="detail-container">

            <h2>Rent Request Detail</h2>

            <c:if test="${isEdit}">
            <form action="${pageContext.request.contextPath}/rentDetail" method="post" id="detailForm">
                <input type="hidden" name="requestId" value="${rr.requestId}" />
            </c:if>

                <!-- META INFO -->
                <div class="meta-info">
                    <p>
                        <strong>Request ID:</strong> ${rr.requestId}
                    </p>
                    <p>
                        <strong>Request Date:</strong>
                        <c:choose>
                            <c:when test="${isEdit}">
                                <input type="datetime-local" name="requestDate" value="<fmt:formatDate value="${rr.requestDate}" pattern="yyyy-MM-dd'T'HH:mm"/>" />
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value="${rr.requestDate}" pattern="dd-MM-yyyy HH:mm"/>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>
                        <strong>Status:</strong>
                        <c:choose>
                            <c:when test="${isEdit}">
                                <select name="status">
                                    <option value="0" <c:if test="${rr.status == 0}">selected</c:if>>Pending</option>
                                    <option value="1" <c:if test="${rr.status == 1}">selected</c:if>>Approved</option>
                                    <option value="2" <c:if test="${rr.status == 2}">selected</c:if>>Rejected</option>
                                    <option value="3" <c:if test="${rr.status == 3}">selected</c:if>>Cancelled</option>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${rr.status == 0}"><span class="status-badge status-pending">Pending</span></c:when>
                                    <c:when test="${rr.status == 1}"><span class="status-badge status-approved">Approved</span></c:when>
                                    <c:when test="${rr.status == 2}"><span class="status-badge status-rejected">Rejected</span></c:when>
                                    <c:when test="${rr.status == 3}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${rr.processedDate != null}">
                        <p>
                            <strong>Processed Date:</strong>
                            <c:choose>
                                <c:when test="${isEdit}">
                                    <input type="datetime-local" name="processedDate" value="<fmt:formatDate value="${rr.processedDate}" pattern="yyyy-MM-dd'T'HH:mm"/>" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${rr.processedDate}" pattern="dd-MM-yyyy HH:mm"/>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </c:if>
                </div>

                <!-- RENTAL DETAILS -->
                <div class="section-title">Rental Details</div>
                <div class="info-card">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty rr.renter.image}">
                                <img src="${pageContext.request.contextPath}/resources/user/image/${rr.renter.image}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/resources/user/image/default.jpg">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info-block">
                        <p><strong>Full Name:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="renterFullName" value="${rr.renter.fullName}" /></c:when>
                                <c:otherwise>${rr.renter.fullName}</c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Email:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="renterEmail" value="${rr.renter.email}" /></c:when>
                                <c:otherwise>${rr.renter.email}</c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Phone:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="renterPhone" value="${rr.renter.phone}" /></c:when>
                                <c:otherwise>${rr.renter.phone}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="info-block">
                        <p><strong>Warehouse:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="warehouseName" value="${rr.warehouse.name}" /></c:when>
                                <c:otherwise>${rr.warehouse.name}</c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Address:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="warehouseAddress" value="${rr.warehouse.address}" /></c:when>
                                <c:otherwise>${rr.warehouse.address}</c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Type:</strong>
                            <c:choose>
                                <c:when test="${isEdit}"><input type="text" name="warehouseType" value="${rr.warehouse.warehouseType.typeName}" /></c:when>
                                <c:otherwise>${rr.warehouse.warehouseType.typeName}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- REQUESTED DATES -->
                <div class="section-title">Requested Dates</div>
                <div class="request-dates">
                    <div class="date-box">
                        Start Date
                        <c:choose>
                            <c:when test="${isEdit}">
                                <input type="date" name="startDate" value="<fmt:formatDate value="${rr.startDate}" pattern="yyyy-MM-dd"/>" />
                            </c:when>
                            <c:otherwise>
                                <strong><fmt:formatDate value="${rr.startDate}" pattern="dd/MM/yyyy"/></strong>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="date-box">
                        End Date
                        <c:choose>
                            <c:when test="${isEdit}">
                                <input type="date" name="endDate" value="<fmt:formatDate value="${rr.endDate}" pattern="yyyy-MM-dd"/>" />
                            </c:when>
                            <c:otherwise>
                                <strong><fmt:formatDate value="${rr.endDate}" pattern="dd/MM/yyyy"/></strong>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="date-box">
                        Area Requested
                        <c:choose>
                            <c:when test="${isEdit}">
                                <select name="area" id="areaSelect" required onchange="updatePrice()">
                                    <option value="">-- Select Area --</option>
                                    <c:forEach items="${areaPriceMap}" var="entry">
                                        <option value="${entry.key}" data-price="${entry.value}" <c:if test="${entry.key == rr.area}">selected</c:if>>${entry.key} m²</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <strong>${rr.area} m²</strong>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="date-box">
                        Price
                        <strong><span id="price">${price}</span> VND</strong>
                    </div>
                </div>

                <!-- ITEM LIST -->
                <div class="section-title">List of Items</div>
                <table class="table" id="itemTable">
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Description</th>
                            <th>Quantity</th>
                            <c:if test="${isEdit}"><th></th></c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${rr.items}" var="item">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${isEdit}">
                                            <input type="text" name="itemName" value="${item.item.itemName}" />
                                        </c:when>
                                        <c:otherwise>${item.item.itemName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isEdit}">
                                            <input type="text" name="description" value="${item.item.description}" />
                                        </c:when>
                                        <c:otherwise>${item.item.description}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.quantity}</td>
                                <c:if test="${isEdit}">
                                    <td>
                                        <button type="button" onclick="removeRow(this)" class="btn btn-reject">Delete</button>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${isEdit}">
                    <button type="button" onclick="addRow()" class="btn btn-approve">Add Item</button>
                </c:if>

                <!-- MANAGER INFO (view only) -->
                <c:if test="${not isEdit && sessionScope.userType == 'INTERNAL' && rr.processedBy != null}">
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
                        <c:when test="${isEdit}">
                            <button type="submit" class="btn btn-update" onclick="return validateForm()">Save Changes</button>
                            <a href="${pageContext.request.contextPath}/rentDetail?id=${rr.requestId}" class="btn btn-reject">Exit</a>
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
            <c:if test="${isEdit}"></form></c:if>

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

    .total-box {
        text-align: right;
        font-weight: bold;
        padding: 15px;
        background: #1e293b;
        color: white;
        border-radius: 8px;
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
</style>
<script>
    function updatePrice() {
        let select = document.getElementById("areaSelect");
        if (!select) return;
        let option = select.options[select.selectedIndex];
        if (!option || !option.dataset.price) {
            document.getElementById("price").innerText = "";
            return;
        }
        document.getElementById("price").innerText = option.dataset.price;
    }
</script>
<script>
    function validateForm() {
        let rows = document.querySelectorAll("#itemTable tbody tr");
        if (rows.length === 0) {
            alert("You must have at least one item.");
            return false;
        }
        for (let i = 0; i < rows.length; i++) {
            let nameInput = rows[i].querySelector("input[name='itemName']");
            let descInput = rows[i].querySelector("input[name='description']");
            if (nameInput && descInput) {
                if (nameInput.value.trim() === "" || descInput.value.trim() === "") {
                    alert("All item fields must be filled.");
                    return false;
                }
            }
        }
        return true;
    }
</script>
<script>
    function addRow() {
        let table = document.getElementById("itemTable");
        if (!table) return;
        let tbody = table.getElementsByTagName("tbody")[0];
        let row = tbody.insertRow();
        row.innerHTML = '<td><input type="text" name="itemName"></td><td><input type="text" name="description"></td><td>0</td><td><button type="button" onclick="removeRow(this)" class="btn btn-reject">Delete</button></td>';
    }
    function removeRow(button) {
        let row = button.closest("tr");
        if (row) row.remove();
    }
</script>

    </body>
</html>
