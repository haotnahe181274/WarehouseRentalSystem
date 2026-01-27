<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Tasks</title>
    <link rel="stylesheet" href="css/Staff-tasks.css">
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>Today's Tasks</h1>
            <span>Monday, January 22, 2024</span>
        </div>
        <div class="user-info">
            <strong>Sarah Johnson</strong><br>
            <span>Staff Member</span>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats">
        <div class="stat-card"><p>Total Tasks</p><h2>24</h2></div>
        <div class="stat-card"><p>Check-Ins</p><h2>12</h2></div>
        <div class="stat-card"><p>Check-Outs</p><h2>12</h2></div>
        <div class="stat-card"><p>Completed</p><h2>8</h2></div>
    </div>

    <!-- Main -->
    <div class="main">
        <!-- Check-ins -->
        <div class="card">
            <h3>Expected Check-Ins</h3>

            <div class="task">
                <div>
                    <strong>09:00 AM - Michael Chen</strong><br>
                    <small>Room 204 • 3 nights</small>
                </div>
                <button class="btn">Start Check-In</button>
            </div>

            <div class="task">
                <div>
                    <strong>09:30 AM - Emma Rodriguez</strong><br>
                    <small>Room 156 • 2 nights</small>
                </div>
                <button class="btn">Start Check-In</button>
            </div>

            <div class="task">
                <div>
                    <strong>10:00 AM - James Wilson</strong><br>
                    <small>Room 312 • 1 night</small>
                </div>
                <button class="btn btn-danger">Urgent</button>
            </div>
        </div>

        <!-- Check-outs -->
        <div class="card">
            <h3>Expected Check-Outs</h3>

            <div class="task">
                <div>
                    <strong>11:00 AM - Lisa Anderson</strong><br>
                    <small>Room 108 • In progress</small>
                </div>
                <button class="btn btn-success">Complete</button>
            </div>

            <div class="task">
                <div>
                    <strong>12:00 PM - Anna Petrov</strong><br>
                    <small>Room 167 • 2 nights</small>
                </div>
                <button class="btn">Start Check-Out</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
