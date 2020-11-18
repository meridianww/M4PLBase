DECLARE @sortOrder INT=0;
SELECT @sortOrder = MAX(ColSortOrder)+1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'EDISummaryHeader'

BEGIN
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshConsigneeContactEmail')
 BEGIN
	 INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshConsigneeContactEmail', 'Consignee Email', 'Consignee Email', NULL, NULL, 'Consignee Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Consignee Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshConsigneeAltContEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshConsigneeAltContEmail', 'Consignee Alternative Email', 'Consignee Alternative Email', NULL, NULL, 'Consignee Alternative Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Consignee Alternative Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshInterConsigneeContactEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshInterConsigneeContactEmail', 'Internal Consignee Email', 'Internal Consignee Email', NULL, NULL, 'Internal Consignee Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Internal Consignee Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshInterConsigneeAltContEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshInterConsigneeAltContEmail', 'Internal Consignee Alternative Email', 'Internal Consignee Alternative Email', NULL, NULL, 'Internal Consignee Alternative Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Internal Consignee Alternative Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshShipFromContactEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshShipFromContactEmail', 'Ship From Email', 'Ship From Email', NULL, NULL, 'Ship From Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Ship From Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshShipFromAltContEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshShipFromAltContEmail', 'Ship From Alternative Email', 'Ship From Alternative Email', NULL, NULL, 'Ship From Alternative Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Ship From Alternative Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshBillToContactEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshBillToContactEmail', 'Billing Email', 'Billing Email', NULL, NULL, 'Billing Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Billing Email')
	 SET @sortOrder = @sortOrder +1
 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshBillToAltContEmail')
 BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	 VALUES ('EN', 'EDISummaryHeader', NULL, 'eshBillToAltContEmail', 'Billing Alternative Email', 'Billing Alternative Email', NULL, NULL, 'Billing Alternative Email', @sortOrder, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'Billing Alternative Email')	 
 END
END
