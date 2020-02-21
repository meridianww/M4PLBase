IF NOT EXISTS (Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobGateway' AND ColColumnName = 'GatewayTypeId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias 
(LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode,
									 ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId,
									  ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'JobGateway', NULL, 'GatewayTypeId', 'Type', 'Type','Type', 15, 'JobGateway', null, 45, 0, 1, 1, 1, NULL, 0, 0, NULL)
END
