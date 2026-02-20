-- ==============================
-- DATABASE SETUP
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
    -- Cột mới thêm vào từ ảnh
    id_card VARCHAR(20),
    address VARCHAR(255),
    internal_user_code VARCHAR(20),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

-- Đã đổi lại thành Renter như yêu cầu
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

-- Cập nhật bảng Item theo ảnh (thêm renter_id, unit_id)
CREATE TABLE Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100),
    description TEXT,
    renter_id INT, -- Đổi lại thành renter_id
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id)
);

-- Bảng mới từ ảnh
CREATE TABLE storage_unit_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    item_id INT,
    unit_id INT,
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (unit_id) REFERENCES Storage_unit(unit_id)
);

-- ==============================
-- REQUEST & CONTRACT
-- ==============================
-- Rent_request chỉ lưu thông tin chung; start_date, end_date, area lưu ở rent_request_unit
CREATE TABLE Rent_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_date DATETIME,
    status INT,
    request_type VARCHAR(20),
    renter_id INT,
    warehouse_id INT,
    internal_user_id INT,
    processed_date DATETIME,
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (internal_user_id) REFERENCES Internal_user(internal_user_id)
);

-- Bảng mới từ ảnh
CREATE TABLE rent_request_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    item_id INT,
    request_id INT,
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (request_id) REFERENCES Rent_request(request_id)
);

-- Mỗi rent request có thể có nhiều unit: mỗi unit có ngày, diện tích, giá riêng
CREATE TABLE rent_request_unit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    area DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    rent_price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (request_id) REFERENCES Rent_request(request_id) ON DELETE CASCADE
);

CREATE TABLE Contract (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATETIME,
    end_date DATETIME,
    status INT,
    renter_id INT, -- Đổi lại thành renter_id
    warehouse_id INT,
    request_id INT, -- Cột mới thêm vào từ ảnh
    price DECIMAL(12,2),
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (request_id) REFERENCES Rent_request(request_id)
);

CREATE TABLE Contract_Storage_unit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT,
    unit_id INT,
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
    contract_id INT,
    FOREIGN KEY (renter_id) REFERENCES Renter(renter_id),
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
-- INSERT DATA
-- ==============================

INSERT INTO Role (role_name) VALUES
('Admin'),
('Manager'),
('Staff');

INSERT INTO Warehouse_Type (type_name, description) VALUES
('Cold Storage', 'Kho lạnh'),
('Normal Storage', 'Kho trong nhà'),
('High Security', 'Kho ngoài trời');

-- Thêm dữ liệu giả cho id_card, address, internal_user_code
INSERT INTO Internal_user
(user_name, password, full_name, email, phone, status, created_at, role_id, image, id_card, address, internal_user_code)
VALUES
('admin01', '123456', 'Nguyễn Thùy Linh', 'admin@mail.com', '0900000011', 1, NOW(), 1, 'default.jpg', '001001001002', 'Hà Nội', 'A12345'),
('manager01', '123456', 'Nguyễn Nhật Anh', 'manager@mail.com', '0900000022', 1, NOW(), 2, 'default.jpg', '001001002003', 'Vĩnh Phúc', 'M12345'),
('staff01', '123456', 'Lê Thanh Hùng', 'staff1@mail.com', '0900000033', 1, NOW(), 3, 'default.jpg', '001001003003', 'Bắc Ninh', 'S12356'),
('staff02', '123456', 'Nguyễn Thị Bừng', 'staff2@mail.com', '090000004', 1, NOW(), 3, 'default.jpg', '001001004002', 'Hải Phòng', 'S12345'),
('admin02', '123456', 'Nguyễn Văn Ân', 'admin7@mail.com', '0911010101', 1, NOW(), 1, 'default.jpg', '079101010101', 'Hà Nội', 'A48291'),
('admin03', '123456', 'Trần Thị Bích Ngọc', 'admin8@mail.com', '0922020202', 1, NOW(), 1, 'default.jpg', '079202020202', 'Hải Phòng', 'A73502'),

