---CASE sample : compare the 2013 and 2014 total US sales performance by shipping to zip code
--- end result should be zip code, 2013 sale, 2014 sale and pct of change from 2013 to 2014

--- Step 1 : simple aggregation to find out the sales by year by zip code
SELECT addr.PostalCode, YEAR(ORDERDATE), SUM(SUBTOTAL)
FROM SALES.SalesOrderHeader OH
INNER JOIN
Person.Address addr
ON
OH.ShipToAddressID = addr.AddressID
INNER JOIN
Person.StateProvince sp
on
addr.StateProvinceID = sp.StateProvinceID
WHERE
YEAR(ORDERDATE) in (2013,2014) and
sp.CountryRegionCode = 'US'
GROUP BY addr.PostalCode,YEAR(ORDERDATE)
;
-- this data does not give us the result directly, more process is required,
--- for example: copy paste to excel and do a pivot table
--- limitation: if result is large, copy paste to excel alone takes long time
--- let alone that excel compute on pivot can choke on large number of rows

-- Step2 : let's try to use the join to solve the problem

SELECT COALESCE(a.postalcode, b.postalcode) AS potstalcode,
COALESCE(a.sale_2013, 0) AS SALE_2013,
COALESCE(b.sale_2014,0) AS SALE_2014,
CASE WHEN a.sale_2013 IS NULL OR a.sale_2013 = 0 THEN NULL
ELSE CAST((COALESCE(b.sale_2014,0) - a.sale_2013) * 100 / a.sale_2013 AS DECIMAL(5,2))
end AS pct
FROM
(
SELECT addr.PostalCode, SUM(SUBTOTAL) AS sale_2013
FROM SALES.SalesOrderHeader OH
INNER JOIN
Person.Address addr
ON
OH.ShipToAddressID = addr.AddressID
INNER JOIN
Person.StateProvince sp
on
addr.StateProvinceID = sp.StateProvinceID

WHERE YEAR(ORDERDATE) in (2013) and
sp.CountryRegionCode = 'US'
GROUP BY addr.PostalCode,YEAR(ORDERDATE)
) A
FULL OUTER JOIN
(
SELECT addr.PostalCode, SUM(SUBTOTAL) AS sale_2014
FROM SALES.SalesOrderHeader OH
INNER JOIN
Person.Address addr
ON
OH.ShipToAddressID = addr.AddressID
INNER JOIN
Person.StateProvince sp
on
addr.StateProvinceID = sp.StateProvinceID

WHERE YEAR(ORDERDATE) in (2014) and
sp.CountryRegionCode = 'US'
GROUP BY addr.PostalCode,YEAR(ORDERDATE)
) B
ON
a.postalcode = b.postalcode
ORDER BY COALESCE(a.postalcode, b.postalcode)
;

--- Step 3: that code looks ugly and difficult to read, we know how to use WITH
--- let's give another try
WITH SALE_TOTAL AS (
SELECT addr.PostalCode,
YEAR(orderdate) AS order_yr, SUM(SUBTOTAL) AS sale
FROM SALES.SalesOrderHeader OH
INNER JOIN
Person.Address addr
ON
OH.ShipToAddressID = addr.AddressID
INNER JOIN
Person.StateProvince sp
on
addr.StateProvinceID = sp.StateProvinceID
WHERE YEAR(ORDERDATE) in (2013,2014) and
sp.CountryRegionCode = 'US'
GROUP BY YEAR(orderdate),addr.PostalCode,YEAR(ORDERDATE)
)
SELECT COALESCE(a.postalcode, b.postalcode) AS postalcode,
COALESCE(a.sale, 0) AS SALE_2013,
COALESCE(b.sale,0) AS SALE_2014,
CASE WHEN a.sale IS NULL OR a.sale = 0 THEN NULL
ELSE CAST((COALESCE(b.sale,0) - a.sale) * 100 / a.sale AS DECIMAL(5,2))
END AS pct
FROM (SELECT * FROM SALE_TOTAL WHERE order_yr = 2013) A
FULL OUTER JOIN
(SELECT * FROM SALE_TOTAL WHERE order_yr = 2014)B
ON
A.POSTALCODE = B.POSTALCODE
ORDER BY postalcode
;
--- Step 4: now use a CASE statement, the code looks much clean and significantly
--- cost effective in terms of execution.

SELECT PostalCode,
SALE_2013,
SALE_2014,
CASE WHEN SALE_2013 = 0 THEN NULL
ELSE CAST((COALESCE(SALE_2014,0) - SALE_2013) * 100 / SALE_2013 AS DECIMAL(5,2))
END AS pct
FROM(
SELECT addr.PostalCode,
SUM(CASE WHEN YEAR(ORDERDATE) = 2013 THEN SUBTOTAL ELSE 0 END) AS SALE_2013,
SUM(CASE WHEN YEAR(ORDERDATE) = 2014 THEN SUBTOTAL ELSE 0 END) AS SALE_2014
FROM SALES.SalesOrderHeader oh
INNER JOIN
Person.Address addr
ON
OH.ShipToAddressID = addr.AddressID
INNER JOIN
Person.StateProvince sp
ON
addr.StateProvinceID = sp.StateProvinceID
WHERE   YEAR(ORDERDATE) IN (2013,2014) AND
sp.CountryRegionCode = 'US'
GROUP BY addr.PostalCode
)A
ORDER BY PostalCode
;