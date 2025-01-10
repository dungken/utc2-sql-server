SELECT *
FROM [Sales].[SalesOrderDetail];

SELECT * 
FROM [Person].[Address];

SELECT * 
FROM [Production].[Product];

SET STATISTICS IO ON;

-- logical reads 1238
--SELECT *
--FROM [Sales].[SalesOrderDetail]
--WHERE [CarrierTrackingNumber] = '4911-403C-98';
-- After create index => logical reads 39

--SELECT * 
--FROM [Person].[Address]
--WHERE [AddressLine1] = '1970 Napa Ct.';

SELECT * 
FROM [Production].[Product]
WHERE [Name] = 'Hex Nut 11';

SET STATISTICS IO OFF;


-- CREATE INDEX
CREATE INDEX idx_CarrierTrackingNumber
ON [Sales].[SalesOrderDetail] ([CarrierTrackingNumber]);

CREATE INDEX idx_AddressLine1
ON [Person].[Address] ([AddressLine1]);

CREATE INDEX idx_Name
ON [Production].[Product] ([Name]);

-- 

