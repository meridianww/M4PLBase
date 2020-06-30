UPDATE dbo.NAV000OrderMapping
SET M4PLColumn = 'JobCustomerSalesOrder'
WHERE EntityName = 'PurchaseOrder'
	AND NavColumn = 'Vendor_Order_No'

UPDATE dbo.NAV000OrderMapping
SET M4PLColumn = 'CONCAT(CAST(Job.Id AS VARCHAR),''-'',FORMAT(GetDate(),''yyyyMMdd''))'
WHERE EntityName = 'PurchaseOrder'
	AND NavColumn = 'Vendor_Invoice_No'

IF NOT EXISTS (
		SELECT 1
		FROM dbo.NAV000OrderMapping
		WHERE EntityName = 'PurchaseOrder'
			AND NavColumn = 'External_Document_No'
		)
BEGIN
	INSERT INTO dbo.NAV000OrderMapping (
		M4PLColumn
		,NavColumn
		,TableName
		,EntityName
		)
	VALUES (
		'JobBOL'
		,'External_Document_No'
		,'Job'
		,'PurchaseOrder'
		)
END