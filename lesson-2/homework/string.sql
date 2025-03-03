create database school
Use school
create table Salesman (saleasman_id INT, Name varchar(15), city varchar(20), comission float)
insert into Salesman values 
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lausen Hen', 'San Jose', 0.12)
alter table Salesman 
drop salesman_id, name, city, comission




select * from Salesman;
select 'This is SQL Exercise, Practice and Solution';
select 1 as column1, 2 as column2, 3 as column3;
select 10+15;
select 0+1;
select name, comission from Salesman;
create table orders (ord_no int,   purch_amt float,   ord_date date,    customer_id int,  salesman_id int);


insert into orders values 
(70001,    150.5,       '2012-10-05',  3005,        5002),
(70002,    65.26,       '2012-10-05',  3002,        5001),
(70004,    110.5,       '2012-08-17',  3009,        5003),
(70007,    948.5,       '2012-09-10',  3005,        5002),
(70005,    2400.6,      '2012-07-27',  3007,        5001),
(70008,    5760,        '2012-09-10',  3002,        5001),
(70010,    1983.43,     '2012-10-10',  3004,        5006),
(70003,    2480.4,      '2012-10-10',  3009,        5003),
(70012,    250.45,      '2012-06-27',  3008,        5002)
select * from orders;
SELECT name, city 
FROM Salesman 
WHERE city = 'Paris';
create table customer (customer_id int,   cust_name varchar(25),    city varchar(20),  grade int,  salesman_id int)
insert into customer values
        (3002,  'Nick Rimando',    'New York',      100,         5001),
        (3007,  'Brad Davis',      'New York',      200,         5001),
        (3005,  'Graham Zusi',     'California',    200,         5002),
        (3008,  'Julian Green',    'London',        300,         5002),
        (3004,  'Fabian Johnson',  'Paris',         300,         5006),
        (3009,  'Geoff Cameron',   'Berlin',        100,         5003),
        (3003,  'Jozy Altidor',    'Moscow',        200,         5007),
        (3001,  'Brad Guzan',      'London',         0,          5005)
select * from customer;
SELECT customer_id, cust_name, city, grade, salesman_id  
FROM customer  
WHERE grade = 200;
SELECT ord_no, ord_date, purch_amt  
FROM orders  
WHERE salesman_id = 5001;
drop table nobel_win
create table nobel_win (year int, subject varchar(15), winner varchar(25), country varchar(10), Category varchar(15))
insert into nobel_win values 
(1970, 'Physics',                   'Hannes Alfven',                                 'Sweden',                 'Scientist'),
(1970, 'Physics',                   'Louis Neel',                                    'France',                 'Scientist'),
(1970, 'Chemistry',                 'Luis Federico Leloir',                          'France',                 'Scientist'),
(1970, 'Physiology',                'Ulf von Euler',                                 'Sweden',                 'Scientist'),
(1970, 'Physiology',                'Bernard Katz',                                  'Germany',                'Scientist'),
(1970, 'Literature',                'Aleksandr Solzhenitsyn',                        'Russia',                 'Linguist'),
(1970, 'Economics',                 'Paul Samuelson',                                'USA',                    'Economist'),
(1970, 'Physiology',                'Julius Axelrod',                                'USA',                    'Scientist'),
(1971, 'Physics',                   'Dennis Gabor',                                  'Hungary',                'Scientist'),
(1971, 'Chemistry',                 'Gerhard Herzberg',                              'Germany',                'Scientist'),
(1971, 'Peace',                     'Willy Brandt',                                  'Germany',                'Chancellor'),
(1971, 'Literature',                'Pablo Neruda',                                  'Chile',                  'Linguist'),
(1971, 'Economics',                 'Simon Kuznets',                                 'Russia',                 'Economist'),
(1978, 'Peace',                     'Anwar al-Sadat',                                'Egypt',                  'President'),
(1978, 'Peace',                     'Menachem Begin',                                'Israel',                 'Prime Minister'),
(1987, 'Chemistry',                 'Donald J. Cram',                                'USA',                    'Scientist'),
(1987, 'Chemistry',                 'Jean-Marie Lehn',                               'France',                 'Scientist'),
(1987, 'Physiology',                'Susumu Tonegawa',                               'Japan ',                 'Scientist'),
(1994, 'Economics',                 'Reinhard Selten',                               'Germany',                'Economist'),
(1994, 'Peace',                     'Yitzhak Rabin',                                 'Israel',                 'Prime Minister'),
(1987, 'Physics',                   'Johannes Georg Bednorz',                        'Germany',                'Scientist'),
(1987, 'Literature',                'Joseph Brodsky',                                'Russia',                 'Linguist'),
(1987, 'Economics',                 'Robert Solow',                                  'USA',                    'Economist'),
(1994, 'Literature',                'Kenzaburo Oe',                                  'Japan',                  'Linguist')
select * from nobel_win
SELECT year, subject, winner  
FROM nobel_win  
WHERE year = 1970;


