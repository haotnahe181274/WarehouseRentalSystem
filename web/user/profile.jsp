<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Profile</title>
            <!-- Removed Bootstrap CDN -->
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

                .form-control-custom {
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

                .form-control-custom:focus {
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

                .btn-primary-custom {
                    background-color: #6366f1;
                    color: white;
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
            </style>
        </head>

        <body>
            <jsp:include page="/Common/Layout/header.jsp" />

            <div class="layout">
                <jsp:include page="/Common/Layout/sidebar.jsp" />

                <div class="main-content">
                    <h2 class="mb-4" style="font-weight: 600; color: #111827;">Account Settings</h2>

                    <form action="${pageContext.request.contextPath}/profile" method="post"
                        enctype="multipart/form-data">
                        <input type="hidden" name="action" value="updateProfile">
                        <input type="hidden" name="id" value="${targetUser.id}">
                        <input type="hidden" name="type" value="${targetUser.type}">

                        <div class="profile-container">
                            <!-- Left Column: Avatar & Password -->
                            <div class="profile-left">
                                <!-- Avatar Card -->
                                <div class="card-custom avatar-section">
                                    <c:if test="${not empty targetUser.image}">
                                        <img src="${pageContext.request.contextPath}/resources/user/image/${targetUser.image}"
                                            alt="Avatar" class="avatar-img" id="avatarPreview">
                                    </c:if>
                                    <c:if test="${empty targetUser.image}">
                                        <img src="https://via.placeholder.com/150" alt="Default Avatar"
                                            class="avatar-img" id="avatarPreview">
                                    </c:if>

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
                                </div>

                                <script>
                                    document.getElementById('imageInput').addEventListener('change', function (e) {
                                        const file = e.target.files[0];
                                        const fileNameDisplay = document.getElementById('fileNameDisplay');

                                        if (!file) {
                                            fileNameDisplay.textContent = '';
                                            return;
                                        }

                                        // Client-side Validation
                                        const validTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
                                        const validExtensions = ['jpg', 'jpeg', 'png', 'gif'];
                                        const fileExtension = file.name.split('.').pop().toLowerCase();

                                        if (!validTypes.includes(file.type) && !validExtensions.includes(fileExtension)) {
                                            alert('Chỉ chấp nhận file ảnh (.jpg, .png). Vui lòng chọn lại!');
                                            e.target.value = ''; // Reset input
                                            fileNameDisplay.textContent = '';
                                            return;
                                        }

                                        fileNameDisplay.textContent = file.name;

                                        // Preview image
                                        if (file) {
                                            const reader = new FileReader();
                                            reader.onload = function (e) {
                                                document.getElementById('avatarPreview').src = e.target.result;
                                            }
                                            reader.readAsDataURL(file);
                                        }
                                    });
                                </script>

                                <!-- Change Password Card -->
                                <div class="card-custom">
                                    <div class="section-title">Change Password</div>
                                    <!-- Old Password -->
                                    <div class="mb-3">
                                        <label class="form-label">Old Password</label>
                                        <input type="password" name="oldPassword" class="form-control-custom">
                                        <c:if test="${not empty errors.oldPassword}">
                                            <div class="error-msg">${errors.oldPassword}</div>
                                        </c:if>
                                    </div>

                                    <!-- New Password -->
                                    <div class="mb-3">
                                        <label class="form-label">New Password</label>
                                        <input type="password" name="newPassword" class="form-control-custom">
                                        <c:if test="${not empty errors.newPassword}">
                                            <div class="error-msg">${errors.newPassword}</div>
                                        </c:if>
                                    </div>

                                    <!-- Confirm Password -->
                                    <div class="mb-3">
                                        <label class="form-label">Confirm Password</label>
                                        <input type="password" name="confirmPassword" class="form-control-custom">
                                        <c:if test="${not empty errors.confirmPassword}">
                                            <div class="error-msg">${errors.confirmPassword}</div>
                                        </c:if>
                                    </div>

                                    <button type="submit" name="btnAction" value="changePassword"
                                        class="btn-custom btn-primary-custom">
                                        Change Password
                                    </button>
                                </div>
                            </div>

                            <!-- Right Column: Profile Info -->
                            <div class="profile-right">
                                <div class="card-custom">
                                    <div class="section-title">Profile Information</div>

                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Username</label>
                                            <input type="text" class="form-control-custom" value="${targetUser.name}"
                                                disabled readonly style="background: #e5e7eb;">
                                        </div>
                                        <div class="d-none">
                                            <!-- Hidden field to keep alignment if needed, or remove -->
                                        </div>
                                    </div>

                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Full Name</label>
                                            <input type="text" name="fullName" class="form-control-custom"
                                                value="${targetUser.fullName}">
                                            <c:if test="${not empty errors.fullName}">
                                                <div class="error-msg">${errors.fullName}</div>
                                            </c:if>
                                        </div>

                                        <div>
                                            <label class="form-label">Role</label>
                                            <input type="text" class="form-control-custom" value="${targetUser.role}"
                                                disabled readonly style="background: #e5e7eb;">
                                        </div>
                                    </div>

                                    <div class="section-title" style="margin-top: 20px;">Contact Info</div>

                                    <div class="row-grid">
                                        <div>
                                            <label class="form-label">Email</label>
                                            <input type="email" name="email" class="form-control-custom"
                                                value="${targetUser.email}">
                                            <c:if test="${not empty errors.email}">
                                                <div class="error-msg">${errors.email}</div>
                                            </c:if>
                                        </div>

                                        <div>
                                            <label class="form-label">Phone</label>
                                            <input type="text" name="phone" class="form-control-custom"
                                                value="${targetUser.phone}">
                                            <c:if test="${not empty errors.phone}">
                                                <div class="error-msg">${errors.phone}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <c:if test="${targetUser.type == 'INTERNAL'}">
                                        <div class="row-grid">
                                            <div>
                                                <label class="form-label">ID Card</label>
                                                <input type="text" name="idCard" class="form-control-custom"
                                                    value="${targetUser.idCard}">
                                                <c:if test="${not empty errors.idCard}">
                                                    <div class="error-msg">${errors.idCard}</div>
                                                </c:if>
                                            </div>

                                            <div>
                                                <label class="form-label">Internal Code</label>
                                                <input type="text" class="form-control-custom"
                                                    value="${targetUser.internalUserCode}" disabled readonly
                                                    style="background: #e5e7eb;">
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Address</label>
                                            <input type="text" name="address" class="form-control-custom"
                                                value="${targetUser.address}">
                                            <c:if test="${not empty errors.address}">
                                                <div class="error-msg">${errors.address}</div>
                                            </c:if>
                                        </div>
                                    </c:if>

                                    <div style="margin-top: 30px; text-align: right;">
                                        <button type="submit" name="btnAction" value="updateInfo"
                                            class="btn-custom btn-primary-custom"
                                            style="width: auto; padding: 10px 30px;">
                                            Save Changes
                                        </button>
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