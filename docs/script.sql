/*
Cho CSDL gồm các quan hệ sau:
HangHoa(MaH, TenH, MoTa)
GiaBan(MaGia, MucGia, DVT, NgayAD, MaH)
ChiTietDonHang(MaCTDH, MaH, MaHD, DVT, MucGia, SoLuong, ThanhTien)
HoaDon(MaHD, NgayLap, MaKH, MaNV, TongTien, ChietKhau)
KhachHang(MaKH, TenKH, DiaChi,  DienThoai, LoaiThe, NgayCapThe)
NhanVien(MaNV, TenNV, DiaChi, DienThoai)
*/

create database QuanLyBanHang;
go
use QuanLyBanHang;
go

-- Bang HangHoa
create table HangHoa(
	MaH nvarchar(50) primary key,
	TenH nvarchar(100) not null,
	MoTa nvarchar(255)
);

INSERT INTO HangHoa (MaH, TenH, MoTa) VALUES
('HH001', N'Áo Thun Nam', N'Áo thun nam chất liệu cotton, size M'),
('HH002', N'Quần Jeans Nam', N'Quần jeans xanh đậm, size 32'),
('HH003', N'Giày Thể Thao', N'Giày chạy bộ nam, size 42'),
('HH004', N'Áo Sơ Mi Nam', N'Áo sơ mi trắng dài tay, size L'),
('HH005', N'Quần Short Nam', N'Quần short kaki, size XL'),
('HH006', N'Mũ Lưỡi Trai', N'Mũ lưỡi trai đen trơn, kiểu dáng thể thao'),
('HH007', N'Thắt Lưng Da', N'Thắt lưng da bò cao cấp, màu nâu'),
('HH008', N'Balo Thể Thao', N'Balo thể thao nhỏ gọn, màu đen'),
('HH009', N'Tất Thể Thao', N'Tất cổ ngắn, màu trắng, set 5 đôi'),
('HH010', N'Áo Khoác Nam', N'Áo khoác gió 2 lớp, màu xanh navy');

SELECT * FROM HangHoa;

-- Bang GiaBan
create table GiaBan (
	MaGia nvarchar(50) primary key,
	MucGia decimal(18,2) not null,
	DVT nvarchar(50) not null,
	NgayAD Date not null,
	MaH nvarchar(50) not null,
	foreign key (MaH) references HangHoa(MaH)
);
INSERT INTO GiaBan (MaGia, MucGia, DVT, NgayAD, MaH) VALUES
('G001', 200000, N'VND', '2024-01-01', 'HH001'),
('G002', 350000, N'VND', '2024-01-01', 'HH002'),
('G003', 150000, N'VND', '2024-01-01', 'HH003'),
('G004', 300000, N'VND', '2024-01-01', 'HH004'),
('G005', 180000, N'VND', '2024-01-01', 'HH005'),
('G006', 120000, N'VND', '2024-01-01', 'HH006'),
('G007', 250000, N'VND', '2024-01-01', 'HH007'),
('G008', 500000, N'VND', '2024-01-01', 'HH008'),
('G009', 70000, N'VND', '2024-01-01', 'HH009'),
('G010', 400000, N'VND', '2024-01-01', 'HH010');
SELECT * FROM GiaBan;

-- Bang KhachHang
create table KhachHang (
	MaKH nvarchar(50) primary key,
	TenKH nvarchar(100) not null,
	DiaChi nvarchar(255),
	DienThoai nvarchar(15),
	LoaiThe nvarchar(50),
	NgayCapThe date
);
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, DienThoai, LoaiThe, NgayCapThe) VALUES
('KH001', N'Nguyễn Văn A', N'123 Đường ABC, Hà Nội', N'0987654321', N'VIP', '2023-01-15'),
('KH002', N'Nguyễn Thị B', N'456 Đường DEF, TP.HCM', N'0976543210', N'Bạc', '2023-02-20'),
('KH003', N'Phạm Minh C', N'789 Đường GHI, Đà Nẵng', N'0965432109', N'Vàng', '2023-03-25'),
('KH004', N'Trần Thị D', N'123 Đường JKL, Hà Nội', N'0912345678', N'VIP', '2023-04-10'),
('KH005', N'Hoàng Anh E', N'456 Đường MNO, TP.HCM', N'0901234567', N'Bạc', '2023-05-05'),
('KH006', N'Phan Minh F', N'789 Đường PQR, Đà Nẵng', N'0932345678', N'Vàng', '2023-06-15'),
('KH007', N'Vũ Thị G', N'101 Đường STU, Hà Nội', N'0956781234', N'VIP', '2023-07-20'),
('KH008', N'Lê Văn H', N'202 Đường VWX, TP.HCM', N'0945678901', N'Bạc', '2023-08-05'),
('KH009', N'Toàn Thị I', N'303 Đường YZA, Đà Nẵng', N'0923456789', N'Vàng', '2023-09-10'),
('KH010', N'Lan Anh J', N'404 Đường BCD, Hà Nội', N'0910123456', N'VIP', '2023-10-15');
SELECT * FROM KhachHang;

