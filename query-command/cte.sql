WITH short_e AS (
	SELECT e.EmployeeID, e.LastName, e.FirstName
	FROM [dbo].[Employees] e
)
SELECT * FROM short_e;

SELECT p.CategoryID, p.ProductName
FROM [dbo].[Products] p
WHERE p.CategoryID = (
	SELECT [CategoryID]
	FROM [dbo].[Products]
	WHERE ProductName = 'Chang'
);

SELECT p.ProductID, p.CategoryID, p.ProductName
FROM [dbo].[Products] p
INNER JOIN (
	SELECT pl.CategoryID
	FROM [dbo].[Products] pl
	WHERE pl.ProductName = 'Chang'
) AS [SubQuery]
ON p.CategoryID = SubQuery.CategoryID;


WITH ProductCategories AS (
	SELECT p.CategoryID
	FROM [dbo].[Products] p
	WHERE p.ProductName = 'Chang'
)
SELECT p1.CategoryID, p1.ProductName
FROM [dbo].[Products] p1
JOIN ProductCategories
ON p1.CategoryID = ProductCategories.CategoryID;


SELECT
	o.OrderID,
	o.OrderDate,
	o.Freight,
	(
		SELECT SUM(od.Quantity * od.UnitPrice)
		FROM [dbo].[Order Details] od
		WHERE od.OrderID = o.OrderID
	) AS TotalPrice,
	(
		SELECT SUM(od.Quantity * od.UnitPrice)
		FROM [dbo].[Order Details] od
		WHERE od.OrderID = o.OrderID
	) / o.Freight AS Ratio
FROM [dbo].[Orders] o;


-- CTE
WITH OrderTotals AS (
	SELECT od.OrderID, SUM(od.Quantity * od.UnitPrice) AS TotalPrice
	FROM [dbo].[Order Details] od
	GROUP BY od.OrderID
),
otx AS (
	SELECT od.OrderID, SUM(od.Quantity * od.UnitPrice) AS TotalPrice
	FROM [dbo].[Order Details] od
	GROUP BY od.OrderID
),
otx2 AS (
	SELECT od.OrderID, SUM(od.Quantity * od.UnitPrice) AS TotalPrice
	FROM [dbo].[Order Details] od
	GROUP BY od.OrderID
)
SELECT 
	o.OrderID, 
	o.OrderDate,
	o.Freight,
	ot.TotalPrice AS TotalPrice,
	ot.TotalPrice / o.Freight AS Ratio
FROM [dbo].[Orders] o
JOIN OrderTotals AS ot ON o.OrderID = ot.OrderID;

-->2005 SQL SERVER
-->5.7 MYSQL

-- Tinh tong doanh so ban hang cho tung san pham tu 2 bang Order Details va Product 
WITH Total AS (
	SELECT od.ProductID, SUM(od.Quantity * od.UnitPrice) AS TotalPrice
	FROM [dbo].[Order Details] od
	GROUP BY od.ProductID
)
SELECT 
	p.ProductID, 
	p.ProductName,
	t.TotalPrice
FROM [dbo].[Products] p
JOIN Total t
ON p.ProductID = t.ProductID; 


-- Tinh tong doanh so ban hang theo tung khach hang va sau do sx danh sach khach hang theo tong ds giam dan
WITH Total AS (
	SELECT o.[CustomerID], SUM(od.[UnitPrice] * od.[Quantity]) AS TotalPrice
	FROM [dbo].[Orders] o
	JOIN [dbo].[Order Details] od
	ON o.[OrderID] = od.[OrderID]
	GROUP BY o.[CustomerID]
)
SELECT
	c.CustomerID,
	c.ContactName,
	t.TotalPrice
FROM [dbo].[Customers] c
JOIN Total t
ON c.CustomerID = t.CustomerID
ORDER BY t.TotalPrice DESC;

-- Tinh tong doanh so ban hang theo nam tu bang Order va Order Details 
WITH Total AS (
	SELECT SUM(od.[UnitPrice] * od.[Quantity]) AS TotalPrice, YEAR(o.OrderDate) AS Years
	FROM [dbo].[Orders] o
	JOIN [dbo].[Order Details] od
	ON o.[OrderID] = od.[OrderID]
	GROUP BY YEAR(o.OrderDate)
)	
SELECT DISTINCT
	YEAR(o.OrderDate) AS Years,
	t.TotalPrice
FROM [dbo].[Orders] o
JOIN Total t
ON YEAR(o.OrderDate) = t.Years;