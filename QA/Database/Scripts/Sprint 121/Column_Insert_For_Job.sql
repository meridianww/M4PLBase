ALTER TABLE JOBDL000Master ADD JobOriginStreetAddress3 nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobOriginStreetAddress4 nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobDeliveryStreetAddress3  nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobDeliveryStreetAddress4  nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobSellerStreetAddress3  nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobSellerStreetAddress4  nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobShipFromStreetAddress3 nvarchar(100)
ALTER TABLE JOBDL000Master ADD JobShipFromStreetAddress4  nvarchar(100)

ALTER TABLE EDI204SummaryHeader ADD eshConsigneeStreetAddress3  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshConsigneeStreetAddress4  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshInterConsigneeStreetAddress3  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshInterConsigneeStreetAddress4  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshBillToStreetAddress3  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshBillToStreetAddress4  nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshShipFromStreetAddress3 nvarchar(75)
ALTER TABLE EDI204SummaryHeader ADD eshShipFromStreetAddress4  nvarchar(75)

ALTER TABLE EDI856ManifestHeader ADD emhConsigneeStreetAddress3  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhConsigneeStreetAddress4  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhInterConsigneeStreetAddress3  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhInterConsigneeStreetAddress4  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhBillToStreetAddress3  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhBillToStreetAddress4  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhShipFromStreetAddress3  nvarchar(75)
ALTER TABLE EDI856ManifestHeader ADD emhShipFromStreetAddress4  nvarchar(75)

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobOriginStreetAddress3')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobOriginStreetAddress3', 'Street Address3', 'Street Address3', NULL, NULL, '', 125, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address3')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobOriginStreetAddress4')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobOriginStreetAddress4', 'Street Address4', 'Street Address4', NULL, NULL, '', 126, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address4')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobDeliveryStreetAddress3')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobDeliveryStreetAddress3', 'Street Address3', 'Street Address3', NULL, NULL, '', 127, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address3')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobDeliveryStreetAddress4')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobDeliveryStreetAddress4', 'Street Address4', 'Street Address4', NULL, NULL, '', 128, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address4')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobSellerStreetAddress3')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobSellerStreetAddress3', 'Street Address3', 'Street Address3', NULL, NULL, '', 129, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address3')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobSellerStreetAddress4')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobSellerStreetAddress4', 'Street Address4', 'Street Address4', NULL, NULL, '', 130, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address4')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobShipFromStreetAddress3')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobShipFromStreetAddress3', 'Street Address3', 'Street Address3', NULL, NULL, '', 131, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address3')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobShipFromStreetAddress4')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobShipFromStreetAddress4', 'Street Address4', 'Street Address4', NULL, NULL, '', 132, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Street Address4')
END

