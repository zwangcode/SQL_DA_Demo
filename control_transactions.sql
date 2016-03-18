CREATE PROCEDURE mslearn.insertWithCursor
AS
BEGIN
DECLARE @BusinessEntityID as INT;
DECLARE @BusinessName as NVARCHAR(50);
DECLARE @Cnt as int  = 0;
DECLARE @BusinessCursor as CURSOR;

SET @BusinessCursor = CURSOR FOR
SELECT BusinessEntityID, Name
 FROM Sales.Store;

OPEN @BusinessCursor;
FETCH NEXT FROM @BusinessCursor INTO @BusinessEntityID, @BusinessName;
set @cnt = @cnt + 1;
BEGIN TRAN;
WHILE @@FETCH_STATUS = 0
BEGIN
 --PRINT cast(@BusinessEntityID as VARCHAR (50)) + ' ' + @BusinessName;
 INSERT INTO  MSLEARN.TEST_INS VALUES (@BusinessEntityID,@BusinessName);
 set @cnt = @cnt + 1;
 -- commit at a fixed interval 10
 IF @Cnt % 10 = 0
 begin
commit;
print ' commmited at ' + cast (@cnt as char(5))
begin tran
end;
 FETCH NEXT FROM @BusinessCursor INTO @BusinessEntityID, @BusinessName;
END
-- CHECK FOR ANY UN-COMMITED TRANS
if @cnt % 10 <> 0
begin
commit;
print ' commmited at ' + cast (@cnt as char(5))
END
 -- clean up
CLOSE @BusinessCursor;
DEALLOCATE @BusinessCursor;
END;