('manager02', '123456', 'Lê Hoàng Minh', 'manager7@mail.com', '0933030303', 1, NOW(), 2, 'default.jpg', '051303030303', 'Đà Nẵng', 'M19483'),
('manager03', '123456', 'Phạm Quang Huy', 'manager8@mail.com', '0944040404', 1, NOW(), 2, 'default.jpg', '051404040404', 'Cần Thơ', 'M56274'),

('staff03', '123456', 'Võ Thị Mai', 'staff21@mail.com', '0955050505', 1, NOW(), 3, 'default.jpg', '031505050505', 'TP Hồ Chí Minh', 'S90817'),
('staff04', '123456', 'Đặng Tuấn Kiệt', 'staff22@mail.com', '0966060606', 1, NOW(), 3, 'default.jpg', '031606060606', 'Bình Dương', 'S27465'),
('staff05', '123456', 'Bùi Gia Bảo', 'staff23@mail.com', '0977070707', 1, NOW(), 3, 'default.jpg', '084707070707', 'Hà Nội', 'S63920'),
('staff06', '123456', 'Đoàn Thu Trang', 'staff24@mail.com', '0988080808', 1, NOW(), 3, 'default.jpg', '084808080808', 'Hải Dương', 'S84571'),
('staff07', '123456', 'Hoàng Minh Đức', 'staff25@mail.com', '0909090909', 1, NOW(), 3, 'default.jpg', '038909090909', 'Nghệ An', 'S12654'),
('staff08', '123456', 'Nguyễn Thị Phương Anh', 'staff26@mail.com', '0912123434', 1, NOW(), 3, 'default.jpg', '038212343434', 'Huế', 'S39028'),
('staff09', '123456', 'Trần Đức Thắng', 'staff27@mail.com', '0923234545', 1, NOW(), 3, 'default.jpg', '060323454545', 'Quảng Ninh', 'S55739'),
('staff10', '123456', 'Lê Thị Kim Oanh', 'staff28@mail.com', '0934345656', 1, NOW(), 3, 'default.jpg', '060434565656', 'Vũng Tàu', 'S77410');


