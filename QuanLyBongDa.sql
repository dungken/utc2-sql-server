CREATE DATABASE FootballDB;
GO

USE FootballDB;
GO


-- Tạo bảng San
CREATE TABLE San (
    MaSan NVARCHAR(10) PRIMARY KEY,
    TenSan NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL
);
GO

-- Tạo bảng Doi
CREATE TABLE Doi (
    MaDoi NVARCHAR(10) PRIMARY KEY,
    TenDoi NVARCHAR(100) NOT NULL
);
GO

-- Tạo bảng TranDau
CREATE TABLE TranDau (
    MaTD NVARCHAR(10) PRIMARY KEY,
    MaSan NVARCHAR(10),
    Ngay DATE NOT NULL,
    Gio TIME NOT NULL,
    FOREIGN KEY (MaSan) REFERENCES San(MaSan)
);
GO

-- Tạo bảng CT_TranDau
CREATE TABLE CT_TranDau (
    MaTD NVARCHAR(10),
    MaDoi NVARCHAR(10),
    SoBanThang INT CHECK (SoBanThang >= 0),
    PRIMARY KEY (MaTD, MaDoi),
    FOREIGN KEY (MaTD) REFERENCES TranDau(MaTD),
    FOREIGN KEY (MaDoi) REFERENCES Doi(MaDoi)
);
GO
-- Nhập dữ liệu cho bảng San
INSERT INTO San (MaSan, TenSan, DiaChi) VALUES
('MDI', N'Mỹ Đình', N'Hà Nội – Việt Nam'),
('NAS', N'Sân vận động quốc gia Viêng Chăn', N'Lào'),
('IMO', N'Sân I-Mobile Buriram', N'Thái Lan'),
('MOD', N'Khu thể thao Morodok', N'Campuchia');
GO

-- Nhập dữ liệu cho bảng Doi
INSERT INTO Doi (MaDoi, TenDoi) VALUES
('VN', N'Việt Nam'),
('LA', N'Lào'),
('TL', N'Thái Lan'),
('CPC', N'Campuchia');
GO

-- Nhập dữ liệu cho bảng TranDau
INSERT INTO TranDau (MaTD, MaSan, Ngay, Gio) VALUES
('01', 'MOD', '2017-08-14', '15:00:00'),
('02', 'NAS', '2017-08-16', '17:00:00'),
('03', 'MOD', '2017-08-16', '15:00:00'),
('04', 'IMO', '2017-08-18', '19:00:00');
GO

-- Nhập dữ liệu cho bảng CT_TranDau
INSERT INTO CT_TranDau (MaTD, MaDoi, SoBanThang) VALUES
('01', 'VN', 3),
('01', 'TL', 1),
('02', 'VN', 5),
('02', 'LA', 0),
('03', 'TL', 3),
('03', 'CPC', 3),
('04', 'TL', 2),
('04', 'LA', 0);
GO


