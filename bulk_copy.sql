--- run cmd to export data
---- bcp Adventureworks2014.[Person].[vStateProvinceCountryRegion] out state.out -c -t "|" -T   -S localhost\sqlexpress

if OBJECT_ID(N'dbo.statecountryregion') is not null
drop table dbo.statecountryregion
;
SELECT * into statecountryregion
FROM Adventureworks2014.[Person].[vStateProvinceCountryRegion]
--- where 0=1 create false condition, query return 0 rows.
--- common technique to create empty table
where 0=1
;

--- table is empty
select * from statecountryregion

--- run bcp from command line
-- bcp adventureworks2014.dbo.statecountryregion IN state.out -c -t "|" -T -S localhost\sqlexpress

--- now table is populated
select * from statecountryregion