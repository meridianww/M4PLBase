IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName = 'JobCard'   AND ColColumnName = 'JobDeliverySitePOCEmail')
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
	,'JobCard'
	,NULL
	,'JobDeliverySitePOCEmail'
	,'Delivery Email'
	,'Delivery Email'
	,NULL
	,NULL
	,''
	,10
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Delivery Email'
	)
END
IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName = 'JobCard'   AND ColColumnName = 'JobServiceActual')
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
	,'JobCard'
	,NULL
	,'JobServiceActual'
	,'Service Actual'
	,'Service Actual'
	,NULL
	,NULL
	,''
	,18
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Service Actual'
	)
END
IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName = 'JobCard'   AND ColColumnName = 'JobMileage')
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
	,'JobCard'
	,NULL
	,'JobMileage'
	,'Job Mileage'
	,'Job Mileage'
	,NULL
	,NULL
	,''
	,28
	,1
	,1
	,1
	,1
	,NULL
	,0
	,0
	,NULL
	,1
	,'Job Mileage'
	)
END