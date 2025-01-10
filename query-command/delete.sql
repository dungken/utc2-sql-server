-- 

SELECT *
INTO Customers_1
FROM [dbo].[Customers];

-- Xoa di khach hang co CustomerID la ALFKI
DELETE FROM [dbo].[Customers_1]
WHERE [CustomerID] LIKE 'ALFKI';

SELECT * FROM [dbo].[Customers_1];

-- Xoa di toan bo khach hang co quoc gia bat dau la 'U'
DELETE FROM [dbo].[Customers_1]
WHERE [Country] LIKE 'U%';

-- Xoa sach 1 bang
DELETE FROM [dbo].[Customers_1];

-- Phan biet su khac nhau giua DELETE FROM va TRUNCATE

SELECT *
INTO Orders_1
FROM [dbo].[Orders];

SELECT *
INTO Products_1
FROM [dbo].[Products];

SELECT *
INTO OrderDetails_1
FROM [dbo].[Order Details];


SELECT * FROM [dbo].[Orders_1];

DELETE FROM [dbo].[Orders_1] 
WHERE [OrderID] = 10248;

SELECT * FROM [dbo].[Products_1];

DELETE FROM [dbo].[Products_1]
WHERE [UnitsInStock] = 0;


SELECT * FROM [dbo].[Orders_1];
SELECT * FROM [dbo].[OrderDetails_1];

DELETE 
FROM [dbo].[Orders_1]
WHERE [CustomerID] LIKE 'HANAR';