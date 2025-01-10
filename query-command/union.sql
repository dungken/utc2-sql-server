
SELECT DISTINCT s.Country
FROM [dbo].[Suppliers] s
UNION
SELECT DISTINCT c.Country
FROM [dbo].[Customers] c;

SELECT DISTINCT s.Country
FROM [dbo].[Suppliers] s
UNION ALL
SELECT DISTINCT c.Country
FROM [dbo].[Customers] c;

SELECT [City], [Country]
FROM [dbo].[Customers]
WHERE [Country] LIKE 'U%'
UNION
SELECT [City], [Country]
FROM [dbo].[Suppliers]
WHERE [City] LIKE 'London'
UNION 
SELECT [ShipCity], [ShipCountry]
FROM [dbo].[Orders]
WHERE [ShipCountry] LIKE 'USA';