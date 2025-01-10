-- Lay ra 5 dong du lieu dau tien trong bang khach hang.
SELECT TOP 5 * FROM Customers;

-- Lay ra 30% nhan vien cong ty hien tai
SELECT TOP 30 PERCENT * FROM Employees;

-- Lay ra cac don hang voi quy dinh la ten khach hang khong trung lap
-- va chi lay ra 5 du lieu dau tien
SELECT DISTINCT TOP 5 ContactName FROM Customers;

-- Lay ra cac san pham co ma the loai khong duoc trung lap va chi lay 
-- ra 3 dong dau tien
SELECT DISTINCT TOP 3 CategoryID FROM Products;

-- Lay ra 10 khach hang dau tien trong bang khach hang
SELECT TOP 10 * FROM Customers;

-- Lay ra 10% don hang trong bang don hang
SELECT TOP 10 PERCENT * FROM Orders;

-- Lay ra 10 CustomerID khau nhau trong bang don hang
SELECT DISTINCT TOP 10 CustomerID FROM Orders;