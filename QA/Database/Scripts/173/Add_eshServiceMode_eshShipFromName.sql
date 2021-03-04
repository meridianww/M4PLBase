
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshServiceMode')
BEGIN
DECLARE @COUNT INT =0
SELECT @COUNT = MAX(ColSortOrder) +1  FROM SYSTM000ColumnsAlias WHERE ColTableName='EDISummaryHeader'
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName,
ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault,
StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'EDISummaryHeader', NULL, 'eshServiceMode', 'Service Mode', 'Service Mode', NULL, NULL,
'esh Service Mode Desc', @COUNT, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'esh Service Mode')
END

IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName = 'eshShipFromName')
BEGIN
DECLARE @COUNT INT =0
SELECT @COUNT = MAX(ColSortOrder) +1  FROM SYSTM000ColumnsAlias WHERE ColTableName='EDISummaryHeader'
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName,
ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault,
StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'EDISummaryHeader', NULL, 'eshShipFromName', 'Ship From Name', 'Ship From Name', NULL, NULL,
'esh Ship From Name Desc', @COUNT, 0, 1, 1, NULL, NULL, 0, 0, NULL, 0, 'esh Ship From Name')
END