-- Insert vào Renter thay vì Customer
INSERT INTO Renter
(user_name, password, full_name, email, phone, status, created_at, image)
VALUES
('renter01', '123456', 'Nguyễn Văn Long', 'a@gmail.com', '091000001', 1, NOW(), 'default.jpg'),
('renter02', '123456', 'Đàm Phương Anh', 'b@gmail.com', '091000002', 1, NOW(), 'default.jpg'),
('renter03', '123456', 'Lê Văn Chính', 'c@gmail.com', '091000003', 1, NOW(), 'default.jpg'),
('renter04', '123456', 'Phạm Thị Ngọc', 'd@gmail.com', '091000004', 1, NOW(), 'default.jpg'),
('renter05', '123456', 'Hoàng Văn Sáng', 'e@gmail.com', '091000005', 1, NOW(), 'default.jpg'),
('renter06', '123456', 'Đỗ Thị Thùy', 'f@gmail.com', '091000006', 1, NOW(), 'default.jpg'),
('renter07', '123456', 'Bùi Văn Giang', 'g@gmail.com', '091000007', 0, NOW(), 'default.jpg'),
('renter08', '123456', 'Nguyễn Văn Hùng', 'h@gmail.com', '0910000008', 1, NOW(), 'default.jpg'),
('renter09', '123456', 'Trần Thị Mai', 'i@gmail.com', '0910000009', 1, NOW(), 'default.jpg'),
('renter10', '123456', 'Lê Văn Nam', 'j@gmail.com', '0910000010', 1, NOW(), 'default.jpg'),
('renter11', '123456', 'Phạm Thị Lan', 'k@gmail.com', '0910000011', 1, NOW(), 'default.jpg'),
('renter12', '123456', 'Hoàng Minh Tuấn', 'l@gmail.com', '0910000012', 1, NOW(), 'default.jpg'),
('renter13', '123456', 'Đỗ Thị Hạnh', 'm@gmail.com', '0910000013', 1, NOW(), 'default.jpg'),
('renter14', '123456', 'Bùi Gia Huy', 'n@gmail.com', '0910000014', 1, NOW(), 'default.jpg'),
('renter15', '123456', 'Võ Thị Ngọc', 'o@gmail.com', '0910000015', 1, NOW(), 'default.jpg'),
('renter16', '123456', 'Đặng Quốc Bảo', 'p@gmail.com', '0910000016', 1, NOW(), 'default.jpg'),
('renter17', '123456', 'Nguyễn Thị Thanh', 'q@gmail.com', '0910000017', 1, NOW(), 'default.jpg'),
('renter18', '123456', 'Trần Quốc Đạt', 'r@gmail.com', '0910000018', 1, NOW(), 'default.jpg'),
('renter19', '123456', 'Lý Thị Thu', 's@gmail.com', '0910000019', 1, NOW(), 'default.jpg'),
('renter20', '123456', 'Phan Minh Khoa', 't@gmail.com', '0910000020', 1, NOW(), 'default.jpg'),
('renter21', '123456', 'Huỳnh Gia Bảo', 'u@gmail.com', '0910000021', 1, NOW(), 'default.jpg'),
('renter22', '123456', 'Ngô Thị Ánh', 'v@gmail.com', '0910000022', 1, NOW(), 'default.jpg'),
('renter23', '123456', 'Mai Văn Trường', 'w@gmail.com', '0910000023', 1, NOW(), 'default.jpg'),
('renter24', '123456', 'Dương Thị Yến', 'x@gmail.com', '0910000024', 1, NOW(), 'default.jpg'),
('renter25', '123456', 'Tạ Minh Đức', 'y@gmail.com', '0910000025', 1, NOW(), 'default.jpg'),
('renter26', '123456', 'Cao Thị Hồng', 'z@gmail.com', '0910000026', 1, NOW(), 'default.jpg'),
('renter27', '123456', 'Vũ Anh Tuấn', 'aa@gmail.com', '0910000027', 0, NOW(), 'default.jpg');


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
('w1_ext.jpg','EXTERIOR',1,1,NOW(),1), ('w1_int.jpg','INTERIOR',0,1,NOW(),1),
('w2_ext.jpg','EXTERIOR',1,1,NOW(),2), ('w2_int.jpg','INTERIOR',0,1,NOW(),2),
('w3_ext.jpg','EXTERIOR',1,1,NOW(),3), ('w3_int.jpg','INTERIOR',0,1,NOW(),3),
('w4_ext.jpg','EXTERIOR',1,1,NOW(),4), ('w4_int.jpg','INTERIOR',0,1,NOW(),4),
('w5_ext.jpg','EXTERIOR',1,1,NOW(),5), ('w5_int.jpg','INTERIOR',0,1,NOW(),5),
('w6_ext.jpg','EXTERIOR',1,1,NOW(),6), ('w6_int.jpg','INTERIOR',0,1,NOW(),6),
('w7_ext.jpg','EXTERIOR',1,1,NOW(),7), ('w7_int.jpg','INTERIOR',0,1,NOW(),7),
('w8_ext.jpg','EXTERIOR',1,0,NOW(),8), ('w8_int.jpg','INTERIOR',0,0,NOW(),8),
('w9_ext.jpg','EXTERIOR',1,1,NOW(),9), ('w9_int.jpg','INTERIOR',0,1,NOW(),9),
('w10_ext.jpg','EXTERIOR',1,1,NOW(),10), ('w10_int.jpg','INTERIOR',0,1,NOW(),10),
('w11_ext.jpg','EXTERIOR',1,1,NOW(),11), ('w11_int.jpg','INTERIOR',0,1,NOW(),11),
('w12_ext.jpg','EXTERIOR',1,1,NOW(),12), ('w12_int.jpg','INTERIOR',0,1,NOW(),12),
('w13_ext.jpg','EXTERIOR',1,1,NOW(),13), ('w13_int.jpg','INTERIOR',0,1,NOW(),13),
('w14_ext.jpg','EXTERIOR',1,1,NOW(),14), ('w14_int.jpg','INTERIOR',0,1,NOW(),14),
('w15_ext.jpg','EXTERIOR',1,1,NOW(),15), ('w15_int.jpg','INTERIOR',0,1,NOW(),15),
('w16_ext.jpg','EXTERIOR',1,1,NOW(),16), ('w16_int.jpg','INTERIOR',0,1,NOW(),16),
('w17_ext.jpg','EXTERIOR',1,1,NOW(),17), ('w17_int.jpg','INTERIOR',0,1,NOW(),17),
('w18_ext.jpg','EXTERIOR',1,1,NOW(),18), ('w18_int.jpg','INTERIOR',0,1,NOW(),18),
('w19_ext.jpg','EXTERIOR',1,1,NOW(),19), ('w19_int.jpg','INTERIOR',0,1,NOW(),19),
('w20_ext.jpg','EXTERIOR',1,1,NOW(),20), ('w20_int.jpg','INTERIOR',0,1,NOW(),20),
('w21_ext.jpg','EXTERIOR',1,1,NOW(),21), ('w21_int.jpg','INTERIOR',0,1,NOW(),21),
('w22_ext.jpg','EXTERIOR',1,1,NOW(),22), ('w22_int.jpg','INTERIOR',0,1,NOW(),22),
('w23_ext.jpg','EXTERIOR',1,0,NOW(),23), ('w23_int.jpg','INTERIOR',0,0,NOW(),23),
('w24_ext.jpg','EXTERIOR',1,1,NOW(),24), ('w24_int.jpg','INTERIOR',0,1,NOW(),24),
('w25_ext.jpg','EXTERIOR',1,1,NOW(),25), ('w25_int.jpg','INTERIOR',0,1,NOW(),25),
('w26_ext.jpg','EXTERIOR',1,1,NOW(),26), ('w26_int.jpg','INTERIOR',0,1,NOW(),26);


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

