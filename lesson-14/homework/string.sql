EASY TASKS
-- 1. Split Name and Surname (TestMultipleColumns)
SELECT Id, 
       LEFT(Name, CHARINDEX(',', Name) - 1) AS Name, 
       LTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name))) AS Surname
FROM TestMultipleColumns;

-- 2. Find strings containing % (TestPercent)
SELECT * FROM TestPercent
WHERE Strs LIKE '%[%]%';

-- 3. Split string based on dot (Splitter)
SELECT Id, 
       PARSENAME(REPLACE(Vals, '.', '.'), 3) AS Part1,
       PARSENAME(REPLACE(Vals, '.', '.'), 2) AS Part2,
       PARSENAME(REPLACE(Vals, '.', '.'), 1) AS Part3
FROM Splitter;

-- 4. Replace all integers with 'X'
DECLARE @str VARCHAR(100) = '1234ABC123456XYZ1234567890ADS';
SELECT @str AS Original,
       TRANSLATE(@str, '0123456789', REPLICATE('X', 10)) AS Replaced;

-- 5. Rows with more than two dots (testDots)
SELECT * FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

-- 6. Count occurrences of substring (example: count 'a')
SELECT texts,
       LEN(texts) - LEN(REPLACE(texts, 'a', '')) AS Count_a
FROM CountSpaces;

-- 7. Count spaces in the string (CountSpaces)
SELECT texts,
       LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- 8. Employees earning more than their managers
SELECT e1.Name AS Employee, e1.Salary, e2.Name AS Manager, e2.Salary AS ManagerSalary
FROM Employee e1
JOIN Employee e2 ON e1.ManagerId = e2.Id
WHERE e1.Salary > e2.Salary;

-- MEDIUM TASKS
-- 1. Separate numbers and characters (SeperateNumbersAndCharcters)
SELECT Value,
       LEFT(Value, PATINDEX('%[^0-9]%', Value + 'A') - 1) AS Numbers,
       SUBSTRING(Value, PATINDEX('%[^0-9]%', Value + 'A'), LEN(Value)) AS Characters
FROM SeperateNumbersAndCharcters;

-- 2. Dates with higher temperature than previous day (weather)
SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 ON DATEDIFF(DAY, w2.RecordDate, w1.RecordDate) = 1
WHERE w1.Temperature > w2.Temperature;

-- 3. First logged in device per player (Activity)
SELECT a.player_id, a.device_id
FROM Activity a
JOIN (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
) AS firsts ON a.player_id = firsts.player_id AND a.event_date = firsts.first_login;

-- 4. First login date per player (Activity)
SELECT player_id, MIN(event_date) AS FirstLogin
FROM Activity
GROUP BY player_id;

-- 5. Return 3rd item from comma separated list (fruits)
SELECT fruit_list,
       TRIM(value) AS ThirdItem
FROM (
    SELECT fruit_list,
           STRING_SPLIT(fruit_list, ',') WITH ORDINALITY
    FROM fruits
) AS split(fruit_list, value, position)
WHERE position = 3;

-- 6. Convert string into rows (char per row)
DECLARE @string VARCHAR(100) = 'sdgfhsdgfhs@121313131';
WITH Numbers AS (
    SELECT TOP (LEN(@string)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master..spt_values
)
SELECT SUBSTRING(@string, n, 1) AS Character
FROM Numbers;

-- 7. Replace p1.code = 0 with p2.code
SELECT p1.id, 
       CASE WHEN p1.code = 0 THEN p2.code ELSE p1.code END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

-- 8. Week-on-week percentage by area (WeekPercentagePuzzle)
SELECT Area, [Date], SalesLocal, SalesRemote, DayName, FinancialWeek,
       1.0 * ISNULL(SalesLocal,0) / NULLIF(SUM(ISNULL(SalesLocal,0)) OVER(PARTITION BY FinancialWeek, Area), 0) * 100 AS LocalPct,
       1.0 * ISNULL(SalesRemote,0) / NULLIF(SUM(ISNULL(SalesRemote,0)) OVER(PARTITION BY FinancialWeek, Area), 0) * 100 AS RemotePct
FROM WeekPercentagePuzzle;

-- DIFFICULT TASKS
-- 1. Swap first two letters in comma separated string (MultipleVals)
SELECT Id,
       STUFF(Vals, 1, CHARINDEX(',', Vals + ','), RIGHT(LEFT(Vals, CHARINDEX(',', Vals + ',') - 1),1)) + ',' + LEFT(LEFT(Vals, CHARINDEX(',', Vals + ',') - 1),1) +
       SUBSTRING(Vals, CHARINDEX(',', Vals + ','), LEN(Vals)) AS Swapped
FROM MultipleVals;

-- 2. All same characters and length > 1 (FindSameCharacters)
SELECT *
FROM FindSameCharacters
WHERE LEN(Vals) > 1 AND LEN(Vals) = LEN(REPLACE(Vals, LEFT(Vals,1), '')) + 1;

-- 3. Remove duplicate ints and single int chars (RemoveDuplicateIntsFromNames)
SELECT DISTINCT PawanName,
       LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name)-1) AS Name
FROM RemoveDuplicateIntsFromNames;

-- 4. (Repeat) All same characters and length > 1
-- Already solved above.

-- 5. Extract integer from start of string (GetIntegers)
SELECT Id,
       LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'A') - 1) AS IntegerPart
FROM GetIntegers
WHERE VALS LIKE '[0-9]%';
