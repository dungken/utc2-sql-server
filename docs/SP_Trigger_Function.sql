-- 1. Báo cáo doanh thu của từng mặt hàng trong năm 2019
SELECT H.TenH, SUM(C.ThanhTien) AS DoanhThu
FROM HANGHOA H
JOIN ChitietDonhang C ON H.MaH = C.MaH
JOIN HOADON HD ON C.MaHD = HD.MaHD
WHERE YEAR(HD.NgayLap) = 2019
GROUP BY H.TenH;


--function
SELECT * FROM dbo.fn_GetDoanhThuMatHang(2019);

CREATE FUNCTION dbo.fn_GetDoanhThuMatHang (@Year INT)
RETURNS TABLE
AS
RETURN
(
    SELECT H.TenH, SUM(C.ThanhTien) AS DoanhThu
    FROM HANGHOA H
    JOIN ChitietDonhang C ON H.MaH = C.MaH
    JOIN HOADON HD ON C.MaHD = HD.MaHD
    WHERE YEAR(HD.NgayLap) = @Year
    GROUP BY H.TenH
);



-- 2. Danh sách nhân viên có doanh thu tháng 12/2019 từ 20 triệu trở lên
SELECT NV.TenNV, SUM(C.ThanhTien) AS DoanhThu
FROM Nhanvien NV
JOIN HOADON HD ON NV.MaNV = HD.MaNV
JOIN ChitietDonhang C ON HD.MaHD = C.MaHD
WHERE YEAR(HD.NgayLap) = 2019 AND MONTH(HD.NgayLap) = 12
GROUP BY NV.TenNV
HAVING SUM(C.ThanhTien) >= 20000000;

--function
SELECT * FROM dbo.fn_GetNhanVienDoanhThu(2019, 12, 20000000);


CREATE FUNCTION dbo.fn_GetNhanVienDoanhThu (@Year INT, @Month INT, @MinDoanhThu DECIMAL(18, 2))
RETURNS TABLE
AS
RETURN
(
    SELECT NV.TenNV, SUM(C.ThanhTien) AS DoanhThu
    FROM Nhanvien NV
    JOIN HOADON HD ON NV.MaNV = HD.MaNV
    JOIN ChitietDonhang C ON HD.MaHD = C.MaHD
    WHERE YEAR(HD.NgayLap) = @Year AND MONTH(HD.NgayLap) = @Month
    GROUP BY NV.TenNV
    HAVING SUM(C.ThanhTien) >= @MinDoanhThu
);


-- 3. Tổng doanh số của khách hàng có thẻ SoftCard trong 1 năm
SELECT KH.TenKH, SUM(C.ThanhTien) AS DoanhSo
FROM KhachHang KH
JOIN HOADON HD ON KH.MaKH = HD.MaKH
JOIN ChitietDonhang C ON HD.MaHD = C.MaHD
WHERE KH.Loaithe = 'SoftCard'
  AND DATEDIFF(DAY, KH.Ngaycapthe, GETDATE()) <= 365
GROUP BY KH.TenKH
HAVING SUM(C.ThanhTien) >= 5000000;

--function

CREATE FUNCTION dbo.fn_GetDoanhSoKhachHangSoftCard (@CardType NVARCHAR(50), @MinDoanhSo DECIMAL(18, 2))
RETURNS TABLE
AS
RETURN
(
    SELECT KH.TenKH, SUM(C.ThanhTien) AS DoanhSo
    FROM KhachHang KH
    JOIN HOADON HD ON KH.MaKH = HD.MaKH
    JOIN ChitietDonhang C ON HD.MaHD = C.MaHD
    WHERE KH.Loaithe = @CardType
      AND DATEDIFF(DAY, KH.Ngaycapthe, GETDATE()) <= 365
    GROUP BY KH.TenKH
    HAVING SUM(C.ThanhTien) >= @MinDoanhSo
);


-- 4. Thống kê doanh thu bán hàng theo từng năm trong 5 năm
SELECT YEAR(HD.NgayLap) AS Nam, SUM(C.ThanhTien) AS DoanhThu
FROM HOADON HD
JOIN ChitietDonhang C ON HD.MaHD = C.MaHD
WHERE YEAR(HD.NgayLap) >= YEAR(GETDATE()) - 5
GROUP BY YEAR(HD.NgayLap)
ORDER BY Nam;
-- 5. Trigger cập nhật Tongtien và Chietkhau trong bảng HOADON
CREATE TRIGGER trg_UpdateTongTienChietKhau
ON ChitietDonhang
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaHD INT, @TongTien DECIMAL(18,2), @ChietKhau DECIMAL(18,2), @LoaiThe NVARCHAR(50), @n DECIMAL(18,2);
    
    SELECT @MaHD = inserted.MaHD
    FROM inserted;

    SELECT @TongTien = SUM(ThanhTien)
    FROM ChitietDonhang
    WHERE MaHD = @MaHD;

    SELECT @LoaiThe = KH.Loaithe
    FROM HOADON HD
    JOIN KhachHang KH ON HD.MaKH = KH.MaKH
    WHERE HD.MaHD = @MaHD;

    IF @LoaiThe = 'SoftCard' SET @n = 0.02;
    IF @LoaiThe = 'SilverCard' SET @n = 0.04;
    IF @LoaiThe = 'GoldednCard' SET @n = 0.05;
    IF @LoaiThe = 'DiamondCard' SET @n = 0.04;

    SET @ChietKhau = @TongTien * @n;

    UPDATE HOADON
    SET TongTien = @TongTien, ChietKhau = @ChietKhau
    WHERE MaHD = @MaHD;
END;
-- 6. Trigger cập nhật Mucgia và Thanhtien trong ChitietDonhang 
CREATE TRIGGER trg_UpdateMucGiaThanhTien
ON ChitietDonhang
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaH INT, @MucGia DECIMAL(18,2), @SoLuong INT;

    SELECT @MaH = inserted.MaH, @SoLuong = inserted.SoLuong
    FROM inserted;

    SELECT @MucGia = G.MucGia
    FROM GIABAN G
    WHERE G.MaH = @MaH;

    UPDATE ChitietDonhang
    SET MucGia = @MucGia, ThanhTien = @MucGia * @SoLuong
    WHERE MaH = @MaH;
END;
-- 7. Thủ tục/hàm tính tổng số lượng hoặc mức giá bán của mặt hàng
CREATE PROCEDURE sp_TinhSoLuongDaBan
    @MaHang INT,
    @DVT NVARCHAR(50),
    @Ngayban DATE,
    @TongSoLuong INT OUTPUT
AS
BEGIN
    SELECT @TongSoLuong = SUM(C.Soluong)
    FROM ChitietDonhang C
    JOIN GIABAN G ON C.MaH = G.MaH
    WHERE C.MaH = @MaHang AND C.DVT = @DVT AND G.NgayAD <= @Ngayban;
END;


