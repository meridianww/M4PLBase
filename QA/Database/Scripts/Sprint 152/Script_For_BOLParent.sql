
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName='JobAdvanceReport' AND ColColumnName='JobBOLMaster')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobBOLMaster', 'BOL Parent', 'BOL Parent', NULL, NULL, '', 39, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'BOL Parent')
END