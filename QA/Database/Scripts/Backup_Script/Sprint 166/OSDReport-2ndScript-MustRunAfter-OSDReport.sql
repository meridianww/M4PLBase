DECLARE @OSDRecordId BIGINT = 0;
DECLARE @maxOrderBy INT = 0;

SELECT @maxOrderBy = MAX(ColSortOrder)
FROM [dbo].[SYSTM000ColumnsAlias]
WHERE ColTableName = 'JobAdvanceReport'

SELECT @OSDRecordId = Id
FROM [dbo].[SYSTM000Ref_Options]
WHERE SysOptionName = 'OSD Report'

--SELECT * FROM [dbo].[SYSTM000Ref_Options]--3335
DELETE
--SELECT *
FROM [dbo].[Job080ReportColumnRelation]
WHERE ReportId = @OSDRecordId

INSERT INTO [dbo].[SYSTM000ColumnsAlias]
SELECT 'EN'
	,'JobAdvanceReport'
	,NULL
	,'ExceptionType'
	,'Exception Type'
	,'Exception Type'
	,NULL
	,NULL
	,NULL
	,@maxOrderBy + 1
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Exception Type'

UNION

SELECT 'EN'
	,'JobAdvanceReport'
	,NULL
	,'JobSiteCode'
	,'DC'
	,'DC'
	,NULL
	,NULL
	,NULL
	,@maxOrderBy + 2
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'DC'

UNION

SELECT 'EN'
	,'JobAdvanceReport'
	,NULL
	,'JobCustomerSalesOrder'
	,'Order Number'
	,'Order Number'
	,NULL
	,NULL
	,NULL
	,@maxOrderBy + 3
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Order Number'

UNION

SELECT 'EN'
	,'JobAdvanceReport'
	,NULL
	,'CgoSerialNumber'
	,'Serial Number'
	,'Serial Number'
	,NULL
	,NULL
	,NULL
	,@maxOrderBy + 4
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Serial Number'

UNION

SELECT 'EN'
	,'JobAdvanceReport'
	,NULL
	,'JobManifestNo'
	,'Manifest No'
	,'Manifest No'
	,NULL
	,NULL
	,NULL
	,86
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Manifest No'

INSERT INTO [dbo].[Job080ReportColumnRelation]
SELECT @OSDRecordId
	,Id AS ColumnId
FROM [dbo].[SYSTM000ColumnsAlias]
WHERE ColTableName = 'JobAdvanceReport'
	AND ColColumnName IN (
		'Id'
		,'ExceptionType'
		,'JobManifestNo'
		,'CgoPartCode'
		,'JobSiteCode'
		,'CgoSerialNumber'
		,'JobCustomerSalesOrder'
		)
	AND ColAliasName NOT IN ('Site Code')