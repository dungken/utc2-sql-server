-- Lay ra ten cua tat ca cac san pham
SELECT [ProductName] FROM [dbo].[Products];

-- Lay ra ten san pham, gia ban tren moi don vi, so luong sp tren don vi

SELECT [ProductName], [UnitPrice], [QuantityPerUnit] FROM [dbo].[Products];

-- Lay ra ten khach hang va quoc gia cua khach hang do

SELECT [ContactName], [Country] FROM [dbo].[Customers];

-- Lay ra ten va so dien thoai cua nha cung cap hang

SELECT [ContactName], [Phone] FROM [dbo].[Suppliers];

-- Lay ra ShipName, ShipAddress, ShipCity, ShipCountry cua tat ca don hang

SELECT [ShipName], [ShipAddress], [ShipCountry] FROM [dbo].[Orders];

 -- Lay ra [CategoryName], [Description] cua tat ca danh muc

 SELECT [CategoryName], [Description] FROM [dbo].[Categories];

 -- Lay ra tat ca du lieu tu bang Products

 SELECT * FROM [dbo].[Products];

 -- Lay ra tat ca du lieu tu bang khach hang

 SELECT * FROM [dbo].[Customers];

 -- Lay ra tat ca du lieu tu bang Orders

 SELECT * FROM [dbo].[Orders];

 -- Lay ra tat ca du lieu tu bang Categories

 SELECT * FROM [dbo].[Categories];