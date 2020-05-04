
IF COL_LENGTH('dbo.PRGRM000Master', 'PrgElectronicInvoice') IS NULL
BEGIN
ALTER TABLE [PRGRM000Master] ADD PrgElectronicInvoice BIT NOT NULL Default(0)
END

IF COL_LENGTH('dbo.JOBDL000Master', 'JobElectronicInvoice') IS NULL
BEGIN
ALTER TABLE JOBDL000Master ADD JobElectronicInvoice BIT NOT NULL Default(0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Program' AND ColColumnName = 'PrgElectronicInvoice')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Program', NULL, 'PrgElectronicInvoice', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 31, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobElectronicInvoice')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobElectronicInvoice', 'Electronic Billing', 'Electronic Billing', NULL, NULL, '', 124, 0, 1, 1, 1, NULL, 0, 0, NULL)
END



