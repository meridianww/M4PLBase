

DECLARE @lookupId BIGINT=0;
DECLARE @manifestRecordId BIGINT=0;
DECLARE @maxOrderBy INT=0;
SELECT @manifestRecordId=Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName='Manifest Report'
SELECT @lookupId=Id FROM [dbo].[SYSTM000Ref_Lookup] WHERE LkupCode='JobReportType'
SELECT @maxOrderBy=MAX(ColSortOrder) FROM [dbo].[SYSTM000ColumnsAlias]  where ColTableName='JobAdvanceReport'

----------------------------Step 1 INSERT INTO SYSTM000Ref_Options
INSERT INTO [dbo].[SYSTM000Ref_Options] 
SELECT @lookupId
,'JobReportType'
,'OSD Report'
,11
,0
,0
,1
,Getdate()
,NULL
,NULL
,NULL

DECLARE @refOptId BIGINT=scope_identity();
PRINT @refOptId
----------------------------Step 2 INSERT INTO SYSTM000ColumnsAlias
INSERT INTO [dbo].[SYSTM000ColumnsAlias] 
VALUES(
'EN'
,'JobAdvanceReport'
,NULL
,'CgoQtyOver'
,'Qty Over'
,'Qty Over'
,NULL
,NULL
,NULL
,@maxOrderBy+1
,1
,1
,1
,1
,NULL
,0
,0
,NULL
,1
,'Qty Over'
)

INSERT INTO [dbo].[SYSTM000ColumnsAlias] 
VALUES(
'EN'
,'JobAdvanceReport'
,NULL
,'CgoQtyShortOver'
,'Qty Short'
,'Qty Short'
,NULL
,NULL
,NULL
,@maxOrderBy+2
,1
,1
,1
,1
,NULL
,0
,0
,NULL
,1
,'Qty Short'
)


INSERT INTO [dbo].[SYSTM000ColumnsAlias] 
VALUES(
'EN'
,'JobAdvanceReport'
,NULL
,'CgoQtyDamaged'
,'Qty Damaged'
,'Qty Damaged'
,NULL
,NULL
,NULL
,@maxOrderBy+3
,1
,1
,1
,1
,NULL
,0
,0
,NULL
,1
,'Qty Damaged'
)

----------------------------Step 3 INSERT MAPPING INTO Job080ReportColumnRelation
INSERT INTO [dbo].[Job080ReportColumnRelation] 
SELECT @refOptId,ColumnId
		FROM [dbo].[Job080ReportColumnRelation] 
		WHERE ReportId=@manifestRecordId
UNION

SELECT @refOptId,Id as ColumnId
FROM [dbo].[SYSTM000ColumnsAlias] where ColTableName='JobAdvanceReport'
AND ColColumnName IN ('CgoQtyOver','CgoQtyShortOver','CgoQtyDamaged')