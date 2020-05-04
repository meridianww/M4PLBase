IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'TransactionDate')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'TransactionDate', 'Transaction Date', 'Transaction Date', 'Transaction Date', NULL, NULL, NULL, 12, 1, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 0)
END