-- Aggregated Window Functions
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East');

-- Easy Questions
-- Compute Running Total Sales per Customer
SELECT customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS running_total_sales
FROM sales_data;

-- Count the Number of Orders per Product Category
SELECT product_category, COUNT(*) AS num_orders
FROM sales_data
GROUP BY product_category;

-- Find the Maximum Total Amount per Product Category
SELECT product_category, MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category;

-- Find the Minimum Price of Products per Product Category
SELECT product_category, MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category;

-- Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT sale_id, order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_sales
FROM sales_data;

-- Find the Total Sales per Region
SELECT region, SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;

-- Compute the Rank of Customers Based on Their Total Purchase Amount
SELECT customer_name, SUM(total_amount) AS total_purchase_amount,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank
FROM sales_data
GROUP BY customer_name;

-- Calculate the Difference Between Current and Previous Sale Amount per Customer
SELECT customer_name, order_date, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS diff_from_previous_sale
FROM sales_data;

-- Find the Top 3 Most Expensive Products in Each Category
SELECT product_category, product_name, unit_price,
       RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rank
FROM sales_data
WHERE rank <= 3;

-- Compute the Cumulative Sum of Sales Per Region by Order Date
SELECT region, order_date, SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- Medium Questions
-- Compute Cumulative Revenue per Product Category
SELECT product_category, SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

-- Sum of Previous Values to Current Value
CREATE TABLE OneColumn (Value SMALLINT);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT Value, SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPreValues
FROM OneColumn;

-- Generate row numbers for the given data. The first row number for every partition should be an odd number.
CREATE TABLE Row_Nums (Id INT, Vals VARCHAR(10));
INSERT INTO Row_Nums VALUES (101, 'a'), (102, 'b'), (102, 'c'), (103, 'f'), (103, 'e'), (103, 'q'), (104, 'r'), (105, 'p');

SELECT Id, Vals, ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) AS RowNumber
FROM Row_Nums;

-- Find customers who have purchased items from more than one product category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- Find Customers with Above-Average Spending in Their Region
WITH region_avg AS (
    SELECT region, AVG(total_amount) AS avg_spending
    FROM sales_data
    GROUP BY region
)
SELECT s.customer_id, s.customer_name, s.total_amount, s.region
FROM sales_data s
JOIN region_avg r ON s.region = r.region
WHERE s.total_amount > r.avg_spending;

-- Rank customers based on their total spending within each region.
SELECT customer_name, region, SUM(total_amount) AS total_spending,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS rank
FROM sales_data
GROUP BY customer_name, region;

-- Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
SELECT customer_id, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- Calculate the sales growth rate (growth_rate) for each month compared to the previous month.
SELECT EXTRACT(MONTH FROM order_date) AS month, EXTRACT(YEAR FROM order_date) AS year,
       SUM(total_amount) AS total_sales,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date))) / LAG(SUM(total_amount)) OVER (ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) * 100 AS growth_rate
FROM sales_data
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date);

-- Identify customers whose total_amount is higher than their last order's total_amount.
WITH last_order AS (
    SELECT customer_id, MAX(order_date) AS last_order_date
    FROM sales_data
    GROUP BY customer_id
)
SELECT s.customer_id, s.customer_name, s.total_amount
FROM sales_data s
JOIN last_order l ON s.customer_id = l.customer_id
WHERE s.order_date = l.last_order_date
AND s.total_amount > (SELECT total_amount FROM sales_data WHERE customer_id = s.customer_id AND order_date = l.last_order_date);

-- Hard Questions
-- Identify Products that prices are above the average product price.
SELECT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- Sum of val1 and val2 for each group, place the value at the beginning of the group.
CREATE TABLE MyData (Id INT, Grp INT, Val1 INT, Val2 INT);
INSERT INTO MyData VALUES (1, 1, 30, 29), (2, 1, 19, 0), (3, 1, 11, 45), (4, 2, 0, 0), (5, 2, 100, 17);

SELECT Id, Grp, Val1, Val2,
       CASE WHEN Id = (SELECT MIN(Id) FROM MyData WHERE Grp = M.Grp) THEN (Val1 + Val2) ELSE NULL END AS Tot
FROM MyData M;

-- Sum of the cost column based on Id. Add quantities when needed.
CREATE TABLE TheSumPuzzle (ID INT, Cost INT, Quantity INT);
INSERT INTO TheSumPuzzle VALUES (1234, 12, 164), (1234, 13, 164), (1235, 100, 130), (1235, 100, 135), (1236, 12, 136);

SELECT ID, SUM(Cost) AS Cost, SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-- Generate row numbers, first row number for every partition should be even.
SELECT Id, Vals, ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) + 1 AS Changed
FROM Row_Nums;
