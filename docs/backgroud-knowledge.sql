
/*
-- Tạo bảng Students
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL
);

-- Tạo bảng Courses
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    Credits INT NOT NULL
);

-- Tạo bảng trung gian StudentCourses để thiết lập quan hệ n-n
CREATE TABLE StudentCourses (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);
ON DELETE CASCADE: Dữ liệu cha xóa thì dữ liệu ở bảng con cũng được xóa theo
*/



/* ///////////////////// INDEX /////////////////////
Trong SQL Server, **index** được sử dụng để cải thiện hiệu suất truy vấn bằng cách sắp xếp 
và lưu trữ dữ liệu theo một cách đặc biệt, giúp tăng tốc độ tìm kiếm và lọc dữ liệu.

### 1. **Các loại Index trong SQL Server**
- **Clustered Index**: Sắp xếp dữ liệu vật lý của bảng theo thứ tự chỉ mục. Một bảng chỉ có thể có **một clustered index**.
- **Non-Clustered Index**: Lưu trữ dữ liệu chỉ mục tách biệt với dữ liệu thực tế. 
	Một bảng có thể có nhiều **non-clustered index**.
- **Unique Index**: Đảm bảo rằng các giá trị trong cột được chỉ định là duy nhất.
- **Composite Index**: Chỉ mục được tạo trên nhiều cột.
- **Full-Text Index**: Được sử dụng cho tìm kiếm văn bản đầy đủ.

---

### 2. **Cú pháp tạo Index**

#### a. Tạo **Clustered Index**
```sql
CREATE CLUSTERED INDEX IDX_Clustered_StudentID
ON Students (StudentID);
```
- **`IDX_Clustered_StudentID`**: Tên của chỉ mục.
- **`Students`**: Tên bảng.
- **`StudentID`**: Cột được đánh chỉ mục.

---

#### b. Tạo **Non-Clustered Index**
```sql
CREATE NONCLUSTERED INDEX IDX_NonClustered_Email
ON Students (Email);
```

---

#### c. Tạo **Unique Index**
```sql
CREATE UNIQUE INDEX IDX_Unique_Email
ON Students (Email);
```
- Đảm bảo rằng không có giá trị trùng lặp trong cột `Email`.

---

#### d. Tạo **Composite Index** (Chỉ mục trên nhiều cột)
```sql
CREATE NONCLUSTERED INDEX IDX_Composite_FullName_Email
ON Students (FullName, Email);
```
- Thích hợp khi bạn thường truy vấn hoặc lọc dữ liệu theo cả hai cột `FullName` và `Email`.

---

#### e. Tạo **Full-Text Index**
1. Cần tạo một **Full-Text Catalog** trước:
   ```sql
   CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;
   ```
2. Sau đó tạo chỉ mục văn bản đầy đủ:
   ```sql
   CREATE FULLTEXT INDEX ON Students (FullName, Email)
   KEY INDEX IDX_Clustered_StudentID
   ON ftCatalog;
   ```
- **`KEY INDEX`** yêu cầu một clustered index.

---

### 3. **Xóa Index**
Dùng lệnh `DROP INDEX` để xóa:
```sql
DROP INDEX IDX_Clustered_StudentID
ON Students;
```

---

### 4. **Kiểm tra Index**
Để xem tất cả các index trên một bảng:
```sql
EXEC sp_helpindex 'Students';
```

---

### 5. **Ví dụ Thực Tế**
Giả sử bạn có bảng `Orders` với các cột `OrderID`, `CustomerID`, và `OrderDate`. 
Bạn thường xuyên truy vấn dữ liệu dựa trên `CustomerID` và `OrderDate`.

#### Tạo chỉ mục:
```sql
CREATE NONCLUSTERED INDEX IDX_Orders_Customer_OrderDate
ON Orders (CustomerID, OrderDate);
```

#### Truy vấn mẫu:
```sql
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 123
  AND OrderDate > '2025-01-01';
```

---
*/



