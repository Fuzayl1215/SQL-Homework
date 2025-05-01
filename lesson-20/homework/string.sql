create database lesson20hw


-- 1. Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales 
    WHERE CustomerName = s.CustomerName 
    AND SaleDate BETWEEN '2024-03-01' AND '2024-03-31'
);

-- 2. Find the product with the highest total sales revenue using a subquery.
SELECT TOP 1 Product
FROM #Sales
GROUP BY Product
ORDER BY SUM(Quantity * Price) DESC;

-- 3. Find the second highest sale amount using a subquery
SELECT MAX(SaleAmount) AS SecondHighestSale
FROM (
    SELECT DISTINCT (Quantity * Price) AS SaleAmount
    FROM #Sales
) AS SalesSubquery
WHERE SaleAmount < (SELECT MAX(Quantity * Price) FROM #Sales);

-- 4. Find the total quantity of products sold per month using a subquery
SELECT MONTH(SaleDate) AS SaleMonth, SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY MONTH(SaleDate);

-- 5. Find customers who bought the same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName
    AND s1.Product = s2.Product
);

-- 6. Return how many fruits does each person have in individual fruit level
SELECT Name,
       SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-- 7. Return older people in the family with younger ones
SELECT f1.ParentId AS PID, f1.ChildID AS CHID
FROM Family f1
JOIN Family f2 ON f1.ParentId = f2.ParentId
WHERE f1.ChildID > f2.ChildID;

-- 8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM #Orders o
WHERE o.CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM #Orders
    WHERE DeliveryState = 'CA'
)
AND o.DeliveryState = 'TX';

-- 9. Insert the names of residents if they are missing
UPDATE #residents
SET fullname = 'Unknown Name'
WHERE fullname NOT LIKE '%name%';

-- 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
WITH RoutePaths AS (
    SELECT RouteID, DepartureCity, ArrivalCity, Cost, 
           CONCAT(DepartureCity, ' - ', ArrivalCity) AS Route
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
)
SELECT Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC;

-- 11. Rank products based on their order of insertion.
SELECT ID, ROW_NUMBER() OVER (ORDER BY ID) AS Rank
FROM #RankingPuzzle;

-- 12. Return Ids, what number of the letter would be next if inserted, the maximum length of the consecutive occurrence of the same digit
WITH ConsecutiveCounts AS (
    SELECT Id, MAX(LENGTH) AS MaxConsecutive
    FROM (
        SELECT Id, LEN(Vals) AS LENGTH
        FROM #Consecutives
        GROUP BY Id, Vals
    ) AS Subquery
)
SELECT Id, MaxConsecutive + 1 AS NextDigit
FROM ConsecutiveCounts;

-- 13. Find employees whose sales were higher than the average sales in their department
SELECT e.EmployeeName
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

-- 14. Find employees who had the highest sales in any given month using EXISTS
SELECT e.EmployeeName
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales
    WHERE SalesMonth = e.SalesMonth
    AND SalesAmount > e.SalesAmount
);

-- 15. Find employees who made sales in every month using NOT EXISTS
SELECT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales
    WHERE SalesMonth NOT IN (1,2,3,4)
    AND e.EmployeeName = e.EmployeeName
);

-- 16. Retrieve the names of products that are more expensive than the average price of all products.
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 17. Find the products that have a stock count lower than the highest stock count.
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

-- 18. Get the names of products that belong to the same category as 'Laptop'.
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop');

-- 19. Retrieve products whose price is greater than the lowest price in the Electronics category.
SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics');

-- 20. Find the products that have a higher price than the average price of their respective category.
SELECT p.Name
FROM Products p
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);

-- 21. Find the products that have been ordered at least once.
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-- 22. Retrieve the names of products that have been ordered more than the average quantity ordered.
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(SUM(o.Quantity))
    FROM Orders o
    GROUP BY o.ProductID
);

-- 23. Find the products that have never been ordered.
SELECT p.Name
FROM Products p
WHERE p.ProductID NOT IN (SELECT DISTINCT ProductID FROM Orders);

-- 24. Retrieve the product with the highest total quantity ordered.
SELECT TOP 1 p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;

-- 25. Find the products that have been ordered more times than the average number of orders placed.
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING COUNT(o.OrderID) > (
    SELECT AVG(OrderCount) 
    FROM (SELECT COUNT(OrderID) AS OrderCount FROM Orders GROUP BY ProductID) AS SubQuery
);
