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
    image VARCHAR(255),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Renter (
    renter_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    password VARCHAR(255),
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    status INT,
    created_at DATETIME,
    image VARCHAR(255)
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
    created_at DATETIME,
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
    renter_id INT,
    warehouse_id INT,
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
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
-- RENT REQUEST
-- ==============================
CREATE TABLE Rent_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_date DATETIME,
    status INT,
    renter_id INT,
    warehouse_id INT,
    internal_user_id INT,
    processed_date DATETIME,
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

-- ==============================
-- STAFF ASSIGNMENT
-- ==============================
CREATE TABLE Staff_assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    assigned_date DATE,
    assigned_to INT,
    warehouse_id INT,
    assigned_by INT,
    assignment_type INT,
    description TEXT,
    assigned_at DATETIME,
    due_date DATETIME,
    started_at DATETIME,
    completed_at DATETIME,
    status INT,
    is_overdue INT,
    FOREIGN KEY (assigned_to) REFERENCES Internal_user(internal_user_id),
    FOREIGN KEY (assigned_by) REFERENCES Internal_user(internal_user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Staff_assignment_item (
    assignment_item_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    item_id INT,
    item_name VARCHAR(255),
    quantity INT,
    note VARCHAR(255),
    FOREIGN KEY (assignment_id) REFERENCES Staff_assignment(assignment_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
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
    renter_id INT,
    warehouse_id INT,
    contract_id INT,
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
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
    action INT,
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
-- INSERT ROLE (3 ROLE)
-- ==============================
INSERT INTO Role (role_name) VALUES
('Admin'),
('Manager'),
('Staff');

INSERT INTO Warehouse_Type (type_name, description) VALUES
('Cold Storage', 'Kho lạnh'),
('Normal Storage', 'Kho trong nhà'),
('High Security', 'Kho ngoài trời');

INSERT INTO Internal_user
(user_name, password, full_name, email, phone, status, created_at, role_id, image)
VALUES
('admin01', '123456', 'Admin System', 'admin@mail.com', '090000001', 1, NOW(), 1, 'admin.png'),
('manager01', '123456', 'Manager A', 'manager@mail.com', '090000002', 1, NOW(), 2, 'manager.png'),
('staff01', '123456', 'Staff A', 'staff1@mail.com', '090000003', 1, NOW(), 3, 'staff1.png'),
('staff02', '123456', 'Staff B', 'staff2@mail.com', '090000004', 1, NOW(), 3, 'staff2.png');

INSERT INTO Renter
(user_name, password, full_name, email, phone, status, created_at, image)
VALUES
('renter01', '123456', 'Nguyen Van A', 'a@gmail.com', '091000001', 1, NOW(), 'a.png'),
('renter02', '123456', 'Tran Thi B', 'b@gmail.com', '091000002', 1, NOW(), 'b.png'),
('renter03', '123456', 'Le Van C', 'c@gmail.com', '091000003', 1, NOW(), 'c.png');

INSERT INTO Warehouse (name, address, description, status, warehouse_type_id) VALUES
('Northern Logistics Hub', 'Hà Nội', 'Kho trung tâm miền Bắc', 1, 1),
('Vinh Phuc Distribution Center', 'Vĩnh Phúc', 'Kho vệ tinh khu công nghiệp', 1, 2),
('Bac Ninh Smart Warehouse', 'Bắc Ninh', 'Kho công nghệ cao', 1, 2),
('Hai Phong Port Warehouse', 'Hải Phòng', 'Kho gần cảng biển', 1, 3),
('Quang Ninh Security Depot', 'Quảng Ninh', 'Kho an ninh cao', 2, 3),
('Thanh Hoa Storage Complex', 'Thanh Hóa', 'Kho tổng hợp', 1, 2),
('Nghe An Logistics Center', 'Nghệ An', 'Kho trung chuyển', 1, 2),
('Ha Tinh Supply Warehouse', 'Hà Tĩnh', 'Kho cung ứng', 0, 1),
('Da Nang Logistics Hub', 'Đà Nẵng', 'Kho miền Trung', 1, 1),
('Quang Nam Storage', 'Quảng Nam', 'Kho lưu trữ hàng tổng hợp', 1, 2),
('Quang Ngai Industrial Warehouse', 'Quảng Ngãi', 'Kho khu công nghiệp', 1, 2),
('Binh Dinh Port Depot', 'Bình Định', 'Kho cảng biển', 1, 3),
('Khanh Hoa Cold Storage', 'Khánh Hòa', 'Kho lạnh thủy sản', 1, 1),
('Dak Lak Agricultural Warehouse', 'Đắk Lắk', 'Kho nông sản', 2, 2),
('Gia Lai Logistics Base', 'Gia Lai', 'Kho trung chuyển Tây Nguyên', 1, 2),
('Lam Dong Cold Chain Center', 'Lâm Đồng', 'Kho lạnh rau củ', 1, 1),
('Binh Duong Smart Warehouse', 'Bình Dương', 'Kho tự động hóa', 1, 2),
('Dong Nai Industrial Storage', 'Đồng Nai', 'Kho công nghiệp', 1, 2),
('Ho Chi Minh Logistics Hub', 'TP Hồ Chí Minh', 'Kho trung tâm miền Nam', 1, 1),
('Long An Distribution Center', 'Long An', 'Kho phân phối', 1, 2),
('Tien Giang Storage', 'Tiền Giang', 'Kho khu vực ĐBSCL', 1, 2),
('Can Tho Logistics Hub', 'Cần Thơ', 'Kho trung tâm miền Tây', 1, 1),
('Vinh Long Warehouse', 'Vĩnh Long', 'Kho tổng hợp', 0, 2),
('An Giang Border Depot', 'An Giang', 'Kho khu vực biên giới', 1, 3),
('Kien Giang Marine Warehouse', 'Kiên Giang', 'Kho hàng hải sản', 1, 1),
('Ca Mau Cold Storage', 'Cà Mau', 'Kho lạnh thủy sản', 2, 1);


INSERT INTO Warehouse_image (image_url, image_type, is_primary, status, created_at, warehouse_id) VALUES
-- Warehouse 1
('w1_ext.jpg','EXTERIOR',1,1,NOW(),1),
('w1_int.jpg','INTERIOR',0,1,NOW(),1),

-- Warehouse 2
('w2_ext.jpg','EXTERIOR',1,1,NOW(),2),
('w2_int.jpg','INTERIOR',0,1,NOW(),2),

-- Warehouse 3
('w3_ext.jpg','EXTERIOR',1,1,NOW(),3),
('w3_int.jpg','INTERIOR',0,1,NOW(),3),

-- Warehouse 4
('w4_ext.jpg','EXTERIOR',1,1,NOW(),4),
('w4_int.jpg','INTERIOR',0,1,NOW(),4),

-- Warehouse 5
('w5_ext.jpg','EXTERIOR',1,1,NOW(),5),
('w5_int.jpg','INTERIOR',0,1,NOW(),5),

-- Warehouse 6
('w6_ext.jpg','EXTERIOR',1,1,NOW(),6),
('w6_int.jpg','INTERIOR',0,1,NOW(),6),

-- Warehouse 7
('w7_ext.jpg','EXTERIOR',1,1,NOW(),7),
('w7_int.jpg','INTERIOR',0,1,NOW(),7),

-- Warehouse 8
('w8_ext.jpg','EXTERIOR',1,0,NOW(),8),
('w8_int.jpg','INTERIOR',0,0,NOW(),8),

-- Warehouse 9
('w9_ext.jpg','EXTERIOR',1,1,NOW(),9),
('w9_int.jpg','INTERIOR',0,1,NOW(),9),

-- Warehouse 10
('w10_ext.jpg','EXTERIOR',1,1,NOW(),10),
('w10_int.jpg','INTERIOR',0,1,NOW(),10),

-- Warehouse 11
('w11_ext.jpg','EXTERIOR',1,1,NOW(),11),
('w11_int.jpg','INTERIOR',0,1,NOW(),11),

-- Warehouse 12
('w12_ext.jpg','EXTERIOR',1,1,NOW(),12),
('w12_int.jpg','INTERIOR',0,1,NOW(),12),

-- Warehouse 13
('w13_ext.jpg','EXTERIOR',1,1,NOW(),13),
('w13_int.jpg','INTERIOR',0,1,NOW(),13),

-- Warehouse 14
('w14_ext.jpg','EXTERIOR',1,1,NOW(),14),
('w14_int.jpg','INTERIOR',0,1,NOW(),14),

-- Warehouse 15
('w15_ext.jpg','EXTERIOR',1,1,NOW(),15),
('w15_int.jpg','INTERIOR',0,1,NOW(),15),

-- Warehouse 16
('w16_ext.jpg','EXTERIOR',1,1,NOW(),16),
('w16_int.jpg','INTERIOR',0,1,NOW(),16),

-- Warehouse 17
('w17_ext.jpg','EXTERIOR',1,1,NOW(),17),
('w17_int.jpg','INTERIOR',0,1,NOW(),17),

-- Warehouse 18
('w18_ext.jpg','EXTERIOR',1,1,NOW(),18),
('w18_int.jpg','INTERIOR',0,1,NOW(),18),

-- Warehouse 19
('w19_ext.jpg','EXTERIOR',1,1,NOW(),19),
('w19_int.jpg','INTERIOR',0,1,NOW(),19),

-- Warehouse 20
('w20_ext.jpg','EXTERIOR',1,1,NOW(),20),
('w20_int.jpg','INTERIOR',0,1,NOW(),20),

-- Warehouse 21
('w21_ext.jpg','EXTERIOR',1,1,NOW(),21),
('w21_int.jpg','INTERIOR',0,1,NOW(),21),

-- Warehouse 22
('w22_ext.jpg','EXTERIOR',1,1,NOW(),22),
('w22_int.jpg','INTERIOR',0,1,NOW(),22),

-- Warehouse 23
('w23_ext.jpg','EXTERIOR',1,0,NOW(),23),
('w23_int.jpg','INTERIOR',0,0,NOW(),23),

-- Warehouse 24
('w24_ext.jpg','EXTERIOR',1,1,NOW(),24),
('w24_int.jpg','INTERIOR',0,1,NOW(),24),

-- Warehouse 25
('w25_ext.jpg','EXTERIOR',1,1,NOW(),25),
('w25_int.jpg','INTERIOR',0,1,NOW(),25),

-- Warehouse 26
('w26_ext.jpg','EXTERIOR',1,1,NOW(),26),
('w26_int.jpg','INTERIOR',0,1,NOW(),26);


INSERT INTO Storage_unit (unit_code, status, area, price_per_unit, description, warehouse_id) VALUES
('HN-A1',1,50,2000000,'Ô nhỏ',1),
('VP-A1',1,70,2500000,'Ô tiêu chuẩn',2),
('BN-A1',1,100,3500000,'Ô lớn',3),
('HP-A1',1,80,3000000,'Ô tiêu chuẩn',4),
('QN-A1',1,120,5000000,'Ô an ninh cao',5),
('TH-A1',1,90,3200000,'Ô trung bình',6),
('NA-A1',1,60,2200000,'Ô nhỏ',7),
('HT-A1',1,70,2400000,'Ô tiêu chuẩn',8),
('DN-A1',1,110,3800000,'Ô lớn',9),
('QM-A1',1,85,2900000,'Ô tiêu chuẩn',10),
('QG-A1',1,75,2700000,'Ô trung bình',11),
('BD-A1',1,95,3400000,'Ô cảng',12),
('KH-A1',1,130,5200000,'Kho lạnh',13),
('DL-A1',1,90,3100000,'Kho nông sản',14),
('GL-A1',1,85,3000000,'Kho trung chuyển',15),
('LD-A1',1,140,5500000,'Kho lạnh cao cấp',16),
('BDU-A1',1,100,3600000,'Kho thông minh',17),
('DNA-A1',1,110,3900000,'Kho công nghiệp',18),
('HCM-A1',1,150,6000000,'Kho trung tâm',19),
('LA-A1',1,80,2800000,'Kho phân phối',20),
('TG-A1',1,70,2600000,'Kho miền Tây',21),
('CT-A1',1,130,5000000,'Kho trung tâm',22),
('VL-A1',1,60,2300000,'Kho tổng hợp',23),
('AG-A1',1,100,4000000,'Kho an ninh',24),
('KG-A1',1,120,4800000,'Kho hải sản',25),
('CM-A1',1,140,5500000,'Kho lạnh thủy sản',26);

INSERT INTO Item (item_name, description) VALUES
('Electronics', 'Thiết bị điện tử'),
('Frozen Food', 'Thực phẩm đông lạnh'),
('Furniture', 'Nội thất');

INSERT INTO Contract
(start_date, end_date, status, renter_id, warehouse_id)
VALUES
(NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1, 1, 1),
(NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1, 2, 2),
(NOW(), DATE_ADD(NOW(), INTERVAL 12 MONTH), 1, 3, 3);

INSERT INTO Contract_Storage_unit
(contract_id, unit_id, rent_price, start_date, end_date, status)
VALUES
(1, 1, 2000000, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1),
(1, 2, 3500000, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1),
(2, 3, 3000000, NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1);

INSERT INTO Payment
(amount, payment_date, method, status, contract_id)
VALUES
(12000000, NOW(), 'BANK', 1, 1),
(9000000, NOW(), 'CASH', 1, 2),
(36000000, NOW(), 'BANK', 1, 3);

INSERT INTO Invoice (issue_date, total_amount, payment_id) VALUES
(NOW(), 12000000, 1),
(NOW(), 9000000, 2),
(NOW(), 36000000, 3);

INSERT INTO Rent_request
(request_date, status, renter_id, warehouse_id, internal_user_id, processed_date)
VALUES
(NOW(), 1, 1, 1, 2, NOW()),
(NOW(), 0, 2, 2, NULL, NULL),
(NOW(), 1, 3, 3, 1, NOW());

INSERT INTO Staff_assignment
(assigned_date, assigned_to, warehouse_id, assigned_by, assignment_type,
 description, assigned_at, due_date, started_at, completed_at, status, is_overdue)
VALUES
(CURDATE(), 3, 1, 2, 1, 'Kiểm kê kho A', NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), NOW(), NULL, 1, 0),
(CURDATE(), 4, 2, 2, 2, 'Dọn kho B', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY), NOW(), NOW(), 2, 0),
(CURDATE(), 3, 3, 1, 1, 'Kiểm tra an ninh', NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), NULL, NULL, 1, 0);

INSERT INTO Staff_assignment_item
(assignment_id, item_id, item_name, quantity, note)
VALUES
(1, 1, 'Electronics', 10, 'Kiểm kê'),
(1, 2, 'Frozen Food', 20, 'Giữ nhiệt độ'),
(2, 3, 'Furniture', 5, 'Dọn dẹp');

INSERT INTO Feedback
(rating, comment, is_anonymous, feedback_date, renter_id, warehouse_id, contract_id)
VALUES
(5, 'Dịch vụ rất tốt', 0, NOW(), 1, 1, 1),
(4, 'Kho ổn', 1, NOW(), 2, 2, 2),
(3, 'Giá hơi cao', 0, NOW(), 3, 3, 3);

INSERT INTO Feedback_response
(response_text, response_date, feedback_id, internal_user_id)
VALUES
('Cảm ơn phản hồi', NOW(), 1, 2),
('Chúng tôi ghi nhận', NOW(), 2, 1),
('Sẽ cải thiện', NOW(), 3, 2);

INSERT INTO Inventory_log
(action, quantity, action_date, item_id, unit_id, internal_user_id)
VALUES
(1, 100, NOW(), 1, 1, 3),
(2, 20, NOW(), 2, 2, 3),
(3, -5, NOW(), 3, 3, 4);

INSERT INTO Incident_report
(type, description, report_date, status, warehouse_id, internal_user_id)
VALUES
('Fire Alarm', 'Báo cháy giả', NOW(), 1, 1, 3),
('Water Leak', 'Rò rỉ nước', NOW(), 2, 2, 4),
('Power Outage', 'Mất điện', NOW(), 3, 3, 2);