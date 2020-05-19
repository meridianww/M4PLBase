IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRGRM010Ref_GatewayDefaults' AND COLUMN_NAME = 'PgdGatewayStatusCode')
BEGIN
ALTER TABLE PRGRM010Ref_GatewayDefaults ADD [PgdGatewayStatusCode] [nvarchar](20) NULL

UPDATE PRGRM010Ref_GatewayDefaults
SET PgdGatewayStatusCode = PgdShipStatusReasonCode
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgRefGatewayDefault' AND ColColumnName = 'PgdGatewayStatusCode')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'PrgRefGatewayDefault', NULL, 'PgdGatewayStatusCode', 'Gateway Status Code', 'Gateway Status Code', NULL, NULL, NULL, 27, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Gateway Status Code')
END

