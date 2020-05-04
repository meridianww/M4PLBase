IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgBillableRate' AND ColColumnName = 'PbrElectronicBilling')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgBillableRate', NULL, 'PbrElectronicBilling', 'Electronic Billing', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 29, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgCostRate' AND ColColumnName = 'PcrElectronicBilling')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgCostRate', NULL, 'PcrElectronicBilling', 'Electronic Billing', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 29, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobBillableSheet' AND ColColumnName = 'PrcElectronicBilling')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobBillableSheet', NULL, 'PrcElectronicBilling', 'Electronic Billing', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 20, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobCostSheet' AND ColColumnName = 'CstElectronicBilling')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobCostSheet', NULL, 'CstElectronicBilling', 'Electronic Billing', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 20, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END