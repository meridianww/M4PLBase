DECLARE @GridTable AS TABLE (SortOrder INT, ColumnName VARCHAR(50))
INSERT INTO @GridTable VALUES (1,'CgoLineItem')
INSERT INTO @GridTable VALUES (2,'CgoPartNumCode')
INSERT INTO @GridTable VALUES (3,'CgoTitle')
INSERT INTO @GridTable VALUES (4,'CgoSerialNumber')
INSERT INTO @GridTable VALUES (5,'CgoPackagingTypeId')
INSERT INTO @GridTable VALUES (6,'CgoQtyUnitsId')
INSERT INTO @GridTable VALUES (7,'CgoMasterCartonLabel')
INSERT INTO @GridTable VALUES (8,'CgoQTYOrdered')
INSERT INTO @GridTable VALUES (9,'CgoQtyOnHand')
INSERT INTO @GridTable VALUES (10,'CgoQtyExpected')
INSERT INTO @GridTable VALUES (11,'CgoQtyOnHold')
INSERT INTO @GridTable VALUES (12,'CgoQtyDamaged')
INSERT INTO @GridTable VALUES (13,'CgoQtyOver')
INSERT INTO @GridTable VALUES (14,'CgoQtyShortOver')
INSERT INTO @GridTable VALUES (15,'CgoWeight')
INSERT INTO @GridTable VALUES (16,'CgoWeightUnitsId')
INSERT INTO @GridTable VALUES (17,'CgoCubes')
INSERT INTO @GridTable VALUES (18,'CgoVolumeUnitsId')
INSERT INTO @GridTable VALUES (19,'CgoLatitude')
INSERT INTO @GridTable VALUES (20,'CgoLongitude')
INSERT INTO @GridTable VALUES (21,'CgoComment')
INSERT INTO @GridTable VALUES (22,'StatusId')
 

DECLARE @ColTableName VARCHAR(50) = 'JobCargo'
DECLARE @SeedForNorGridSortOrder INT = (SELECT COUNT(1) from @GridTable)

UPDATE ca SET ca.IsGridColumn = 1, ca.ColSortOrder = gt.SortOrder from
 [dbo].[SYSTM000ColumnsAlias]  AS ca
 INNER JOIN @GridTable gt
 ON gt.ColumnName = ca.ColColumnName
  where ColTableName = @ColTableName
  


UPDATE  ca  SET ca.IsGridColumn =0 , ColSortOrder = x.row_num
FROM
[dbo].[SYSTM000ColumnsAlias]  AS ca
INNER JOIN 
(select ca.Id, @SeedForNorGridSortOrder +ROW_NUMBER() OVER (
	ORDER BY Id
   ) row_num from
[dbo].[SYSTM000ColumnsAlias]  AS ca
 LEFT JOIN
   @GridTable as gt
 ON gt.ColumnName = ca.ColColumnName
  where ColTableName = @ColTableName AND
  gt.ColumnName IS NULL
) x ON x.Id = ca.Id


UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Quantity Loaded', ColCaption = 'Quantity Loaded', 
ColGridAliasName = 'Quantity Loaded' where ColTableName = 'JobCargo' and ColColumnName = 'CgoQtyExpected'

UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Quantity Delivered', ColCaption = 'Quantity Delivered', 
ColGridAliasName = 'Quantity Delivered' where ColTableName = 'JobCargo' and ColColumnName = 'CgoQtyOnHold'


UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Quantity Short', ColCaption = 'Quantity Short', 
ColGridAliasName = 'Quantity Short' where ColTableName = 'JobCargo' and ColColumnName = 'CgoQtyShortOver'