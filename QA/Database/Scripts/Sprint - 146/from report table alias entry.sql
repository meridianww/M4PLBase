
DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report'
BEGIN
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report' AND ColColumnName = 'CgoPackagingTypeId')
         BEGIN
		    DECLARE @PackagingCodeID INT
			SELECT @PackagingCodeID = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'PackagingCode'
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'Report', NULL, 'CgoPackagingTypeId', 'Packaging Type', 'Packaging Type', 'Packaging Type', @PackagingCodeID, 'PackagingCode', '', @CountofSortOrder, 0, 0, 1, 1, NULL, 0, 0, NULL, 0)
		 END

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report' AND ColColumnName = 'JobWeightUnitTypeId')
         BEGIN
		    DECLARE @WeightCodeID INT
			SELECT @WeightCodeID = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'WeightUnitType'
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'Report', NULL, 'JobWeightUnitTypeId', 'Weight Unit', 'Weight Unit', 'Weight Unit', @WeightCodeID, 'WeightUnitType', '', @CountofSortOrder, 0, 0, 1, 1, NULL, 0, 0, NULL, 0)
		 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report' AND ColColumnName = 'IsEnabledAddtionalfield')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'Report', NULL, 'IsEnabledAddtionalfield', 'Enable Additional Search', 'Enable Additional Search', 'Enable Additional Search', NULL, NULL, '', @CountofSortOrder, 0, 0, 1, 1, NULL, 0, 0, NULL, 0)
		 END
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report' AND ColColumnName = 'JobPartsOrdered')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'Report', NULL, 'JobPartsOrdered', 'Parts Ordered', 'Parts Ordered', 'Parts Ordered', NULL, NULL, '', @CountofSortOrder, 0, 0, 1, 1, NULL, 0, 0, NULL, 0)
		 END
END