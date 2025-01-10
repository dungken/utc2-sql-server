-- Loc ra tat ca cac khach hang co ten lien he bat dau bang chu 'A'
SELECT * FROM Customers WHERE ContactName LIKE 'A%';

-- Loc ra tat ca cac khach hang co ten lien he bat dau bang chu 'H'
-- va chu thu 2 la bat ky ky tu nao
SELECT * FROM Customers WHERE ContactName LIKE 'H_%';

-- Loc ra cac don hang gui den thanh pho co chu cai bat dau la 'L',
-- chu cai thu 2 la u hoac o
SELECT OrderID, ShipName FROM Orders WHERE ShipName LIKE 'L[u,o]%';

-- Loc ra cac don hang gui den thanh pho co chu cai bat dau la 'L',
-- chu cai thu 2 khong la u hoac o
SELECT OrderID, ShipName FROM Orders WHERE ShipName LIKE 'L[^o,u]%';

-- Lay ra tat ca cac nha cung cap hang co ten cong ty bat dau la 'A'
-- va khong chua ky tu 'b'
SELECT * FROM Suppliers WHERE CompanyName LIKE 'A[^b]%';