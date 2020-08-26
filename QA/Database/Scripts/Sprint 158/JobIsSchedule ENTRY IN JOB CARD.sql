IF NOT EXISTS (
		SELECT 1
		FROM SYSTM000ColumnsAlias
		WHERE ColTableName = 'JOBCARD'
			AND ColColumnName = 'JobIsSchedule'
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
		,'JobCard'
		,NULL
		,'JobIsSchedule'
		,'Job Schedule'
		,'Job Schedule'
		,NULL
		,NULL
		,''
		,137
		,1
		,1
		,1
		,1
		,NULL
		,0
		,0
		,NULL
		,1
		,'Job Schedule'
		)
END





