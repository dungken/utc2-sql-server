-- Lay ra ten quoc gia khach nhau tu bang khach hang
SELECT DISTINCT Country FROM Customers;

-- Lay ra ma so buu dien khac nhau tu bang nha cung cap
SELECT DISTINCT PostalCode FROM Suppliers;

-- Lay ra du lieu khau nhau ve ho cua nhan vien va cach goi danh hieu 
-- lich su tu bang nhan vien
SELECT DISTINCT LastName, TitleOfCourtesy FROM Employees; 
SELECT DISTINCT TitleOfCourtesy FROM Employees;

-- Lay ra ma don vi van chuyen khac nhau tu bang don hang
SELECT DISTINCT ShipVia FROM Orders;

-- Lay ra ShipCity khac nhau tu bang don hang
SELECT DISTINCT ShipCity FROM Orders;

-- Lay ra ten san pham khac nhau tu bang san pham
SELECT DISTINCT ProductName FROM Products;

-- Lay ra tat ca cac Region khau nhau tu bang nhan vien
SELECT DISTINCT Region FROM Employees;
