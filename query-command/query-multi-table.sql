

SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
FROM [dbo].[Products] AS p, [dbo].[Categories] as c
WHERE c.CategoryID = p.CategoryID;


SELECT e.[EmployeeID], [LastName], [FirstName], COUNT([OrderID]) AS [TotalOrders]
FROM [dbo].[Employees] as e, [dbo].[Orders] as o
WHERE e.EmployeeID = o.EmployeeID
GROUP BY e.[EmployeeID], [LastName], [FirstName];

SELECT c.[CustomerID], c.[CompanyName], c.[ContactName], COUNT(o.OrderID) AS [TotalOrders]
FROM [dbo].[Customers] AS c, [dbo].[Orders] AS o
WHERE c.CustomerID = o.CustomerID AND c.Country = 'UK'
GROUP BY c.[CustomerID], c.[CompanyName], c.[ContactName];


SELECT s.ShipperID, s.CompanyName, SUM(o.Freight) AS [TotalFreight]
FROM [dbo].[Orders] AS o, [dbo].[Shippers] AS s
WHERE o.ShipVia = s.ShipperID
GROUP BY s.ShipperID, s.CompanyName
ORDER BY SUM(o.Freight) DESC;

SELECT TOP 1 s.SupplierID, s.CompanyName, COUNT(p.ProductID) AS [TotalProducts]
FROM [dbo].[Products] AS p, [dbo].[Suppliers] AS s
WHERE p.SupplierID = s.SupplierID
GROUP BY s.SupplierID, s.CompanyName
ORDER BY COUNT(p.ProductID) DESC;

SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice) AS [Total]
FROM [dbo].[Orders] AS o, [dbo].[Order Details] AS od
WHERE o.OrderID = od.OrderID
GROUP BY o.OrderID;

SELECT o.OrderID, e.LastName, e.FirstName, SUM(od.Quantity * od.UnitPrice) AS [Total]
FROM [dbo].[Orders] AS o, [dbo].[Order Details] AS od, [dbo].[Employees] AS e
WHERE e.EmployeeID = o.EmployeeID AND o.OrderID = od.OrderID
GROUP BY o.OrderID, e.LastName, e.FirstName;

SELECT o.OrderID, c.ContactTitle, s.CompanyName, c.Country, YEAR(o.ShippedDate)
FROM [dbo].[Orders] AS o, [dbo].[Customers] AS c, [dbo].[Shippers] AS s
WHERE o.CustomerID = c.CustomerID 
      AND o.ShipVia = s.ShipperID 
	  AND c.Country = 'UK'
	  AND YEAR(o.ShippedDate) = 1997;

SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
FROM [dbo].[Products] AS p, [dbo].[Categories] AS c
WHERE p.CategoryID = c.CategoryID
	  AND c.CategoryName = 'Seafood';

SELECT s.SupplierID, s.Country, p.ProductID, p.ProductName
FROM [dbo].[Products] AS p, [dbo].[Suppliers] AS s
WHERE s.SupplierID = p.SupplierID
	  AND s.Country = 'Germany';

SELECT o.OrderID, c.ContactName, s.CompanyName
FROM [dbo].[Customers] AS c, [dbo].[Orders] AS o, [dbo].[Shippers] AS s
WHERE c.CustomerID = o.CustomerID 
	  AND o.ShipVia = s.ShipperID
	  AND o.ShipCity = 'London';

SELECT o.OrderID, c.ContactName, s.CompanyName, o.RequiredDate, o.ShippedDate
FROM [dbo].[Customers] AS c, [dbo].[Orders] AS o, [dbo].[Shippers] AS s
WHERE c.CustomerID = o.CustomerID 
	  AND o.ShipVia = s.ShipperID
	  AND o.RequiredDate < o.ShippedDate;

SELECT o.ShipCountry, COUNT(o.OrderID) AS [NumberOfOrders]
FROM [dbo].[Customers] AS c, [dbo].[Orders] AS o, [dbo].[Shippers] AS s
WHERE c.CustomerID = o.CustomerID 
	  AND o.ShipVia = s.ShipperID
	  AND c.Country <> 'USA'
GROUP BY o.ShipCountry
HAVING COUNT(o.OrderID) > 100;