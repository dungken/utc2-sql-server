CREATE DATABASE QuanLyBanHang;
GO

USE QuanLyBanHang;
GO

-- Bảng Khách_Hàng
CREATE TABLE Khach_Hang (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100),
    DiaChi NVARCHAR(255),
    DienThoai VARCHAR(15) NULL,
    Email NVARCHAR(100) NULL
);

-- Bảng Vật tư
CREATE TABLE VatTu (
    MaVT VARCHAR(10) PRIMARY KEY,
    TenVT NVARCHAR(100),
    DonViTinh NVARCHAR(50),
    DonGiaMua DECIMAL(18, 2),
    SoLuongTon INT CHECK (SoLuongTon >= 0)
);

-- Bảng Hóa_Đơn
CREATE TABLE Hoa_Don (
    SoHD VARCHAR(10) PRIMARY KEY,
    NgayLapHoaDon DATE,
    MaKH VARCHAR(10),
    TongTriGia DECIMAL(18, 2) CHECK (TongTriGia >= 0),
    FOREIGN KEY (MaKH) REFERENCES Khach_Hang(MaKH)
);

-- Bảng Chi_Tiết_Hóa_Đơn
CREATE TABLE Chi_Tiet_Hoa_Don (
    SoHD VARCHAR(10),
    MaVT VARCHAR(10),
    SoLuong INT CHECK (SoLuong >= 0),
    KhuyenMai DECIMAL(5, 2) CHECK (KhuyenMai >= 0 AND KhuyenMai <= 100),
    GiaBan DECIMAL(18, 2),
    PRIMARY KEY (SoHD, MaVT),
    FOREIGN KEY (SoHD) REFERENCES Hoa_Don(SoHD),
    FOREIGN KEY (MaVT) REFERENCES VatTu(MaVT)
);


CREATE TRIGGER trg_CheckEmail
ON Khach_Hang
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT Email
        FROM Khach_Hang
        GROUP BY Email
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR ('Email phải là duy nhất!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER trg_CheckSoLuongTon
ON VatTu
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM VatTu
        WHERE SoLuongTon < 0
    )
    BEGIN
        RAISERROR ('Số lượng tồn không được âm!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER trg_UpdateTongTriGia
ON Chi_Tiet_Hoa_Don
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @SoHD VARCHAR(10);
    DECLARE @TongTriGia DECIMAL(18, 2);

    SELECT @SoHD = SoHD FROM inserted;

    SELECT @TongTriGia = SUM(SoLuong * GiaBan * (1 - KhuyenMai / 100.0))
    FROM Chi_Tiet_Hoa_Don
    WHERE SoHD = @SoHD;

    UPDATE Hoa_Don
    SET TongTriGia = @TongTriGia
    WHERE SoHD = @SoHD;
END;


CREATE TRIGGER trg_CheckGiaBan
ON Chi_Tiet_Hoa_Don
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT CT.*
        FROM Chi_Tiet_Hoa_Don CT
        JOIN VatTu VT ON CT.MaVT = VT.MaVT
        WHERE CT.GiaBan < VT.DonGiaMua
    )
    BEGIN
        RAISERROR ('Giá bán không được thấp hơn giá mua!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

INSERT INTO Khach_Hang (MaKH, TenKH, DiaChi, DienThoai, Email) VALUES
('KH001', 'Nguyen Van A', 'Tan Binh', '0123456789', 'a@example.com'),
('KH002', 'Tran Thi B', 'District 1', NULL, 'b@example.com'),
('KH003', 'Le Van C', 'District 2', '0987654321', NULL),
('KH004', 'Pham Minh D', 'Tan Binh', '0245789123', 'd@example.com');

INSERT INTO VatTu (MaVT, TenVT, DonViTinh, DonGiaMua, SoLuongTon) VALUES
('VT001', N'Gạch', N'Cái', 20000, 50),
('VT002', N'Xi măng', N'Tấn', 700000, 20),
('VT003', N'Cát', N'Khối', 300000, 100),
('VT004', N'Đá', N'Tấn', 400000, 10);

INSERT INTO Hoa_Don (SoHD, NgayLapHoaDon, MaKH, TongTriGia) VALUES
('HD001', '2023-09-01', 'KH001', 500000),
('HD002', '2023-09-05', 'KH002', 250000),
('HD003', '2023-09-10', 'KH003', 300000);

INSERT INTO Chi_Tiet_Hoa_Don (SoHD, MaVT, SoLuong, KhuyenMai, GiaBan) VALUES
('HD001', 'VT001', 2, 0, 22000), -- giá bán phải >= 20000 (giá mua của VT001)
('HD001', 'VT002', 1, 5, 710000), -- giá bán >= 700000
('HD002', 'VT003', 1, 10, 300000), -- giá bán >= 300000
('HD003', 'VT001', 3, 0, 21000), -- giá bán >= 20000
('HD003', 'VT004', 1, 0, 400000); -- giá bán >= 400000



--1. Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, tên
--khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
SELECT MaKH, TenKH, DiaChi, DienThoai, Email
FROM Khach_Hang
WHERE DiaChi = 'Tan Binh';

--2. Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng,
--địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.
SELECT MaKH, TenKH, DiaChi, Email
FROM Khach_Hang
WHERE DienThoai IS NULL;

--3. Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ
--Email gồm mã khách hàng, tên khách hàng, địa chỉ.
SELECT MaKH, TenKH, DiaChi
FROM Khach_Hang
WHERE DienThoai IS NULL AND Email IS NULL;

--4. Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã
--khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
SELECT MaKH, TenKH, DiaChi, DienThoai, Email
FROM Khach_Hang
WHERE DienThoai IS NOT NULL AND Email IS NOT NULL;

--5. Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá
--mua.
SELECT MaVT, TenVT, DonGiaMua
FROM VatTu
WHERE DonViTinh = 'Cái';

--6. Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có
--giá mua trên 25000.
SELECT MaVT, TenVT, DonViTinh, DonGiaMua
FROM VatTu
WHERE DonGiaMua > 25000;

--7. Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên
--vật tư, đơn vị tính và giá mua.
SELECT MaVT, TenVT, DonViTinh, DonGiaMua
FROM VatTu
WHERE TenVT LIKE '%Gạch%';

--8. Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có
--giá mua nằm trong khoảng từ 20000 đến 40000.
SELECT MaVT, TenVT, DonViTinh, DonGiaMua
FROM VatTu
WHERE DonGiaMua BETWEEN 20000 AND 40000;

--9. Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ
--khách hàng và số điện thoại.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, KH.DienThoai
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH;

--10. Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện
--thoại của ngày 25/5/2010.
SELECT HD.SoHD, KH.TenKH, KH.DiaChi, KH.DienThoai
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
WHERE HD.NgayLapHoaDon = '2010-05-25';

--11. Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ
--khách hàng và số điện thoại của những hóa đơn trong tháng 6/2010.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, KH.DienThoai
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
WHERE HD.NgayLapHoaDon BETWEEN '2010-06-01' AND '2010-06-30';

--12. Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại) đã mua
--hàng trong tháng 6/2010.
SELECT DISTINCT KH.TenKH, KH.DiaChi, KH.DienThoai
FROM Khach_Hang KH
JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
WHERE HD.NgayLapHoaDon BETWEEN '2010-06-01' AND '2010-06-30';