-- Bang NhanVien 
create table NhanVien(
	MaVN nvarchar(50) primary key,
	TenNV nvarchar(100) not null,
	DiaChi nvarchar(255),
	DienThoai nvarchar(15)
);
INSERT INTO NhanVien (MaVN, TenNV, DiaChi, DienThoai) VALUES
('NV001', N'Nguyễn Hữu K', N'123 Đường PQR, Hà Nội', N'0981234567'),
('NV002', N'Phan Tiến L', N'456 Đường ABC, TP.HCM', N'0979876543'),
('NV003', N'Trần Hồng M', N'789 Đường XYZ, Đà Nẵng', N'0969876543'),
('NV004', N'Hoàng Duy N', N'101 Đường DEF, Hà Nội', N'0945678901'),
('NV005', N'Vũ Minh O', N'202 Đường GHI, TP.HCM', N'0932345678'),
('NV006', N'Ngô Lan P', N'303 Đường STU, Đà Nẵng', N'0912345678'),
('NV007', N'Bùi Anh Q', N'404 Đường JKL, Hà Nội', N'0909876543'),
('NV008', N'Phạm Duy R', N'505 Đường LMN, TP.HCM', N'0923456789'),
('NV009', N'Lê Duy S', N'606 Đường OPQ, Đà Nẵng', N'0941234567'),
('NV010', N'Nguyễn Minh T', N'707 Đường RST, Hà Nội', N'0934567890');
SELECT * FROM NhanVien;

-- Bang HoaDon
create table HoaDon(
	MaHD nvarchar(50) primary key,
	NgayLap date not null,
	MaKH nvarchar(50),
	MaNV nvarchar(50),
	TongTien decimal(18,2),
	ChietKhau decimal(18,2),
	foreign key (MaKH) references KhachHang(MaKH),
	foreign key (MaNV) references NhanVien(MaVN)
);
INSERT INTO HoaDon (MaHD, NgayLap, MaKH, MaNV, TongTien, ChietKhau) VALUES
('HD001', '2024-01-15', 'KH001', 'NV001', 1500000, 0),
('HD002', '2024-01-16', 'KH002', 'NV002', 1200000, 100000),
('HD003', '2024-01-17', 'KH003', 'NV003', 1800000, 200000),
('HD004', '2024-01-18', 'KH004', 'NV004', 1300000, 0),
('HD005', '2024-01-19', 'KH005', 'NV005', 1000000, 50000),
('HD006', '2024-01-20', 'KH006', 'NV006', 2200000, 0),
('HD007', '2024-01-21', 'KH007', 'NV007', 2500000, 300000),
('HD008', '2024-01-22', 'KH008', 'NV008', 1400000, 0),
('HD009', '2024-01-23', 'KH009', 'NV009', 1600000, 100000),
('HD010', '2024-01-24', 'KH010', 'NV010', 2100000, 150000);

-- Thêm 10 dòng dữ liệu vào bảng HoaDon
INSERT INTO HoaDon (MaHD, NgayLap, MaKH, MaNV, TongTien, ChietKhau) VALUES
('HD011', '2023-01-15', 'KH001', 'NV001', 1300000, 0),
('HD012', '2023-02-16', 'KH002', 'NV002', 1400000, 50000),
('HD013', '2023-03-17', 'KH003', 'NV003', 1500000, 70000),
('HD014', '2023-04-18', 'KH004', 'NV004', 1700000, 100000),
('HD015', '2023-05-19', 'KH005', 'NV005', 1600000, 80000),
('HD016', '2022-06-20', 'KH006', 'NV006', 1800000, 0),
('HD017', '2022-07-21', 'KH007', 'NV007', 2000000, 0),
('HD018', '2022-08-22', 'KH008', 'NV008', 1200000, 60000),
('HD019', '2021-09-23', 'KH009', 'NV009', 1100000, 0),
('HD020', '2021-10-24', 'KH010', 'NV010', 2500000, 200000);

