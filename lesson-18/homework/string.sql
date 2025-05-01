CREATE DATABASE LESSON18HW


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);


;CREATE PROCEDURE GetEmployeeBonuses
AS
BEGIN
    -- Step 1: Create temp table
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10, 2),
        BonusAmount DECIMAL(10, 2)
    );

    -- Step 2: Use CTE to join Employees and DepartmentBonus and calculate Bonus
    WITH CTE AS (
        SELECT 
            e.EmployeeID,
            CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
            e.Department,
            e.Salary,
            e.Salary * db.BonusPercentage / 100 AS BonusAmount
        FROM Employees e
        JOIN DepartmentBonus db ON e.Department = db.Department
    )
    INSERT INTO #EmployeeBonus
    SELECT * FROM CTE;

    -- Step 3: Return results
    SELECT * FROM #EmployeeBonus;

    -- Optional: Drop temp table if desired (SQL Server handles it automatically at the end)
    -- DROP TABLE #EmployeeBonus;
END;


CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);



-- Task 3: Perform MERGE to sync Products_Current with Products_New
MERGE Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

-- Update if ProductID matches
WHEN MATCHED THEN
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Price = source.Price

-- Insert if ProductID doesn't exist in current
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

-- Delete if ProductID no longer exists in new
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- View final state of Products_Current
SELECT * FROM Products_Current;

--Task 4
CREATE TABLE Tree (
    id INT PRIMARY KEY,
    parent_id INT
);

-- Task 4: Classify each node as 'Root', 'Leaf', or 'Inner'
WITH NodeTypes AS (
    SELECT 
        t1.id,
        CASE 
            WHEN t1.parent_id IS NULL THEN 'Root'
            WHEN t1.id NOT IN (SELECT DISTINCT parent_id FROM Tree WHERE parent_id IS NOT NULL) THEN 'Leaf'
            ELSE 'Inner'
        END AS NodeType
    FROM Tree t1
)
SELECT * FROM NodeTypes;

--Task 5
CREATE TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (user_id INT, time_stamp DATETIME, action ENUM('confirmed','timeout'));


INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');


INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');



WITH ConfirmationCounts AS (
    SELECT 
        user_id,
        SUM(CASE WHEN action = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_count,
        COUNT(*) AS total_confirmations
    FROM Confirmations
    GROUP BY user_id
),
ConfirmationRate AS (
    SELECT 
        s.user_id,
        COALESCE(cc.confirmed_count, 0) AS confirmed,
        COALESCE(cc.total_confirmations, 0) AS total,
        CASE 
            WHEN COALESCE(cc.total_confirmations, 0) = 0 THEN 0
            ELSE ROUND(COALESCE(cc.confirmed_count, 0) * 1.0 / cc.total_confirmations, 2)
        END AS confirmation_rate
    FROM Signups s
    LEFT JOIN ConfirmationCounts cc ON s.user_id = cc.user_id
)
SELECT * FROM ConfirmationRate;



--Task 6
CREATE TABLE employees11 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees11(id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);


WITH CTE AS (
    SELECT MIN(salary) AS MinSalary
    FROM employees
)
SELECT e.id, e.name, e.salary
FROM employees e
JOIN CTE ON e.salary = CTE.MinSalary;

--Task 7
-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');




;CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    -- Create a CTE to gather the product sales data
    WITH ProductSales AS (
        SELECT 
            p.ProductName,
            SUM(s.Quantity) AS TotalQuantitySold,
            SUM(s.Quantity * p.Price) AS TotalSalesAmount,
            MIN(s.SaleDate) AS FirstSaleDate,
            MAX(s.SaleDate) AS LastSaleDate
        FROM 
            Products p
        LEFT JOIN 
            Sales s ON p.ProductID = s.ProductID
        WHERE 
            p.ProductID = @ProductID
        GROUP BY 
            p.ProductName
    )
    -- Select the result from the CTE
    SELECT 
        ProductName,
        ISNULL(TotalQuantitySold, NULL) AS TotalQuantitySold,
        ISNULL(TotalSalesAmount, NULL) AS TotalSalesAmount,
        ISNULL(FirstSaleDate, NULL) AS FirstSaleDate,
        ISNULL(LastSaleDate, NULL) AS LastSaleDate
    FROM 
        ProductSales;
END;

