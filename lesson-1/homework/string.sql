--1. Data:
--Data refers to raw facts or figures that have not yet been processed or organized. It can include numbers, text, images, or any input that can be stored and processed by a computer.

--Database:
--A database is an organized collection of data that is stored and accessed electronically. It allows users to efficiently store, retrieve, and manage data.

--Relational Database:
--A relational database is a type of database that stores data in tables (also called relations). Each table consists of rows and columns, and relationships can be established between different tables using keys.

--Table:
--A table is a set of data elements (values) organized using a model of vertical columns and horizontal rows. Each column represents a field, and each row represents a record.

--2. Five Key Features of SQL Server:
--Data Storage and Retrieval – Efficiently stores and retrieves data for various applications.


--3. SQL Server can run in:

--Windows Authentication Mode

--Mixed Mode (Windows + SQL Server Authentication)


--Security Features – Supports user authentication, authorization, encryption, and data masking.

--Transaction Management – Supports ACID properties (Atomicity, Consistency, Isolation, Durability) for reliable transactions.

--High Availability – Offers features like Always On Availability Groups, replication, and failover clustering.

--Business Intelligence Tools – Includes built-in tools like SQL Server Reporting Services (SSRS), SQL Server Integration Services (SSIS), and SQL Server Analysis Services (SSAS).


--4. create database SchoolDB

5. create table Students
(studentid int primary key, name varchar(50), age int)


--6. --SQL Server - system which to manage database. SSMS - envirnment to use SQL server. SQL - language of this system.


--7. --1. DQL (Data Query Language):
--Purpose: Used to retrieve data from the database.

--Main Command: SELECT

--2. DML (Data Manipulation Language):
--Purpose: Used to modify data inside tables (but not the structure).

--Commands: INSERT, UPDATE, DELETE

--3. DDL (Data Definition Language):
--Purpose: Used to define or modify the structure of database objects.

--Commands: CREATE, ALTER, DROP, TRUNCATE

--4. DCL (Data Control Language):
--Purpose: Used to control access and permissions to data.

--Commands: GRANT, REVOKE

--5. TCL (Transaction Control Language):
--Purpose: Used to manage transactions (groups of SQL operations that must all succeed or fail together).

--Commands: COMMIT, ROLLBACK, SAVEPOINT

--8.
insert into Students values (1, 'Arsenal', 15),
(2, 'Barca', 5), (3, 'Bayern', 6)

--9.
RESTORE DATABASE SchoolDB  
FROM DISK = 'C:\Backup\SchoolDB.bak'  
WITH REPLACE;

--Steps:

--Right-click on Databases in Object Explorer.

--Click Restore Database…

--Choose Device, then click the ... button and add the .bak file.

--Check the Restore checkbox under the "Select the backup sets to restore".

--Go to Options, check Overwrite the existing database (WITH REPLACE) if needed.

--Click OK to start restoring.