/* ///////////////////// VIEW /////////////////////
**View** trong SQL Server là một đối tượng cơ sở dữ liệu ảo, đại diện cho một tập hợp kết quả của một câu truy vấn SQL. 
Nó được sử dụng để đơn giản hóa các truy vấn phức tạp, bảo mật dữ liệu, và cung cấp một giao diện dữ liệu tùy chỉnh.

---

### 1. **Cú pháp Tạo View**
```sql
CREATE VIEW ViewName AS
SELECT Column1, Column2, ...
FROM TableName
WHERE Condition;
```

---

### 2. **Ví dụ về View**

#### a. Tạo View cơ bản
Giả sử bạn có bảng `Students` với các cột `StudentID`, `FullName`, `Email`, `BirthDate`. 
Bạn muốn hiển thị danh sách sinh viên và chỉ cần các cột `FullName` và `Email`.

```sql
CREATE VIEW View_StudentInfo AS
SELECT FullName, Email
FROM Students;
```

- **Sử dụng View**:
```sql
SELECT * FROM View_StudentInfo;
```

---

#### b. View với điều kiện
Chỉ hiển thị sinh viên có năm sinh từ 2000 trở đi:
```sql
CREATE VIEW View_StudentsBornAfter2000 AS
SELECT StudentID, FullName, BirthDate
FROM Students
WHERE YEAR(BirthDate) >= 2000;
```

---

#### c. View với JOIN
Giả sử bạn có bảng `Students` và `Courses` với bảng trung gian `StudentCourses`. 
Bạn muốn tạo View hiển thị sinh viên cùng khóa học mà họ đăng ký.

```sql
CREATE VIEW View_StudentCourses AS
SELECT 
    s.FullName AS StudentName,
    c.CourseName AS Course
FROM 
    Students s
JOIN 
    StudentCourses sc ON s.StudentID = sc.StudentID
JOIN 
    Courses c ON sc.CourseID = c.CourseID;
```

- **Sử dụng View**:
```sql
SELECT * FROM View_StudentCourses;
```

---

### 3. **Cập nhật View**

#### a. Thay đổi View
Nếu bạn cần thay đổi định nghĩa của View:
```sql
ALTER VIEW ViewName AS
SELECT Column1, Column2, ...
FROM TableName
WHERE Condition;
```

#### b. Xóa View
Nếu không cần sử dụng View nữa:
```sql
DROP VIEW ViewName;
```

---

### 4. **Sử dụng View để Cập nhật Dữ liệu**
Trong một số trường hợp, bạn có thể sử dụng View để thêm, sửa, xóa dữ liệu 
(nếu View được tạo trên một bảng duy nhất và không sử dụng các phép toán như `GROUP BY`, `DISTINCT`, hoặc `JOIN`).

#### Ví dụ:
```sql
CREATE VIEW View_UpdateStudents AS
SELECT StudentID, FullName, Email
FROM Students;
```

- **Cập nhật thông qua View**:
```sql
UPDATE View_UpdateStudents
SET Email = 'new_email@example.com'
WHERE StudentID = 1;
```

---

### 5. **Kiểm tra View**
Để xem định nghĩa của View:
```sql
EXEC sp_helptext 'ViewName';
```

Để liệt kê tất cả các View trong cơ sở dữ liệu:
```sql
SELECT name 
FROM sys.views;
```

---

### 6. **Ưu và Nhược Điểm của View**

#### **Ưu điểm:**
1. **Đơn giản hóa truy vấn**: Dễ dàng truy vấn dữ liệu phức tạp.
2. **Tăng cường bảo mật**: Hạn chế quyền truy cập trực tiếp vào bảng gốc.
3. **Dễ dàng quản lý**: Thay đổi định nghĩa View mà không cần thay đổi ứng dụng sử dụng View.
4. **Tái sử dụng truy vấn**: Không phải lặp lại các câu truy vấn phức tạp.

#### **Nhược điểm:**
1. **Không lưu trữ dữ liệu**: View không lưu dữ liệu thực tế, chỉ là kết quả của truy vấn.
2. **Hiệu suất**: Nếu View phức tạp hoặc dữ liệu lớn, hiệu suất truy vấn có thể giảm.
3. **Giới hạn chỉnh sửa**: Không thể cập nhật dữ liệu qua View nếu View sử dụng `JOIN`, `GROUP BY`, hoặc `DISTINCT`.

*/


