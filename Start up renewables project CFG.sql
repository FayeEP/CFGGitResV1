-- Creation of tables and input --
-- This is a database for a renewables start up business managing finance and client details -- 
-- HIGHLIGHT code from line 7 to line 204 to create the database, then queries are from 205 up to line 379-- 

-- Select * from Project --

Create database Renewables;

-- Client creation and data insert--
use Renewables;

CREATE TABLE Client (
Client_ID INT UNIQUE,
Client_Name  VARCHAR(50),
City VARCHAR(50),
CONSTRAINT pk_Client_ID 
Primary Key 
(Client_ID)
);

insert into Client
(Client_ID, Client_Name, City)
VALUES
(001, 'Sun Energy', 'London'),
(002, 'Future Wind', 'Berlin'),
(003, 'Renewables', 'London'),
(004, 'Project Solar', 'Madrid'),
(005, 'Project Wind', 'Paris'),
(006, 'Solar and Wind', 'Milan'),
(007, 'Low Carbon', 'Rome'),
(008, 'Green Future', 'Madrid');


-- Managers creation and data insert--

use Renewables;

CREATE TABLE Managers(
Manager_ID CHAR(4)NOT NULL UNIQUE,
Manager_Name  VARCHAR(50),
Technical_ID CHAR(2)NOT NULL,
CONSTRAINT pk_Manager_ID
Primary Key 
(Manager_ID)
);

insert into Managers
(Manager_ID, Manager_Name, Technical_ID)
VALUES
('PM01', 'Barry', 'SO'),
('PM02', 'Claire', 'WI'),
('PM03', 'Tom', 'HY'),
('PM04', 'Kate', 'WI'),
('PM05', 'Sarah', 'SO'),
('PM06', 'John', 'WI'),
('PM07', 'Terry', 'SO'),
('PM08', 'Jo', 'HY')
;

-- Technical creation and data insert--

CREATE TABLE Technical (
Technical_ID CHAR(2)NOT NULL UNIQUE,
Technical_Name  VARCHAR(10),
CONSTRAINT PK_Technical_ID
Primary Key 
(Technical_ID)
);

insert into Technical
(Technical_ID, Technical_Name)
VALUES
('SO', 'Solar'),
('WI', 'Wind'),
('HY', 'Hydro');


-- Invoice creation and data insert--

CREATE TABLE Invoice (
Invoice_Num CHAR(6)NOT NULL UNIQUE,
Invoice_Amount INT,
Client_ID  INT,
Project_ID CHAR(4)NOT NULL,
Manager_ID CHAR(4)NOT NULL,
CONSTRAINT pk_Invoice_Num
Primary Key 
(Invoice_Num)
);

insert into Invoice
(Invoice_Num, Invoice_Amount, Client_ID, Project_ID, Manager_ID)
VALUES
('INV001', 500, 002, 'P001', 'PM02'),
('INV002', 10000, 004, 'P002', 'PM01'),
('INV003', 14000, 004, 'P003', 'PM01'),
('INV004', 850, 001, 'P004', 'PM05'),
('INV005', 25000, 001, 'P005', 'PM05'),
('INV006', 15000, 003, 'P006', 'PM03'),
('INV007', 2000, 003, 'P007', 'PM04'),
('INV008', 150, 003, 'P007', 'PM04');



-- Project creation and data insert --

CREATE TABLE Project (
Project_ID CHAR(4)NOT NULL UNIQUE,
Project_Name  VARCHAR(50),
Location VARCHAR(50),
Client_ID INT,
Technical_ID CHAR(2)NOT NULL,
Manager_ID CHAR(4)NOT NULL,
CONSTRAINT pk_Project_ID 
Primary Key 
(Project_ID)
);

insert into Project
(Project_ID, Project_Name, Location, Client_ID, Technical_ID, Manager_ID)
VALUES
('P001', 'North Sea Wind', 'Scotland', 002, 'WI', 'PM02'),
('P002', 'Spanish Solar', 'Spain', 004, 'SO', 'PM01'),
('P003', 'Madrid Solar', 'Spain', 004, 'SO', 'PM01'),
('P004', 'Costal Solar', 'England', 001, 'SO', 'PM05'),
('P005', 'Southampton Fields', 'England', 001, 'SO', 'PM05'),
('P006', 'Wales Power', 'Wales', 003, 'HY', 'PM03'),
('P007', 'Highland Project', 'Scotland', 003, 'WI', 'PM04'),
('P008', 'Southern Wind Fields', 'England', 002, 'WI', 'PM04'),
('P009', 'Coastal Wind', 'England', 003, 'WI', 'PM06'),
('P010', 'Future Fields', 'Spain', 002, 'WI', 'PM06');

-- Adding FK section --

-- Manager--

Alter Table Managers
Add Constraint
FK_Technical_ID
Foreign Key 
(Technical_Id)
References
Technical 
(Technical_ID);

-- Invoice --

