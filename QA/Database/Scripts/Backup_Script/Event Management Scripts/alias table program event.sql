DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgEventManagement'

BEGIN
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='PrgEventManagement' AND ColColumnName = 'ProgramID')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'PrgEventManagement', NULL, 'ProgramID', 'Program', 'Program', 'Program', NULL, NULL, '', @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
END


--DECLARE @CountofSortOrder int
--SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='EventType'


IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='EventType' AND ColColumnName = 'Id')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'EventType', NULL, 'Id', 'Id', 'Id', 'Id', NULL, NULL, '', 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='EventType' AND ColColumnName = 'EventName')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'EventType', NULL, 'EventName', 'Event Name', 'Event Name', 'Event Name', NULL, NULL, '', 2, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='EventType' AND ColColumnName = 'EventDisplayName')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'EventType', NULL, 'EventDisplayName', 'Event Display Name', 'Event Display Name', 'Event Display Name', NULL, NULL, '', 3, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END
