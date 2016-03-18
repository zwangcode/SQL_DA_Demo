IF EXISTS (
	SELECT name FROM sys.indexes
	WHERE name = N'IX_ProductVendor_VendorID')
	DROP INDEX IX_ProductVendor_VendorID ON Purchasing.ProductVendor;
GO

CREATE INDEX IX_ProductVendor_VendorID
	ON Purchasing.ProductVendor (BusinessEntityId);

-- update stats for table
UPDATE 
	STATISTICS Purchasing.ProductVendor;
---- refresh stats for an index
UPDATE 
	STATISTICS Purchasing.ProductVendor IX_ProductVendor_VendorID;
--- create stats on non-index columns
CREATE STATISTICS Products
	ON Production.Product ([Name], ProductNumber);

--- show the status of stats
SELECT name AS stats_name
	,STATS_DATE(object_id, stats_id) AS statistics_update_date
FROM sys.stats
WHERE object_id = OBJECT_ID('Production.product');
--- drop stats
DROP STATISTICS Production.Product.Products;