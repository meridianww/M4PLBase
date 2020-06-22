

DECLARE @ID INT
SELECT  @ID =ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'UnitWeight'
UPDATE SYSTM000ColumnsAlias SET ColLookupCode = 'UnitWeight',ColLookupId = @ID
WHERE ColTableName = 'Report' AND ColColumnName = 'JobWeightUnitTypeId'

DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report'

IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='Report' AND ColColumnName = 'CargoId')
         BEGIN
		    DECLARE @PackagingCodeID INT
			SELECT @PackagingCodeID = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'PackagingCode'
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'Report', NULL, 'CargoId', 'Cargo', 'Cargo', 'Cargo', @PackagingCodeID, null, null, @CountofSortOrder, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
		 END