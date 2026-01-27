<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Equipment Check-In</title>
    <link rel="stylesheet" href="css/Staff-check.css">
</head>
<body>
<header class="topbar">
    <div class="logo">RentFlow</div>
    <nav class="nav">
        <a href="#">Dashboard</a>
        <a href="#" class="active">Check-In</a>
        <a href="#">Check-Out</a>
        <a href="#">Inventory</a>
    </nav>
</header>

<div class="container">
    <h1>Equipment Check-In</h1>
    <p class="subtitle">Verify and process returned rental equipment</p>

    <!-- Scan QR -->
    <div class="card center">
        <div class="qr-box">QR</div>
        <h3>Scan Booking QR Code</h3>
        <p>Scan the customer's booking QR code to load their rental details</p>
        <button class="btn">Scan QR Code</button>
    </div>

    <!-- Booking details -->
    <div class="card">
        <div class="card-header">
            <h3>Booking Details</h3>
            <span class="status active">Active Rental</span>
        </div>
        <div class="grid-3">
            <div><small>Booking ID</small><strong>#RB-2024-0158</strong></div>
            <div><small>Customer</small><strong>Sarah Johnson</strong></div>
            <div><small>Return Date</small><strong>Jan 22, 2024</strong></div>
        </div>
    </div>

    <!-- Checklist -->
    <div class="card">
        <h3>Equipment Return Checklist</h3>
        <p class="subtitle">Verify each item's quantity and condition</p>

        <div class="item">
            <div class="item-info">
                <strong>Canon EOS R5 Camera</strong>
                <small>Declared Qty: 2</small>
            </div>
            <input type="number" value="2">
            <select><option>Good</option></select>
            <span class="icon ok">✓</span>
        </div>

        <div class="item">
            <div class="item-info">
                <strong>Sony FX3 Cinema Camera</strong>
                <small>Declared Qty: 1</small>
            </div>
            <input type="number" value="1">
            <select><option>Good</option></select>
            <span class="icon ok">✓</span>
        </div>

        <div class="item warning">
            <div class="item-info">
                <strong>Rode Wireless GO II</strong>
                <small>Declared Qty: 3</small>
            </div>
            <input type="number" value="2">
            <select><option>Good</option></select>
            <span class="icon warn">!</span>
        </div>

        <div class="item">
            <div class="item-info">
                <strong>SanDisk Extreme Pro CFexpress</strong>
                <small>Declared Qty: 4</small>
            </div>
            <input type="number" value="4">
            <select><option>Good</option></select>
            <span class="icon ok">✓</span>
        </div>

        <div class="footer">
            <span>Progress: 3 of 4 items verified</span>
            <div>
                <button class="btn-outline">Save Progress</button>
                <button class="btn">Complete Check-In</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>