ALTER TABLE PRGRM070EDIHeader ADD PehFtpServerUrl nvarchar(255)
ALTER TABLE PRGRM070EDIHeader ADD PehFtpUsername  nvarchar(50)
ALTER TABLE PRGRM070EDIHeader ADD PehFtpPassword  nvarchar(50)
ALTER TABLE PRGRM070EDIHeader ADD PehFtpPort  nvarchar(10)

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehInOutFolder')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehInOutFolder', 'In/Out Folder', 'In/Out Folder', 'In/Out Folder', NULL, NULL, '', 28, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehArchiveFolder')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehArchiveFolder', 'Archive Folder', 'Archive Folder', 'Archive Folder', NULL, NULL, '', 29, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehProcessFolder')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehProcessFolder', 'Processing Folder', 'Processing Folder', 'Processing Folder', NULL, NULL, '', 30, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehFtpServerUrl')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehFtpServerUrl', 'FTP URL', 'FTP URL', 'FTP URL', NULL, NULL, '', 31, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehFtpUsername')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehFtpUsername', 'FTP Username', 'FTP Username', 'FTP Username', NULL, NULL, '', 32, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehFtpPassword')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehFtpPassword', 'FTP Password', 'FTP Password', 'FTP Password', NULL, NULL, '', 33, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgEdiHeader' AND ColColumnName = 'PehFtpPort')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgEdiHeader', NULL, 'PehFtpPort', 'FTP Port', 'FTP Port', 'FTP Port', NULL, NULL, '', 34, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END