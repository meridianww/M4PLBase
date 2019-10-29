SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
	[eshShipDescription] [varchar](80) NULL,
	[eshOrderType] [varchar](30) NULL,
	[eshPurchaseOrderNo] [varchar](30) NULL,
	[eshLocationNumber] [varchar](30) NULL,
	[eshShipDate] [datetime2](7) NULL,
	[eshArrivalDate3PL] [datetime2](7) NULL,
	[eshServiceMode] [nvarchar](30) NULL,
	[eshProductType] [nvarchar](30) NULL,
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
	[eshShipToName] [varchar](60) NULL,
	[eshShipToNameID] [bigint] NULL,
	[eshShipToAddress1] [varchar](75) NULL,
	[eshShipToAddress2] [varchar](75) NULL,
	[eshShipToCity] [varchar](75) NULL,
	[eshShipToState] [varchar](25) NULL,
	[eshShipToPostalCode] [varchar](15) NULL,
	[eshShipToCountryCode] [varchar](10) NULL,
	[eshShipToContactName] [varchar](75) NULL,
	[eshShipToContactNumber] [varchar](80) NULL,
	[eshShipToAltContName] [varchar](75) NULL,
	[eshShipToAltContNumber] [varchar](80) NULL,
 CONSTRAINT [PK_EDI204SummaryHeader] PRIMARY KEY CLUSTERED 
(
	[eshHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDI204SummaryHeader] ADD  CONSTRAINT [DF_PK_EDI204SummaryHeader_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
