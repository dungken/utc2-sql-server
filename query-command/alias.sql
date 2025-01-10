-- Lay ra "CompanyName" va dat ten thay the la "Cong ty"; "PostCode" va dat
-- ten thay the la "Ma buu dien"
SELECT [CompanyName] AS [Cong Ty],
	   [PostalCode] AS [Ma buu dien]
FROM Customers;

-- Lay ra LastName va dat ten thay the la "Ho"; FirstName va dat ten 
-- thay the la "Ten"
SELECT [LastName] AS [Ho],
	   [FirstName] AS [Ten]
FROM Employees;

-- Lay ra 15 dong du lieu dau tien cua tat ca cac cot trong bang Orders
-- dat ten thay the cho bang la "o"
SELECT TOP 15 o.*
FROM Orders AS o;


-- 

SELECT TOP 15 
	p.ProductName AS [Ten san pham],
	p.SupplierID AS [Ma nha cung cap],
	p.CategoryID AS [Ma the loai]
FROM Products AS p;

--
SELECT DISTINCT TOP 30 PERCENT
	c.CompanyName AS [Ten cong ty],
	c.Country AS [Quoc gia]
FROM Customers AS c;


-- 

SELECT TOP 10
	o.ShipName AS [Ten san pham],
	o.ShipAddress AS [Dia chi giao],
	o.RequiredDate AS [Ngay yeu cau giao],
	o.ShippedDate AS [Ngay da giao]
FROM Orders AS o;