DECLARE @CountofSortOrder INT

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL020Gateways' AND COLUMN_NAME = 'GwyCargoId')
BEGIN
	ALTER TABLE JOBDL020Gateways
	ADD GwyCargoId BIGINT NULL 
END
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway' AND ColColumnName = 'GwyCargoId')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JobGateway', NULL, 'GwyCargoId', 'Cargo', 'Cargo', 'Cargo', NULL, NULL, '', @CountofSortOrder, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL020Gateways' AND COLUMN_NAME = 'GwyExceptionTitleId')
BEGIN
	ALTER TABLE JOBDL020Gateways
	ADD GwyExceptionTitleId BIGINT NULL
END 
DECLARE @CountofSortOrder1 INT
SELECT @CountofSortOrder1 = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway' AND ColColumnName = 'GwyExceptionTitleId')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JobGateway', NULL, 'GwyExceptionTitleId', 'Exception Reason', 'Exception Reason', 'Exception Reason', NULL, NULL, '', @CountofSortOrder1, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
		END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL020Gateways' AND COLUMN_NAME = 'GwyExceptionStatusId')
BEGIN
	ALTER TABLE JOBDL020Gateways
	ADD GwyExceptionStatusId BIGINT NULL 
END
DECLARE @CountofSortOrder2 INT
SELECT @CountofSortOrder2 = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway' AND ColColumnName = 'GwyExceptionStatusId')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JobGateway', NULL, 'GwyExceptionStatusId', 'Install Status', 'Install Status', 'Install Status', NULL, NULL, '', @CountofSortOrder2, 1, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL021GatewayExceptionCode]') AND type in (N'U'))
BEGIN
  CREATE TABLE [dbo].[JOBDL021GatewayExceptionCode]
	(
	 Id BIGINT PRIMARY KEY IDENTITY(1,1),
	 CustomerId BIGINT NOT NULL,
	 JgeReferenceCode NVARCHAR(50) NULL,
	 JgeReasonCode NVARCHAR(200) NULL,
	 CreateDate DATETIME2(7) NULL,
	 CreatedBy NVARCHAR(30) NULL,
	 ModifiedDate DATETIME2(7) NULL,
	 ModifiedBy NVARCHAR(30) NULL
	)
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL022GatewayExceptionReason]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[JOBDL022GatewayExceptionReason]
	(
	 Id BIGINT PRIMARY KEY IDENTITY(1,1),
	 JGExceptionId BIGINT,
	 JgeTitle NVARCHAR(200) NULL,
	 CreateDate DATETIME2(7) NULL,
	 CreatedBy NVARCHAR(30) NULL,
	 ModifiedDate DATETIME2(7) NULL,
	 ModifiedBy NVARCHAR(30) NULL,
	 CONSTRAINT FK_GatewayExceptionCode FOREIGN KEY (JGExceptionId)
		REFERENCES JOBDL021GatewayExceptionCode(id)
	)
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL023GatewayInstallStatusMaster]') AND type in (N'U'))
BEGIN
   CREATE TABLE JOBDL023GatewayInstallStatusMaster
	(
	 Id BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	 ExStatusDescription NVARCHAR(200) NOT NULL,
	 ExceptionType NVARCHAR(30)
	)
END



IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='GwyExceptionCode' AND ColColumnName = 'Id')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'GwyExceptionCode', NULL, 'Id', 'Id', 'Id', 'Id', NULL, NULL, '', 1, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
		END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='GwyExceptionCode' AND ColColumnName = 'JgeTitle')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'GwyExceptionCode', NULL, 'JgeTitle', 'Title', 'Title', 'Title', NULL, NULL, '', 2, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
		 END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='GwyExceptionCode' AND ColColumnName = 'JgeReasonCode')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'GwyExceptionCode', NULL, 'JgeReasonCode', 'Reason Code', 'Reason Code', 'Reason Code', NULL, NULL, '', 3, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
		 END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Table WHERE SysRefName ='GwyExceptionCode' AND TblTableName = 'JOBDL022GatewayExceptionReason')
         BEGIN
			INSERT INTO SYSTM000Ref_Table (SysRefName,LangCode,TblLangName,TblTableName,TblMainModuleId,TblIcon,TblTypeId,TblPrimaryKeyName,TblParentIdFieldName)
			VALUES('GwyExceptionCode','EN','Gateway Exception Code','JOBDL022GatewayExceptionReason',13,'0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C0000000F744558745469746C65003344436F6C756D6E3BDE021B9B000001E149444154785E6593B16B165110C47F771E117BADF26F4441B431696CB45030A4528345D0B4620A8560C44A44301834FA093136361A22C4080A2206844004C1428DD1D246AB14E6BB9D51BE77EF3064606F77DEBE9B9D85BB627A7EED153068031880546FE7B99FEA7CEED7C5F599154F8C1D6CEF53A4BC13F9B0C8B25C9B7E4725190C7FB602370AC6DB751A66D3624FDF2E2453663B6A5E5B78FF83B15B6F18995C6CAD5B4636FE3F005B949271BB9B78BAB2C1DCA521BE7FDA682F7F5DBAC7F2F9FD2C5F18488224E59029234CE239CCDDD54D146ACF3E2FCC70B2F381A803DB48050214A6B48481F5A5595E8E1F60E0E713245044EB20226075925F7DFD8CDF7ECBE9A9E760904419769AB27887130FD65008D9445D63C0243180DFBBFB999B18E2DBC7F5C689296910DD34256A2117284C8642E0946757377BAB645451473B114344DDF0206480B402224284A1AEB70899BA1655C8D834AA46D108AAC68D80B303059289AE9A15442525129105DCDA35050021818DEAECA08B0CB2A91C46BD6670FF6A877D472EF3F0E663CE8D1C46360092989DEAB077F00A9D1BF38C0E1FC24A432A352B1C7BF4056C0086CF02B494E3FF7A19A7CE0018616CA8C2C64EDF7686F323F34C9CEB02C9BD28462F3E5BC21C75D3B20D4E3943DEF19BE7FAC55F4F97C5D38F0409630000000049454E44AE426082',
			211,'Id','JobID')
		 END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnSettingsByUser WHERE ColTableName ='GwyExceptionCode')
         BEGIN
			INSERT INTO SYSTM000ColumnSettingsByUser(ColUserId,ColTableName,ColSortOrder,ColNotVisible,ColIsDefault)
			VALUES (2,'GwyExceptionCode','Id,JgeTitle,JgeReasonCode',NULL,'Id,JgeTitle,JgeReasonCode')
		 END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='GwyExceptionStatusCode' AND ColColumnName = 'Id')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'GwyExceptionStatusCode', NULL, 'Id', 'Id', 'Id', 'Id', NULL, NULL, '', 1, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
 		 END
GO

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='GwyExceptionStatusCode' AND ColColumnName = 'ExStatusDescription')
         BEGIN
			INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'GwyExceptionStatusCode', NULL, 'ExStatusDescription', 'Status Description', 'Status Description', 'Status Description', NULL, NULL, '', 2, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
		 END
GO

IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Table WHERE SysRefName ='GwyExceptionStatusCode' AND TblTableName = 'JOBDL023GatewayInstallStatusMaster')
         BEGIN
			INSERT INTO SYSTM000Ref_Table (SysRefName,LangCode,TblLangName,TblTableName,TblMainModuleId,TblIcon,TblTypeId,TblPrimaryKeyName,TblParentIdFieldName)
			VALUES('GwyExceptionStatusCode','EN','Gateway Exception Status Description','JOBDL023GatewayInstallStatusMaster',13,'0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C0000000F744558745469746C65003344436F6C756D6E3BDE021B9B000001E149444154785E6593B16B165110C47F771E117BADF26F4441B431696CB45030A4528345D0B4620A8560C44A44301834FA093136361A22C4080A2206844004C1428DD1D246AB14E6BB9D51BE77EF3064606F77DEBE9B9D85BB627A7EED153068031880546FE7B99FEA7CEED7C5F599154F8C1D6CEF53A4BC13F9B0C8B25C9B7E4725190C7FB602370AC6DB751A66D3624FDF2E2453663B6A5E5B78FF83B15B6F18995C6CAD5B4636FE3F005B949271BB9B78BAB2C1DCA521BE7FDA682F7F5DBAC7F2F9FD2C5F18488224E59029234CE239CCDDD54D146ACF3E2FCC70B2F381A803DB48050214A6B48481F5A5595E8E1F60E0E713245044EB20226075925F7DFD8CDF7ECBE9A9E760904419769AB27887130FD65008D9445D63C0243180DFBBFB999B18E2DBC7F5C689296910DD34256A2117284C8642E0946757377BAB645451473B114344DDF0206480B402224284A1AEB70899BA1655C8D834AA46D108AAC68D80B303059289AE9A15442525129105DCDA35050021818DEAECA08B0CB2A91C46BD6670FF6A877D472EF3F0E663CE8D1C46360092989DEAB077F00A9D1BF38C0E1FC24A432A352B1C7BF4056C0086CF02B494E3FF7A19A7CE0018616CA8C2C64EDF7686F323F34C9CEB02C9BD28462F3E5BC21C75D3B20D4E3943DEF19BE7FAC55F4F97C5D38F0409630000000049454E44AE426082',
			211,'Id','JobID')
		END
GO
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnSettingsByUser WHERE ColTableName ='GwyExceptionStatusCode')
         BEGIN
			INSERT INTO SYSTM000ColumnSettingsByUser(ColUserId,ColTableName,ColSortOrder,ColNotVisible,ColIsDefault)
			VALUES (2,'GwyExceptionStatusCode','Id,ExStatusDescription',NULL,'Id,ExStatusDescription')
		 END
GO