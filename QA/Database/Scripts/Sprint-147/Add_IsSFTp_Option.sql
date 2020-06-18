ALTER TABLE [dbo].[PRGRM070EdiHeader] ADD IsSFTPUsed BIT NOT NULL Default(0)

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='PrgEdiHeader' AND ColColumnName = 'IsSFTPUsed')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'PrgEdiHeader', NULL, 'IsSFTPUsed', 'SFTP', 'SFTP', NULL, NULL, '', 35, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'SFTP')
END


