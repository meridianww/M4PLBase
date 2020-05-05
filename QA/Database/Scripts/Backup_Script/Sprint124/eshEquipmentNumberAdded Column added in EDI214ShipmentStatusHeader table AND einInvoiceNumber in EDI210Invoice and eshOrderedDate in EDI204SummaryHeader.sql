IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[EDI214ShipmentStatusHeader]')
			AND name = 'eshEquipmentNumber'
		)
BEGIN
	 ALTER TABLE dbo.EDI214ShipmentStatusHeader ADD eshEquipmentNumber varchar(10) NULL
END
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[EDI210Invoice]')
			AND name = 'einInvoiceNumber'
		)
BEGIN
	 ALTER TABLE dbo.EDI210Invoice ADD einInvoiceNumber varchar(30) NULL
END
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[EDI204SummaryHeader]')
			AND name = 'eshOrderedDate'
		)
BEGIN
	 ALTER TABLE dbo.EDI204SummaryHeader ADD eshOrderedDate datetime2 NULL
END
GO