SELECT * FROM HoaDon;


-- Bang ChiTietDonHang
create table ChiTietDonHang (
	MaCTDH nvarchar(50) primary key,
	MaH nvarchar(50) not null,
	MaHD nvarchar(50) not null,
	DVT nvarchar(50),
	MucGia decimal(18,2),
	SoLuong int not null,
	ThanhTien decimal(18,2),
	foreign key (MaH) references HangHoa(MaH),
	foreign key (MaHD) references HoaDon(MaHD)
);
INSERT INTO ChiTietDonHang (MaCTDH, MaH, MaHD, DVT, MucGia, SoLuong, ThanhTien) VALUES
('CTDH001', 'HH001', 'HD001', N'Cái', 200000, 5, 1000000),
('CTDH002', 'HH002', 'HD002', N'Cái', 350000, 3, 1050000),
('CTDH003', 'HH003', 'HD003', N'Đôi', 150000, 4, 600000),
('CTDH004', 'HH004', 'HD004', N'Cái', 300000, 2, 600000),
('CTDH005', 'HH005', 'HD005', N'Cái', 180000, 3, 540000),
('CTDH006', 'HH006', 'HD006', N'Cái', 120000, 4, 480000),
('CTDH007', 'HH007', 'HD007', N'Cái', 250000, 2, 500000),
('CTDH008', 'HH008', 'HD008', N'Cái', 500000, 1, 500000),
('CTDH009', 'HH009', 'HD009', N'Bộ', 70000, 6, 420000),
('CTDH010', 'HH010', 'HD010', N'Cái', 400000, 2, 800000);
-- Thêm dữ liệu vào bảng ChiTietDonHang
INSERT INTO ChiTietDonHang (MaCTDH, MaH, MaHD, DVT, MucGia, SoLuong, ThanhTien) VALUES
('CTDH011', 'HH001', 'HD016', N'Cái', 600000, 2, 1200000),
('CTDH012', 'HH002', 'HD016', N'Cái', 500000, 1, 500000),
('CTDH013', 'HH003', 'HD017', N'Cái', 700000, 2, 1400000),
('CTDH014', 'HH004', 'HD017', N'Cái', 400000, 1, 400000),
('CTDH015', 'HH005', 'HD018', N'Cái', 600000, 1, 600000),
('CTDH016', 'HH006', 'HD018', N'Cái', 300000, 2, 600000),
('CTDH017', 'HH007', 'HD019', N'Cái', 250000, 4, 1000000),
('CTDH018', 'HH008', 'HD019', N'Cái', 300000, 3, 900000),
('CTDH019', 'HH009', 'HD020', N'Cái', 350000, 5, 1750000),
('CTDH020', 'HH010', 'HD020', N'Cái', 450000, 2, 900000);
SELECT * FROM ChiTietDonHang;


--//////// INDEX ////////

create index IDX_HoaDon_MaHD_MaKH on HoaDon(MaHD, MaKH);
create index IDX_HoaDon_NgayLap on HoaDon(NgayLap);
create index IDX_ChiTietDonHang_MaH on ChiTietDonHang(MaH);
create index IDX_KhachHang_LoaiThe on KhachHang(LoaiThe);
create index IDX_HoaDon_MaNV on HoaDon(MaNV);
create index IDX_GiaBan_MaH_NgayAD on GiaBan(MaH, NgayAD);
create index IDX_ChiTietDonHang_MaHD_MaH on ChiTietDonHang(MaHD, MaH);


/*1.Lập báo cáo danh thu trong năm 2024 của từng mặt hàng*/
create view BaoCaoDoanhThu2024 as
select hh.MaH, hh.TenH, sum(ct.SoLuong * ct.MucGia) as DoanhThu2024
from HoaDon hd
join ChiTietDonHang ct on hd.MaHD = ct.MaHD
join HangHoa hh on ct.MaH = hh.MaH
where year(hd.NgayLap) = 2024
group by hh.MaH, hh.TenH;

SELECT * FROM BaoCaoDoanhThu2024;


