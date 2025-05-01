create database lesson23hw


-- Puzzle 1: Extract Month with Leading Zero
SELECT 
    Id, 
    Dt, 
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR), 2) AS MonthPrefixedWithZero
FROM Dates;

-- Puzzle 2: Unique Ids & SUM of Max vals
SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) x
GROUP BY rID;

-- Puzzle 3: Lengths Between 6 and 10
SELECT * 
FROM TestFixLengths 
WHERE LEN(Vals) BETWEEN 6 AND 10;

-- Puzzle 4: Max Vals per ID with Item in single SELECT
SELECT ID, Item, Vals
FROM TestMaximum t
WHERE (ID, Vals) IN (
    SELECT ID, MAX(Vals)
    FROM TestMaximum
    GROUP BY ID
);

-- Puzzle 5: Sum of Max Vals by Id
SELECT Id, SUM(MaxVal) AS SumofMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVal
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) x
GROUP BY Id;

-- Puzzle 6: Difference Between a and b
SELECT 
    Id, 
    a, 
    b, 
    CASE WHEN a - b = 0 THEN '' ELSE CAST(a - b AS VARCHAR) END AS OUTPUT
FROM TheZeroPuzzle;

-- Sales Queries

-- 7. Total revenue from all sales
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue FROM Sales;

-- 8. Average unit price of products
SELECT AVG(UnitPrice) AS AvgUnitPrice FROM Sales;

-- 9. Count of sales transactions
SELECT COUNT(*) AS TotalTransactions FROM Sales;

-- 10. Max units sold in one transaction
SELECT MAX(QuantitySold) AS MaxUnitsSold FROM Sales;

-- 11. Products sold per category
SELECT Category, SUM(QuantitySold) AS TotalSold FROM Sales GROUP BY Category;

-- 12. Total revenue per region
SELECT Region, SUM(QuantitySold * UnitPrice) AS Revenue FROM Sales GROUP BY Region;

-- 13. Total quantity sold per month
SELECT 
    FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth, 
    SUM(QuantitySold) AS TotalQty
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM');

-- 14. Product with highest total revenue
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS Revenue
FROM Sales
GROUP BY Product
ORDER BY Revenue DESC;

-- 15. Running total of revenue ordered by date
SELECT 
    SaleDate, 
    Product,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotal
FROM Sales;

-- 16. Revenue contribution by category
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS Revenue,
    ROUND(
        100.0 * SUM(QuantitySold * UnitPrice) / 
        SUM(SUM(QuantitySold * UnitPrice)) OVER (), 2
    ) AS PercentContribution
FROM Sales
GROUP BY Category;

-- Customers + Sales JOIN Queries

-- 17. Sales with customer names (Assuming join via Region)
SELECT 
    s.*, 
    c.CustomerName 
FROM Sales s
JOIN Customers c ON s.Region = c.Region;

-- 18. Customers who made no purchases
SELECT * 
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Sales s WHERE s.Region = c.Region
);

-- 19. Total revenue per customer (Region-based)
SELECT 
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS Revenue
FROM Customers c
JOIN Sales s ON c.Region = s.Region
GROUP BY c.CustomerName;

-- 20. Customer with highest revenue
SELECT TOP 1 
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS Revenue
FROM Customers c
JOIN Sales s ON c.Region = s.Region
GROUP BY c.CustomerName
ORDER BY Revenue DESC;

-- 21. Sales per customer per month
SELECT 
    c.CustomerName,
    FORMAT(s.SaleDate, 'yyyy-MM') AS SaleMonth,
    SUM(s.QuantitySold * s.UnitPrice) AS MonthlyRevenue
FROM Customers c
JOIN Sales s ON c.Region = s.Region
GROUP BY c.CustomerName, FORMAT(s.SaleDate, 'yyyy-MM');

-- Products Queries

-- 22. Products sold at least once
SELECT DISTINCT s.Product
FROM Sales s
JOIN Products p ON s.Product = p.ProductName;

-- 23. Most expensive product
SELECT TOP 1 * 
FROM Products 
ORDER BY SellingPrice DESC;

-- 24. Sales with cost price from Products table
SELECT 
    s.*, 
    p.CostPrice 
FROM Sales s
JOIN Products p ON s.Product = p.ProductName;

-- 25. Products sold above category average price
SELECT *
FROM Products p
WHERE SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = p.Category
);
