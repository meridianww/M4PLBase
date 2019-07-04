SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI204SummaryHeader](
	[eshHeaderID] [bigint] IDENTITY(1,1) NOT NULL,
	[eshTradingPartner] [varchar](20) NULL,
	[eshGroupControlNo] [bigint] NULL,
	[eshBOLNo] [varchar](30) NULL,
	[eshMasterBOLNo] [varchar](30) NULL,
	[eshMethodOfPayment] [varchar](10) NULL,
	[eshSetPurpose] [varchar](10) NULL,
	[eshCustomerReferenceNo] [varchar](30) NULL,
	[eshLocationId] [varchar](30) NULL,
	[eshShipDescription] [varchar](30) NULL,
	[eshOrderType] [varchar](30) NULL,
	[eshPurchaseOrderNo] [varchar](30) NULL,
	[eshLocationNumber] [varchar](30) NULL,
	[eshShipDate] [datetime2](7) NULL,
	[eshArrivalDate3PL] [datetime2](7) NULL,
	[eshProductType] [varchar](30) NULL,
	[eshLatitude] [varchar](30) NULL,
	[eshLongitude] [varchar](30) NULL,
	[eshReasonCodeCancellation] [varchar](30) NULL,
	[eshManifestNo] [varchar](30) NULL,
	[eshTotalWeight] [decimal](18, 2) NULL,
	[eshTotalCubicFeet] [decimal](18, 2) NULL,
	[eshTotalPieces] [bigint] NULL,
	[eshDeliveryCommitmentType] [varchar](30) NULL,
	[eshScheduledPickupDate] [datetime2](7) NULL,
	[eshScheduledDeliveryDate] [datetime2](7) NULL,
	[eshSpecialNotes] [varchar](30) NULL,
	[eshConsigneeName] [varchar](60) NULL,
	[eshConsigneeNameID] [bigint] NULL,
	[eshConsigneeAddress1] [varchar](75) NULL,
	[eshConsigneeAddress2] [varchar](75) NULL,
	[eshConsigneeCity] [varchar](75) NULL,
	[eshConsigneeState] [varchar](25) NULL,
	[eshConsigneePostalCode] [varchar](15) NULL,
	[eshConsigneeCountryCode] [varchar](10) NULL,
	[eshConsigneeContactName] [varchar](75) NULL,
	[eshConsigneeContactNumber] [varchar](80) NULL,
	[eshConsigneeAltContName] [varchar](75) NULL,
	[eshConsigneeAltContNumber] [varchar](80) NULL,
	[eshInterConsigneeName] [varchar](60) NULL,
	[eshInterConsigneeNameID] [bigint] NULL,
	[eshInterConsigneeAddress1] [varchar](75) NULL,
	[eshInterConsigneeAddress2] [varchar](75) NULL,
	[eshInterConsigneeCity] [varchar](75) NULL,
	[eshInterConsigneeState] [varchar](25) NULL,
	[eshInterConsigneePostalCode] [varchar](15) NULL,
	[eshInterConsigneeCountryCode] [varchar](10) NULL,
	[eshInterConsigneeContactName] [varchar](75) NULL,
	[eshInterConsigneeContactNumber] [varchar](80) NULL,
	[eshInterConsigneeAltContName] [varchar](75) NULL,
	[eshInterConsigneeAltContNumber] [varchar](80) NULL,
	[eshShipFromName] [varchar](60) NULL,
	[eshShipFromNameID] [bigint] NULL,
	[eshShipFromAddress1] [varchar](75) NULL,
	[eshShipFromAddress2] [varchar](75) NULL,
	[eshShipFromCity] [varchar](75) NULL,
	[eshShipFromState] [varchar](25) NULL,
	[eshShipFromPostalCode] [varchar](15) NULL,
	[eshShipFromCountryCode] [varchar](10) NULL,
	[eshShipFromContactName] [varchar](75) NULL,
	[eshShipFromContactNumber] [varchar](80) NULL,
	[eshShipFromAltContName] [varchar](75) NULL,
	[eshShipFromAltContNumber] [varchar](80) NULL,
	[eshBillToName] [varchar](60) NULL,
	[eshBillToNameID] [bigint] NULL,
	[eshBillToAddress1] [varchar](75) NULL,
	[eshBillToAddress2] [varchar](75) NULL,
	[eshBillToCity] [varchar](75) NULL,
	[eshBillToState] [varchar](25) NULL,
	[eshBillToPostalCode] [varchar](15) NULL,
	[eshBillToCountryCode] [varchar](10) NULL,
	[eshBillToContactName] [varchar](75) NULL,
	[eshBillToContactNumber] [varchar](80) NULL,
	[eshBillToAltContName] [varchar](75) NULL,
	[eshBillToAltContNumber] [varchar](80) NULL,
	[eshTextData] [varchar](max) NULL,
	[eshUDF01] [varchar](30) NULL,
	[eshUDF02] [varchar](30) NULL,
	[eshUDF03] [varchar](30) NULL,
	[eshUDF04] [varchar](30) NULL,
	[eshUDF05] [varchar](30) NULL,
	[eshUDF06] [varchar](30) NULL,
	[eshUDF07] [varchar](30) NULL,
	[eshUDF08] [varchar](30) NULL,
	[eshUDF09] [varchar](30) NULL,
	[eshUDF10] [varchar](30) NULL,
	[ProFlags01] [varchar](1) NULL,
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
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [varchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [varchar](50) NULL,
 CONSTRAINT [PK_EDI204SummaryHeader] PRIMARY KEY CLUSTERED 
(
	[eshHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[EDI204SummaryHeader] ADD  CONSTRAINT [DF_PK_EDI204SummaryHeader_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Group Control Number - Assigned By Sender, increments by one for each transaction set' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshGroupControlNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill of Lading' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBOLNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Master BOL Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshMasterBOLNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Method of Payment - CC: Collect, PP: Prepaid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshMethodOfPayment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction Set Purpose - 00: Original, 01: Cancel Request, 05: Replace, 21: Hold' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshSetPurpose'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Reference Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshCustomerReferenceNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location ID of Ship From' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshLocationId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Shipment - H: Home, L: Store, B: Builder' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Order - AO: Regular Order, AA: Return Order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshOrderType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Purchase Order Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshPurchaseOrderNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location Number (Domicile)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshLocationNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Ship Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Arrival Date at the 3PL Location' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshArrivalDate3PL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product Type / Customer Brand' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshProductType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude of Delivery Address - Format is Degrees, Minutes, Seconds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshLatitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude of Delivery Address - Format is Degrees, Minutes, Seconds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshLongitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reason Code for Cancellation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshReasonCodeCancellation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshTotalWeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Cubic Feet' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshTotalCubicFeet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Pieces' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshTotalPieces'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Commitment Type - FC: Firm Delivery Date, SA: Standard Delivery Appointment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshDeliveryCommitmentType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scheduled Pickup Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshScheduledPickupDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scheduled Pickup Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshScheduledDeliveryDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Special Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshSpecialNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cosignee Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneePostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeContactName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeContactNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Alternate Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeAltContName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Alternate Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshConsigneeAltContNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Intermediate Consignee Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshInterConsigneeContactName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromContactName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromContactNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Alternate Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromAltContName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship From Alternate Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshShipFromAltContNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToContactName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToContactNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Alternate Contact Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToAltContName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill To Alternate Contact Communication Number - Telephone or Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryHeader', @level2type=N'COLUMN',@level2name=N'eshBillToAltContNumber'
GO