/*2. Đưa ra danh sách những nhân viên có doanh thu bán hàng tháng 1/2024 từ 500,000đ trở lên*/
create view DoanhThuNV_2024 as 
select nv.MaVN, nv.TenNV, sum(ct.SoLuong * ct.MucGia) as DoanhThuThang1
from HoaDon hd
join ChiTietDonHang ct on hd.MaHD = ct.MaHD
join NhanVien nv on hd.MaNV = nv.MaVN
where month(hd.NgayLap) = 1 and year(hd.NgayLap) = 2024
group by nv.MaVN, nv.TenNV
having sum(ct.SoLuong * ct.MucGia) >= 500000;

SELECT * FROM DoanhThuNV_2024;


/*
3.Tính tổng doanh số mua hàng tính từ ngày cấp thẻ đến ngày hiện tại của mỗi khách hàng 
được cấp thẻ <<VIP>>. Thời gian tính từ ngày cấp thẻ đến ngày hiện tại phải <= 1 năm. 
Chi tiết hiển thị các khách hàng có tổng doanh số mua hàng >=  800.000
*/

create function fn_TongDoanhSoKH(@MaKH nvarchar(50))
returns decimal(18, 2)
as 
begin
	declare @TongDoanhSo decimal(18,2);
	
	select @TongDoanhSo = sum(ct.SoLuong * ct.MucGia)
	from HoaDon hd
	join ChiTietDonHang ct on hd.MaHD = ct.MaHD
	join KhachHang kh on hd.MaKH = kh.MaKH
	where kh.MaKH = @MaKH 
		and kh.LoaiThe = N'VIP' 
		and hd.NgayLap between kh.NgayCapThe and dateadd(year, 1, kh.NgayCapThe);

	return @TongDoanhSo;
end;

select 
	kh.MaKH,
	kh.TenKH,
	dbo.fn_TongDoanhSoKH(kh.MaKH) as TongDoanhSo
from KhachHang kh
where kh.LoaiThe = N'VIP'
group by kh.MaKH, kh.TenKH
having dbo.fn_TongDoanhSoKH(kh.MaKH) >= 800000;


/*4.Thống kê doanh thu bán hàng theo từng năm của 5 năm trở lại đây */

create view ThongKeDoanhThuTheoTungNam as 
select year(hd.NgayLap) as Nam, sum(ct.SoLuong * ct.MucGia) as DoanhThu
from HoaDon hd
join ChiTietDonHang ct on hd.MaHD = ct.MaHD
group by year(hd.NgayLap)
having year(hd.NgayLap) between year(getdate()) - 5 and year(getdate());

select * from ThongKeDoanhThuTheoTungNam;

/*
5. Viết thủ tục với tham số đầu vào là @MaHang, @DVT, @NgayBan, tham số đầu ra là tổng số 
lượng đã bán của mặt hàng đã cho (hoặc tham số đầu ra là mức giá bán của mã hàng đó)
*/

create procedure sp_TongSoLuongHoacMucGia
	@MaHang nvarchar(50),
	@DVT nvarchar(50),
	@NgayBan date,
	@TongSoLuong int output,
	@MucGia decimal(18,2) output
as 
begin
	-- Tinh tong so luong da ban cua mat hang
	select @TongSoLuong = sum(ct.SoLuong)
	from ChiTietDonHang ct
	where ct.MaH = @MaHang
		and ct.DVT = @DVT
		and ct.MaHD in 
			(
				select MaHD
				from HoaDon
				where NgayLap <= @NgayBan
			)
	-- Neu khong co so luong ban duoc, tra ve muc gia cua mat hang
	if @TongSoLuong is null or @TongSoLuong = 0
	begin
		select top 1 @MucGia = g.MucGia
		from GiaBan g
		where g.MaH = @MaHang and g.NgayAD <= @NgayBan
		order by  g.NgayAD desc
	end
end

declare @TongSoLuong int,
        @MucGia decimal(18, 2);

exec sp_TongSoLuongHoacMucGia
	@MaHang = 'HH001',
	@DVT = N'Cai',
	@NgayBan = '2024-01-20',
	@TongSoLuong = @TongSoLuong output,
	@MucGia = @MucGia output;

select @TongSoLuong as TongSoLuong, @MucGia as MucGia;

