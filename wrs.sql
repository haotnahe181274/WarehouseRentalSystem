-- ==============================
-- DATABASE
-- ==============================
DROP DATABASE IF EXISTS wrs;
CREATE DATABASE wrs;
USE wrs;

-- ==============================
-- MASTER TABLES
-- ==============================
CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

CREATE TABLE Warehouse_Type (
    warehouse_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- ==============================
-- USER TABLES
-- ==============================
CREATE TABLE Internal_user (
    internal_user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    password VARCHAR(255),
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    status INT,
    created_at DATETIME,
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    password VARCHAR(255),
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    status INT,
    create_at DATETIME
);

-- ==============================
-- WAREHOUSE
-- ==============================
CREATE TABLE Warehouse (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    description TEXT,
    status INT,
    warehouse_type_id INT,
    FOREIGN KEY (warehouse_type_id) REFERENCES Warehouse_Type(warehouse_type_id)
);

CREATE TABLE Warehouse_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255),
    image_type VARCHAR(50),
    is_primary BOOLEAN,
    status INT,
    create_at DATETIME,
    warehouse_id INT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- ==============================
-- STORAGE & ITEM
-- ==============================
CREATE TABLE Storage_unit (
    unit_id INT AUTO_INCREMENT PRIMARY KEY,
    unit_code VARCHAR(50),
    status INT,
    area DECIMAL(10,2),
    price_per_unit DECIMAL(10,2),
    description TEXT,
    warehouse_id INT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100),
    description TEXT
);

-- ==============================
-- CONTRACT
-- ==============================
CREATE TABLE Contract (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATETIME,
    end_date DATETIME,
    status INT,
    customer_id INT,
    warehouse_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Contract_Storage_unit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT,
    unit_id INT,
    rent_price DECIMAL(10,2),
    start_date DATETIME,
    end_date DATETIME,
    status INT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id),
    FOREIGN KEY (unit_id) REFERENCES Storage_unit(unit_id)
);

-- ==============================
-- PAYMENT & INVOICE
-- ==============================
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10,2),
    payment_date DATETIME,
    method VARCHAR(50),
    status INT,
    contract_id INT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);

CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_date DATETIME,
    total_amount DECIMAL(10,2),
    payment_id INT,
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);

-- ==============================
-- RENT REQUEST & ASSIGNMENT
-- ==============================
CREATE TABLE Rent_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_date DATETIME,
    status INT,
    customer_id INT,
    warehouse_id INT,
    internal_user_id INT,
    processed_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

CREATE TABLE Staff_assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    assigned_date DATETIME,
    internal_user_id INT,
    warehouse_id INT,
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- ==============================
-- FEEDBACK
-- ==============================
CREATE TABLE Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    rating INT,
    comment TEXT,
    is_anonymous BOOLEAN,
    feedback_date DATETIME,
    customer_id INT,
    warehouse_id INT,
    contract_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);

