IF NOT EXISTS(Select 1 From dbo.NAV000OrderMapping Where NavColumn = 'Quantity' AND EntityName = 'SalesOrder')
BEGIN
INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName)
Values ('JobQtyActual', 'Quantity', 'Job', 'SalesOrder')
END

IF NOT EXISTS(Select 1 From dbo.NAV000OrderMapping Where NavColumn = 'Quantity' AND EntityName = 'PurchaseOrder')
BEGIN
INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName)
Values ('JobQtyActual', 'Quantity', 'Job', 'PurchaseOrder')
END