--13. Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm các
--thông tin tên khách hàng, địa chỉ, số điện thoại.
SELECT KH.TenKH, KH.DiaChi, KH.DienThoai
FROM Khach_Hang KH
WHERE KH.MaKH NOT IN (
    SELECT DISTINCT HD.MaKH
    FROM Hoa_Don HD
    WHERE HD.NgayLapHoaDon BETWEEN '2010-06-01' AND '2010-06-30'
);


--14. Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn
--vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá
--bán * số lượng).
SELECT CT.SoHD, CT.MaVT, VT.TenVT, VT.DonViTinh, CT.GiaBan, VT.DonGiaMua,
       CT.SoLuong, (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan
FROM Chi_Tiet_Hoa_Don CT
JOIN VatTu VT ON CT.MaVT = VT.MaVT;

--15. Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn
--vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá
--bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.
SELECT CT.SoHD, CT.MaVT, VT.TenVT, VT.DonViTinh, CT.GiaBan, VT.DonGiaMua,
       CT.SoLuong, (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan
FROM Chi_Tiet_Hoa_Don CT
JOIN VatTu VT ON CT.MaVT = VT.MaVT
WHERE CT.GiaBan >= VT.DonGiaMua;

--16. Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá
--mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) và
--cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn
--hơn 100.
SELECT CT.SoHD, CT.MaVT, VT.TenVT, VT.DonViTinh, CT.GiaBan, VT.DonGiaMua,
       CT.SoLuong, (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan,
       CASE WHEN (CT.GiaBan * CT.SoLuong) > 100 THEN 10 ELSE 0 END AS KhuyenMai
FROM Chi_Tiet_Hoa_Don CT
JOIN VatTu VT ON CT.MaVT = VT.MaVT;

--17. Tìm ra những mặt hàng chưa bán được.
SELECT *
FROM VatTu VT
WHERE VT.MaVT NOT IN (
    SELECT DISTINCT CT.MaVT
    FROM Chi_Tiet_Hoa_Don CT
);

--18. Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa
--chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị
--giá bán.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, KH.DienThoai,
       VT.TenVT, VT.DonViTinh, VT.DonGiaMua, CT.GiaBan, CT.SoLuong,
       (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
JOIN Chi_Tiet_Hoa_Don CT ON HD.SoHD = CT.SoHD
JOIN VatTu VT ON CT.MaVT = VT.MaVT;

--19. Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên
--khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng,
--trị giá mua, trị giá bán.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, KH.DienThoai,
       VT.TenVT, VT.DonViTinh, VT.DonGiaMua, CT.GiaBan, CT.SoLuong,
       (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
JOIN Chi_Tiet_Hoa_Don CT ON HD.SoHD = CT.SoHD
JOIN VatTu VT ON CT.MaVT = VT.MaVT
WHERE HD.NgayLapHoaDon BETWEEN '2010-05-01' AND '2010-05-31';

--20. Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên
--khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng,
--trị giá mua, trị giá bán.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, KH.DienThoai,
       VT.TenVT, VT.DonViTinh, VT.DonGiaMua, CT.GiaBan, CT.SoLuong,
       (VT.DonGiaMua * CT.SoLuong) AS TriGiaMua,
       (CT.GiaBan * CT.SoLuong) AS TriGiaBan
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
JOIN Chi_Tiet_Hoa_Don CT ON HD.SoHD = CT.SoHD
JOIN VatTu VT ON CT.MaVT = VT.MaVT
WHERE HD.NgayLapHoaDon BETWEEN '2010-01-01' AND '2010-03-31';

--21. Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng,
--địa chỉ khách hàng, tổng trị giá của hóa đơn.
SELECT HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, HD.TongTriGia
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH;

--22. Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên
--khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
SELECT TOP 1 HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, HD.TongTriGia
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
ORDER BY HD.TongTriGia DESC;

--23. Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa
--đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
SELECT TOP 1 HD.SoHD, HD.NgayLapHoaDon, KH.TenKH, KH.DiaChi, HD.TongTriGia
FROM Hoa_Don HD
JOIN Khach_Hang KH ON HD.MaKH = KH.MaKH
WHERE HD.NgayLapHoaDon BETWEEN '2010-05-01' AND '2010-05-31'
ORDER BY HD.TongTriGia DESC;


--24. Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.
SELECT KH.MaKH, KH.TenKH, COUNT(HD.SoHD) AS SoHoaDon
FROM Khach_Hang KH
LEFT JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.TenKH;

--25. Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.
SELECT KH.MaKH, KH.TenKH, MONTH(HD.NgayLapHoaDon) AS Thang, COUNT(HD.SoHD) AS SoHoaDon
FROM Khach_Hang KH
LEFT JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.TenKH, MONTH(HD.NgayLapHoaDon);

--26. Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
SELECT TOP 1 KH.MaKH, KH.TenKH, COUNT(HD.SoHD) AS SoHoaDon
FROM Khach_Hang KH
JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.TenKH
ORDER BY SoHoaDon DESC;

--27. Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.
SELECT KH.MaKH, KH.TenKH, SUM(CT.SoLuong) AS TongSoLuong
FROM Khach_Hang KH
JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
JOIN Chi_Tiet_Hoa_Don CT ON HD.SoHD = CT.SoHD
GROUP BY KH.MaKH, KH.TenKH
ORDER BY TongSoLuong DESC;

--28. Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.
SELECT VT.MaVT, VT.TenVT, COUNT(DISTINCT CT.SoHD) AS SoHoaDon
FROM VatTu VT
JOIN Chi_Tiet_Hoa_Don CT ON VT.MaVT = CT.MaVT
GROUP BY VT.MaVT, VT.TenVT
ORDER BY SoHoaDon DESC;

--29. Lấy ra các thông tin về các mặt hàng mà được bán nhiều nhất.
SELECT VT.MaVT, VT.TenVT, SUM(CT.SoLuong) AS TongSoLuong
FROM VatTu VT
JOIN Chi_Tiet_Hoa_Don CT ON VT.MaVT = CT.MaVT
GROUP BY VT.MaVT, VT.TenVT
ORDER BY TongSoLuong DESC;

--30. Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ,
--số lượng hóa đơn đã mua (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn
--để trống)

SELECT KH.MaKH, KH.TenKH, KH.DiaChi, COUNT(HD.SoHD) AS SoHoaDon
FROM Khach_Hang KH
LEFT JOIN Hoa_Don HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.TenKH, KH.DiaChi;
