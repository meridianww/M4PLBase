Declare @EtdTypeId INT, @EtdLookupId INT, @StatusLookupCode INT

IF NOT EXISTS (Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'EdtType')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode,LkupTableName)
Values ('EdtType','Global')
END
Select @EtdLookupId = Id From SYSTM000Ref_Lookup Where LkupCode = 'EdtType'

IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @EtdLookupId AND SysLookupCode = 'EdtType' AND SysOptionName = 'EDI')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@EtdLookupId,'EdtType','EDI',1,1,0,1,GetDate(),NULL)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @EtdLookupId AND SysLookupCode = 'EdtType' AND SysOptionName = 'xCBL')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@EtdLookupId,'EdtType','xCBL',1,1,0,1,GetDate(),NULL)
END

Select @EtdTypeId = SysLookupId From dbo.SYSTM000Ref_Options Where  SysLookupCode = 'EdtType' AND SysOptionName = 'EDI'
Select @StatusLookupCode = SysLookupId From dbo.SYSTM000Ref_Options Where  SysLookupCode = 'Status' AND SysOptionName = 'Active'

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'Id')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'Id', 'ID', 'ID', 'ID', NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'JobId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'JobId', 'Job ID', 'Job ID', 'Job ID', NULL, NULL, NULL, 2, 1, 0, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'EdtCode')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'EdtCode', 'Code', 'Code', 'Code', NULL, NULL, NULL, 3, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'EdtTitle')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'EdtTitle', 'Title', 'Title', 'Title', NULL, NULL, NULL, 4, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'StatusId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'StatusId', 'Status', 'Status', 'Status', @StatusLookupCode, 'Status', '', 5, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'EdtData')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'EdtData', 'Data', 'Data', 'Data', NULL, NULL, NULL, 6, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'EdtTypeId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'EdtTypeId', 'Type', 'Type', 'Type', @EtdTypeId, 'EdtType', '', 7, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'EnteredBy')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'EnteredBy', 'Entered By', 'Entered By', 'Entered By', NULL, NULL, NULL, 8, 1, 0, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'DateEntered')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'DateEntered', 'Entered On', 'Entered On', 'Entered On', NULL, NULL, NULL, 9, 1, 0, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'ChangedBy')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'ChangedBy', 'Changed By', 'Changed By', 'Changed By', NULL, NULL, NULL, 10, 1, 0, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobEDIXcbl' AND ColColumnName = 'DateChanged')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobEDIXcbl', NULL, 'DateChanged', 'Changed On', 'Changed On', 'Changed On', NULL, NULL, NULL, 11, 1, 0, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 0)
END


IF NOT EXISTS (Select 1 From [SYSTM000Ref_Table] Where SysRefName = 'JobEDIXcbl')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('JobEDIXcbl', 'EN', 'EDI/xCBL', 'JOBDL070ElectronicDataTransactions', 13, 0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C0000000F744558745469746C65003344436F6C756D6E3BDE021B9B000001E149444154785E6593B16B165110C47F771E117BADF26F4441B431696CB45030A4528345D0B4620A8560C44A44301834FA093136361A22C4080A2206844004C1428DD1D246AB14E6BB9D51BE77EF3064606F77DEBE9B9D85BB627A7EED153068031880546FE7B99FEA7CEED7C5F599154F8C1D6CEF53A4BC13F9B0C8B25C9B7E4725190C7FB602370AC6DB751A66D3624FDF2E2453663B6A5E5B78FF83B15B6F18995C6CAD5B4636FE3F005B949271BB9B78BAB2C1DCA521BE7FDA682F7F5DBAC7F2F9FD2C5F18488224E59029234CE239CCDDD54D146ACF3E2FCC70B2F381A803DB48050214A6B48481F5A5595E8E1F60E0E713245044EB20226075925F7DFD8CDF7ECBE9A9E760904419769AB27887130FD65008D9445D63C0243180DFBBFB999B18E2DBC7F5C689296910DD34256A2117284C8642E0946757377BAB645451473B114344DDF0206480B402224284A1AEB70899BA1655C8D834AA46D108AAC68D80B303059289AE9A15442525129105DCDA35050021818DEAECA08B0CB2A91C46BD6670FF6A877D472EF3F0E663CE8D1C46360092989DEAB077F00A9D1BF38C0E1FC24A432A352B1C7BF4056C0086CF02B494E3FF7A19A7CE0018616CA8C2C64EDF7686F323F34C9CEB02C9BD28462F3E5BC21C75D3B20D4E3943DEF19BE7FAC55F4F97C5D38F0409630000000049454E44AE426082, 211, 'Id', 'JobId', GetDate(), NULL, NULL, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM030Ref_TabPageName refTpn Where refTpn.LangCode='EN' AND refTpn.RefTableName = 'Job' AND (ISNULL(refTpn.StatusId, 1) = 1) AND refTpn.TabTableName = 'JobEDIXcbl')
BEGIN
INSERT INTO dbo.SYSTM030Ref_TabPageName (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId)
VALUES ('EN', 'Job', 11, 'JobEDIXcbl', 'EDI/xCBL', 'DataView', NULL, 1)
END



