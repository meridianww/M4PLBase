CREATE TABLE SYSTM000CustNAVConfiguration
(
  NAVConfigurationId BIGINT PRIMARY KEY IDENTITY(1,1),
  ServiceUrl NVARCHAR(200),
  ServiceUserName NVARCHAR(100),
  ServicePassword NVARCHAR(500),
  DateEntered DATETIME2 NULL,
  EnteredBy NVARCHAR(50) NULL,
  DateChanged DATETIME2 NULL,
  ChangedBy NVARCHAR(50) NULL,
)

IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Table WHERE SysRefName='CustNAVConfiguration')
BEGIN
	INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, TblItemNumberFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('CustNAVConfiguration', 'EN', 'Customer NAV Configuration', 'SYSTM000CustNAVConfiguration', 10, NULL, NULL, 'Id', NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM SYSTM030Ref_TabPageName WHERE RefTableName='CustNAVConfiguration' AND TabTableName='CustNAVConfiguration')
BEGIN
	INSERT INTO dbo.SYSTM030Ref_TabPageName (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 'CustNAVConfiguration', 9, 'CustNAVConfiguration', 'NAV Configuration', 'DataView', NULL, 1, GETUTCDATE(), 'SimonDekker', NULL, NULL)
END


