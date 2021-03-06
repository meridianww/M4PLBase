IF NOT EXISTS ( SELECT 1 FROM [dbo].[NAV000OrderMapping] WHERE NavColumn = 'Posting_Date' AND EntityName = 'SalesOrder')
BEGIN
	INSERT INTO [dbo].[NAV000OrderMapping] (
		[M4PLColumn]
		,[NavColumn]
		,[TableName]
		,[EntityName]
		,[DefaultValue]
		,[SpecialHandling]
		)
	SELECT [M4PLColumn]
		,'Posting_Date'
		,[TableName]
		,[EntityName]
		,[DefaultValue]
		,[SpecialHandling]
	FROM [dbo].[NAV000OrderMapping]
	WHERE NavColumn = 'Delivery_Date'
		AND EntityName = 'SalesOrder'
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NAV000OrderMapping] WHERE NavColumn = 'Posting_Date' AND EntityName = 'PurchaseOrder')
BEGIN
	INSERT INTO [dbo].[NAV000OrderMapping] (
		[M4PLColumn]
		,[NavColumn]
		,[TableName]
		,[EntityName]
		,[DefaultValue]
		,[SpecialHandling]
		)
	SELECT [M4PLColumn]
		,'Posting_Date'
		,[TableName]
		,[EntityName]
		,[DefaultValue]
		,[SpecialHandling]
	FROM [dbo].[NAV000OrderMapping]
	WHERE NavColumn = 'Delivery_Date'
		AND EntityName = 'PurchaseOrder'
END