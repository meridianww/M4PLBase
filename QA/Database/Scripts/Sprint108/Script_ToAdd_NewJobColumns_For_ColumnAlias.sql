IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobQtyOrdered')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobQtyOrdered', 'Qty Ord', 'Qty Ord', NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobQtyActual')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobQtyActual', 'Qty Act ', 'Qty Act', NULL, NULL, '', 2, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobQtyUnitTypeId')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobQtyUnitTypeId', 'Units', 'Units', NULL, NULL, '', 3, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobPartsOrdered')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobPartsOrdered', 'Pcs Ord', 'Pcs Ord', NULL, NULL, NULL, 4, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobPartsActual')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobPartsActual', 'Pcs Act', 'Pcs Act', NULL, NULL, '', 5, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobTotalCubes')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobTotalCubes', 'Cubes', 'Cubes', NULL, NULL, '', 6, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobServiceMode')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobServiceMode', 'Service Mode ', 'Service Mode ', NULL, NULL, '', 7, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobChannel')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobChannel', 'Channel', 'Channel', NULL, NULL, '', 8, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = 'Job' AND ColColumnName = 'JobProductType')
BEGIN
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobProductType', 'Product Type', 'Product Type', NULL, NULL, '', 9, 0, 1, 1, 1, NULL, 0, 0, NULL)
END



