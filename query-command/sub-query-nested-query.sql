SELECT o.OrderID, (
	SELECT COUNT(od.OrderID)
	FROM [dbo].[Order Details] od
	LEFT JOIN [dbo].[Products] p
	ON od.ProductID = p.ProductID
	GROUP BY p.ProductID
) AS [NumberOfProducts]
FROM [dbo].[Orders] o;