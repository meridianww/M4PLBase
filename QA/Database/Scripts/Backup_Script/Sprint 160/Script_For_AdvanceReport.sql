DECLARE @ReportType INT
	,@ActualPartId INT
	,@ActualQuantityId INT

SELECT @ReportType = Id
FROM SYSTM000Ref_Options
WHERE SysLookupCode = 'JobReportType'
	AND SysOptionName = 'Job Advance Report'

IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000ColumnsAlias
		WHERE ColTableName = 'JobAdvanceReport'
			AND ColColumnName = 'JobPartsActual'
		)
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (
		LangCode
		,ColTableName
		,ColAssociatedTableName
		,ColColumnName
		,ColAliasName
		,ColCaption
		,ColLookupId
		,ColLookupCode
		,ColDescription
		,ColSortOrder
		,ColIsReadOnly
		,ColIsVisible
		,ColIsDefault
		,StatusId
		,ColDisplayFormat
		,ColAllowNegativeValue
		,ColIsGroupBy
		,ColMask
		,IsGridColumn
		,ColGridAliasName
		)
	VALUES (
		'EN'
		,'JobAdvanceReport'
		,NULL
		,'JobPartsActual'
		,'Parts Actual'
		,'Parts Actual'
		,NULL
		,NULL
		,''
		,80
		,1
		,1
		,1
		,1
		,NULL
		,0
		,0
		,NULL
		,1
		,'Parts Actual'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000ColumnsAlias
		WHERE ColTableName = 'JobAdvanceReport'
			AND ColColumnName = 'JobQtyActual'
		)
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (
		LangCode
		,ColTableName
		,ColAssociatedTableName
		,ColColumnName
		,ColAliasName
		,ColCaption
		,ColLookupId
		,ColLookupCode
		,ColDescription
		,ColSortOrder
		,ColIsReadOnly
		,ColIsVisible
		,ColIsDefault
		,StatusId
		,ColDisplayFormat
		,ColAllowNegativeValue
		,ColIsGroupBy
		,ColMask
		,IsGridColumn
		,ColGridAliasName
		)
	VALUES (
		'EN'
		,'JobAdvanceReport'
		,NULL
		,'JobQtyActual'
		,'Quantity Actual'
		,'Quantity Actual'
		,NULL
		,NULL
		,''
		,81
		,1
		,1
		,1
		,1
		,NULL
		,0
		,0
		,NULL
		,1
		,'Quantity Actual'
		)
END

SELECT @ActualPartId = Id
FROM dbo.SYSTM000ColumnsAlias
WHERE ColTableName = 'JobAdvanceReport'
	AND ColColumnName = 'JobPartsActual'

SELECT @ActualQuantityId = Id
FROM dbo.SYSTM000ColumnsAlias
WHERE ColTableName = 'JobAdvanceReport'
	AND ColColumnName = 'JobQtyActual'

IF NOT EXISTS (
		SELECT *
		FROM dbo.Job080ReportColumnRelation
		WHERE ReportId = @ReportType
			AND ColumnId = @ActualPartId
		)
BEGIN
	INSERT INTO dbo.Job080ReportColumnRelation (
		ReportId
		,ColumnId
		)
	VALUES (
		@ReportType
		,@ActualPartId
		)
END

IF NOT EXISTS (
		SELECT *
		FROM dbo.Job080ReportColumnRelation
		WHERE ReportId = @ReportType
			AND ColumnId = @ActualQuantityId
		)
BEGIN
	INSERT INTO dbo.Job080ReportColumnRelation (
		ReportId
		,ColumnId
		)
	VALUES (
		@ReportType
		,@ActualQuantityId
		)
END