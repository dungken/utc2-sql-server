-- Tao bang moi voi cac san pham co gia > 50;
SELECT *
INTO HighValueProducts
FROM [dbo].[Products]
WHERE [UnitPrice] > 50;

-- Tao bang moi voi cac don hang duoc giao den USA
SELECT * 
INTO USAOrders
FROM [dbo].[Orders]
WHERE [ShipCountry] LIKE 'USA';

-- 
SELECT *
INTO CustomersInLondon
FROM [dbo].[Customers] 
WHERE [City] LIKE 'London';

-- 
SELECT o.ShipName, o.OrderDate, od.UnitPrice, od.Quantity
INTO HighValueOrdes
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Order Details] od
ON o.OrderID = od.OrderID
WHERE (od.Quantity * od.UnitPrice) > 1000;