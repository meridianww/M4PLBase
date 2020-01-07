IF NOT EXISTS(Select 1 From NAV000OrderMapping Where EntityName = 'ShippingItem' AND M4PLColumn = 'PrcElectronicBilling')
BEGIN
INSERT INTO NAV000OrderMapping (M4PLColumn,NavColumn,TableName,EntityName)
VALUES ('PrcElectronicBilling', 'Electronic_Invoice', 'BillableSheet','ShippingItem')
END
IF NOT EXISTS(Select 1 From NAV000OrderMapping Where EntityName = 'PurchaseOrderItem' AND M4PLColumn = 'CstElectronicBilling')
BEGIN
INSERT INTO NAV000OrderMapping (M4PLColumn,NavColumn,TableName,EntityName)
VALUES ('CstElectronicBilling', 'Electronic_Invoice', 'CostSheet','PurchaseOrderItem')
END