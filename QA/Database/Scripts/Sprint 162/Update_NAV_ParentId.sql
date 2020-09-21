IF NOT EXISTS(Select 1 From dbo.NAV000OrderMapping Where M4PLColumn = 'JobBOLMaster' AND EntityName = 'SalesOrder' AND NavColumn = 'Parent_ID')
BEGIN
INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn,TableName,EntityName)
Values ('JobBOLMaster','Parent_ID','Job','SalesOrder')
END


IF NOT EXISTS(Select 1 From dbo.NAV000OrderMapping Where M4PLColumn = 'JobBOLMaster' AND EntityName = 'PurchaseOrder' AND NavColumn = 'Parent_ID')
BEGIN
INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn,TableName,EntityName)
Values ('JobBOLMaster','Parent_ID','Job','PurchaseOrder')
END