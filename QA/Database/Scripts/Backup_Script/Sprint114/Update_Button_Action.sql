IF NOT EXISTS (Select 1 From  dbo.SYSTM000Ref_Table Where SysRefName = 'NavSalesOrder')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, TblItemNumberFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('NavSalesOrder', 'EN', 'Create/Update Order in NAV', '', 2278, NULL, NULL, 'Id', NULL, NULL, GetDate(), NULL, NULL, NULL)
END

 UPDATE [dbo].[SYSTM000MenuDriver] SET  [MnuExecuteProgram] = 'SyncOrderDetailsInNAV', MnuTableName = 'NavSalesOrder' Where MnuTitle ='Create/Update Order in NAV'