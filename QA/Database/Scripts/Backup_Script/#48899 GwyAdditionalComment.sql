DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JobGateway' AND ColColumnName = 'GwyAddtionalComment')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JobGateway', NULL, 'GwyAddtionalComment', 'Comment', 'Comment', 'Comment', NULL, NULL, '', @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL020Gateways' AND COLUMN_NAME = 'GwyAddtionalComment')
BEGIN
	ALTER TABLE JOBDL020Gateways
	ADD GwyAddtionalComment NVARCHAR(MAX) NULL;
END