/* ///////////////////// STORE PROCEDURE /////////////////////
**Stored Procedure** trong SQL Server là một tập hợp các câu lệnh SQL được lưu trữ trên máy chủ, 
giúp bạn thực hiện các tác vụ lặp lại hoặc phức tạp. Nó được sử dụng để cải thiện hiệu suất, quản lý logic nghiệp vụ, 
và tăng cường tính bảo mật.

---

### 1. **Cú pháp Tạo Stored Procedure**
```sql
CREATE PROCEDURE ProcedureName
    @Parameter1 DataType,
    @Parameter2 DataType = DefaultValue
AS
BEGIN
    -- Các câu lệnh SQL
    SELECT Column1, Column2
    FROM TableName
    WHERE Column3 = @Parameter1;
END;
```

- **`@Parameter1`**: Là tham số truyền vào.
- **`DataType`**: Kiểu dữ liệu của tham số.
- **`DefaultValue`**: Giá trị mặc định nếu không truyền tham số.

---

### 2. **Ví dụ về Stored Procedure**

#### a. Stored Procedure Đơn Giản
Hiển thị danh sách sinh viên:
```sql
CREATE PROCEDURE GetStudents
AS
BEGIN
    SELECT StudentID, FullName, Email
    FROM Students;
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC GetStudents;
```

---

#### b. Stored Procedure với Tham Số
Lấy thông tin sinh viên theo `StudentID`:
```sql
CREATE PROCEDURE GetStudentByID
    @StudentID INT
AS
BEGIN
    SELECT StudentID, FullName, Email
    FROM Students
    WHERE StudentID = @StudentID;
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC GetStudentByID @StudentID = 1;
```

---

#### c. Stored Procedure với Giá Trị Mặc Định
Lấy danh sách sinh viên theo năm sinh, mặc định là `2000`:
```sql
CREATE PROCEDURE GetStudentsByBirthYear
    @BirthYear INT = 2000
AS
BEGIN
    SELECT StudentID, FullName, BirthDate
    FROM Students
    WHERE YEAR(BirthDate) = @BirthYear;
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC GetStudentsByBirthYear;         -- Sử dụng giá trị mặc định
EXEC GetStudentsByBirthYear 1995;   -- Truyền tham số
```

---

#### d. Stored Procedure với INSERT
Thêm sinh viên mới:
```sql
CREATE PROCEDURE AddStudent
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @BirthDate DATE
AS
BEGIN
    INSERT INTO Students (FullName, Email, BirthDate)
    VALUES (@FullName, @Email, @BirthDate);
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC AddStudent 
    @FullName = 'Nguyen Van A',
    @Email = 'a@example.com',
    @BirthDate = '2001-01-01';
```

---

#### e. Stored Procedure với UPDATE
Cập nhật email của sinh viên:
```sql
CREATE PROCEDURE UpdateStudentEmail
    @StudentID INT,
    @NewEmail NVARCHAR(100)
AS
BEGIN
    UPDATE Students
    SET Email = @NewEmail
    WHERE StudentID = @StudentID;
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC UpdateStudentEmail @StudentID = 1, @NewEmail = 'new_email@example.com';
```

---

#### f. Stored Procedure với DELETE
Xóa sinh viên theo `StudentID`:
```sql
CREATE PROCEDURE DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Students
    WHERE StudentID = @StudentID;
END;
```
- **Thực thi Stored Procedure**:
```sql
EXEC DeleteStudent @StudentID = 1;
```

---

### 3. **Quản lý Stored Procedure**

#### a. Xem Danh Sách Stored Procedure
```sql
SELECT name 
FROM sys.procedures;
```

#### b. Xem Định Nghĩa của Stored Procedure
```sql
EXEC sp_helptext 'ProcedureName';
```

#### c. Sửa Stored Procedure
```sql
ALTER PROCEDURE ProcedureName
AS
BEGIN
    -- Định nghĩa mới
END;
```

#### d. Xóa Stored Procedure
```sql
DROP PROCEDURE ProcedureName;
```

---

### 4. **Lợi Ích của Stored Procedure**
1. **Hiệu suất**: Tăng tốc độ thực thi nhờ lưu trữ kế hoạch thực thi (execution plan).
2. **Tính bảo mật**: Hạn chế truy cập trực tiếp vào bảng cơ sở dữ liệu.
3. **Tái sử dụng**: Lập trình viên có thể tái sử dụng logic SQL đã được định nghĩa.
4. **Dễ bảo trì**: Thay đổi logic tại một nơi mà không cần cập nhật nhiều nơi.

*/


