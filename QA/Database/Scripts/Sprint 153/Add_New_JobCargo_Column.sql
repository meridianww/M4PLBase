ALTER TABLE dbo.JOBDL010Cargo ADD CgoDateLastScan DateTime2(7) NULL
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobCargo' AND ColColumnName = 'CgoDateLastScan')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobCargo', NULL, 'CgoDateLastScan', 'Last Scanned', 'Last Scanned', NULL, NULL, NULL, 40, 0, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Last Scanned')
END

