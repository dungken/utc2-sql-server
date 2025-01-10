
WITH fibo(prev_n, n) AS (
	-- Phan khoi tao
		SELECT
			0 as prev_n,
			1 as n
	-- Phan de quy
		UNION ALL

		SELECT
			n as prev_n,
			prev_n + n as n
		FROM fibo
) SELECT * FROM fibo OPTION(MAXRECURSION 5);


WITH giaiThua(stt, gtX) AS (
	SELECT 
		1 as stt,
		1 as gtX
	UNION ALL
	SELECT 
		stt + 1 as stt,
		(stt + 1) * gtX  as  gtX
	FROM giaiThua
) SELECT * FROM giaiThua OPTION(MAXRECURSION 4);

-- Su dung truy van de quy de tao cau truc quan ly cua nhan vien trong bang "Employees" 
-- Trong do ReportTo la ma cua nguoi quan ly
declare @EmployeeID int
set @EmployeeID = 2;

WITH e_cte AS (
	SELECT  e.EmployeeID,
			e.LastName + '' + e.FirstName as Name,
			e.ReportsTo as ManagerID,
			0 as level
	FROM [dbo].[Employees] e
	WHERE e.EmployeeID = @EmployeeID

	UNION ALL

	SELECT  e1.EmployeeID,
			e1.LastName + '' + e1.FirstName as Name,
			e1.ReportsTo as ManagerID,
			level+1 as level
		
	FROM [dbo].[Employees] e1
	JOIN e_cte ON e1.ReportsTo = e_cte.EmployeeID
)SELECT * FROM e_cte OPTION(MAXRECURSION 100);