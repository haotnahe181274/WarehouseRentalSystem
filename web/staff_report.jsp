<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Equipment Check-in</title>
    <link rel="stylesheet" href="css/staff-report.css">
</head>
<body>
<header class="topbar">
    <div class="logo">Equipment Manager</div>
    <div class="user">John Stevens <span>Staff</span></div>
</header>

<div class="container">
    <div class="breadcrumb">Dashboard &gt; Equipment Check-In &gt; Incident Report</div>

    <!-- CARD 1 -->
    <div class="card">
        <h2>Equipment Check-in</h2>
        <p class="subtitle">Review and confirm equipment return details</p>

        <div class="grid-3">
            <div><small>Equipment ID</small><strong>EQ-2847</strong></div>
            <div><small>Equipment Name</small><strong>Pneumatic Drill XR-500</strong></div>
            <div><small>Assigned To</small><strong>Michael Rodriguez</strong></div>
        </div>

        <div class="status">
            <small>Condition Status</small>
            <div class="btn-group">
                <button class="btn-outline">Good</button>
                <button class="btn-danger" onclick="openModal()">Damaged</button>
            </div>
        </div>
    </div>
</div>

<!-- CARD 2 - MODAL -->
<div id="incidentModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Incident Report</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>

        <p class="subtitle">Document equipment damage details</p>

        <div class="grid-2">
            <div><small>Equipment ID</small><strong>EQ-2847</strong></div>
            <div><small>Equipment</small><strong>Pneumatic Drill XR-500</strong></div>
        </div>

        <label>Description of Damage *</label>
        <textarea placeholder="Provide detailed information about the damage..."></textarea>

        <label>Upload Photo (Optional)</label>
        <div class="upload-box">Click to upload or drag and drop<br><small>PNG, JPG, PDF (max 10MB)</small></div>

        <div class="notice">
            <strong>Important Notice</strong>
            <p>This report will be reviewed by the maintenance team. Equipment may be temporarily removed from inventory.</p>
        </div>

        <div class="modal-footer">
            <button class="btn-outline" onclick="closeModal()">Cancel</button>
            <button class="btn">Submit Report</button>
        </div>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById('incidentModal').style.display = 'flex';
    }
    function closeModal() {
        document.getElementById('incidentModal').style.display = 'none';
    }
</script>
</body>
</html>
