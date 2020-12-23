IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'JobDL000Master' AND column_name = 'JobSalesInvoiceNumber')  
BEGIN
    ALTER Table dbo.JobDL000Master ADD JobSalesInvoiceNumber nvarchar(50)
END 

IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'JobDL000Master' AND column_name = 'JobPurchaseInvoiceNumber')  
BEGIN
    ALTER Table dbo.JobDL000Master ADD JobPurchaseInvoiceNumber nvarchar(50)
END 

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobSalesInvoiceNumber')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobSalesInvoiceNumber', 'Sales Invoice Number', 'Sales Invoice Number', NULL, NULL, '', 141, 1, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Sales Invoice Number')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobPurchaseInvoiceNumber')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Job', NULL, 'JobPurchaseInvoiceNumber', 'Purchase Invoice Number', 'Purchase Invoice Number', NULL, NULL, '', 142, 1, 0, 1, 1, NULL, 0, 0, NULL, 0, 'Purchase Invoice Number')
END
