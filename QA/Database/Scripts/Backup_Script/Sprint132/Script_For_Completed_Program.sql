ALTER TABLE PRGRM010Ref_GatewayDefaults ADD PgdGatewayDefaultComplete BIT Default(0)
IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName='PrgRefGatewayDefault' AND ColColumnName = 'PgdGatewayDefaultComplete')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'PrgRefGatewayDefault', NULL, 'PgdGatewayDefaultComplete', 'Default Complete', 'Default Complete', 'Default Complete', NULL, NULL, NULL, 23, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END
