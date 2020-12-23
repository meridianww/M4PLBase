SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI210InvoiceHistory](
	[einInvoiceID] [bigint] NOT NULL,
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
 CONSTRAINT [PK_EDI210InvoiceHistory] PRIMARY KEY CLUSTERED 
(
	[einInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
