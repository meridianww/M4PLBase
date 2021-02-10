Declare @LookupId INT, @SalesOrderId INT, @NotRequiredId INT, @BothId INT
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Lookup Where LkupCode = 'NavOrderOption')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Lookup (LkupCode, LkupTableName)
Values ('NavOrderOption', 'Global')
END

Select @LookupId = Id From dbo.SYSTM000Ref_Lookup Where LkupCode = 'NavOrderOption'

IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Not Required')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,StatusId,DateEntered, EnteredBy)
VALUES (@LookupId, 'NavOrderOption', 'Not Required',1,1,1,GetDate(),NULL)
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Both')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,StatusId,DateEntered, EnteredBy)
VALUES (@LookupId, 'NavOrderOption', 'Both',2,0,1,GetDate(),NULL)
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Sales Order')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,StatusId,DateEntered, EnteredBy)
VALUES (@LookupId, 'NavOrderOption', 'Sales Order',3,0,1,GetDate(),NULL)
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Purchase Order')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,StatusId,DateEntered, EnteredBy)
VALUES (@LookupId, 'NavOrderOption', 'Purchase Order',4,0,1,GetDate(),NULL)
END

Select @BothId = ID From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Both'
Select @SalesOrderId = ID From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Sales Order'
Select @NotRequiredId = ID From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysOptionName = 'Not Required'

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'PgdGatewayNavOrderOption' AND Object_ID = Object_ID(N'dbo.PRGRM010Ref_GatewayDefaults'))
BEGIN
ALTER TABLE dbo.PRGRM010Ref_GatewayDefaults ADD PgdGatewayNavOrderOption BIGINT NULL
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_PgdGatewayNavOrderOption] FOREIGN KEY([PgdGatewayNavOrderOption])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgRefGatewayDefault' AND ColColumnName = 'PgdGatewayNavOrderOption')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode,ColTableName,ColColumnName,ColAliasName,ColCaption,ColLookupId,ColLookupCode,ColSortOrder,ColIsReadOnly,ColIsVisible,ColIsDefault, StatusId, ColAllowNegativeValue, ColIsGroupBy, IsGridColumn, ColGridAliasName)
VALUES ('EN','PrgRefGatewayDefault', 'PgdGatewayNavOrderOption','NAV Push', 'NAV Push', @LookupId,'NavOrderOption',31,0,1,1,1,0,0,0,'NAV Push')
END

UPDATE PRGRM010Ref_GatewayDefaults SET PgdGatewayNavOrderOption = @SalesOrderId Where PgdGatewayCode = 'Delivered' AND StatusId=1
UPDATE PRGRM010Ref_GatewayDefaults SET PgdGatewayNavOrderOption = @BothId Where PgdGatewayCode IN ('POD Completion', 'Will Call','Return to AWC') AND StatusId=1

UPDATE PRGRM010Ref_GatewayDefaults SET PgdGatewayNavOrderOption = @NotRequiredId Where PgdGatewayCode NOT IN ('Delivered','POD Completion', 'Will Call','Return to AWC') AND StatusId=1




