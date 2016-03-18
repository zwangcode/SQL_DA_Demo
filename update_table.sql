USE TEMPDB;
---- sample update, change the DOB date to another value.
--- previouse insert sample set all dob to 1965-01-01
-- here, we are updating dob by adding the result of person_id/7 to this value
--- notice: person id  is integer. integer division does not yield to any decimal values
--- it will round down to the nearest integer

UPDATE
mslearn.person
SET
dob = dateadd(DAY,person_id /7,dob)
go

----- second sample, we are building a update from query.
----- scenario: use a table contains person_id and dob value to update the matching
----- person in the person table.
------ concept of join will be covered later in SELECT section. Here just to show a sample
---- syntax of update from
------

--- create temp structure to hold data
---- any table whose tablename start with # indicate that the table is not PHYSICAL
--- after yo ulogff from the database and log back on, you will see that the #TEMP disappeared.
--- such table are usually called VOLATILE TABLE or TEMPORARY TABLE
CREATE TABLE #TEMP (
ID INT,
DOB DATE
)
GO

-- populate some data into the temp table

DECLARE @id INT = 0;
WHILE @id < 100
BEGIN
   INSERT INTO #TEMP(ID, DOB) VALUES (@id, dateadd(DAY,@id/11,'01/05/1966'));
   SET @id = @id +1;
end;

SELECT * FROM #temp;

UPDATE mslearn.person
SET dob = #temp.dob
FROM #temp
INNER JOIN
mslearn.person
ON
mslearn.person.person_id = #temp.id;
;

SELECT * FROM mslearn.person WHERE person_id < 100
;

---- simple delete sample, delete from temp table whose person_id mod 5 = 0
---- % operator is MOD, sample 5 %3 = 2    6%3 = 0
DELETE FROM #temp WHERE id % 5 = 0;
SELECT * FROM #temp;

--- similar delete join sample. Delete rows from person_address whose person id matches
--- - id in the temp table
--- joni will be covered later
DELETE A
FROM MSLEARN.PERSON_ADDRESS A
INNER JOIN
#TEMP B
ON
A.PERSON_ID = B.ID
;