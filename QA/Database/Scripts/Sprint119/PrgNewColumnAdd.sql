
IF COL_LENGTH('dbo.PRGRM000Master', 'PrgRollUpBilling') IS NULL
BEGIN
ALTER TABLE PRGRM000Master ADD PrgRollUpBilling	bit Default(0)
END

IF COL_LENGTH('dbo.PRGRM000Master', 'PrgRollUpBillingJobFieldId') IS NULL
BEGIN
ALTER TABLE PRGRM000Master ADD PrgRollUpBillingJobFieldId BIGINT
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Program' AND ColColumnName = 'PrgRollUpBillingJobFieldId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Program', NULL, 'PrgRollUpBillingJobFieldId', 'Roll Up Billing Field', 'Roll Up Billing Field', NULL, NULL, '', 29, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Program' AND ColColumnName = 'PrgRollUpBilling')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Program', NULL, 'PrgRollUpBilling', 'Roll Up Billing', 'Roll Up Billing', NULL, NULL, '', 30, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

