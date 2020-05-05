IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobOrderedDate')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobOrderedDate', 'Ordered Date', 'Ordered Date', NULL, NULL, '', 108, 0, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobShipmentDate')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobShipmentDate', 'Shipment Date', 'Shipment Date', NULL, NULL, '', 109, 0, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobInvoicedDate')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Job', NULL, 'JobInvoicedDate', 'Invoiced Date', 'Invoiced Date', NULL, NULL, '', 110, 0, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL)
END