-- Hay cho biet moi khach hang da dat bao nhieu don hang
SELECT [CustomerID], COUNT([OrderID]) AS [TotalOrders]
FROM Orders
GROUP BY [CustomerID];

-- Hay tinh gia tri don gia trung binh theo moi nha cung cap san pham
SELECT [SupplierID], AVG([UnitPrice]) AS [AvgUnitPrice]
FROM Products
GROUP BY [SupplierID];

-- Hay cho biet moi the loai co tong so bao nhieu san pham trong kho
SELECT [CategoryID], SUM([UnitsOnOrder]) AS [SumUnitsOnOrder]
FROM Products
GROUP BY [CategoryID];

-- Hay cho biet gia van chuyen thap nhat va cao nhat cua cac don hang 
-- theo tung thanh pho va quoc gia khac nhau
SELECT [ShipCity], [ShipCountry], 
	   MIN([Freight]) AS [MinFreight], 
	   MAX([Freight]) AS [MaxFreight]
FROM Orders
GROUP BY [ShipCity], [ShipCountry];

-- Hay thong ke so luong nhan vien theo tung quoc gia khac nhau
SELECT [Country], COUNT([EmployeeID]) AS [NumbersOfEmployee]
FROM Employees
GROUP BY [Country];

SELECT * FROM Employees;