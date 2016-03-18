--- USE TEMPDB : this command switch the connection to tempdb database

USE TEMPDB;
-- a schema has to be created before tables / views are added to the schema
CREATE SCHEMA MSLEARN;

--DROP TABLE mslearn.PERSON;
CREATE TABLE mslearn.PERSON (
PERSON_ID INT,
FIRST_NAME VARCHAR(50),
LAST_NAME VARCHAR(50),
MIDDLE_NAME VARCHAR(50),
DOB DATE,
HOME_ADDREDSS VARCHAR(50),
BUSINESS_ADDRESS VARCHAR(50),
MAILING_ADDRESS VARCHAR(50),
HOME_PHONE VARCHAR(30),
CELL_PHONE VARCHAR(30),
BUSINESS_PHONE VARCHAR(30)
);
go

/******
Previouse example did not address the second and third normal form. therefore, we need to do following
1. make person table carry a primary key : person_id
2. separate address from person table and make its own entity
3. establish relationship of person and address by creating person_address table
************/

--- primary key column has to be NOT NULL, which means no NULL values are allowed in this column
ALTER TABLE mslearn.person ALTER COLUMN person_id INT NOT NULL;
go
---- add primary key to the table
ALTER TABLE mslearn.person ADD CONSTRAINT pk_person PRIMARY KEY (person_id);
go

--DROP TABLE MSLEARN.ADDRESS;

CREATE TABLE MSLEARN.ADDRESS (
ADDRESS_ID INT NOT NULL PRIMARY KEY,
STREET_LINE1 VARCHAR(60),
STREET_LINE2 VARCHAR(60),
CITY VARCHAR (60),
STATE VARCHAR(40),
ZIP_CODE VARCHAR(10)
);
--DROP TABLE MSLEARN.PERSON_ADDRESS;
/*********************************************************************
Person address table establish the relationship between person and
address. One person can have multiple addresses, while a address can
host multiple person. The relationship between person and address is
many-to-many. This table here are commonly known as "cross-reference table"
or junction table. Check wiki for one to many, one to one and many to many
relationship
In this example, foreign key is established without using ALTER table
statement for convinience.

Address type is a two character code,
BA: business address
HA: home address
SA: shipping address

**********************************************************************/
CREATE TABLE MSLEARN.PERSON_ADDRESS(
PERSON_ID INT NOT NULL FOREIGN KEY REFERENCES MSLEARN.PERSON(PERSON_ID),
ADDRESS_ID INT NOT NULL FOREIGN KEY REFERENCES MSLEARN.ADDRESS(ADDRESS_ID),
ADDRESS_TYPE_CD VARCHAR(2) NOT NULL
);

/**********************************************************************************
We only allow one type of address per person. Therefore, creating an unique
index constraint here will prevent one person have multiple home addresses
*********************************************************************************/

CREATE UNIQUE INDEX AK_PersonAddress ON mslearn.person_address (person_id,  address_type_cd)
;
---- -just clean up the original person table
ALTER TABLE MSLEARN.PERSON DROP COLUMN HOME_ADDREDSS;
ALTER TABLE MSLEARN.PERSON DROP COLUMN BUSINESS_ADDRESS;
ALTER TABLE MSLEARN.PERSON DROP COLUMN MAILING_ADDRESS;