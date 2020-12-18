
DROP TABLE SYSTM000CustNAVConfiguration
CREATE TABLE SYSTM000CustNAVConfiguration
(
  NAVConfigurationId BIGINT PRIMARY KEY IDENTITY(1,1),
  ServiceUrl NVARCHAR(200),
  ServiceUserName NVARCHAR(100),
  ServicePassword NVARCHAR(500),
  CustomerId BIGINT,
  DateEntered DATETIME2 NULL,
  EnteredBy NVARCHAR(50) NULL,
  DateChanged DATETIME2 NULL,
  ChangedBy NVARCHAR(50) NULL,
  StatusId INT 
)

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='NAVConfigurationId')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'NAVConfigurationId', 'NAV Configuration Id', 'NAV Configuration Id', NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'NAV Configuration Id')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='ServiceUrl')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'ServiceUrl', 'Service Url', 'Service Url', NULL, NULL, '', 2, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Service Url')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='ServiceUserName')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'ServiceUserName', 'Service User Name', 'Service User Name', NULL, NULL, '', 3, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Service User Name')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='ServicePassword')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'ServicePassword', 'Service Password', 'Service Password', NULL, NULL, '', 4, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Service Password')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='CustomerId')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'CustomerId', 'Customer ID', 'Customer ID', NULL, NULL, NULL, 5, 1, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Customer ID')
END

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='EnteredBy')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'EnteredBy', 'Entered By', 'Entered By', NULL, NULL, '', 6, 1, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Entered By')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='DateEntered')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'DateEntered', 'Entered On', 'Entered On', NULL, NULL, NULL, 7, 1, 0, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 0, 'Entered On')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='DateChanged')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'DateChanged', 'Changed On', 'Changed On', NULL, NULL, '', 8, 1, 0, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 0, 'Changed On')
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='ChangedBy')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'ChangedBy', 'Changed By', 'Changed By', NULL, NULL, '', 9, 1, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Changed By')
END 
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='CustNAVConfiguration' AND ColColumnName='StatusId')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'CustNAVConfiguration', NULL, 'StatusId', 'Status', 'Status', NULL, NULL, '', 10, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Status')
END

IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Table WHERE SysRefName='CustNAVConfiguration')
BEGIN
	INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, TblItemNumberFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('CustNAVConfiguration', 'EN', 'Customer NAV Configuration', 'SYSTM000CustNAVConfiguration', 10, NULL, NULL, 'Id', NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM SYSTM030Ref_TabPageName WHERE RefTableName='CustNAVConfiguration' AND TabTableName='CustNAVConfiguration')
BEGIN
	INSERT INTO dbo.SYSTM030Ref_TabPageName (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 'Customer', 9, 'CustNAVConfiguration', 'NAV Configuration', 'DataView', NULL, 1, GETUTCDATE(), 'SimonDekker', NULL, NULL)
END 
