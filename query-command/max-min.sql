-- Tim ra gia thap nhat cua cac san pham trong bang san pham
SELECT MIN(p.UnitPrice) AS [MinPrice],
	   MAX(p.UnitPrice) AS [MaxPrice]
FROM Products AS p;

-- Lay ra ngay dat hang gan day nhat trong bang Orders
SELECT MAX(o.OrderDate) AS [LatelyOrderDate] FROM Orders AS o;

-- Lay ra ngay dat hang lau nhat trong bang Orders
SELECT MIN(o.OrderDate) AS [MinOrderDate] FROM Orders AS o;

-- Lay ra so luong hang ton kho lon nhat
SELECT 
	MAX(p.UnitsInStock) AS [MaxInStock]
FROM Products AS p;

-- Lay ra tuoi doi cua nhan vien lon nhat trong cong ty
SELECT MIN(E.BirthDate) AS [MaxBirthDate] FROM Employees as E;

-- Lay ra so luong lon nhat va nho nhat cua so luong hang trong Order Detail 

SELECT 
	MAX(o.Quantity) AS [MaxQuantity],
	MIN(o.Quantity) AS [MinQuantity]
FROM [Order Details] AS o;

-- Lay ra gia lon nhat va nho nhat cua gia san pham trong Order Detail 
SELECT 
	MAX(o.UnitPrice) AS [MaxUnitPrice],
	MIN(o.UnitPrice) AS [MinUnitPrice]
FROM [Order Details] AS o;