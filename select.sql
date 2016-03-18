USE tempdb;

--- simple select sample with where clause
SELECT * FROM mslearn.person WHERE person_id < 100;

--- simple group by sample with count
SELECT dob, COUNT(*) FROM mslearn.PERSON
GROUP BY dob
ORDER BY dob;

--- group by multiple columns
SELECT datepart(YEAR,dob) AS birth_year,
COUNT(*) AS CNT
FROM mslearn.PERSON
GROUP BY datepart(YEAR,dob)
ORDER BY datepart(YEAR,dob)
;

--- group by multiple columns with where clause
SELECT datepart(YEAR,dob) AS birth_year,
datepart(MONTH,dob) AS birth_month,
COUNT(*) AS CNT
FROM mslearn.PERSON
WHERE datepart(YEAR,dob) <= 1980
GROUP BY datepart(YEAR,dob),datepart(MONTH,dob)
ORDER BY birth_year,birth_month
;

--- NULLs are not included in the computation of aggregate functions.
--- this sample shows the interesting/confusing side effect of NULL

DROP TABLE #TEMP;
CREATE TABLE #TEMP (
ID INT,
VAL INT
);
INSERT INTO #TEMP VALUES(1,10);
INSERT INTO #TEMP VALUES(1,20);
INSERT INTO #TEMP VALUES(1,NULL);

INSERT INTO #TEMP VALUES(2,10);
INSERT INTO #TEMP VALUES(2,20);

INSERT INTO #TEMP VALUES(3,NULL);
INSERT INTO #TEMP VALUES(3,NULL);

--- read the result set and think about why the AVG value looks strange for the group which id= 1
SELECT ID, SUM(VAL) AS val_sum, AVG(VAL) AS val_avg, MIN(VAL) AS val_min,MAX(VAL) AS val_max,COUNT(*) AS CNT
FROM #TEMP
GROUP BY ID;