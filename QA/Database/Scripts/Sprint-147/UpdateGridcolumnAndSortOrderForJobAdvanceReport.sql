DECLARE @GridTable AS TABLE (SortOrder INT, ColumnName VARCHAR(50))
INSERT INTO @GridTable VALUES (1,'Id')  
INSERT INTO @GridTable VALUES (2,'JobCustomerSalesOrder')
INSERT INTO @GridTable VALUES (3,'JobGatewayStatus')
INSERT INTO @GridTable VALUES (4,'JobDeliveryDateTimePlanned')
INSERT INTO @GridTable VALUES (5,'JobOriginDateTimePlanned')
INSERT INTO @GridTable VALUES (6,'JobDeliverySiteName')
INSERT INTO @GridTable VALUES (7,'JobDeliverySitePOC')
INSERT INTO @GridTable VALUES (8,'JobDeliverySitePOCPhone')
INSERT INTO @GridTable VALUES (9,'JobDeliverySitePOCPhone2')
INSERT INTO @GridTable VALUES (10,'JobDeliverySitePOCEmail')
INSERT INTO @GridTable VALUES (11,'JobDeliveryStreetAddress')
INSERT INTO @GridTable VALUES (12,'JobDeliveryStreetAddress2')
INSERT INTO @GridTable VALUES (13,'JobDeliveryCity')
INSERT INTO @GridTable VALUES (14,'JobDeliveryState')
INSERT INTO @GridTable VALUES (15,'JobDeliveryPostalCode')
INSERT INTO @GridTable VALUES (16,'JobQtyActual')
INSERT INTO @GridTable VALUES (17,'JobPartsActual')
INSERT INTO @GridTable VALUES (18,'JobServiceActual')
INSERT INTO @GridTable VALUES (19,'JobCubesUnitTypeId')
INSERT INTO @GridTable VALUES (20,'JobTotalWeight')
INSERT INTO @GridTable VALUES (21,'CgoPartCode')
INSERT INTO @GridTable VALUES (22,'CargoTitle')
INSERT INTO @GridTable VALUES (23,'PackagingCode')
INSERT INTO @GridTable VALUES (24,'JobServiceMode')
INSERT INTO @GridTable VALUES (25,'JobCarrierContract')
INSERT INTO @GridTable VALUES (26,'JobOrderedDate')
INSERT INTO @GridTable VALUES (27,'JobBOL')
INSERT INTO @GridTable VALUES (28,'JobMileage')
INSERT INTO @GridTable VALUES (29,'JobCustomerPurchaseOrder')
INSERT INTO @GridTable VALUES (30,'StatusId') 


DECLARE @ColTableName VARCHAR(50) = 'JobAdvanceReport'
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
