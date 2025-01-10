-- Hay cho biet nhung khach hang nao da dat nhieu hon 20 don hang, 
-- sap xep theo thu tu tong so don hang giam dan
SELECT [CustomerID], COUNT([OrderID]) AS [TotalOrders]
FROM Orders
GROUP BY [CustomerID]
HAVING COUNT([OrderID]) > 20
ORDER BY COUNT([OrderID]) DESC;

-- Hay loc ra nhung nha cung cap san pham co tong so luong hang trong kho
-- (UnitsInStock) lon hon 30, co trung binh don gia (UnitPrice) co gia tri
-- duoi 50
SELECT [SupplierID], 
       SUM([UnitsInStock]) AS [TotalUnitsInStock], 
	   AVG([UnitPrice]) AS [AvgUnitPrice]
FROM Products
GROUP BY [SupplierID]
HAVING SUM([UnitsInStock]) > 30 AND AVG([UnitPrice]) < 50;

-- Hay cho biet tong so tien van chuyen cua tung thang, trong nua nam sau
-- 1996, sap xep theo thang tang dan
SELECT MONTH([ShippedDate]) AS [Month], SUM([Freight]) AS [TotalFreight]
FROM Orders
WHERE [ShippedDate] BETWEEN '1996-7-1' AND '1996-12-31'
GROUP BY MONTH([ShippedDate])
ORDER BY MONTH([ShippedDate]) ASC;

-- Hay cho biet tong so tien van chuyen cua tung thang, trong nua nam sau
-- 1996, sap xep theo thang tang dan, tong tien van chuyen lon hon 1000$
SELECT MONTH([ShippedDate]) AS [Month], SUM([Freight]) AS [TotalFreight]
FROM Orders
WHERE [ShippedDate] BETWEEN '1996-7-1' AND '1996-12-31'
GROUP BY MONTH([ShippedDate])
HAVING SUM([Freight]) > 1000
ORDER BY MONTH([ShippedDate]) ASC;

-- Hay loc ra nhung thanh pho co so luong don hang > 16 va sap xep
-- theo tong so luong giam dan
SELECT [ShipCity], COUNT([OrderID]) AS [NumbersOfOrder]
FROM Orders
GROUP BY [ShipCity]
HAVING COUNT([OrderID]) > 16
ORDER BY COUNT([OrderID]) ASC;