-- Cập nhật Item inserts để bao gồm renter_id và unit_id

INSERT INTO Item (item_name, description, renter_id) VALUES
('Samsung TVs Batch 01', 'Lô tivi Samsung 55 inch', 1),      -- đã có contract
('Frozen Salmon 2025', 'Cá hồi đông lạnh nhập khẩu', 2),     -- đã có contract
('Office Chairs Set A', 'Ghế văn phòng cao cấp', 3),         -- đã có contract

('Textile Materials Lot 5', 'Nguyên liệu vải may mặc', 4),   -- chưa được duyệt
('Motorbike Spare Parts', 'Phụ tùng xe máy', 5),             -- đang chờ xử lý
('Imported Apples', 'Táo nhập khẩu Mỹ', 6),                  -- bị từ chối
('Wooden Tables Export', 'Bàn gỗ xuất khẩu', 7),             -- pending
('Rice Export Batch','Gạo xuất khẩu',12),
('Ceramic Tiles','Gạch men xây dựng',13),
('Frozen Shrimp Lot','Tôm đông lạnh',14),
('Sony TVs Batch 02', 'Lô tivi Sony 65 inch', 1),
('LG Refrigerators Lot', 'Tủ lạnh LG nhập khẩu', 1),
('Air Conditioner Units', 'Máy lạnh dân dụng', 1);

-- Dữ liệu mới cho storage_unit_item
INSERT INTO storage_unit_item (quantity, item_id, unit_id) VALUES
(100, 1, 1),
(50, 2, 2),
(20, 3, 3),
(500, 8, 22),  -- 500 bao gạo
(300, 9, 24),  -- 300 thùng gạch
(800, 10, 25),  -- 800 thùng tôm
(200, 11, 1),
(150, 12, 1),
(100, 13, 1);