CREATE TABLE Feedback_response (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    response_text TEXT,
    response_date DATETIME,
    feedback_id INT,
    internal_user_id INT,
    FOREIGN KEY (feedback_id) REFERENCES Feedback(feedback_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

-- ==============================
-- INVENTORY & INCIDENT
-- ==============================
CREATE TABLE Inventory_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action INT,           -- 1=IMPORT, 2=EXPORT, 3=ADJUST
    quantity INT,
    action_date DATETIME,
    item_id INT,
    unit_id INT,
    internal_user_id INT,
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (unit_id) REFERENCES Storage_unit(unit_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

CREATE TABLE Incident_report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    description TEXT,
    report_date DATETIME,
    status INT,
    warehouse_id INT,
    internal_user_id INT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

-- ==============================
-- SAMPLE DATA
-- ==============================

-- ROLE
INSERT INTO Role(role_name)
VALUES ('Admin'), ('Warehouse Manager'), ('Staff');

-- WAREHOUSE TYPE
INSERT INTO Warehouse_Type(type_name, description)
VALUES 
('Cold Storage', 'Kho lạnh'),
('Normal Storage', 'Kho thường');

-- INTERNAL USER
INSERT INTO Internal_user(user_name, password, full_name, email, phone, status, created_at, role_id)
VALUES 
('admin01', '123456', 'System Admin', 'admin@mail.com', '0909000001', 1, NOW(), 1),
('manager01', '123456', 'Warehouse Manager A', 'manager@mail.com', '0909000002', 1, NOW(), 2),
('staff01', '123456', 'Warehouse Staff A', 'staff@mail.com', '0909000003', 1, NOW(), 3);

-- CUSTOMER
INSERT INTO Customer(user_name, password, full_name, email, phone, status, create_at)
VALUES 
('cus01', '123456', 'Nguyen Van A', 'a@gmail.com', '0911000001', 1, NOW()),
('cus02', '123456', 'Tran Thi B', 'b@gmail.com', '0911000002', 1, NOW());

-- WAREHOUSE
INSERT INTO Warehouse(name, address, description, status, warehouse_type_id)
VALUES 
('Kho A', 'Ha Noi', 'Kho trung tâm', 1, 1),
('Kho B', 'Ho Chi Minh', 'Kho miền Nam', 1, 2);

-- WAREHOUSE IMAGE
INSERT INTO Warehouse_image(image_url, image_type, is_primary, status, create_at, warehouse_id)
VALUES
('khoA.jpg', 'EXTERIOR', TRUE, 1, NOW(), 1),
('khoB.jpg', 'INTERIOR', TRUE, 1, NOW(), 2);

-- STORAGE UNIT
INSERT INTO Storage_unit(unit_code, status, area, price_per_unit, description, warehouse_id)
VALUES
('U-A01', 1, 50.0, 2000000, 'Kho nhỏ', 1),
('U-B01', 1, 80.0, 3000000, 'Kho tiêu chuẩn', 2);

-- ITEM
INSERT INTO Item(item_name, description)
VALUES
('Electronics', 'Thiết bị điện tử'),
('Frozen Food', 'Thực phẩm đông lạnh');

-- CONTRACT
INSERT INTO Contract(start_date, end_date, status, customer_id, warehouse_id)
VALUES
(NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1, 1, 1),
(NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1, 2, 2);

-- CONTRACT STORAGE UNIT
INSERT INTO Contract_Storage_unit(contract_id, unit_id, rent_price, start_date, end_date, status)
VALUES
(1, 1, 2000000, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1),
(2, 2, 3000000, NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1);

-- PAYMENT
INSERT INTO Payment(amount, payment_date, method, status, contract_id)
VALUES
(12000000, NOW(), 'BANK_TRANSFER', 1, 1),
(9000000, NOW(), 'CASH', 1, 2);

-- INVOICE
INSERT INTO Invoice(issue_date, total_amount, payment_id)
VALUES
(NOW(), 12000000, 1),
(NOW(), 9000000, 2);

-- RENT REQUEST
INSERT INTO Rent_request(request_date, status, customer_id, warehouse_id, internal_user_id, processed_date)
VALUES
(NOW(), 1, 1, 1, 2, NOW()),
(NOW(), 2, 2, 2, 1, NULL);

-- STAFF ASSIGNMENT
INSERT INTO Staff_assignment(assigned_date, internal_user_id, warehouse_id)
VALUES
(NOW(), 3, 1),
(NOW(), 3, 2);

-- FEEDBACK
INSERT INTO Feedback(rating, comment, is_anonymous, feedback_date, customer_id, warehouse_id, contract_id)
VALUES
(5, 'Kho sạch sẽ, dịch vụ tốt', 0, NOW(), 1, 1, 1),
(4, 'Giá hợp lý', 1, NOW(), 2, 2, 2);

-- FEEDBACK RESPONSE
INSERT INTO Feedback_response(response_text, response_date, feedback_id, internal_user_id)
VALUES
('Cảm ơn anh/chị đã phản hồi!', NOW(), 1, 2);

-- INVENTORY LOG
-- action: 1=IMPORT, 2=EXPORT
INSERT INTO Inventory_log(action, quantity, action_date, item_id, unit_id, internal_user_id)
VALUES
(1, 100, NOW(), 1, 1, 3),
(2, 20, NOW(), 2, 2, 3);

-- INCIDENT REPORT
INSERT INTO Incident_report(type, description, report_date, status, warehouse_id, internal_user_id)
VALUES
('Fire Alarm', 'Báo cháy giả', NOW(), 3, 1, 3),
('Water Leak', 'Rò rỉ nước nhẹ', NOW(), 2, 2, 2);
