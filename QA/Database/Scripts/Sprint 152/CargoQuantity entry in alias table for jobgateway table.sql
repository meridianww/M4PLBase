

DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway'

BEGIN
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway' AND ColColumnName = 'CargoQuantity')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JobGateway', NULL, 'CargoQuantity', 'Cargo Quantity', 'Cargo Quantity', 'Cargo Quantity', NULL, NULL, '', @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
END