Use Adventureworks2014;
go

SELECT
Sales.Customer.CustomerID
,Person.Person.FirstName
,Person.Person.MiddleName
,Person.Person.LastName
,Sales.SalesOrderHeader.OrderDate
,Sales.SalesOrderHeader.SubTotal
,Person.Address.City
,Person.StateProvince.StateProvinceCode
,Person.CountryRegion.CountryRegionCode
FROM
Person.Person 
INNER JOIN Sales.Customer 
ON Person.Person.BusinessEntityID = Sales.Customer.PersonID AND Person.Person.BusinessEntityID = Sales.Customer.PersonID AND Person.Person.BusinessEntityID = Sales.Customer.PersonID 
INNER JOIN Person.BusinessEntity 
ON Person.Person.BusinessEntityID = Person.BusinessEntity.BusinessEntityID AND Person.Person.BusinessEntityID = Person.BusinessEntity.BusinessEntityID 
INNER JOIN Person.Address 
INNER JOIN Person.BusinessEntityAddress 
ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID AND Person.Address.AddressID = Person.BusinessEntityAddress.AddressID 
INNER JOIN Person.AddressType 
ON Person.BusinessEntityAddress.AddressTypeID = Person.AddressType.AddressTypeID AND
                Person.BusinessEntityAddress.AddressTypeID = Person.AddressType.AddressTypeID 
ON Person.BusinessEntity.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID AND Person.BusinessEntity.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
INNER JOIN Person.StateProvince 
ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID AND Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID AND Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID 
INNER JOIN Person.CountryRegion 
ON Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode AND Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode AND Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode
WHERE
(Person.CountryRegion.CountryRegionCode = N'US') AND (Person.StateProvince.StateProvinceCode = N'WA') AND (Person.Address.City = N'Redmond')
;
go

SELECT
MSLEARN.PERSON.PERSON_ID
,COUNT(*) AS cnt
FROM
MSLEARN.ADDRESS 
INNER JOIN
MSLEARN.PERSON_ADDRESS 
ON MSLEARN.ADDRESS.ADDRESS_ID = MSLEARN.PERSON_ADDRESS.ADDRESS_ID 
INNER JOIN
MSLEARN.PERSON 
ON MSLEARN.PERSON_ADDRESS.PERSON_ID = MSLEARN.PERSON.PERSON_ID
GROUP BY MSLEARN.PERSON.PERSON_ID
having count(*)  > 1