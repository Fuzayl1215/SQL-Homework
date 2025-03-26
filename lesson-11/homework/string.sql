--Task 1
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d 
ON e.DepartmentID = d.DepartmentID;

--Task 2
SELECT s.StudentName, c.ClassName
FROM Students s
LEFT JOIN Classes c 
ON s.ClassID = c.ClassID;

--Task 3
SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Orders o
RIGHT JOIN Customers c 
ON o.CustomerID = c.CustomerID;

--Task 4
SELECT p.ProductName, s.SaleID, s.Quantity
FROM Products p
FULL OUTER JOIN Sales s 
ON p.ProductID = s.ProductID;

--Task 5
SELECT e1.Name AS Employee, e2.Name AS Manager
FROM Employeess e1
LEFT JOIN Employeess e2
ON e1.ManagerID = e2.EmployeeID;

--Task 6
SELECT Colors.ColorName, Sizes.SizeName
FROM Colors
CROSS JOIN Sizes;

--Task 7
SELECT Movies.Title, Movies.ReleaseYear, Actors.Name AS ActorName
FROM Movies
INNER JOIN Actors ON Movies.MovieID = Actors.MovieID
WHERE Movies.ReleaseYear > 2015;

--Task 8
SELECT Orders.OrderDate, Customers.CustomerName, OrderDetails.ProductID
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID;

--Task 9
SELECT 
    Productss.ProductName, 
    SUM(Saless.Quantity * Productss.Price) AS TotalRevenue
FROM Saless
INNER JOIN Productss ON Saless.ProductID = Productss.ProductID
GROUP BY Productss.ProductName;
