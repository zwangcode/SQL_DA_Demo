--- this example shows microsoft merge statement
--- source table contains three records, target table contains 2 records
---- one record is matching between source to target interms of employee id
---- we are asking to use the source table's content to UPSERT operation
---- when employee id is matching, then use the name in source table to update the target table
---- when not matched , if the row in the source table employee name start with S
---- then do insert to the target table
---- when not matched , if the row in the target table employee name start with S
---- then delete the target row

---- Note: the ANSI standard did not define the match by source or target behavior
---- ANSI definition is simply TARGET LEFT OUTER JOIN SOURCE where SOURCE.join column IS NULL then insert.
---- Microsoft defines these two additional feature.
---- WHEN NOT MATCHED BY TARGET means TARGET LEFT OUTER JOIN SOURCE  where SOURCE.joincolumn IS NULL -- then do insert or delete
---- WHEN NOT MATCHED BY SOURCE means SOURCE LEFT OUTER JOIN TARGET  where TARGET.joincolumn IS NULL -- then do insert or delete

--- Microsoft also extend the merge statement with OUTPUT clause, you can use $action to see whether it is update/delete/insert
--- if update happens the operation is treated as delete first then insert

USE tempdb;
GO
drop table dbo.target;
go
drop table dbo.source;
go

CREATE TABLE dbo.Target(EmployeeID int, EmployeeName varchar(10),
     CONSTRAINT Target_PK PRIMARY KEY(EmployeeID));
CREATE TABLE dbo.Source(EmployeeID int, EmployeeName varchar(10),
     CONSTRAINT Source_PK PRIMARY KEY(EmployeeID));
GO
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(100, 'Mary');
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(101, 'Sara');
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(102, 'Stefano');

GO
INSERT dbo.Source(EmployeeID, EmployeeName) Values(103, 'Bob');
INSERT dbo.Source(EmployeeID, EmployeeName) Values(104, 'Steve');
INSERT INTO dbo.source(EmployeeID, EmployeeName) values (100,'Mike');
GO

select 'source',* from dbo.source ;
go
select 'target',* from dbo.target;

USE tempdb;
GO
MERGE Target AS T
USING Source AS S
ON (T.EmployeeID = S.EmployeeID)
WHEN NOT MATCHED BY TARGET AND S.EmployeeName LIKE 'S%'
    THEN INSERT(EmployeeID, EmployeeName) VALUES(S.EmployeeID, S.EmployeeName)
WHEN MATCHED
    THEN UPDATE SET T.EmployeeName = S.EmployeeName
WHEN NOT MATCHED BY SOURCE AND T.EmployeeName LIKE 'S%'
    THEN DELETE
OUTPUT $action, inserted.*, deleted.*;