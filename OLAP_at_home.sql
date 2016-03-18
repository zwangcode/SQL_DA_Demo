CREATE TABLE ELG
(
ELG_REC_ID INT,
MEM_ID INTEGER,
START_DT DATE,
END_DT DATE
)
;
GO

INSERT INTO ELG VALUES
(1,1, '2013-01-01','2013-02-28');
INSERT INTO ELG VALUES
(2,1, '2013-02-01','2013-03-28');
INSERT INTO ELG VALUES
(3,1, '2013-03-01','2013-04-28');
INSERT INTO ELG VALUES
(4,1, '2013-01-01','2013-03-28');
INSERT INTO ELG VALUES
(5,1, '2013-04-01','2013-05-28');
INSERT INTO ELG VALUES
(6,1, '2013-06-01','2013-07-28');

INSERT INTO ELG VALUES
(7,2, '2014-01-01','2014-02-28');
INSERT INTO ELG VALUES
(8,2, '2014-02-01','2014-03-28');
INSERT INTO ELG VALUES
(9,2, '2013-03-01','2013-04-28');
INSERT INTO ELG VALUES
(10,2, '2013-04-01','2013-05-28');

INSERT INTO ELG VALUES
(11,2, '2013-06-01','2013-07-28');
INSERT INTO ELG VALUES
(12,2, '2013-07-29','2013-09-28');

--- step 1.1 sort the data by id and start/end date, bring the previous
--- start end date to the current row to prepare for overlap detection
SElECT MEM_ID, START_DT, END_DT,
--ROW_NUMBER() OVER (PARTITION BY ID ORDER BY START_DT DESC, END_DT DESC) AS WNDW_ID,
--- PREV START END
MIN(START_DT) OVER (PARTITION BY MEM_ID ORDER BY START_DT, END_DT
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ) AS PREV_START_DT,

MIN(END_DT) OVER (PARTITION BY MEM_ID ORDER BY START_DT, END_DT
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ) AS PREV_END_DT
INTO #STEP1_1
FROM ELG
;

SELECT * FROM #STEP1_1 ORDER BY MEM_ID, START_DT, END_DT;

--- Step 1.2 use case statement to detect overlap
SELECT *,
CASE
WHEN  (Start_DT <= PREV_END_DT) AND (END_DT >= PREV_START_DT) THEN 0
        --- elg window started in the same month as previous window end.
            WHEN year(START_DT) * 100 + month(START_DT) =
      year(PREV_END_DT) * 100 + month(PREV_END_DT) THEN 0
ELSE 1
END AS OVLAP_FLG
INTO #STEP1
FROM #STEP1_1;

SELECT * FROM #STEP1
ORDER BY ID, START_DT, END_DT;

--- Step 2: design the variable to indicate a continousely overlap window id
--- here , we can answer the question you migth have, why we use 0 to present
--- a true condition for overlap, why not use 1????
--- answer is here, the window id we are designning here should NOT change
--- if continousely overlapping. To find continousely overlapping we have to either
--- recursively checking row by row, or we can use the following psudo code
---- SUM(case when overlapping then 0 else 1 end)
---  over (between current row and all previouse rows)
--- this cumulative sum will only change when NON-overlapping condition is found
--- therefore, design the overlapflag in step 1 = 0 saves us some typing here to
--- use case statement

SELECT A.*,
SUM(OVLAP_FLG) OVER (PARTITION BY MEM_ID
ORDER BY START_DT,END_DT
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS OVFLG_WNDW_ID
    INTO #STEP2
FROM #STEP1 A
;

SELECT * FROM #STEP2 ORDER BY MEM_ID,START_DT, END_DT;

--- Step 3: simple aggregation
---- here, we did not use simple aggregatoin, instead, we are using
---- ordered analytical function . It is just to preserve the original
---- table rows and present the results.

SELECT  B.ELG_REC_ID, B.MEM_ID, B.START_DT, B.END_DT, B.OVLAP_FLG,B.OVFLG_WNDW_ID,
MIN(START_DT) OVER (PARTITION BY B.MEM_ID, OVFLG_WNDW_ID) AS NEW_START_DT,
MAX(END_DT) OVER (PARTITION BY B.MEM_ID, OVFLG_WNDW_ID) AS NEW_END_DT
FROM #STEP2 B
ORDER BY MEM_ID, START_DT, END_DT;