DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgRefGatewayDefault'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgRefGatewayDefault' AND ColColumnName = 'MappingId')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'PrgRefGatewayDefault', NULL, 'MappingId', 'Next Gateway', 'Next Gateway', 'Next Gateway', NULL, NULL, '', @CountofSortOrder, 0, 0, 1, 1, NULL, 0, 0, NULL, 0)
		 END
GO

