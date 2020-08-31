
IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Lookup WHERE LkupCode='Year')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Lookup (LkupCode, LkupTableName)
VALUES ('Year', 'Global')

DECLARE @Id INT
SET @ID = SCOPE_IDENTITY()  
	BEGIN
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2015, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2016, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2017, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2018, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2019, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
		INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
		VALUES (@ID, 'Year', 2020, 4, 0, 0, 1, '2020-08-17 10:33:11.137', NULL, NULL, NULL)
	END
	IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName='REPORT' AND ColColumnName='Year')
	BEGIN
		INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
		VALUES ('EN', 'Report', NULL, 'Year', 'Year', 'Year', @Id, 'Year', 'Year', 2, 0, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Year')
	END
END