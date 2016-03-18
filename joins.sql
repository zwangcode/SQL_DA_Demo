 --- inner join example

SELECT p.PERSON_ID,
addr.ADDRESS_ID,
p.FIRST_NAME,
p.LAST_NAME,
p.MIDDLE_NAME,
p.DOB,
pa.ADDRESS_TYPE_CD,
addr.STREET_LINE1,
addr.STREET_LINE2,
addr.CITY,
addr.STATE,
addr.ZIP_CODE
FROM mslearn.person p
INNER JOIN
mslearn.PERSON_ADDRESS pa
ON
p.person_id = pa.person_id
INNER JOIN
mslearn.address addr
ON
pa.ADDRESS_ID = addr.ADDRESS_ID
WHERE p.PERSON_ID >=2995 and p.person_id <=2996
order by p.PERSON_ID,addr.ADDRESS_ID

--- left outer join sample
SELECT p.PERSON_ID,
addr.ADDRESS_ID,
p.FIRST_NAME,
p.LAST_NAME,
p.MIDDLE_NAME,
p.DOB,
pa.ADDRESS_TYPE_CD,
addr.STREET_LINE1,
addr.STREET_LINE2,
addr.CITY,
addr.STATE,
addr.ZIP_CODE
FROM mslearn.person p
LEFT OUTER JOIN
mslearn.PERSON_ADDRESS pa
ON
p.person_id = pa.person_id
LEFT OUTER JOIN
mslearn.address addr
ON
pa.ADDRESS_ID = addr.ADDRESS_ID
WHERE p.person_id < 10
order by p.PERSON_ID,addr.ADDRESS_ID
;

--- left outer join sample 2 find out how many person who do not have address record

SELECT sum(1.0)
FROM MSLEARN.PERSON P
LEFT OUTER JOIN
MSLEARN.PERSON_ADDRESS PA
ON
P.PERSON_ID = PA.PERSON_ID
WHERE PA.PERSON_ID IS NULL
;
--- why sum(1.0)????

-- full outer join sample
select * into #PERSON_A FROM MSLEARN.PERSON WHERE PERSON_ID >=1 AND PERSON_ID <=10;
select * into #PERSON_B FROM MSLEARN.PERSON WHERE PERSON_ID >=5 AND PERSON_ID <=15;
SELECT *
FROM #PERSON_A A
FULL OUTER JOIN
#PERSON_B B
ON
A.PERSON_ID = B.PERSON_ID