/* ///////////////////// FUNCTION ///////////////////// 
**Function** trong SQL Server là một đối tượng cơ sở dữ liệu được sử dụng để thực hiện các tác vụ tính toán, 
thao tác trên dữ liệu, và trả về một giá trị duy nhất (Scalar Function) hoặc một tập kết quả (Table-Valued Function). 
Functions giúp tái sử dụng logic trong các truy vấn SQL.

---

### 1. **Phân loại Functions**
SQL Server hỗ trợ hai loại Function chính:

1. **Scalar Function**: Trả về một giá trị duy nhất (ví dụ: `INT`, `VARCHAR`, `DATE`).
2. **Table-Valued Function (TVF)**: Trả về một tập hợp dữ liệu (bảng).

---

### 2. **Scalar Function**

#### a. **Cú pháp Tạo Scalar Function**
```sql
CREATE FUNCTION FunctionName (@Parameter1 DataType, @Parameter2 DataType)
RETURNS ReturnDataType
AS
BEGIN
    DECLARE @Result ReturnDataType;

    -- Logic xử lý
    SET @Result = <Biểu thức hoặc giá trị>;

    RETURN @Result;
END;
```

#### b. **Ví dụ**
Tạo một hàm trả về tổng số ngày giữa hai ngày:
```sql
CREATE FUNCTION GetDaysDifference(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate);
END;
```

- **Sử dụng**:
```sql
SELECT dbo.GetDaysDifference('2025-01-01', '2025-01-10') AS DaysDifference;
```

---

### 3. **Inline Table-Valued Function**

#### a. **Cú pháp Tạo Inline TVF**
```sql
CREATE FUNCTION FunctionName (@Parameter1 DataType, @Parameter2 DataType)
RETURNS TABLE
AS
RETURN
(
    SELECT Column1, Column2
    FROM TableName
    WHERE Condition
);
```

#### b. **Ví dụ**
Tạo một hàm trả về danh sách sinh viên theo năm sinh:
```sql
CREATE FUNCTION GetStudentsByYear(@BirthYear INT)
RETURNS TABLE
AS
RETURN
(
    SELECT StudentID, FullName, BirthDate
    FROM Students
    WHERE YEAR(BirthDate) = @BirthYear
);
```

- **Sử dụng**:
```sql
SELECT * FROM dbo.GetStudentsByYear(2000);
```

---

### 4. **Multi-Statement Table-Valued Function**

#### a. **Cú pháp Tạo Multi-Statement TVF**
```sql
CREATE FUNCTION FunctionName (@Parameter1 DataType, @Parameter2 DataType)
RETURNS @ResultTable TABLE
(
    Column1 DataType,
    Column2 DataType
)
AS
BEGIN
    -- Logic xử lý
    INSERT INTO @ResultTable
    SELECT Column1, Column2
    FROM TableName
    WHERE Condition;

    RETURN;
END;
```

#### b. **Ví dụ**
Tạo hàm trả về danh sách sinh viên và số năm kể từ ngày sinh:
```sql
CREATE FUNCTION GetStudentInfo(@BirthYear INT)
RETURNS @ResultTable TABLE
(
    StudentID INT,
    FullName NVARCHAR(100),
    YearsSinceBirth INT
)
AS
BEGIN
    INSERT INTO @ResultTable
    SELECT 
        StudentID,
        FullName,
        DATEDIFF(YEAR, BirthDate, GETDATE()) AS YearsSinceBirth
    FROM Students
    WHERE YEAR(BirthDate) = @BirthYear;

    RETURN;
END;
```

- **Sử dụng**:
```sql
SELECT * FROM dbo.GetStudentInfo(2000);
```

---

### 5. **Quản lý Functions**

#### a. Xem Danh Sách Functions
```sql
SELECT name 
FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF');
```

- `FN`: Scalar Function
- `IF`: Inline Table-Valued Function
- `TF`: Multi-Statement Table-Valued Function

#### b. Xem Định Nghĩa của Function
```sql
EXEC sp_helptext 'FunctionName';
```

#### c. Sửa Function
```sql
ALTER FUNCTION FunctionName
AS
BEGIN
    -- Định nghĩa mới
END;
```

#### d. Xóa Function
```sql
DROP FUNCTION FunctionName;
```

---

### 6. **Ưu và Nhược Điểm của Functions**

#### **Ưu điểm:**
1. **Tái sử dụng**: Có thể sử dụng lại logic đã được định nghĩa nhiều lần.
2. **Tính mô-đun**: Tách biệt logic tính toán, dễ bảo trì.
3. **Tăng hiệu suất**: Đặc biệt với các phép toán hoặc truy vấn lặp lại.
4. **Bảo mật**: Hạn chế truy cập trực tiếp vào bảng cơ sở dữ liệu.

#### **Nhược điểm:**
1. **Giới hạn cập nhật**: Functions không thể thay đổi dữ liệu (không sử dụng được `INSERT`, `UPDATE`, `DELETE`).
2. **Hiệu suất thấp hơn Stored Procedure**: Functions có thể chậm hơn nếu xử lý phức tạp.

*/


