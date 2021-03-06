SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI210Invoice](
	[einInvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[einTradingPartner] [varchar](20) NULL,
	[einShipmentID] [varchar](30) NULL,
	[einPaymentType] [varchar](10) NULL,
	[einCurrencyCode] [varchar](10) NULL,
	[einInvoiceDate] [varchar](50) NULL,
	[einTotalAmountDue] [decimal](18, 2) NULL,
	[einDeliveryDate] [varchar](50) NULL,
	[einSCACCode] [varchar](80) NULL,
	[einPickupDate] [varchar](50) NULL,
	[einTotalWeight] [decimal](18, 2) NULL,
	[einShipperName] [varchar](60) NULL,
	[einShipperNameID] [bigint] NULL,
	[einShipperAddress1] [varchar](75) NULL,
	[einShipperAddress2] [varchar](75) NULL,
	[einShipperCity] [varchar](75) NULL,
	[einShipperState] [varchar](25) NULL,
	[einShipperPostalCode] [varchar](15) NULL,
	[einShipperCountryCode] [varchar](10) NULL,
	[einShipFromName] [varchar](60) NULL,
	[einShipFromNameID] [bigint] NULL,
	[einShipFromAddress1] [varchar](75) NULL,
	[einShipFromAddress2] [varchar](75) NULL,
	[einShipFromCity] [varchar](75) NULL,
	[einShipFromState] [varchar](25) NULL,
	[einShipFromPostalCode] [varchar](15) NULL,
	[einShipFromCountryCode] [varchar](10) NULL,
	[einConsigneeName] [varchar](60) NULL,
	[einConsigneeNameID] [bigint] NULL,
	[einConsigneeAddress1] [varchar](75) NULL,
	[einConsigneeAddress2] [varchar](75) NULL,
	[einConsigneeCity] [varchar](75) NULL,
	[einConsigneeState] [varchar](25) NULL,
	[einConsigneePostalCode] [varchar](15) NULL,
	[einConsigneeCountryCode] [varchar](10) NULL,
	[einShipToName] [varchar](60) NULL,
	[einShipToNameID] [bigint] NULL,
	[einShipToAddress1] [varchar](75) NULL,
	[einShipToAddress2] [varchar](75) NULL,
	[einShipToCity] [varchar](75) NULL,
	[einShipToState] [varchar](25) NULL,
	[einShipToPostalCode] [varchar](15) NULL,
	[einShipToCountryCode] [varchar](10) NULL,
	[einBillToName] [varchar](60) NULL,
	[einBillToAddress1] [varchar](75) NULL,
	[einBillToAddress2] [varchar](75) NULL,
	[einBillToCity] [varchar](75) NULL,
	[einBillToState] [varchar](25) NULL,
	[einBillToPostalCode] [varchar](15) NULL,
	[einBillToCountryCode] [varchar](10) NULL,
	[einWeight] [decimal](18, 2) NULL,
	[einWeightQualifier] [varchar](10) NULL,
	[einLadingDescription] [varchar](50) NULL,
	[einCommodityCode] [varchar](50) NULL,
	[einPieces] [bigint] NULL,
	[einFreightCharge] [decimal](18, 2) NULL,
	[einFuelSurcharge] [decimal](18, 2) NULL,
	[einVolume] [decimal](18, 2) NULL,
	[einVolumeQualifier] [varchar](10) NULL,
	[einAdditionalHandling] [varchar](45) NULL,
	[einCabinetReturn] [varchar](45) NULL,
	[einGoodSalesTax] [varchar](45) NULL,
	[einHarmonizedServiceTax] [varchar](45) NULL,
	[einInsideDelivery] [varchar](45) NULL,
	[einMinimumCharge] [varchar](45) NULL,
	[einOutOfRangeMiles] [varchar](45) NULL,
	[einPickupCharge] [varchar](45) NULL,
	[einReconsignment] [varchar](45) NULL,
	[einRedeliveryAttempt] [varchar](45) NULL,
	[einHolidayOrWeekendDelivery] [varchar](45) NULL,
	[einSpecialDelivery] [varchar](45) NULL,
	[einStairsExcessDelivery] [varchar](45) NULL,
	[einStorage] [varchar](45) NULL,
	[einStanisciHandling] [varchar](45) NULL,
	[einUnloadingFee] [varchar](45) NULL,
	[einBridgeToll] [varchar](45) NULL,
	[einExtraLabor] [varchar](45) NULL,
	[einHighwayToll] [varchar](45) NULL,
	[einAccessorial1] [varchar](45) NULL,
	[einAccessorial2] [varchar](45) NULL,
	[einAccessorial3] [varchar](45) NULL,
	[einAccessorial4] [varchar](45) NULL,
	[einAccessorial5] [varchar](45) NULL,
	[einAccessorial6] [varchar](45) NULL,
	[einAccessorial7] [varchar](45) NULL,
	[einAccessorial8] [varchar](45) NULL,
	[einAccessorial9] [varchar](45) NULL,
	[einAccessorial10] [varchar](45) NULL,
	[ProFlags02] [varchar](1) NULL,
	[ProFlags03] [varchar](1) NULL,
	[ProFlags04] [varchar](1) NULL,
	[ProFlags05] [varchar](1) NULL,
	[ProFlags06] [varchar](1) NULL,
	[ProFlags07] [varchar](1) NULL,
	[ProFlags08] [varchar](1) NULL,
	[ProFlags09] [varchar](1) NULL,
	[ProFlags10] [varchar](1) NULL,
	[ProFlags11] [varchar](1) NULL,
	[ProFlags12] [varchar](1) NULL,
	[ProFlags13] [varchar](1) NULL,
	[ProFlags14] [varchar](1) NULL,
	[ProFlags15] [varchar](1) NULL,
	[ProFlags16] [varchar](1) NULL,
	[ProFlags17] [varchar](1) NULL,
	[ProFlags18] [varchar](1) NULL,
	[ProFlags19] [varchar](1) NULL,
	[ProFlags20] [varchar](1) NULL,
	[einInvoiceNumber] [varchar](30) NULL,
	[einFuelSurchargeQty] [int] NULL,
	[einAdditionalHandlingQty] [int] NULL,
	[einCabinetReturnQty] [int] NULL,
	[einGoodSalesTaxQty] [int] NULL,
	[einHarmonizedServiceTaxQty] [int] NULL,
	[einInsideDeliveryQty] [int] NULL,
	[einMinimumChargeQty] [int] NULL,
	[einOutOfRangeMilesQty] [int] NULL,
	[einPickupChargeQty] [int] NULL,
	[einReconsignmentQty] [int] NULL,
	[einRedeliveryAttemptQty] [int] NULL,
	[einHolidayOrWeekendDeliveryQty] [int] NULL,
	[einSpecialDeliveryQty] [int] NULL,
	[einStairsExcessDeliveryQty] [int] NULL,
	[einStorageQty] [int] NULL,
	[einStanisciHandlingQty] [int] NULL,
	[einUnloadingFeeQty] [int] NULL,
	[einBridgeTollQty] [int] NULL,
	[einExtraLaborQty] [int] NULL,
	[einHighwayTollQty] [int] NULL,
	[einAccessorial1Qty] [int] NULL,
	[einAccessorial2Qty] [int] NULL,
	[einAccessorial3Qty] [int] NULL,
	[einAccessorial4Qty] [int] NULL,
	[einAccessorial5Qty] [int] NULL,
	[einAccessorial6Qty] [int] NULL,
	[einAccessorial7Qty] [int] NULL,
	[einAccessorial8Qty] [int] NULL,
	[einAccessorial9Qty] [int] NULL,
	[einAccessorial10Qty] [int] NULL,
 CONSTRAINT [PK_EDI210Invoice] PRIMARY KEY CLUSTERED 
(
	[einInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipment ID - Customer Reference Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipmentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Method of Payment - CC: Collect, PP: Prepaid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einPaymentType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Currency Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einCurrencyCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of Invoice' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einInvoiceDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Amount Due' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einTotalAmountDue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einDeliveryDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SCAC Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einSCACCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Pickup Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einPickupDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einTotalWeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipper Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipperCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipFromCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cosignee Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneePostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einConsigneeCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship To Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einShipToCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBillToCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einWeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight Qualifier - G:Pounds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einWeightQualifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lading Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einLadingDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commodity Code - Mutually Defined' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einCommodityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Pieces' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einPieces'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Freight Charge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einFreightCharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Fuel Surcharge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einFuelSurcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Volume' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Volume Qualifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einVolumeQualifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Additional Handling ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einAdditionalHandling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cabinet Return' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einCabinetReturn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Goods and Sales Tax' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einGoodSalesTax'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Harmonized Service Tac' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einHarmonizedServiceTax'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inside Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einInsideDelivery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum Charge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einMinimumCharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Out of Range Miles' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einOutOfRangeMiles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Pickup Charge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einPickupCharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reconsignment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einReconsignment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Redelivery Attempt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einRedeliveryAttempt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Holiday or Weekend Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einHolidayOrWeekendDelivery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Special Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einSpecialDelivery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stairs Excess Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einStairsExcessDelivery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Storage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einStorage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stanisci Handling' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einStanisciHandling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unloading Fee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einUnloadingFee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bridge Toll' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einBridgeToll'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Extra Labor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einExtraLabor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Highway Toll' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI210Invoice', @level2type=N'COLUMN',@level2name=N'einHighwayToll'
GO
