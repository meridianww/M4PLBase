IF NOT EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'JOBDL061BillableSheet'
			AND COLUMN_NAME = 'IsProblem'
		)
BEGIN
	ALTER TABLE [dbo].[JOBDL061BillableSheet] ADD IsProblem BIT NOT NULL DEFAULT(0)

	UPDATE [dbo].[JOBDL061BillableSheet]
	SET IsProblem = 1
	WHERE ISNULL(PrcChargeID, 0) = 0
		AND StatusId = 1
END

IF NOT EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'JOBDL062CostSheet'
			AND COLUMN_NAME = 'IsProblem'
		)
BEGIN
	ALTER TABLE [dbo].[JOBDL062CostSheet] ADD IsProblem BIT NOT NULL DEFAULT(0)

	UPDATE [dbo].[JOBDL062CostSheet]
	SET IsProblem = 1
	WHERE ISNULL(CstChargeID, 0) = 0
		AND StatusId = 1
END

IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
		WHERE CONSTRAINT_NAME = 'FK_JOBDL062CostSheet_CstChargeID'
		)
BEGIN
	ALTER TABLE [dbo].[JOBDL062CostSheet]

	DROP CONSTRAINT [FK_JOBDL062CostSheet_CstChargeID]
END

IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
		WHERE CONSTRAINT_NAME = 'FK_BillableSheet_ChargeTypeId'
		)
BEGIN
	ALTER TABLE [dbo].[JOBDL061BillableSheet]

	DROP CONSTRAINT [FK_BillableSheet_ChargeTypeId]
END

IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000ColumnsAlias
		WHERE ColTableName = 'JobCostSheet'
			AND ColColumnName = 'IsProblem'
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
		,'JobCostSheet'
		,NULL
		,'IsProblem'
		,'Is Problem'
		,'Is Problem'
		,NULL
		,NULL
		,''
		,21
		,1
		,1
		,1
		,1
		,NULL
		,0
		,0
		,NULL
		,0
		,'Is Problem'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000ColumnsAlias
		WHERE ColTableName = 'JobBillableSheet'
			AND ColColumnName = 'IsProblem'
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
		,'JobBillableSheet'
		,NULL
		,'IsProblem'
		,'Is Problem'
		,'Is Problem'
		,NULL
		,NULL
		,''
		,21
		,1
		,1
		,1
		,1
		,NULL
		,0
		,0
		,NULL
		,0
		,'Is Problem'
		)
END