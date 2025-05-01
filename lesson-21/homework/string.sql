create database lesson21


-- 1. Assign a row number to each sale based on the SaleDate
SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-- 2. Rank products based on the total quantity sold (use DENSE_RANK())
SELECT ProductName, SUM(Quantity) AS TotalQuantitySold,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS Rank
FROM ProductSales
GROUP BY ProductName;

-- 3. Identify the top sale for each customer based on the SaleAmount
SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
       RANK() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS SaleRank
FROM ProductSales
WHERE SaleRank = 1;

-- 4. Display each sale's amount along with the next sale amount in the order of SaleDate using the LEAD() function
SELECT SaleID, ProductName, SaleDate, SaleAmount, 
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- 5. Display each sale's amount along with the previous sale amount in the order of SaleDate using the LAG() function
SELECT SaleID, ProductName, SaleDate, SaleAmount, 
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

-- 6. Rank each sale amount within each product category
SELECT SaleID, ProductName, SaleDate, SaleAmount, 
       RANK() OVER (PARTITION BY ProductName ORDER BY SaleAmount DESC) AS SaleRank
FROM ProductSales;

-- 7. Identify sales amounts that are greater than the previous sale's amount
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       CASE WHEN SaleAmount > LAG(SaleAmount) OVER (ORDER BY SaleDate) THEN 'Greater' ELSE 'Not Greater' END AS SalesComparison
FROM ProductSales;

-- 8. Calculate the difference in sale amount from the previous sale for every product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS AmountDifference
FROM ProductSales;

-- 9. Compare the current sale amount with the next sale amount in terms of percentage change
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / SaleAmount * 100 AS PercentageChange
FROM ProductSales;

-- 10. Calculate the ratio of the current sale amount to the previous sale amount within the same product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS SaleRatio
FROM ProductSales;

-- 11. Calculate the difference in sale amount from the very first sale of that product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS AmountFromFirstSale
FROM ProductSales;

-- 12. Find sales that have been increasing continuously for a product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       CASE WHEN SaleAmount > LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) THEN 'Increasing' ELSE 'Not Increasing' END AS SalesTrend
FROM ProductSales;

-- 13. Calculate a "closing balance" for sales amounts which adds the current sale amount to a running total of previous sales
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ClosingBalance
FROM ProductSales;

-- 14. Calculate the moving average of sales amounts over the last 3 sales
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM ProductSales;

-- 15. Show the difference between each sale amount and the average sale amount
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DifferenceFromAverage
FROM ProductSales;

-- 16. Find employees who have the same salary rank
SELECT Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1
WHERE SalaryRank IN (
    SELECT SalaryRank
    FROM (
        SELECT DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM Employees1
    ) AS Ranks
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
);

-- 17. Identify the top 2 highest salaries in each department
SELECT EmployeeID, Name
