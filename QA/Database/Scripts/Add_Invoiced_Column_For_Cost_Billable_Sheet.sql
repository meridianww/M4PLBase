IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CstInvoiced' AND Object_ID = Object_ID(N'dbo.JOBDL062CostSheet'))
BEGIN
ALTER TABLE dbo.JOBDL062CostSheet ADD CstInvoiced BIT NOT NULL Default(0) 
END

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'PrcInvoiced' AND Object_ID = Object_ID(N'dbo.JOBDL061BillableSheet'))
BEGIN
ALTER TABLE dbo.JOBDL061BillableSheet ADD PrcInvoiced BIT NOT NULL Default(0) 
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobCostSheet' AND ColColumnName = 'CstInvoiced')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobCostSheet', NULL, 'CstInvoiced', 'Invoiced', 'Invoiced', NULL, NULL, '', 22, 1, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Invoiced')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobBillableSheet' AND ColColumnName = 'PrcInvoiced')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobBillableSheet', NULL, 'PrcInvoiced', 'Invoiced', 'Invoiced', NULL, NULL, '', 22, 1, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Invoiced')
END