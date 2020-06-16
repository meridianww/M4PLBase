DECLARE @GridTable AS TABLE (SortOrder INT, ColumnName VARCHAR(50))
INSERT INTO @GridTable VALUES (1,'JobCustomerSalesOrder')
INSERT INTO @GridTable VALUES (2,'JobGatewayStatus')
INSERT INTO @GridTable VALUES (3,'JobDeliveryDateTimePlanned')
INSERT INTO @GridTable VALUES (4,'JobOriginDateTimePlanned')
INSERT INTO @GridTable VALUES (5,'JobDeliverySiteName')
INSERT INTO @GridTable VALUES (6,'JobDeliverySitePOC')
INSERT INTO @GridTable VALUES (7,'JobDeliverySitePOCPhone')
INSERT INTO @GridTable VALUES (8,'JobDeliverySitePOCPhone2')
INSERT INTO @GridTable VALUES (9,'JobDeliverySitePOCEmail')
INSERT INTO @GridTable VALUES (10,'JobDeliveryStreetAddress')
INSERT INTO @GridTable VALUES (11,'JobDeliveryStreetAddress2')
INSERT INTO @GridTable VALUES (12,'JobDeliveryCity')
INSERT INTO @GridTable VALUES (13,'JobDeliveryState')
INSERT INTO @GridTable VALUES (14,'JobDeliveryPostalCode')
INSERT INTO @GridTable VALUES (15,'JobQtyActual')
INSERT INTO @GridTable VALUES (16,'JobPartsActual')
INSERT INTO @GridTable VALUES (17,'JobServiceActual')
INSERT INTO @GridTable VALUES (18,'JobCubesUnitTypeId')
INSERT INTO @GridTable VALUES (19,'JobServiceMode')
INSERT INTO @GridTable VALUES (20,'JobCarrierContract')
INSERT INTO @GridTable VALUES (21,'JobOrderedDate')
INSERT INTO @GridTable VALUES (22,'JobBOL')
INSERT INTO @GridTable VALUES (23,'JobMileage')
INSERT INTO @GridTable VALUES (24,'JobCustomerPurchaseOrder')
INSERT INTO @GridTable VALUES (25,'StatusId')  
INSERT INTO @GridTable VALUES (26,'Id')  

DECLARE @ColTableName VARCHAR(50) = 'JobCard'
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
