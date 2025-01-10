SELECT * 
INTO Customer_1
FROM [dbo].[Customers];

SELECT * FROM [dbo].[Customer_1];


UPDATE [dbo].[Customer_1]
SET [Country] = 'Phap';

SELECT * FROM [dbo].[Products_1];

UPDATE [dbo].[Products_1]
SET [ProductName] = 'Chang Update',
	[SupplierID] = 2, 
	[CategoryID] = 7, 
	[QuantityPerUnit] = '10 boxes x 20 bags'
WHERE [ProductName] = 'Chang';