-- Rent_request: chỉ request_date, status, request_type, renter_id, warehouse_id, internal_user_id, processed_date
INSERT INTO Rent_request (request_date, status, request_type, renter_id, warehouse_id, internal_user_id, processed_date) VALUES
('2025-01-05 09:15:00', 1, 'RENT', 1, 1, 2, '2025-01-06 10:30:00'),
('2025-02-01 14:00:00', 1, 'RENT', 2, 2, 3, '2025-02-02 08:45:00'),
('2025-03-12 11:20:00', 1, 'RENT', 3, 3, 4, '2025-03-13 09:10:00'),
('2025-04-01 10:00:00', 0, 'RENT', 4, 4, NULL, NULL),
('2025-04-05 16:30:00', 0, 'RENT', 7, 5, NULL, NULL),
('2025-05-01 09:00:00', 1, 'CHECK_IN', 1, 1, 2, '2025-05-01 10:00:00'),
('2025-03-01 08:00:00', 3, 'RENT', 6, 6, NULL, NULL),
('2025-06-01 08:00:00', 1, 'RENT', 12, 22, 2, '2025-06-02 09:00:00'),
('2025-06-05 09:30:00', 1, 'RENT', 13, 24, 1, '2025-06-06 10:00:00'),
('2025-06-10 10:00:00', 1, 'RENT', 14, 25, 2, '2025-06-11 11:00:00'),
(NOW(), 1, 'RENT', 1, 1, 2, NOW()),
(NOW(), 0, 'RENT', 1, 1, NULL, NULL),
(NOW(), 1, 'CHECK_IN', 1, 1, 3, NOW()),
(NOW(), 1, 'CHECK_IN', 1, 1, 3, NOW()),
(NOW(), 1, 'CHECK_OUT', 1, 1, 3, NOW());

-- rent_request_unit: mỗi request (RENT) có ít nhất 1 unit với area, start_date, end_date, rent_price
INSERT INTO rent_request_unit (request_id, area, start_date, end_date, rent_price) VALUES
(1, 50, '2025-01-10', '2025-07-10', 2000000),
(2, 70, '2025-02-05', '2025-08-05', 2500000),
(3, 100, '2025-03-20', '2026-03-20', 3500000),
(4, 80, '2025-04-10', '2025-10-10', 3000000),
(5, 120, '2025-04-20', '2025-12-20', 5000000),
(6, 50, '2025-05-01', '2025-11-01', 2000000),
(7, 90, '2025-03-10', '2025-09-10', 3200000),
(8, 130, '2025-06-10', '2025-12-10', 5000000),
(9, 100, '2025-06-15', '2026-06-15', 4000000),
(10, 120, '2025-06-20', '2026-06-20', 4800000),
(11, 70, '2025-07-01', '2026-01-01', 2200000),
(12, 30, '2025-08-01', '2026-02-01', 0),
(13, 50, '2025-07-01', '2026-01-01', 2000000),
(14, 50, '2025-07-05', '2026-01-01', 2000000),
(15, 50, '2025-08-01', '2026-01-01', 2000000);

-- Dữ liệu mới cho rent_request_item
INSERT INTO rent_request_item (quantity, item_id, request_id) VALUES
(0, 1, 1),
(0, 2, 2),
(0, 3, 3),
(0, 4, 4),
(0, 7, 5),
(0, 6, 6),
(100, 1, 7),
(200, 1, 11),
(150, 11, 12),

-- CHECK OUT
(50, 1, 13);

-- Cập nhật Contract để bao gồm renter_id và request_id
INSERT INTO Contract
(start_date, end_date, status, renter_id, warehouse_id, request_id, price)
VALUES
(NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1, 1, 1, 1, 5500000),
(NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1, 2, 2, 2, 3000000),
(NOW(), DATE_ADD(NOW(), INTERVAL 12 MONTH), 1, 3, 3, 3, 36000000),
('2025-06-10 00:00:00','2025-12-10 00:00:00',1,12,22,7, 5000000),
('2025-06-15 00:00:00','2026-06-15 00:00:00',1,13,24,8, 4000000),
('2025-06-20 00:00:00','2026-06-20 00:00:00',1,14,25,9, 4800000);

