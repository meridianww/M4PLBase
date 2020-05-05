IF NOT EXISTS (Select 1 From [SYSTM000Ref_Table] Where SysRefName = 'JobXcblInfo')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, 
TblPrimaryKeyName, TblParentIdFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('JobXcblInfo', 'EN', 'JobXcblInfo', 'JOBDL000Master', 13, 
0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C0000001A744558745469746C65005765656B3B566965773B5765656B20766965773B5B83154A0000004E49444154785EC591410A004004451DCC62EE7FA93F9932646141B2787D492F41003ECC0CC9403AF31ADAF4E94966AC306B2E5082A0CCBEC08E5261561057AD0894D31540245D01CD0AF6DFD8E10202B14F3F196CDD7C0000000049454E44AE426082,
211, 'Id', 'JobId', GetDate(), NULL, NULL, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM030Ref_TabPageName refTpn Where refTpn.LangCode='EN' AND refTpn.RefTableName = 'Job' AND (ISNULL(refTpn.StatusId, 1) = 1) AND refTpn.TabTableName = 'JobXcblInfo')
BEGIN
INSERT INTO dbo.SYSTM030Ref_TabPageName (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId)
VALUES ('EN', 'Job', 11, 'JobXcblInfo', 'JobXcblInfo', 'DataView', NULL, 1)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'Id')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'Id', 'ID', 'ID', 'ID', NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'JobId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'JobId', 'Job ID', 'Job ID', 'Job ID', NULL, NULL, NULL, 2, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'EdtCode')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'CustomerSalesOrderNumber', 'Sales Order', 'Sales Order', 'Sales Order', NULL, NULL, NULL, 3, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'EdtTitle')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'ColumnName', 'ColumnName', 'ColumnName', 'ColumnName', NULL, NULL, NULL, 4, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'StatusId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'ExistingValue', 'Existing Value', 'Existing Value', 'Existing Value', NULL, NULL, NULL, 5, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobXcblInfo' AND ColColumnName = 'EdtData')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobXcblInfo', NULL, 'UpdatedValue', 'Updated Value', 'Updated Value', 'Updated Value', NULL, NULL, NULL, 6, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END
