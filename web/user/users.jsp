<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>
                <c:choose>
                    <c:when test="${mode == 'add'}">Add User</c:when>
                    <c:when test="${mode == 'edit'}">Update User</c:when>
                    <c:otherwise>User Detail</c:otherwise>
                </c:choose>
            </title>

            <style>
                /* Custom Reset/Utilities */
                * {
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', Arial, sans-serif;
                    background: #f3f4f6;
                    margin: 0;
                }

                .mb-3 {
                    margin-bottom: 1rem !important;
                }

                .mb-4 {
                    margin-bottom: 1.5rem !important;
                }

                .d-none {
                    display: none !important;
                }

                .layout {
                    display: flex;
                    min-height: 100vh;
                }

                .main-content {
                    flex: 1;
                    padding: 32px;
                    background: #f5f7fb;
                }

                .profile-container {
                    display: flex;
                    gap: 24px;
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .profile-left {
                    width: 300px;
                    flex-shrink: 0;
                    display: flex;
                    flex-direction: column;
                    gap: 24px;
                }

                .profile-right {
                    flex-grow: 1;
                }

                .card-custom {
                    background: white;
                    border-radius: 12px;
                    padding: 24px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    /* Match profile.jsp */
                }

                .avatar-section {
                    text-align: center;
                }

                .avatar-img {
                    width: 150px;
                    height: 150px;
                    border-radius: 50%;
                    object-fit: cover;
                    margin-bottom: 16px;
                    border: 4px solid #f3f4f6;
                }

                .form-label {
                    font-weight: 500;
                    color: #374151;
                    margin-bottom: 8px;
                    font-size: 14px;
                    display: block;
                    /* Ensure label behaves like block */
                }

                .form-control-custom,
                .form-select-custom {
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    padding: 10px 14px;
                    width: 100%;
                    font-size: 14px;
                    transition: all 0.2s;
                    background-color: #f9fafb;
                    display: block;
                    /* Ensure input behaves like block */
                }

                .form-control-custom:focus,
                .form-select-custom:focus {
                    border-color: #6366f1;
                    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                    outline: none;
                    background-color: white;
                }

                .section-title {
                    font-size: 16px;
                    font-weight: 600;
                    color: #111827;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                    border-bottom: 1px solid #e5e7eb;
                }

                .btn-custom {
                    width: 100%;
                    padding: 10px;
                    border-radius: 8px;
                    font-weight: 500;
                    transition: all 0.2s;
                    cursor: pointer;
                    /* Add pointer cursor */
                    text-align: center;
                    display: inline-block;
                    border: none;
                    font-size: 14px;
                }

                .btn-width-auto {
                    width: auto;
                    padding: 10px 24px;
                }

                .btn-primary-custom {
                    background-color: #6366f1;
                    color: white;
                    border: none;
                }

                .btn-primary-custom:hover {
                    background-color: #4f46e5;
                }

                .btn-outline {
                    background: white;
                    border: 1px solid #d1d5db;
                    color: #374151;
                }

                .btn-outline:hover {
                    background: #f9fafb;
                }

                .row-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                    margin-bottom: 20px;
                }

                .error-msg {
                    color: #dc2626;
                    font-size: 12px;
                    margin-top: 4px;
                }

                .mb-3 {
                    margin-bottom: 1rem !important;
                }

                /* View mode text styling */
                .view-text {
                    padding: 10px 14px;
                    background-color: #e5e7eb;
                    /* Gray for readonly look */
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    color: #374151;
                    font-size: 14px;
                    display: block;
                    width: 100%;
                }

                .nav-actions {
                    margin-top: 30px;
                    display: flex;
                    justify-content: flex-end;
                    gap: 12px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/Common/Layout/header.jsp" />
            <c:set var="loginUser" value="${sessionScope.user}" />

            <div class="layout">
                <jsp:include page="/Common/Layout/sidebar.jsp" />

                <div class="main-content">
                    <h2 class="mb-4" style="font-weight: 600; color: #111827;">
                        <c:choose>
                            <c:when test="${mode == 'add'}">Add New User</c:when>
                            <c:when test="${mode == 'edit'}">Edit User</c:when>
                            <c:otherwise>User Detail</c:otherwise>
                        </c:choose>
                    </h2>

                    <form action="${pageContext.request.contextPath}/user/list" method="post"
                        enctype="multipart/form-data">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="mode" value="${mode}">

                        <c:if test="${targetUser != null}">
                            <input type="hidden" name="id" value="${targetUser.id}">
                            <input type="hidden" name="type" value="${targetUser.type}">
                        </c:if>

                        <div class="profile-container">
                            <!-- Left Column: Avatar -->
                            <div class="profile-left">
                                <div class="card-custom avatar-section">
                                    <c:if test="${not empty targetUser.image}">
                                        <img src="${pageContext.request.contextPath}/resources/user/image/${targetUser.image}"
                                            alt="Avatar" class="avatar-img">
                                    </c:if>
                                    <c:if test="${empty targetUser.image}">
                                        <img src="https://via.placeholder.com/150" alt="Default Avatar"
                                            class="avatar-img">
                                    </c:if>

                                    <!-- Upload Button (Only for Add or Edit, not View) -->
                                    <c:if test="${mode != 'view'}">
                                        <label class="btn-custom btn-outline"
                                            style="cursor: pointer; display: block; margin-top: 10px;">
                                            Upload Photo
                                            <input type="file" name="image" accept=".jpg, .jpeg, .png"
                                                style="display: none;" id="imageInput">
                                        </label>
                                        <div id="fileNameDisplay"
                                            style="margin-top: 8px; font-size: 13px; color: #6b7280; word-break: break-all;">
                                        </div>

                                        <c:if test="${not empty errors.image}">
                                            <div class="error-msg">${errors.image}</div>
                                        </c:if>

                                        <script>
                                            document.getElementById('imageInput').addEventListener('change', function (e) {
                                                const file = e.target.files[0];
                                                const fileNameDisplay = document.getElementById('fileNameDisplay');

                                                if (!file) {
                                                    fileNameDisplay.textContent = '';
                                                    return;
                                                }

                                                // Client-side Validation to reject .exe or non-image
                                                const validTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
                                                const validExtensions = ['jpg', 'jpeg', 'png', 'gif'];
                                                const fileExtension = file.name.split('.').pop().toLowerCase();

                                                if (!validTypes.includes(file.type) && !validExtensions.includes(fileExtension)) {
                                                    alert('Just support jpg, png');
                                                    e.target.value = ''; // Reset input
                                                    fileNameDisplay.textContent = '';
                                                    return;
                                                }

                                                fileNameDisplay.textContent = file.name;

                                                // Preview image
                                                if (file) {
                                                    const reader = new FileReader();
                                                    reader.onload = function (e) {
                                                        const img = document.querySelector('.avatar-img');
                                                        if (img) img.src = e.target.result;
                                                    }
                                                    reader.readAsDataURL(file);
                                                }
                                            });
                                        </script>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Right Column: User Info -->
                            <div class="profile-right">
                                <div class="card-custom">
                                    <div class="section-title">User Information</div>

                                    <!-- Username & Password (for Add) or Status (for View/Edit) -->
                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Username</label>
                                            <c:choose>
                                                <c:when test="${mode == 'add'}">
                                                    <input type="text" name="username" class="form-control-custom"
                                                        value="${username}" required>
                                                    <c:if test="${not empty errors.username}">
                                                        <div class="error-msg">${errors.username}</div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="view-text">${targetUser.name}</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:if test="${mode == 'add'}">
                                            <div>
                                                <label class="form-label">Password</label>
                                                <input type="password" name="password" class="form-control-custom"
                                                    required>
                                                <c:if test="${not empty errors.password}">
                                                    <div class="error-msg">${errors.password}</div>
                                                </c:if>
                                            </div>
                                        </c:if>
                                        <c:if test="${mode != 'add'}">
                                            <!-- Empty div or Status can go here -->
                                            <div>
                                                <label class="form-label">Status</label>
                                                <c:choose>
                                                    <c:when test="${mode == 'view'}">
                                                        <div class="view-text">
                                                            <c:choose>
                                                                <c:when test="${targetUser.status == 1}">Active</c:when>
                                                                <c:otherwise>Blocked</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- If Editing allow changing status? Usually status change is a separate action (Block/Unblock) but let's keep it view-only or as is -->
                                                        <div class="view-text">
                                                            <c:choose>
                                                                <c:when test="${targetUser.status == 1}">Active</c:when>
                                                                <c:otherwise>Blocked</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Full Name</label>
                                            <c:choose>
                                                <c:when test="${mode == 'view'}">
                                                    <div class="view-text">${targetUser.fullName}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" name="fullName" class="form-control-custom"
                                                        value="${not empty fullName ? fullName : targetUser.fullName}"
                                                        required>
                                                    <c:if test="${not empty errors.fullName}">
                                                        <div class="error-msg">${errors.fullName}</div>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Role -->
                                        <div>
                                            <label class="form-label">Role</label>
                                            <c:choose>
                                                <c:when test="${targetUser.type == 'INTERNAL' || mode == 'add'}">
                                                    <c:choose>
                                                        <c:when test="${mode == 'view'}">
                                                            <div class="view-text">${targetUser.role}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <select name="roleId" class="form-select-custom">
                                                                <option value="1" ${targetUser.role=='Admin'
                                                                    ? 'selected' : '' }>Admin</option>
                                                                <option value="2" ${targetUser.role=='Manager'
                                                                    ? 'selected' : '' }>Manager</option>
                                                                <option value="3" ${targetUser.role=='Staff'
                                                                    ? 'selected' : '' }>Staff</option>
                                                            </select>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="view-text">Renter</div> <!-- Or empty -->
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="section-title" style="margin-top: 20px;">Contact Info</div>

                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Email</label>
                                            <c:choose>
                                                <c:when test="${mode == 'view'}">
                                                    <div class="view-text">${targetUser.email}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="email" name="email" class="form-control-custom"
                                                        value="${not empty email ? email : targetUser.email}" required>
                                                    <c:if test="${not empty errors.email}">
                                                        <div class="error-msg">${errors.email}</div>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <label class="form-label">Phone</label>
                                            <c:choose>
                                                <c:when test="${mode == 'view'}">
                                                    <div class="view-text">${targetUser.phone}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" name="phone" class="form-control-custom"
                                                        value="${not empty phone ? phone : targetUser.phone}">
                                                    <c:if test="${not empty errors.phone}">
                                                        <div class="error-msg">${errors.phone}</div>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Internal User Specifics -->
                                    <c:if test="${targetUser.type == 'INTERNAL' || mode == 'add'}">
                                        <div class="row-grid">
                                            <div>
                                                <label class="form-label">ID Card</label>
                                                <c:choose>
                                                    <c:when test="${mode == 'view'}">
                                                        <div class="view-text">${targetUser.idCard}</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="text" name="idCard" class="form-control-custom"
                                                            value="${not empty idCard ? idCard : targetUser.idCard}">
                                                        <c:if test="${not empty errors.idCard}">
                                                            <div class="error-msg">${errors.idCard}</div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div>
                                                <label class="form-label">Internal Code</label>
                                                <c:choose>
                                                    <c:when test="${mode == 'add'}">
                                                        <div class="view-text" style="color: #9ca3af;">(Auto-generated)
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="view-text">${targetUser.internalUserCode}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Address</label>
                                            <c:choose>
                                                <c:when test="${mode == 'view'}">
                                                    <div class="view-text">${targetUser.address}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" name="address" class="form-control-custom"
                                                        value="${not empty address ? address : targetUser.address}">
                                                    <c:if test="${not empty errors.address}">
                                                        <div class="error-msg">${errors.address}</div>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>

                                    <c:if test="${mode == 'view'}">
                                        <div class="mb-3">
                                            <label class="form-label">Created At</label>
                                            <div class="view-text">
                                                <fmt:formatDate value="${targetUser.createdAt}"
                                                    pattern="yyyy-MM-dd HH:mm" />
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Actions -->
                                    <div class="nav-actions">
                                        <!-- UPDATE BUTTON (Admin viewing details) -->
                                        <c:if test="${mode == 'view' && loginUser.role == 'Admin'}">
                                            <a class="btn-custom btn-primary-custom btn-width-auto"
                                                style="text-decoration: none; display: inline-block;"
                                                href="${pageContext.request.contextPath}/user/list?action=edit&id=${targetUser.id}&type=${targetUser.type}">
                                                Edit User
                                            </a>
                                        </c:if>

                                        <!-- SAVE BUTTON (Add/Edit mode) -->
                                        <c:if test="${mode != 'view'}">
                                            <button class="btn-custom btn-primary-custom btn-width-auto" type="submit">
                                                Save Changes
                                            </button>
                                        </c:if>

                                        <!-- BACK BUTTON -->
                                        <a class="btn-custom btn-outline btn-width-auto"
                                            href="${pageContext.request.contextPath}/user/list"
                                            style="text-decoration: none; display: inline-block; text-align: center;">
                                            Back to List
                                        </a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <jsp:include page="/Common/Layout/footer.jsp" />
        </body>

        </html>