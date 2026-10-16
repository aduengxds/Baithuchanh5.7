
-- BAI THUC HANH 5.7: VIEW, INDEX, STORED PROCEDURE

-- BUOC 1: Tao co so du lieu
CREATE DATABASE IF NOT EXISTS demo_products;
USE demo_products;

-- BUOC 2: Tao bang Products
CREATE TABLE IF NOT EXISTS Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12,2) NOT NULL,
    productAmount INT NOT NULL DEFAULT 0,
    productDescription TEXT,
    productStatus VARCHAR(30) DEFAULT 'Available'
);

-- Them du lieu mau
INSERT INTO Products
(productCode, productName, productPrice, productAmount,
 productDescription, productStatus)
VALUES
('P001', 'Laptop Dell', 15000000, 10, 'Laptop Dell van phong', 'Available'),
('P002', 'Laptop HP', 14000000, 8, 'Laptop HP hoc tap', 'Available'),
('P003', 'Mouse Logitech', 350000, 30, 'Chuot khong day', 'Available'),
('P004', 'Keyboard Corsair', 1200000, 15, 'Ban phim co', 'Available'),
('P005', 'Monitor Samsung', 4500000, 12, 'Man hinh 24 inch', 'Available'),
('P006', 'Laptop Asus', 18000000, 5, 'Laptop Asus gaming', 'Available'),
('P007', 'Headphone Sony', 2100000, 20, 'Tai nghe Sony', 'Available'),
('P008', 'USB Kingston', 200000, 50, 'USB 64GB', 'Available'),
('P009', 'Webcam Logitech', 900000, 18, 'Webcam Full HD', 'Available'),
('P010', 'Monitor LG', 5200000, 7, 'Man hinh LG', 'Out of stock');

-- Kiem tra du lieu
SELECT * FROM Products;


-- BUOC 3: EXPLAIN TRUOC KHI TAO INDEX

-- Truy van theo productCode
EXPLAIN
SELECT * FROM Products
WHERE productCode = 'P001';

-- Truy van theo productName va productPrice
EXPLAIN
SELECT * FROM Products
WHERE productName = 'Laptop Dell'
  AND productPrice = 15000000;


-- Tao Unique Index tren productCode
CREATE UNIQUE INDEX idx_productCode
ON Products(productCode);

-- Tao Composite Index tren productName va productPrice
CREATE INDEX idx_productName_productPrice
ON Products(productName, productPrice);


-- EXPLAIN SAU KHI TAO INDEX

-- Kiem tra Unique Index
EXPLAIN
SELECT * FROM Products
WHERE productCode = 'P001';

-- Kiem tra Composite Index
EXPLAIN
SELECT * FROM Products
WHERE productName = 'Laptop Dell'
  AND productPrice = 15000000;

-- Ep su dung Composite Index de quan sat
EXPLAIN
SELECT * FROM Products
FORCE INDEX (idx_productName_productPrice)
WHERE productName = 'Laptop Dell'
  AND productPrice = 15000000;

-- Xem cac index cua bang
SHOW INDEX FROM Products;


-- BUOC 4: VIEW

-- Tao view
CREATE OR REPLACE VIEW vw_ProductInfo AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy van view
SELECT * FROM vw_ProductInfo;

-- Sua view: bo sung dieu kien chi lay san pham dang Available
CREATE OR REPLACE VIEW vw_ProductInfo AS
SELECT productCode, productName, productPrice, productStatus
FROM Products
WHERE productStatus = 'Available';

-- Kiem tra view sau khi sua
SELECT * FROM vw_ProductInfo;

-- Xoa view
DROP VIEW IF EXISTS vw_ProductInfo;


-- BUOC 5: STORED PROCEDURE

DELIMITER //

-- 1. Lay tat ca san pham
CREATE PROCEDURE sp_GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //


-- 2. Them san pham moi
CREATE PROCEDURE sp_AddProduct(
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(12,2),
    IN p_productAmount INT,
    IN p_productDescription TEXT,
    IN p_productStatus VARCHAR(30)
)
BEGIN
    INSERT INTO Products (
        productCode, productName, productPrice,
        productAmount, productDescription, productStatus
    )
    VALUES (
        p_productCode, p_productName, p_productPrice,
        p_productAmount, p_productDescription, p_productStatus
    );
END //


-- 3. Sua san pham theo Id
CREATE PROCEDURE sp_UpdateProduct(
    IN p_Id INT,
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(12,2),
    IN p_productAmount INT,
    IN p_productDescription TEXT,
    IN p_productStatus VARCHAR(30)
)
BEGIN
    UPDATE Products
    SET productCode = p_productCode,
        productName = p_productName,
        productPrice = p_productPrice,
        productAmount = p_productAmount,
        productDescription = p_productDescription,
        productStatus = p_productStatus
    WHERE Id = p_Id;
END //


-- 4. Xoa san pham theo Id
CREATE PROCEDURE sp_DeleteProduct(IN p_Id INT)
BEGIN
    DELETE FROM Products
    WHERE Id = p_Id;
END //

DELIMITER ;


-- KIEM TRA CAC STORED PROCEDURE

-- Lay danh sach san pham
CALL sp_GetAllProducts();

-- Them san pham mau de kiem tra
CALL sp_AddProduct(
    'P011',
    'Tablet Samsung',
    7500000,
    6,
    'May tinh bang Samsung',
    'Available'
);

-- Kiem tra sau khi them
SELECT * FROM Products WHERE productCode = 'P011';

-- Sua san pham co Id = 11
CALL sp_UpdateProduct(
    11,
    'P011',
    'Tablet Samsung Updated',
    7900000,
    9,
    'May tinh bang Samsung da cap nhat',
    'Available'
);

-- Kiem tra sau khi sua
SELECT * FROM Products WHERE Id = 11;

-- Xoa san pham co Id = 11
CALL sp_DeleteProduct(11);

-- Kiem tra sau khi xoa
SELECT * FROM Products WHERE Id = 11;

-- Danh sach stored procedure
SHOW PROCEDURE STATUS
WHERE Db = 'demo_products';
