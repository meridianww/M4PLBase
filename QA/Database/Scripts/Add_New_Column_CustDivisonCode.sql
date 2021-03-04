IF NOT EXISTS (
		SELECT 1
		FROM sys.columns
		WHERE Name = N'CustDivisonCode'
			AND Object_ID = Object_ID(N'dbo.CUST000Master')
		)
BEGIN
	ALTER TABLE [dbo].[CUST000Master] ADD CustDivisonCode NVARCHAR(50)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[SYSTM000ColumnsAlias]
		WHERE [ColTableName] = 'Customer'
			AND [ColColumnName] = 'CustDivisonCode'
		)
BEGIN
	INSERT [dbo].[SYSTM000ColumnsAlias] ([LangCode], [ColTableName], [ColAssociatedTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask], [IsGridColumn], [ColGridAliasName])
	VALUES (N'EN', N'Customer', NULL, N'CustDivisonCode', N'Division', N'Division', NULL, NULL, N'', 29, 0, 1, 1, 1, NULL, 0, 0, NULL, 1, N'Division')
END

UPDATE [dbo].[NAV000OrderMapping]
SET M4PLColumn = 'VdcCustomerCode', TableName = 'DC'
WHERE NavColumn = 'Shortcut_Dimension_2_Code'
	AND EntityName IN ('SalesOrder', 'PurchaseOrder')

UPDATE [dbo].[NAV000OrderMapping]
SET M4PLColumn = 'CustDivisonCode', TableName = 'Customer'
WHERE NavColumn = 'Shortcut_Dimension_1_Code'
	AND EntityName IN ('SalesOrder', 'PurchaseOrder')