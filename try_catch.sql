CREATE PROCEDURE HumanResources.terminateEmployee
(@EmpID int)
as

BEGIN TRY
 BEGIN TRANSACTION
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
 COMMIT
END TRY

BEGIN CATCH
  -- Determine if an error occurred.
  IF @@TRANCOUNT > 0
     ROLLBACK

  -- Return the error information.
  DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
  SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
  RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
END CATCH;