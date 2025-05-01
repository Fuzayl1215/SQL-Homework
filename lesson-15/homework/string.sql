-- Easy Tasks

-- 1. Create a numbers table using a recursive query.
WITH CTE AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1
    FROM CTE
    WHERE Num < 100
)
SELECT Num FROM CTE
OPTION (MAXRECURSION 0);

-- 2. Beginning at 1, this script uses a recursive statement to double the number for each record.
WITH CTE AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num * 2
    FROM CTE
    WHERE Num < 1000
)
SELECT Num FROM CTE
OPTION (MAXRECURSION 0);

-- 3. Write a query to find the total sales per employee using a derived table. (Sales, Employees)
WITH CTE AS (
    SELECT e.EmployeeID, e.FirstName, e.LastName, ISNULL(SUM(s.SalesAmount), 0) AS TotalSales
    FROM Employees e
    LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT * FROM CTE;

-- 4. Create a CTE to find the average salary of employees. (Employees)
WITH CTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT * FROM CTE;

-- 5. Write a query using a derived table to find the highest sales for each product. (Sales, Products)
WITH CTE AS (
    SELECT p.ProductID, MAX(s.SalesAmount) AS HighestSales
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    GROUP BY p.ProductID
)
SELECT p.ProductName, CTE.HighestSales
FROM Products p
JOIN CTE ON p.ProductID = CTE.ProductID;

-- 6. Use a CTE to get the names of employees who have made more than 5 sales. (Sales, Employees)
WITH CTE AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.FirstName, e.LastName
FROM Employees e
JOIN CTE ON e.EmployeeID = CTE.EmployeeID
WHERE CTE.SalesCount > 5;

-- 7. Write a query using a CTE to find all products with sales greater than $500. (Sales, Products)
WITH CTE AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductName
FROM Products p
JOIN CTE ON p.ProductID = CTE.ProductID
WHERE CTE.TotalSales > 500;

-- 8. Create a CTE to find employees with salaries above the average salary. (Employees)
WITH CTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e
JOIN CTE ON e.Salary > CTE.AvgSalary;

-- 9. Write a query to find the total number of products sold using a derived table. (Sales, Products)
WITH CTE AS (
    SELECT ProductID, COUNT(*) AS TotalProductsSold
    FROM Sales
    GROUP BY ProductID
)
SELECT SUM(TotalProductsSold) AS TotalProductsSold FROM CTE;

-- 10. Use a CTE to find the names of employees who have not made any sales. (Sales, Employees)
WITH CTE AS (
    SELECT EmployeeID
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.FirstName, e.LastName
FROM Employees e
LEFT JOIN CTE ON e.EmployeeID = CTE.EmployeeID
WHERE CTE.EmployeeID IS NULL;

-- Medium Tasks

-- 11. This script uses recursion to calculate factorials.
WITH CTE AS (
    SELECT 1 AS n, 1 AS fact
    UNION ALL
    SELECT n + 1, fact * (n + 1)
    FROM CTE
    WHERE n < 5
)
SELECT * FROM CTE;

-- 12. This script uses recursion to calculate Fibonacci numbers.
WITH CTE AS (
    SELECT 1 AS n, 0 AS fib
    UNION ALL
    SELECT n + 1, fib + (SELECT fib FROM CTE WHERE n = CTE.n - 1)
    FROM CTE
    WHERE n < 10
)
SELECT * FROM CTE;

-- 13. This script uses recursion to split a string into rows of substrings for each character in the string. (Example)
WITH CTE AS (
    SELECT LEFT(String, 1) AS str, 1 AS pos
    FROM Example
    WHERE pos = 1
    UNION ALL
    SELECT SUBSTRING(str, pos + 1, 1), pos + 1
    FROM Example
    WHERE pos < LEN(str)
)
SELECT str FROM CTE;

-- 14. Create a CTE to rank employees based on their total sales. (Employees, Sales)
WITH CTE AS (
    SELECT e.EmployeeID, SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Employees e ON e.EmployeeID = s.EmployeeID
    GROUP BY e.EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName, CTE.TotalSales,
       RANK() OVER (ORDER BY CTE.TotalSales DESC) AS Rank
FROM Employees e
JOIN CTE ON e.EmployeeID = CTE.EmployeeID;

-- 15. Write a query using a derived table to find the top 5 employees by the number of orders made. (Employees, Sales)
WITH CTE AS (
    SELECT EmployeeID, COUNT(*) AS NumberOfSales
    FROM Sales
    GROUP BY EmployeeID
)
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, CTE.NumberOfSales
FROM Employees e
JOIN CTE ON e.EmployeeID = CTE.EmployeeID
ORDER BY CTE.NumberOfSales DESC;

-- 16. Use a CTE to calculate the sales difference between the current month and the previous month. (Sales)
WITH CTE AS (
    SELECT YEAR(SaleDate) AS Year, MONTH(SaleDate) AS Month, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT s1.Year, s1.Month, s1.TotalSales - ISNULL(s2.TotalSales, 0) AS SalesDifference
FROM CTE s1
LEFT JOIN CTE s2 ON s1.Year = s2.Year AND s1.Month = s2.Month + 1;

-- 17. Write a query using a CTE to find the sales per product category. (Sales, Products)
WITH CTE AS (
    SELECT p.CategoryID, SUM(s.SalesAmount) AS SalesPerCategory
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    GROUP BY p.CategoryID
)
SELECT * FROM CTE;

-- 18. Use a CTE to rank products based on total sales in the last year. (Sales, Products)
WITH CTE AS (
    SELECT p.ProductID, SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.SaleDate BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE()
    GROUP BY p.ProductID
)
SELECT p.ProductName, CTE.TotalSales,
       RANK() OVER (ORDER BY CTE.TotalSales DESC) AS Rank
FROM Products p
JOIN CTE ON p.ProductID = CTE.ProductID;

-- 19. Create a derived table to find employees with sales over $5000 in each quarter. (Sales, Employees)
WITH CTE AS (
    SELECT e.EmployeeID, SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
    WHERE s.SaleDate BETWEEN '2025-01-01' AND '2025-03-31'
    GROUP BY e.EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName, CTE.TotalSales
FROM Employees e
JOIN CTE ON e.EmployeeID = CTE.EmployeeID
WHERE CTE.TotalSales > 5000;

-- 20. Use a CTE to find the top 3 employees by total sales amount in the last month. (Sales, Employees)
WITH CTE AS (
    SELECT e.EmployeeID, e.FirstName, e.LastName, SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
    WHERE s.SaleDate BETWEEN '2025-04-01' AND '2025-04-30'
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT TOP 3 * FROM CTE
ORDER BY TotalSales DESC;

-- Difficult Tasks

-- 21. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence. (Example: n=5 | 1, 12, 123, 1234, 12345)
WITH CTE AS (
    SELECT '1' AS Num
    UNION ALL
    SELECT Num + CAST(LEN(Num) + 1 AS VARCHAR)
    FROM CTE
    WHERE LEN(Num) < 5
)
SELECT Num FROM CTE;

-- 22. Write a query using a CTE to find the employees who have made the most sales in the last 6 months. (Employees, Sales)
WITH CTE AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    WHERE SaleDate BETWEEN DATEADD(MONTH, -6, GETDATE()) AND GETDATE()
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName, CTE.SalesCount
FROM Employees e
JOIN CTE ON e.EmployeeID = CTE.EmployeeID
ORDER BY CTE.SalesCount DESC
LIMIT 1;

-- 23. This script uses recursion to display a running total where the sum cannot go higher than 10 or lower than 0. (Numbers)
WITH CTE AS (
    SELECT 0 AS Total
    UNION ALL
    SELECT CASE WHEN Total + 1 > 10 THEN 10 ELSE Total + 1 END
    FROM CTE
)
SELECT Total FROM CTE
WHERE Total <= 10;

-- 24. Given a table of employee shifts, and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and does not have an activity planned, label the time frame as “Work”. (Schedule, Activity)
WITH CTE AS (
    SELECT s.EmployeeID, s.ShiftStart, s.ShiftEnd, a.ActivityName
    FROM Schedule s
    LEFT JOIN Activity a ON s.EmployeeID = a.EmployeeID AND s.ShiftStart = a.ActivityStart
)
SELECT EmployeeID, ShiftStart, ShiftEnd, COALESCE(ActivityName, 'Work') AS Activity
FROM CTE;

-- 25. Create a complex query that uses both a CTE and a derived table to calculate sales totals for each department and product. (Employees, Sales, Products, Departments)
WITH CTE AS (
    SELECT e.DepartmentID, p.ProductID, SUM(s.SalesAmount) AS SalesTotal
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
    JOIN Products p ON s.ProductID = p.ProductID
    GROUP BY e.DepartmentID, p.ProductID
)
SELECT d.DepartmentName, p.ProductName, CTE.SalesTotal
FROM CTE
JOIN Departments d ON CTE.DepartmentID = d.DepartmentID
JOIN Products p ON CTE.ProductID =
