ALTER TABLE JobDL000Master ADD JobDriverAlert NVARCHAR(Max) NULL

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobDriverAlert')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobDriverAlert', 'Driver Alert', 'Driver Alert', NULL, NULL, '', 141, 0, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Driver Alert')
END