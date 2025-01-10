
SELECT e.FirstName, c.ContactName
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Employees] e
ON o.EmployeeID = e.EmployeeID
INNER JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID

SELECT s.CompanyName, p.ProductName
FROM [dbo].[Products] p
LEFT JOIN [dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID;

SELECT c.ContactName, o.ShipName
FROM [dbo].[Orders] o
RIGHT JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID;

SELECT c.CategoryName, s.CompanyName
FROM [dbo].[Products] p
FULL JOIN [dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID
FULL JOIN [dbo].[Categories] c
ON p.CategoryID = c.CategoryID;

SELECT DISTINCT p.ProductName, s.CompanyName
FROM [dbo].[Order Details] od
INNER JOIN [dbo].[Products] p
ON od.ProductID = p.ProductID
INNER JOIN [dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID;

SELECT o.OrderID, c.ContactName, e.FirstName, e.LastName
FROM [dbo].[Orders] o
LEFT JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID
LEFT JOIN [dbo].[Employees] e
ON o.EmployeeID = e.EmployeeID;

SELECT o.OrderID, c.ContactName, e.FirstName, e.LastName
FROM [dbo].[Orders] o
RIGHT JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID
RIGHT JOIN [dbo].[Employees] e
ON o.EmployeeID = e.EmployeeID;


SELECT c.CategoryName, s.CompanyName
FROM [dbo].[Products] p
LEFT JOIN [dbo].[Categories] c
ON p.CategoryID = c.CategoryID
RIGHT JOIN [dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID;


SELECT c.CategoryName, s.CompanyName
FROM [dbo].[Products] p
FULL JOIN [dbo].[Categories] c
ON p.CategoryID = c.CategoryID
FULL JOIN [dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID;

SELECT DISTINCT c.ContactName, p.ProductName
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN [dbo].[Products] p
ON od.ProductID = p.ProductID
INNER JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID
ORDER BY p.ProductName;

SELECT e.FirstName, e.LastName, c.ContactName
FROM [dbo].[Orders] o
FULL JOIN [dbo].[Employees] e
ON o.EmployeeID = e.EmployeeID
FULL JOIN [dbo].[Customers] c
ON o.CustomerID = c.CustomerID;
