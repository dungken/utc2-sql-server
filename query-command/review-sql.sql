-- Hay cho biet khach hang nao da dat nhieu hon 20 don hang, sx theo thu 
-- tu tong so don hang giam dan
SELECT [CustomerID], COUNT([OrderID]) AS [TotalOrders]
FROM Orders
GROUP BY [CustomerID]
HAVING COUNT([OrderID]) > 20
ORDER BY COUNT([OrderID]) DESC;

-- Hay loc ra cac nhan vien	co tong don hang so lon hon hoac bang 100, 
-- sx theo tong so don hang giam dan
SELECT [EmployeeID], SUM([OrderID]) AS [SumOrder]
FROM Orders
GROUP BY [EmployeeID]
HAVING SUM([OrderID]) >= 100
ORDER BY SUM([OrderID]) DESC;

-- Hay cho biet nhung the loai nao co so san pham khac nhau lon hon 11
SELECT [CategoryID], COUNT([ProductID]) AS [CountProducts]
FROM Products
GROUP BY [CategoryID]
HAVING COUNT([ProductID]) > 11;

-- Hay cho biet quoc gia nao bat dau bang 'A' hoac 'G' va co so luong don
-- hang lon hon 29
SELECT [ShipCountry], COUNT([OrderID]) AS [NumbersOfOrder]
FROM Orders
WHERE [ShipCountry] LIKE '[A,G]%'
GROUP BY [ShipCountry]
HAVING COUNT([OrderID]) > 29
ORDER BY COUNT([OrderID]) DESC;

-- Cho biet nhung thanh pho nao co so luong don hang duoc giao la khac 1 
-- hoac 2, va ngay dat hang tu '1997-04-01' den '1997-08-31'
SELECT [ShipCity], COUNT([OrderID]) AS [NumbersOfOrder]
FROM [dbo].[Orders]
WHERE [OrderDate] BETWEEN '1997-04-01' AND '1997-08-31'
GROUP BY [ShipCity]
HAVING COUNT([OrderID]) NOT IN (1, 2);