INSERT INTO Contract_Storage_unit
(contract_id, unit_id, start_date, end_date, status)
VALUES
(1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1),
(1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1),
(2, 3, NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1),
(4,22,'2025-06-10 00:00:00','2025-12-10 00:00:00',1),
(5,24,'2025-06-15 00:00:00','2026-06-15 00:00:00',1),
(6,25,'2025-06-20 00:00:00','2026-06-20 00:00:00',1);

INSERT INTO Payment
(amount, payment_date, method, status, contract_id)
VALUES
(12000000, NOW(), 'BANK', 1, 1),
(9000000, NOW(), 'CASH', 1, 2),
(36000000, NOW(), 'BANK', 1, 3);

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
(rating, comment, is_anonymous, feedback_date, renter_id, contract_id)
VALUES
(5, 'Dịch vụ rất tốt', 0, NOW(), 1, 1),
(5, 'Dịch vụ tốt', 0, NOW(), 6, 1),
(4, 'Kho ổn', 1, NOW(), 2, 2),
(3, 'Giá hơi cao', 0, NOW(), 3, 3);

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
(3, -5, NOW(), 3, 3, 4),
(1, 200, NOW(), 11, 1, 3),   -- check in
(1, 150, NOW(), 12, 1, 3),
(2, -50, NOW(), 1, 1, 3); 

INSERT INTO Incident_report
(type, description, report_date, status, warehouse_id, internal_user_id)
VALUES
('Fire Alarm', 'Báo cháy giả', NOW(), 1, 1, 3),
('Water Leak', 'Rò rỉ nước', NOW(), 2, 2, 4),
('Power Outage', 'Mất điện', NOW(), 3, 3, 2);


-- ==============================
-- INSERT BỔ SUNG STORAGE UNIT
-- ==============================

INSERT INTO Storage_unit (unit_code, status, area, price_per_unit, description, warehouse_id) VALUES
-- Bổ sung cho Northern Logistics Hub (Kho 1)
('HN-A2', 1, 60.00, 2200000, 'Ô trung bình - Tầng 1', 1),
('HN-A3', 1, 100.00, 4000000, 'Ô lớn - Gần cửa xuất', 1),

-- Bổ sung cho Vinh Phuc Distribution Center (Kho 2)
('VP-A2', 1, 45.00, 1800000, 'Ô nhỏ - Khu vực khô ráo', 2),
('VP-B1', 1, 120.00, 4500000, 'Khu vực kệ cao (Pallet racking)', 2),

-- Bổ sung cho Bac Ninh Smart Warehouse (Kho 3)
('BN-A2', 1, 150.00, 5000000, 'Ô tự động hóa hoàn toàn', 3),
('BN-B1', 1, 50.00, 2000000, 'Ô linh kiện điện tử', 3),

-- Bổ sung cho Hai Phong Port Warehouse (Kho 4)
('HP-A2', 1, 200.00, 7000000, 'Ô Container 20ft', 4),
('HP-B1', 1, 400.00, 13000000, 'Ô Container 40ft', 4),

-- Bổ sung cho Da Nang Logistics Hub (Kho 9)
('DN-A2', 1, 55.00, 2500000, 'Ô tiêu chuẩn', 9),
('DN-B1', 1, 90.00, 3500000, 'Ô hàng dễ vỡ', 9),

-- Bổ sung cho Ho Chi Minh Logistics Hub (Kho 19)
('HCM-A2', 1, 200.00, 8000000, 'Kho trung tâm - Diện tích lớn', 19),
('HCM-B1', 1, 40.00, 2000000, 'Ô nhỏ - Lưu trữ hồ sơ', 19),

-- Bổ sung cho Can Tho Logistics Hub (Kho 22)
('CT-A2', 1, 100.00, 4200000, 'Kho nông sản sạch', 22),
('CT-B1', 1, 150.00, 5500000, 'Kho máy móc nông nghiệp', 22);