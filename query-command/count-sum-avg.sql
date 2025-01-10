-- Dem so luong khach hang co trong bang (Customers)
SELECT COUNT(*) AS [NumbersOfCustomers] FROM Customers;
SELECT COUNT([ContactName]) AS [NumbersOfCustomers] FROM Customers;

-- Tinh tong so tien van chuyen (Freight) cua tat ca cac don hang
SELECT SUM(Freight) AS [SumFreight] FROM Orders;

-- Tinh trung binh so luong don dat hang (Quantity) cua tat ca
-- cac san pham trong bang [Order Detail]
SELECT AVG(Quantity) FROM [Order Details];

-- Dem so luong, tinh tong so luong hang ton kho va trung binh gia
-- cua cac san pham co trong bang Products
SELECT 
	COUNT(*) AS [CountProducts],
	SUM(UnitsInStock - UnitsOnOrder) AS [SumStocks],
	AVG(UnitPrice) AS [AvgPrice]
FROM Products;

-- Dem so luong don hang tu bang (Orders) theo 2 cach
SELECT COUNT(*) FROM Orders;
SELECT COUNT(CustomerID) FROM Orders;

-- Tinh trung binh cot UnitPrice va tinh tong cho cot Quantity
-- tu bang Order Detail
SELECT 
	AVG(UnitPrice) AS [AvgPrice],
	SUM(Quantity) AS [SumQuantity]
FROM [Order Details];
