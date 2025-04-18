create database lesson3hw

--easy

--1. BULK INSERT is used to import large volumes of data from a file (like .csv or .txt) directly into a SQL Server table.

--Purpose:
--Fast and efficient way to load data.

--Often used in data warehousing and ETL (Extract, Transform, Load) processes.

--2.
--.CSV – Comma Separated Values

--.TXT – Plain text files

--.XML – Extensible Markup Language

--.JSON – JavaScript Object Notation (via OPENJSON or import tools)

--3.
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);

--4.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
(1, 'Laptop', 799.99),
(2, 'Smartphone', 499.50),
(3, 'Keyboard', 49.99);
select * from Products

--5.
--NULL- Represents missing or unknown data. No value assigned.

--NOT NULL- Ensures that a column must have a value. Cannot be left empty.
-- This column can have empty values
ProductDescription VARCHAR(100) NULL,

-- This column must always have a value
ProductName VARCHAR(50) NOT NULL

--6.
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

--7.
-- This query selects all products with price above $100
SELECT * FROM Products
WHERE Price > 100;

--8.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

--9.
--The IDENTITY property is used to auto-generate incremental numbers for a column, usually for primary keys.

--Purpose:
--Automatically assigns a unique ID to each new row.

--Avoids manual input of primary key values.
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE
);


--medium

--10.
BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',   -- Columns separated by comma
    ROWTERMINATOR = '\n',    -- Each row ends with a new line
    FIRSTROW = 2             -- Skip header row
);

--11.
ALTER TABLE Products
ADD CategoryID INT;

ALTER TABLE Products
ADD CONSTRAINT FK_Category
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);
select * from Products

--12.
Feature       | PRIMARY KEY                    | UNIQUE KEY
Uniqueness    | Must be unique                 | Must be unique
Null values   | Cannot have NULL values        | Can have one NULL value
One per table | Only one primary key per table | Can have multiple unique keys
Main purpose  | Identify records uniquely      | Prevent duplicate values

-- PRIMARY KEY
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- UNIQUE KEY
ALTER TABLE Students
ADD CONSTRAINT UQ_Name UNIQUE (Name);
select * from Students

--13.
ALTER TABLE Products
ADD CONSTRAINT CHK_Pricegraterthanzero CHECK (Price > 0);

--14.
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

--15.
SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

--16.
--Purpose:
--To maintain referential integrity between two tables.

--Ensures that a value in one table must exist in another table (parent table).

-- Products.CategoryID must exist in Categories.CategoryID
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)


--hard

--17.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Age INT CHECK (Age >= 18)
);

--18.
CREATE TABLE Invoice (
    InvoiceID INT IDENTITY(100,10) PRIMARY KEY,
    Amount DECIMAL(10,2)
);

--19.
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

--20.
SELECT ISNULL(PhoneNumber, 'Not Provided') AS Contact
FROM Customers;

SELECT COALESCE(Mobile, HomePhone, 'No Contact') AS PrimaryContact
FROM Customers;


--Difference:

ISNULL only allows 2 parameters; COALESCE accepts multiple.

COALESCE is ANSI SQL standard, while ISNULL is SQL Server-specific.

--21.
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

--22.
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FullName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) 
        REFERENCES Departments(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
