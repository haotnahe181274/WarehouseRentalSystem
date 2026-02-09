<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Incident Report</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .container {
            width: 700px;
            margin: 50px auto;
            background: #fff;
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        input[readonly] {
            background: #f1f1f1;
        }

        .btn {
            background: #007bff;
            color: #fff;
            padding: 10px 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn:hover {
            background: #0056b3;
        }

        .row {
            display: flex;
            gap: 20px;
        }

        .row .form-group {
            flex: 1;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Incident Report</h2>

    <form>
        <!-- INCIDENT TYPE -->
        <div class="form-group">
            <label>Incident Type</label>
            <select required>
                <option value="">-- Select Incident Type --</option>
                <option>Inventory Issue</option>
                <option>Damaged Goods</option>
                <option>Lost Item</option>
                <option>Fire Alarm</option>
                <option>Water Leak</option>
                <option>Power Outage</option>
                <option>Security Issue</option>
            </select>
        </div>

        <!-- DESCRIPTION -->
        <div class="form-group">
            <label>Description</label>
            <textarea rows="4"
                      placeholder="Describe the incident in detail..."
                      required></textarea>
        </div>

        <!-- STAFF & WAREHOUSE -->
        <div class="row">
            <div class="form-group">
                <label>Reported By</label>
                <input type="text" value="Nguyen Van A (Staff)" readonly />
            </div>

            <div class="form-group">
                <label>Warehouse</label>
                <select required>
                    <option value="">-- Select Warehouse --</option>
                    <option>Ha Noi Central Warehouse</option>
                    <option>Bac Ninh Smart Warehouse</option>
                    <option>Hai Phong Port Warehouse</option>
                    <option>Ho Chi Minh Logistics Hub</option>
                </select>
            </div>
        </div>

        <!-- SUBMIT -->
        <div style="text-align:center; margin-top: 25px;">
            <button class="btn">Submit Report</button>
        </div>
    </form>
</div>

</body>
</html>
