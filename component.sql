declare @MYVAR AS INT =100;
SELECT @MYVAR, 'AFTER DECLARE BEFORE SET';
SET @MYVAR=150;
SELECT @MYVAR ,'AFTER SET';
-- system predefined global variables
http://www.codeproject.com/Articles/39131/Global-Variables-in-SQL-Server
select abc;
if @@ERROR > 0
print 'error occured'
else
print ' no error‘
--loop
declare @loopvar as int = 1;
while (@loopvar < 10)
begin
print '@loopvar = ' + cast(@loopvar as char(3));
set @loopvar = @loopvar +1;
end