CREATE LOGIN TEST_USER WITH PASSWORD='TESTPWD01$';

CREATE USER TEST_U_DB FOR LOGIN TEST_USER;

CREATE ROLE READONLY_ROLE;

GRANT SELECT ON  database :: adventureworks2014 TO  READONLY_ROLE;
alter role readonly_role add member test_u_db;

GRANT CREATE VIEW ON database :: adventureworks2014 to READONLY_ROLE;
grant alter on schema :: person to readonly_role;
--- login as test_user to test select and create view

REVOKE CREATE VIEW ON database :: adventureworks2014 FROM readonly_role;
revoke alter on schema :: person from readonly_role;

drop role readonly_role;
drop user TEST_U_DB;
drop login test_user;