SELECT o.*, (
	SELECT SUM(od.Quantity * od.UnitPrice)
	FROM [dbo].[Order Details] od
	WHERE o.OrderID = od.OrderID
) AS [TotalPrice]
FROM [dbo].[Orders] o

-- Loc ra ten san pham va tong so don hang cua san pham
SELECT p.ProductName, (
	SELECT COUNT(od.OrderID)
	FROM [dbo].[Order Details] od
	WHERE p.ProductID = od.ProductID
) AS [TotalOrders]
FROM [dbo].[Products] p

SELECT ProductName, TotalOrders
FROM (
		SELECT p.ProductName, (
		SELECT COUNT(od.OrderID)
		FROM [dbo].[Order Details] od
		WHERE p.ProductID = od.ProductID
		) AS [TotalOrders]
FROM [dbo].[Products] p
) AS TEMP;


-- Ban hay in ra ma don hang va so luong gia tri cua don hang do

SELECT o.OrderID, (
	SELECT COUNT(od.OrderID)
	FROM [dbo].[Order Details] od
	WHERE o.OrderID = od.OrderID
) AS [NumberOfOrders]
FROM [dbo].[Orders] o

-- Liet ke cac don hang co ngay dat hang gan nhat
SELECT o.*
FROM [dbo].[Orders] o
WHERE o.OrderDate = (
	SELECT MAX(o.OrderDate)
	FROM [dbo].[Orders] o
);

-- Liet ke tat ca cac san pham (ProductName) ma khong co don dat
-- hang nao dat mua chung

SELECT p.ProductName
FROM [dbo].[Products] p
WHERE p.ProductID NOT IN (
	SELECT DISTINCT od.ProductID
	FROM [dbo].[Order Details] od
);


-- Lay thong tin ve cac don hang, va ten cac san pham thuoc 
-- cac don hang chua duoc giao cho khach

SELECT o.OrderID, od.ProductID, p.ProductName
FROM [dbo].[Products] p
INNER JOIN [dbo].[Order Details] od
ON p.ProductID = od.ProductID
INNER JOIN [dbo].[Orders] o
ON o.OrderID = od.OrderID
WHERE o.OrderID IN (
	SELECT o.OrderID
	FROM [dbo].[Orders] o
	WHERE o.ShippedDate IS NULL
);

-- Lay thong tin ve cac san pham co so luong ton kho
-- it hon so luong ton kho trung binh cua tat ca cac sp

SELECT *
FROM [dbo].[Products] p
WHERE p.UnitsInStock < (
	SELECT AVG(p.UnitsInStock) 
	FROM [dbo].[Products] p
);

-- Lay thong tin ve cac khach hang co tong gia tri don hang lon
-- nhat

SELECT *
FROM [dbo].[Customers] c
WHERE c.CustomerID = (
	SELECT TOP 1 c.CustomerID
	FROM [dbo].[Customers] c, [dbo].[Order Details] od, [dbo].[Orders] o
	WHERE o.CustomerID = c.CustomerID
	GROUP BY c.CustomerID, od.Quantity, od.UnitPrice
	ORDER BY (od.Quantity * od.UnitPrice) DESC
);