/*
6. Viết trigger tự động cập nhật trường Mucgia và Thanhtien của bảng ChitietDonhang khi thêm 
mới hay cập nhật một bản ghi.
*/
CREATE TRIGGER trg_UpdateMucGiaThanhTien
ON ChiTietDonHang
AFTER INSERT, UPDATE
AS
BEGIN
    -- Cập nhật MucGia và ThanhTien cho các bản ghi được thêm hoặc cập nhật
    UPDATE ct
    SET 
        ct.MucGia = ISNULL(
            (
                SELECT TOP 1 g.MucGia
                FROM GiaBan g
                INNER JOIN HoaDon h ON ct.MaHD = h.MaHD
                WHERE g.MaH = ct.MaH 
                  AND g.NgayAD <= h.NgayLap
                ORDER BY g.NgayAD DESC
            ), 0), -- Nếu không tìm thấy mức giá thì mặc định là 0
        ct.ThanhTien = ct.SoLuong * ISNULL(
            (
                SELECT TOP 1 g.MucGia
                FROM GiaBan g
                INNER JOIN HoaDon h ON ct.MaHD = h.MaHD
                WHERE g.MaH = ct.MaH 
                  AND g.NgayAD <= h.NgayLap
                ORDER BY g.NgayAD DESC
            ), 0)
    FROM ChiTietDonHang ct
    INNER JOIN inserted i ON ct.MaCTDH = i.MaCTDH;
END;

INSERT INTO ChiTietDonHang (MaCTDH, MaH, MaHD, DVT, SoLuong)
VALUES ('CT0021', 'HH002', 'HD002', N'Cái', 10);

SELECT * FROM ChiTietDonHang;

UPDATE ChiTietDonHang
SET SoLuong = 20
WHERE MaCTDH = 'CT0021';

SELECT * FROM ChiTietDonHang;


/*
7. Viết 1 trigger tự động cập nhật trường Tongtien, Chietkhau trong quan hệ HOADON khi thêm mới 
hay cập nhật một bản ghi trong ChitietDonhang. Biết rằng :
Tongtien=Tổng các Thanhtien của từng mặt hàng trong ChitietDonhang

Chietkhau = Tongtien * n

Trong đó: 
n = 2% nếu khách hàng có thẻ « VIP » 
n = 4% nếu khách hàng có thẻ « Bạc » 
n = 5% nếu khách hàng có thẻ « Vàng »
*/

CREATE TRIGGER trg_UpdateTongTienChietKhau
ON ChiTietDonHang
AFTER INSERT, UPDATE
AS
BEGIN
    -- Cập nhật TongTien trong bảng HoaDon
    UPDATE h
    SET 
        h.TongTien = (
            SELECT SUM(ct.ThanhTien)
            FROM ChiTietDonHang ct
            WHERE ct.MaHD = h.MaHD
        )
    FROM HoaDon h
    INNER JOIN inserted i ON h.MaHD = i.MaHD;

    -- Cập nhật ChietKhau trong bảng HoaDon
    UPDATE h
    SET 
        h.ChietKhau = (
            SELECT 
                SUM(ct.ThanhTien) * 
                CASE 
                    WHEN kh.LoaiThe = N'VIP' THEN 0.02
                    WHEN kh.LoaiThe = N'Bạc' THEN 0.04
                    WHEN kh.LoaiThe = N'Vàng' THEN 0.05
                    ELSE 0
                END
            FROM ChiTietDonHang ct
            INNER JOIN HoaDon hd ON ct.MaHD = hd.MaHD
            INNER JOIN KhachHang kh ON hd.MaKH = kh.MaKH
            WHERE ct.MaHD = h.MaHD
            GROUP BY kh.LoaiThe
        )
    FROM HoaDon h
    INNER JOIN inserted i ON h.MaHD = i.MaHD;
END;

INSERT INTO ChiTietDonHang (MaCTDH, MaH, MaHD, DVT, MucGia, SoLuong, ThanhTien)
VALUES 
('CTDH030', 'HH001', 'HD001', N'Cái', 150000, 2, 300000), -- Tổng tiền = 300000
('CTDH031', 'HH002', 'HD001', N'Cái', 200000, 1, 200000); -- Tổng tiền = 200000


UPDATE ChiTietDonHang
SET SoLuong = 3, ThanhTien = 450000
WHERE MaCTDH = 'CTDH030'; -- Cập nhật chi tiết đơn hàng cho 'HH001' trong 'HD001'


DELETE FROM ChiTietDonHang
WHERE MaCTDH = 'CTDH01231'; -- Xóa chi tiết đơn hàng 'HH002' trong 'HD001'

-- Kiểm tra bảng HoaDon
SELECT * FROM HoaDon WHERE MaHD = 'HD001';

-- Kiểm tra bảng ChiTietDonHang
SELECT * FROM ChiTietDonHang WHERE MaHD = 'HD001';