/* ///////////////////// TRIGGER /////////////////////
Trigger trong SQL Server là một loại **stored procedure đặc biệt** được tự động thực thi khi có một 
sự kiện cụ thể xảy ra trên một bảng hoặc một view, chẳng hạn như khi thực hiện các thao tác **INSERT**,
**UPDATE**, hoặc **DELETE**.

### **Phân loại Trigger trong SQL Server**
1. **DML Trigger (Data Manipulation Language Trigger):** 
   - Kích hoạt khi có thao tác **INSERT**, **UPDATE**, hoặc **DELETE** trên bảng hoặc view.
2. **DDL Trigger (Data Definition Language Trigger):**
   - Kích hoạt khi có các thao tác thay đổi cấu trúc dữ liệu như **CREATE**, **ALTER**, **DROP**.
3. **LOGON Trigger:**
   - Kích hoạt khi một phiên đăng nhập (logon) vào SQL Server xảy ra.

---

### **Cấu trúc cơ bản của Trigger DML**
Trigger DML thường được sử dụng nhất, với cấu trúc cơ bản như sau:

```sql
CREATE TRIGGER [Tên_Trigger]
ON [Tên_Bảng]
AFTER [INSERT | UPDATE | DELETE]
AS
BEGIN
    -- Các logic xử lý
    PRINT 'Trigger đã được kích hoạt'
END;
```

---

### **Ví dụ chi tiết về Trigger**
#### 1. **Trigger ghi log khi thêm dữ liệu**
Khi có thêm dữ liệu vào bảng `HangHoa`, trigger sẽ tự động ghi log vào bảng `LogHangHoa`.

##### Tạo bảng `LogHangHoa`:
```sql
CREATE TABLE LogHangHoa (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaH NVARCHAR(50),
    TenH NVARCHAR(100),
    ActionTime DATETIME DEFAULT GETDATE(),
    Action NVARCHAR(50)
);
```

##### Tạo Trigger:
```sql
CREATE TRIGGER trg_InsertLogHangHoa
ON HangHoa
AFTER INSERT
AS
BEGIN
    INSERT INTO LogHangHoa (MaH, TenH, Action)
    SELECT MaH, TenH, N'INSERT'
    FROM INSERTED;
END;
```

##### Mô tả:
- Trigger được kích hoạt sau khi thêm dữ liệu vào bảng `HangHoa`.
- Bảng `INSERTED` là bảng tạm (virtual table), chứa các bản ghi mới được thêm vào.

---

#### 2. **Trigger kiểm tra dữ liệu khi UPDATE**
Giả sử bạn muốn ngăn việc cập nhật giá trị `NULL` trong cột `TenH` của bảng `HangHoa`.

##### Tạo Trigger:
```sql
CREATE TRIGGER trg_PreventNullTenH
ON HangHoa
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE TenH IS NULL)
    BEGIN
        RAISERROR (N'Tên hàng không được để trống.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
```

##### Mô tả:
- Trigger kiểm tra nếu có bản ghi nào cập nhật cột `TenH` thành `NULL`. Nếu có, giao dịch bị hủy với 
thông báo lỗi.

---

#### 3. **Trigger đồng bộ dữ liệu khi DELETE**
Nếu một hàng bị xóa khỏi bảng `HangHoa`, các dòng chi tiết liên quan trong bảng `ChiTietDonHang` cũng 
sẽ bị xóa.

##### Tạo Trigger:
```sql
CREATE TRIGGER trg_DeleteChiTietDonHang
ON HangHoa
AFTER DELETE
AS
BEGIN
    DELETE FROM ChiTietDonHang
    WHERE MaH IN (SELECT MaH FROM DELETED);
END;
```

##### Mô tả:
- Bảng `DELETED` chứa các bản ghi bị xóa khỏi bảng `HangHoa`.
- Trigger tự động xóa các dòng trong `ChiTietDonHang` có liên quan.

---

### **Sử dụng bảng tạm `INSERTED` và `DELETED`
- `INSERTED`: Chứa các bản ghi **mới** được thêm hoặc cập nhật.
- `DELETED`: Chứa các bản ghi **cũ** bị xóa hoặc được cập nhật (trước khi thay đổi).

---

### **Lưu ý khi sử dụng Trigger**
1. **Hiệu năng:** Trigger có thể ảnh hưởng đến hiệu suất nếu logic phức tạp hoặc áp dụng trên bảng lớn.
2. **Không trả kết quả:** Trigger không trả dữ liệu cho ứng dụng gọi, nên không thể sử dụng trực tiếp
để hiển thị dữ liệu.
3. **Tránh vòng lặp vô hạn:** Sử dụng trigger cẩn thận để tránh việc một trigger kích hoạt chính nó
hoặc các trigger khác (recursive trigger).
*/