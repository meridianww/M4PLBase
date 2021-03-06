ALTER TABLE dbo.NAV000JobOrderItemMapping ADD Document_Number Varchar(50) NULL
UPDATE NAV000OrderMapping SET M4PLColumn = 'CASE WHEN ISNULL(BillableSheet.PrcElectronicBilling,0) = 0 THEN JOM.SONumber ELSE EJOM.SONumber END', SpecialHandling = 1 
Where M4PLColumn='SONumber'  AND NavColumn='Document_No'
UPDATE dbo.NAV000OrderMapping SET M4PLColumn = 'CASE WHEN ISNULL(CostSheet.CstElectronicBilling,0) = 0 THEN JOM.PONumber ELSE EJOM.PONumber END', SpecialHandling = 1
Where EntityName = 'PurchaseOrderItem' AND NavColumn =  'Document_No'