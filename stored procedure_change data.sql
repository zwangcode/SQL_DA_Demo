CREATE PROCEDURE HumanResources.terminateEmployee
(@EmpID int)
as
BEGIN
--- first disable the employee in employee table with active flag to false
UPDATE HumanResources.Employee
SET CurrentFlag = 0
where BusinessEntityID = @EmpID
;

--- second scramble the password in person.password
update person.Password
set PasswordHash = hashbytes('sha1',cast(CURRENT_TIMESTAMP as varchar(15)))
where BusinessEntityID = @EmpID
;
END