SELECT winner  
FROM nobel_win  
WHERE year = 1971  
AND subject = 'Literature';

SELECT year, subject  
FROM nobel_win 
WHERE winner = 'Dennis Gabor';

select winner
from nobel_win
where subject = 'Physics'
AND year > 1950;


SELECT year, subject, winner, country  
FROM nobel_win  
WHERE subject = 'Chemistry'  
AND year BETWEEN 1965 AND 1975;


SELECT *  
FROM nobel_win  
WHERE category = 'Prime Minister'  
AND year > 1972  
AND winner IN ('Menachem Begin', 'Yitzhak Rabin');

SELECT year, subject, winner, country, category  
FROM nobel_win  
WHERE winner LIKE 'Louis%';



SELECT year, subject, winner, country, category  
FROM nobel_win  
WHERE (subject = 'Physics' AND year = 1970)  
   OR (subject = 'Economics' AND year = 1971);


select *
from nobel_win
where year = 1970
and subject NOT IN ('Economics',  'Physiology');



select *
from nobel_win
where (subject = 'Physiology' and year < 1971)
union 
(select * from nobel_win where (subject = 'Peace' and year >= 1974))


select *
from nobel_win
where winner = 'Johannes Georg Bednorz'



SELECT year, subject, winner, country, category  
FROM nobel_win  
WHERE subject NOT LIKE 'P%'  
ORDER BY year DESC, winner ASC;


select *
from nobel_win
where year = 1970
ORDER BY  
CASE  
WHEN subject IN ('Chemistry', 'Economics') THEN 1  -- Move these to the end  
ELSE 0  
END,  
subject ASC;


create table item_mast (PRO_ID int, PRO_NAME varchar(20), PRO_PRICE decimal, PRO_COM int)
insert into item_mast values
(101,     'Mother Board',                    3200.00,         15),
(102,     'Key Board',                        450.00,         16),
(103,     'ZIP drive',                        250.00,         14),
(104,     'Speaker',                          550.00,         16),
(105,     'Monitor',                         5000.00,         11),
(106,     'DVD drive',                        900.00,         12),
(107,     'CD drive',                         800.00,         12),
(108,     'Printer',                         2600.00,         13),
(109,     'Refill cartridge',                 350.00,         13),
(110,     'Mouse',                            250.00,         12)
select * from item_mast;

select *
from item_mast
where PRO_PRICE between 200.00 and 600.00


select AVG(PRO_PRICE) as avg_price
from item_mast
where PRO_COM = 16


SELECT pro_name AS "Item Name", 
       pro_price AS "Price in Rs."
FROM item_mast;


select pro_name, pro_price
from item_mast
where PRO_PRICE >= 250.00
order by PRO_PRICE desc, PRO_NAME asc;


SELECT PRO_COM AS company_code, 
       AVG(PRO_PRICE) AS avg_price
FROM item_mast
GROUP BY PRO_COM;


select PRO_NAME, PRO_PRICE
from item_mast
WHERE PRO_PRICE = (SELECT MIN(PRO_PRICE) FROM item_mast);


create table emp_details (EMP_IDNO varchar(10), EMP_FNAME varchar(10), EMP_LNAME varchar(10), EMP_DEPT int)
insert into emp_details values 
 (127323,  'Michale',         'Robbin',                  57),
 (526689,  'Carlos',          'Snares',                  63),
 (843795,  'Enric',           'Dosio',                   57),
 (328717,  'Jhon',            'Snares',                  63),
 (444527,  'Joseph',          'Dosni',                   47),
 (659831,  'Zanifer',         'Emily',                   47),
 (847674,  'Kuleswar',        'Sitaraman',               57),
 (748681,  'Henrey',          'Gabriel',                 47),
 (555935,  'Alex',            'Manuel',                  57),
 (539569,  'George',          'Mardy',                   27),
 (733843,  'Mario',           'Saule',                   63),
 (631548,  'Alan',            'Snappy',                   27),
 (839139,  'Maria',           'Foster',                   57)
 select * from emp_details;

 select distinct emp_lname 
 from emp_details;


 select *
 from emp_details
 where EMP_LNAME = 'Snares'; 


 select *
 from emp_details
 where EMP_DEPT = 57;
