DROP DATABASE QuanLyCty;

CREATE DATABASE QuanLyCty;
GO

USE QuanLyCty;
GO
-- Bảng NHACUNGCAP
CREATE TABLE NHACUNGCAP (
    id_nha_cung_cap INT IDENTITY(1,1) PRIMARY KEY,
    ten_nha_cung_cap NVARCHAR(255) NOT NULL,
    dia_chi NVARCHAR(255),
    dien_thoai NVARCHAR(15),
    email NVARCHAR(100) CHECK (email LIKE '%_@__%.__%')
);
GO

-- Bảng LOAIHANG
CREATE TABLE LOAIHANG (
    id_loai_hang INT IDENTITY(1,1) PRIMARY KEY,
    ten_loai_hang NVARCHAR(255) NOT NULL
);
GO

-- Bảng MATHANG
CREATE TABLE MATHANG (
    id_mat_hang INT IDENTITY(1,1) PRIMARY KEY,
    ten_mat_hang NVARCHAR(255) NOT NULL,
    gia DECIMAL(10, 2) NOT NULL CHECK (gia >= 0),
    so_luong INT NOT NULL CHECK (so_luong >= 0),
    id_loai_hang INT FOREIGN KEY REFERENCES LOAIHANG(id_loai_hang),
    id_nha_cung_cap INT FOREIGN KEY REFERENCES NHACUNGCAP(id_nha_cung_cap)
);
GO

-- Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    id_nhan_vien INT IDENTITY(1,1) PRIMARY KEY,
    ten_nhan_vien NVARCHAR(255) NOT NULL,
    chuc_vu NVARCHAR(100),
    luong DECIMAL(10, 2) NOT NULL CHECK (luong >= 0)
);
GO

-- Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    id_khach_hang INT IDENTITY(1,1) PRIMARY KEY,
    ten_khach_hang NVARCHAR(255) NOT NULL,
    dia_chi NVARCHAR(255),
    dien_thoai NVARCHAR(15),
    email NVARCHAR(100) CHECK (email LIKE '%_@__%.__%')
);
GO

-- Bảng DONDATHANG
CREATE TABLE DONDATHANG (
    id_don_dat_hang INT IDENTITY(1,1) PRIMARY KEY,
    ngay_dat_hang DATETIME NOT NULL,
    id_nhan_vien INT FOREIGN KEY REFERENCES NHANVIEN(id_nhan_vien),
    id_khach_hang INT FOREIGN KEY REFERENCES KHACHHANG(id_khach_hang),
    noigiaohang NVARCHAR(255),
    ngaychuyendat DATETIME
);
GO

-- Bảng CHITIETDATHANG
CREATE TABLE CHITIETDATHANG (
    id_chi_tiet_don_dat_hang INT IDENTITY(1,1) PRIMARY KEY,
    id_don_dat_hang INT FOREIGN KEY REFERENCES DONDATHANG(id_don_dat_hang),
    id_mat_hang INT FOREIGN KEY REFERENCES MATHANG(id_mat_hang),
    so_luong INT NOT NULL CHECK (so_luong > 0),
    gia DECIMAL(10, 2) NOT NULL CHECK (gia >= 0)
);
GO

-- Bảng nhật ký cho NHACUNGCAP
CREATE TABLE LOG_NHACUNGCAP (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_nha_cung_cap INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO



-- Bảng nhật ký cho LOAIHANG
CREATE TABLE LOG_LOAIHANG (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_loai_hang INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO

-- Bảng nhật ký cho MATHANG
CREATE TABLE LOG_MATHANG (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_mat_hang INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO

-- Bảng nhật ký cho NHANVIEN
CREATE TABLE LOG_NHANVIEN (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_nhan_vien INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO

-- Bảng nhật ký cho KHACHHANG
CREATE TABLE LOG_KHACHHANG (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO

-- Bảng nhật ký cho DONDATHANG
CREATE TABLE LOG_DONDATHANG (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_don_dat_hang INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO

-- Bảng nhật ký cho CHITIETDATHANG
CREATE TABLE LOG_CHITIETDATHANG (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_chi_tiet_don_dat_hang INT,
    action NVARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    user_name NVARCHAR(100)
);
GO


-- Trigger cho NHACUNGCAP
CREATE TRIGGER trg_LogNhacungcap
ON NHACUNGCAP
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_NHACUNGCAP (id_nha_cung_cap, action, user_name)
        SELECT id_nha_cung_cap, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_NHACUNGCAP (id_nha_cung_cap, action, user_name)
        SELECT id_nha_cung_cap, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_NHACUNGCAP (id_nha_cung_cap, action, user_name)
        SELECT id_nha_cung_cap, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho LOAIHANG
CREATE TRIGGER trg_LogLoaithang
ON LOAIHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_LOAIHANG (id_loai_hang, action, user_name)
        SELECT id_loai_hang, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_LOAIHANG (id_loai_hang, action, user_name)
        SELECT id_loai_hang, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_LOAIHANG (id_loai_hang, action, user_name)
        SELECT id_loai_hang, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho MATHANG
CREATE TRIGGER trg_LogMathang
ON MATHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_MATHANG (id_mat_hang, action, user_name)
        SELECT id_mat_hang, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_MATHANG (id_mat_hang, action, user_name)
        SELECT id_mat_hang, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_MATHANG (id_mat_hang, action, user_name)
        SELECT id_mat_hang, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho NHANVIEN
CREATE TRIGGER trg_LogNhanvien
ON NHANVIEN
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_NHANVIEN (id_nhan_vien, action, user_name)
        SELECT id_nhan_vien, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_NHANVIEN (id_nhan_vien, action, user_name)
        SELECT id_nhan_vien, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_NHANVIEN (id_nhan_vien, action, user_name)
        SELECT id_nhan_vien, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho KHACHHANG
CREATE TRIGGER trg_LogKhachhang
ON KHACHHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_KHACHHANG (id_khach_hang, action, user_name)
        SELECT id_khach_hang, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_KHACHHANG (id_khach_hang, action, user_name)
        SELECT id_khach_hang, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_KHACHHANG (id_khach_hang, action, user_name)
        SELECT id_khach_hang, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho DONDATHANG
CREATE TRIGGER trg_LogDondathang
ON DONDATHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_DONDATHANG (id_don_dat_hang, action, user_name)
        SELECT id_don_dat_hang, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_DONDATHANG (id_don_dat_hang, action, user_name)
        SELECT id_don_dat_hang, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_DONDATHANG (id_don_dat_hang, action, user_name)
        SELECT id_don_dat_hang, 'DELETE', @user_name FROM deleted;
    END
END;
GO

-- Trigger cho CHITIETDATHANG
CREATE TRIGGER trg_LogChitietdathang
ON CHITIETDATHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @user_name NVARCHAR(100) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_CHITIETDATHANG (id_chi_tiet_don_dat_hang, action, user_name)
        SELECT id_chi_tiet_don_dat_hang, 'INSERT', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_CHITIETDATHANG (id_chi_tiet_don_dat_hang, action, user_name)
        SELECT id_chi_tiet_don_dat_hang, 'UPDATE', @user_name FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_CHITIETDATHANG (id_chi_tiet_don_dat_hang, action, user_name)
        SELECT id_chi_tiet_don_dat_hang, 'DELETE', @user_name FROM deleted;
    END
END;
GO


-- Truy van CSDL

