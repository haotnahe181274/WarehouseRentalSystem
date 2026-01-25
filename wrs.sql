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
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    status VARCHAR(20),
    warehouse_type_id INT,
    FOREIGN KEY (warehouse_type_id) REFERENCES Warehouse_Type(warehouse_type_id)
);

CREATE TABLE Warehouse_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255),
    image_type VARCHAR(50),
    is_primary BOOLEAN,
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    status VARCHAR(20),
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
    action VARCHAR(50),
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
    status VARCHAR(20),
    warehouse_id INT,
    internal_user_id INT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

-- ==============================
-- SAMPLE DATA
-- ==============================
INSERT INTO Role(role_name)
VALUES ('Admin'), ('Warehouse Manager'), ('Staff');

INSERT INTO Warehouse_Type(type_name, description)
VALUES ('Cold Storage', 'Kho lạnh'),
       ('Normal Storage', 'Kho thường');

INSERT INTO Internal_user(user_name, password, full_name, email, phone, status, created_at, role_id)
VALUES ('admin01', '123456', 'System Admin', 'admin@mail.com', '0909000001', 'ACTIVE', NOW(), 1);

INSERT INTO Customer(user_name, password, full_name, email, phone, status, create_at)
VALUES ('cus01', '123456', 'Nguyen Van A', 'a@gmail.com', '0911000001', 'ACTIVE', NOW());

INSERT INTO Warehouse(name, address, description, status, warehouse_type_id)
VALUES ('Kho A', 'Ha Noi', 'Kho trung tâm', 'AVAILABLE', 1);

INSERT INTO Storage_unit(unit_code, status, area, price_per_unit, description, warehouse_id)
VALUES ('U-A01', 'AVAILABLE', 50.0, 2000000, 'Kho nhỏ', 1);

INSERT INTO Contract(start_date, end_date, status, customer_id, warehouse_id)
VALUES (NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 'ACTIVE', 1, 1);

INSERT INTO Payment(amount, payment_date, method, status, contract_id)
VALUES (12000000, NOW(), 'BANK_TRANSFER', 'PAID', 1);

INSERT INTO Invoice(issue_date, total_amount, payment_id)
VALUES (NOW(), 12000000, 1);