CREATE TABLE Log_San (
    MaSan NVARCHAR(10),
    Action NVARCHAR(10),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Log_Doi (
    MaDoi NVARCHAR(10),
    Action NVARCHAR(10),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Log_TranDau (
    MaTD NVARCHAR(10),
    Action NVARCHAR(10),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Log_CT_TranDau (
    MaTD NVARCHAR(10),
    MaDoi NVARCHAR(10),
    Action NVARCHAR(10),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO


CREATE TRIGGER trg_Log_San
ON San
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action NVARCHAR(10)

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'

    INSERT INTO Log_San (MaSan, Action)
    SELECT MaSan, @action FROM 
    (SELECT MaSan FROM inserted UNION SELECT MaSan FROM deleted) AS Changes;
END;


GO
CREATE TRIGGER trg_Log_Doi
ON Doi
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action NVARCHAR(10)

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'

    INSERT INTO Log_Doi (MaDoi, Action)
    SELECT MaDoi, @action FROM 
    (SELECT MaDoi FROM inserted UNION SELECT MaDoi FROM deleted) AS Changes;
END;


GO
CREATE TRIGGER trg_Log_TranDau
ON TranDau
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action NVARCHAR(10)

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'

    INSERT INTO Log_TranDau (MaTD, Action)
    SELECT MaTD, @action FROM 
    (SELECT MaTD FROM inserted UNION SELECT MaTD FROM deleted) AS Changes;
END;


GO
CREATE TRIGGER trg_Log_CT_TranDau
ON CT_TranDau
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action NVARCHAR(10)

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'

    INSERT INTO Log_CT_TranDau (MaTD, MaDoi, Action)
    SELECT MaTD, MaDoi, @action FROM 
    (SELECT MaTD, MaDoi FROM inserted UNION SELECT MaTD, MaDoi FROM deleted) AS Changes;
END;
GO

-- In số trận đấu mà mỗi đội đã thi đấu. Hiển thị: MaDoi, TenDoi.
SELECT D.MaDoi, D.TenDoi, COUNT(CT.SoBanThang) AS SoTranDaThiDau
FROM Doi D
LEFT JOIN CT_TranDau CT ON D.MaDoi = CT.MaDoi
GROUP BY D.MaDoi, D.TenDoi;


--In kết quả trận đấu theo tỷ số:
SELECT T.MaTD AS MaTran, 
       CONCAT(D1.TenDoi, '-', D2.TenDoi) AS 'Đội trận đấu', 
       CONCAT(SUM(CT1.SoBanThang), '-', SUM(CT2.SoBanThang) ) AS 'Tỷ số'
FROM TranDau T
JOIN CT_TranDau CT1 ON T.MaTD = CT1.MaTD AND CT1.MaDoi IN (SELECT MaDoi FROM Doi WHERE MaDoi IN (SELECT MaDoi FROM CT_TranDau WHERE MaTD = T.MaTD))
JOIN CT_TranDau CT2 ON T.MaTD = CT2.MaTD AND CT2.MaDoi <> CT1.MaDoi
JOIN Doi D1 ON CT1.MaDoi = D1.MaDoi
JOIN Doi D2 ON CT2.MaDoi = D2.MaDoi
GROUP BY T.MaTD, D1.TenDoi, D2.TenDoi;


--In kết quả mỗi trận theo điểm:
SELECT CT.MaTD AS MaTran, 
       D.TenDoi AS Doi, 
       CT.SoBanThang AS Diem
FROM CT_TranDau CT
JOIN Doi D ON CT.MaDoi = D.MaDoi;


--In mã đội, tên đội, tổng số điểm:
SELECT D.MaDoi, 
       D.TenDoi, 
       SUM(CT.SoBanThang) AS TongDiem
FROM Doi D
LEFT JOIN CT_TranDau CT ON D.MaDoi = CT.MaDoi
GROUP BY D.MaDoi, D.TenDoi;


--Sắp xếp danh sách các đội để biết thứ hạng:
SELECT D.MaDoi, 
       D.TenDoi, 
       SUM(CT.SoBanThang) AS TongDiem,
       SUM(CT.SoBanThang) - (SELECT SUM(SoBanThang) FROM CT_TranDau WHERE MaTD IN (SELECT MaTD FROM TranDau WHERE MaTD = CT.MaTD) AND MaDoi <> D.MaDoi) AS HieuSoBanThang
FROM Doi D
LEFT JOIN CT_TranDau CT ON D.MaDoi = CT.MaDoi
GROUP BY D.MaDoi, D.TenDoi
ORDER BY TongDiem DESC, HieuSoBanThang DESC;


--Hiển thị các trận chưa đá:
SELECT DISTINCT CONCAT(D1.TenDoi, ' - ', D2.TenDoi) AS 'Các trận chưa đá'
FROM Doi D1
CROSS JOIN Doi D2
WHERE D1.MaDoi <> D2.MaDoi 
  AND NOT EXISTS (SELECT * FROM TranDau T WHERE (T.MaSan IS NULL OR T.Gio IS NULL));
