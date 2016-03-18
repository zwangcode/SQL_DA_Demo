--- use IN to find out distinct person who are with address record
--- note: tempdb tables are not persistent.. it will disappear after logff
--- in this example, we are going to use adventure works to do the presentation.
--- look at person.businessentityaddress and person.person
--- IN will stop at the first encounter and return true .
--- Join will cause two rows return because two records match the criteria
use AdventureWorks2014;
SELECT p.*
FROM    Person.Person as p
where P.businessentityid not in (
select businessentityid
from person.BusinessEntityAddress
)
-- and p.BusinessEntityID =5668;

select p.*
from person.person p
inner join
person.BusinessEntityAddress ba
on
p.BusinessEntityID = ba.BusinessEntityID
--where p.BusinessEntityID = 5668
;

---- BE CAREFUL ABOUT THE NULL values.. Here is a sample

CREATE TABLE #TEMP1 (
ID INT ,
VAL CHAR(1))
;

INSERT INTO #TEMP1 VALUES (NULL,'0'),(1,'A'),(2,'B')
;

CREATE TABLE #TEMP2 (
ID INT ,
VAL CHAR(1))
;
INSERT INTO #TEMP2 VALUES (NULL,'0'),(1,'A');

SELECT * FROM #TEMP1;
SELECT * FROM #TEMP2;

SELECT *
FROM #TEMP1 A
WHERE ID NOT IN (SELECT ID FROM #TEMP2)
;
SELECT *
FROM #TEMP1 A
WHERE ID  IN (SELECT ID FROM #TEMP2)
;