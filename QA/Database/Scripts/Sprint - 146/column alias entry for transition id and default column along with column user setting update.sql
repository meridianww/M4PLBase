



IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRGRM010Ref_GatewayDefaults' AND COLUMN_NAME = 'TransitStatusId')
BEGIN
	ALTER TABLE PRGRM010Ref_GatewayDefaults
	ADD TransitStatusId INT NULL
END
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Transit_SYSTM000Ref_Options] FOREIGN KEY([TransitStatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Transit_SYSTM000Ref_Options]
GO


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRGRM010Ref_GatewayDefaults' AND COLUMN_NAME = 'PgdGatewayDefaultForJob')
BEGIN
	ALTER TABLE PRGRM010Ref_GatewayDefaults
	ADD PgdGatewayDefaultForJob BIT NULL 
END

DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgRefGatewayDefault'
DECLARE @SysLookupId INT,@SysLookupCode NVARCHAR(200)
SELECT @SysLookupId = ID,@SysLookupCode = LkupCode FROM [dbo].[SYSTM000Ref_Lookup] WHERE [LkupCode] = 'TransitStatus'

BEGIN
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgRefGatewayDefault' AND ColColumnName = 'TransitStatusId')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'PrgRefGatewayDefault', NULL, 'TransitStatusId', 'Transit Status', 'Transit Status', 'Transit Status', @SysLookupId, @SysLookupCode, '', @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgRefGatewayDefault' AND ColColumnName = 'PgdGatewayDefaultForJob')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'PrgRefGatewayDefault', NULL, 'PgdGatewayDefaultForJob', 'Default Job Gateway', 'Default Job Gateway', 'Default Job Gateway', NULL, NULL, '', @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
END
UPDATE SYSTM000ColumnSettingsByUser 
SET ColSortOrder = 'Id,PgdGatewaySortOrder,PgdGatewayCode,PgdShipmentType,PgdOrderType,PgdGatewayDefault,PgdGatewayDefaultComplete,PgdGatewayTitle,GatewayTypeId,UnitTypeId,PgdGatewayDuration,GatewayDateRefTypeId,StatusId,PgdGatewayResponsible,PgdGatewayAnalyst,Scanner,PgdShipStatusReasonCode,PgdShipApptmtReasonCode,PgdProgramID,PgdGatewayDescription,PgdGatewayComment,DateEntered,EnteredBy,DateChanged,ChangedBy,MappingId,TransitStatusId,PgdGatewayDefaultForJob'
,ColIsDefault = 'Id,PgdGatewaySortOrder,PgdGatewayCode,PgdShipmentType,PgdOrderType,PgdGatewayDefault,PgdGatewayDefaultComplete,PgdGatewayTitle,GatewayTypeId,UnitTypeId,PgdGatewayDuration,GatewayDateRefTypeId,StatusId,PgdGatewayResponsible,PgdGatewayAnalyst,Scanner,PgdShipStatusReasonCode,PgdShipApptmtReasonCode,PgdProgramID,PgdGatewayDescription,PgdGatewayComment,DateEntered,EnteredBy,DateChanged,ChangedBy,MappingId,TransitStatusId,PgdGatewayDefaultForJob'
WHERE ColTableName = 'PrgRefGatewayDefault'

