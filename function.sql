---- math function
-- for complete reference to Math function, pleASe go to https://msdn.microsoft.com/en-us/library/ms177516.ASpx
SELECT  ABS(-10), FLOOR(123.45),CEILING(123.45), DEGREES(PI()/2),RAND(10),ROUND(123.9995, 3)

-- String function

SELECT CHARINDEX('search', 'data to be search'),STR(12345.678,8,2),
CONCAT ( 'Happy ', 'Birthday ', 11, '/', '25' ) AS Result,
'Happy '+'Birthday', substring('abcde',2,2);

DECLARE @d DATETIME = '10/01/2011';
SELECT FORMAT ( @d, 'd', 'en-US' ) AS 'US English Result'
      ,FORMAT ( @d, 'd', 'en-gb' ) AS 'Great Britain English Result'
      ,FORMAT ( @d, 'd', 'de-de' ) AS 'German Result'
      ,FORMAT ( @d, 'd', 'zh-cn' ) AS 'Simplified Chinese (PRC) Result';

select left('abcd',2), substring('abcd',1,2),right('abcd',2) , substring('abcde',len('abcd')-1,2),upper('abcd'),lower('Abcd')

---- Date time functions
--- sql server specific date time
SELECT SYSDATETIME(), SYSDATETIMEOFFSET(),SYSUTCDATETIME();

--- ANSI SQL
SELECT CURRENT_TIMESTAMP;

SELECT DATENAME(YEAR,CURRENT_TIMESTAMP)

--- Date part

SELECT DATEPART(YEAR,CURRENT_TIMESTAMP), YEAR(current_timestamp), DATEPART(MONTH,CURRENT_TIMESTAMP),MONTH(CURRENT_TIMESTAMP), DATEPART(DAY,CURRENT_TIMESTAMP), DAY(CURRENT_TIMESTAMP);

SET LANGUAGE N'Français';
go
SELECT DATENAME(YEAR,CURRENT_TIMESTAMP), DATENAME(MONTH,CURRENT_TIMESTAMP), DATENAME(DAY,CURRENT_TIMESTAMP),DATENAME(weekday,CURRENT_TIMESTAMP);
SET LANGUAGE N'日本語';
go
SELECT DATENAME(YEAR,CURRENT_TIMESTAMP), DATENAME(MONTH,CURRENT_TIMESTAMP), DATENAME(DAY,CURRENT_TIMESTAMP),DATENAME(weekday,CURRENT_TIMESTAMP);
SET LANGUAGE N'繁體中文';
go
SELECT DATENAME(YEAR,CURRENT_TIMESTAMP), DATENAME(MONTH,CURRENT_TIMESTAMP), DATENAME(DAY,CURRENT_TIMESTAMP),DATENAME(weekday,CURRENT_TIMESTAMP);
SET LANGUAGE us_english;
go
SELECT DATENAME(YEAR,CURRENT_TIMESTAMP), DATENAME(MONTH,CURRENT_TIMESTAMP), DATENAME(DAY,CURRENT_TIMESTAMP),DATENAME(weekday,CURRENT_TIMESTAMP);

--- ADD DATE
SELECT DATEADD(month, 1, '2006-08-30'),DATEADD(DAY, 1, '2006-08-30'),DATEADD(YEAR, -1, '2006-08-30');

--- CAST AND CONVERT
--https://msdn.microsoft.com/en-us/library/ms187928.ASpx
SELECT CAST ('2010-01-02' AS DATETIME), CONVERT(DATETIME, '2010-01-02',120),
CONVERT(DATETIME, '01/02/2010',103),CONVERT(DATETIME, '01/02/2010',101);
select cASt(1 AS decimal(5,4)),cASt('1' AS int), cASt(1.0 AS char(10));

--- cASe statemetn and iif
DECLARE @A INT =2;
SELECT CASE @A WHEN 1 THEN '1'
WHEN 2 THEN '2'
ELSE NULL
END,
IIF(@A = 1 ,'1', IIF(@A=2,'2',NULL)),
CASE WHEN @A >0 THEN 'GREATER THAN 0'
 WHEN @A = 2 THEN '2'
 ELSE NULL
END,
IIF(@A > 0 , 'GREATER THAN 0', IIF(@A=2,'2',NULL))
;