Alter Table Invoice
Add Constraint
FK_Client_ID
Foreign Key 
(Client_Id)
References
Client 
(Client_ID);

Alter Table Invoice
Add Constraint
FK_Manager_ID
Foreign Key 
(Manager_Id)
References
Managers
(Manager_ID);

Alter Table Invoice
Add Constraint
FK_Project_ID
Foreign Key 
(Project_Id)
References
Project
(Project_ID);


-- Project --

Alter Table Project
Add Constraint
FK1_Client_ID
Foreign Key 
(Client_Id)
References
Client 
(Client_ID);

Alter Table Project
Add Constraint
FK1_Technical_ID
Foreign Key 
(Technical_ID)
References
Technical 
(Technical_ID);

Alter Table Project
Add Constraint
FK1_Manager_ID
Foreign Key 
(Manager_Id)
References
Managers
(Manager_ID);


--  Queries with Joins x3 --
-- adding Manager Name to Invoice table -- 

SELECT * FROM Invoice
Left JOIN Managers
on 
Invoice.Manager_ID = Managers.Manager_ID
Order By invoice.Manager_ID
;


SELECT * FROM Client
Right JOIN Invoice
on 
Client.Client_ID = Invoice.Client_ID
Order by Client.client_id
;


SELECT * FROM Invoice
Left JOIN Project
on 
Invoice.Project_ID = Project.Project_ID
Order by invoice.invoice_Num
;


--  5 Queries to retrieve data with Order By --
-- 1. select query based on location --
SELECT 
    *
FROM
    Project
WHERE
    Location = 'England'
Order by 
    project.Project_ID DESC
    ;
    
-- 2. select query based on Technical  --

    
Select Project_ID, Manager_ID, Project_Name

From Project 

WHERE TECHNICAL_ID = 'WI'

ORDER BY Project_Name ASC;
        
-- 3. building on queries -- 

SELECT 
    *
FROM
    Project
WHERE
    Technical_ID = 'SO'
        AND (Location = 'England'
        OR Location = 'Spain')
        
Order by Location ASC;   

   -- 4. Testing a Sub-Query--
   -- select invoice amounts by ascending price-- 
   SELECT * FROM Invoice
WHERE Invoice_amount < (SELECT AVG(Invoice_amount) FROM Invoice)
Order BY Invoice_amount ASC;

   SELECT Project_ID, Invoice_num, Invoice_Amount FROM Invoice
WHERE Invoice_amount < (SELECT AVG(Invoice_amount) FROM Invoice);

-- 5. Query --
   
   SELECT 
    Manager_ID, SUM(Invoice_Amount) AS 'revenue'
FROM
    Invoice
GROUP BY Manager_ID 
ORDER BY Manager_ID;



-- two queires to aggregate functions -- 


Select Count(Project_Name) as 'Number of Projects'
From Renewables.Project;

Select AVG(Invoice_Amount) as 'Average Value of Invoicing'
From Renewables.Invoice;

-- Use at least two additional in-built functions (to the two aggregate functions already counted in the previous point) -- 

Select Client_ID,
Count(Project_Name) as 'Number of Projects'
From Renewables.Project
Where Technical_ID = 'WI'
Group by Client_Id;

-- Client data search --

SELECT 
sum(invoice_amount) as 'invoice amount by client',
Count(invoice_Num) as 'total invoices'
From Invoice
Where Client_Id > 000
Group by Client_id;


-- Testing Views Functions -- 

CREATE VIEW Client_Invoice AS
SELECT Client_ID, Invoice_num
FROM Invoice
WHERE Manager_ID = 'PM05';

Select * 
from client_invoice

-- User Created Function to value projects  -- 

DELIMITER //
CREATE FUNCTION Client_Value (Invoice_Amount INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
DECLARE Value_Range VARCHAR(20);
IF Invoice_Amount > 1000 THEN
SET Value_Range = 'High';
ELSEIF (Invoice_Amount < 1000) THEN
SET Value_Range = 'Mid';
END IF;
RETURN (Value_Range);
END //
DELIMITER ;

Select * ,
Client_Value (Invoice_amount) AS Value_to_Business from Invoice

Order by Client_ID;

-- Query with the functiion in it -- 

select Invoice_Amount, 
Invoice_num,
Client_ID,
Client_Value(Invoice_Amount) as 'Range'
From invoice;


-- User created procedure Client Invoices by Client ID --

DELIMITER //
Create PROCEDURE Client_Invoicing (In id CHAR(4))
Begin
    SELECT * FROM Invoice
    Where Client_ID = id;
 END //
DELIMITER ;

Call Client_Invoicing (001);
Call Client_Invoicing (004);


-- one query to delete data --
-- please remove the dashes and run the query -- 
-- run select all to see the table and scroll down to project_id P010 to see the data field that will be deleted -- 

Select * from Project

-- delete query Please remove the lines to run the delete query --
DELETE FROM Project WHERE Project_ID = 'P010';

-- run the next select to see it gone on the table --

select * from Project
