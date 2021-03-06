SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Xcbl].[SummaryHeader](
	[SummaryHeaderId] [bigint] IDENTITY(1,1) NOT NULL,
	[TradingPartner] [varchar](20) NULL,
	[GroupControlNo] [bigint] NULL,
	[BOLNo] [varchar](30) NULL,
	[MasterBOLNo] [varchar](30) NULL,
	[MethodOfPayment] [varchar](10) NULL,
	[SetPurpose] [varchar](10) NULL,
	[CustomerReferenceNo] [varchar](30) NULL,
	[ShipDescription] [varchar](30) NULL,
	[OrderType] [varchar](30) NULL,
	[PurchaseOrderNo] [varchar](30) NULL,
	[ShipDate] [datetime2](7) NULL,
	[ArrivalDate3PL] [datetime2](7) NULL,
	[ServiceMode] [nvarchar](30) NULL,
	[ProductType] [nvarchar](30) NULL,
	[ReasonCodeCancellation] [varchar](30) NULL,
	[ManifestNo] [varchar](30) NULL,
	[TotalWeight] [decimal](18, 2) NULL,
	[TotalCubicFeet] [decimal](18, 2) NULL,
	[TotalPieces] [bigint] NULL,
	[DeliveryCommitmentType] [varchar](30) NULL,
	[ScheduledPickupDate] [datetime2](7) NULL,
	[ScheduledDeliveryDate] [datetime2](7) NULL,
	[SpecialNotes] [varchar](max) NULL,
	[OrderedDate] [datetime2](7) NULL,
	[TextData] [varchar](max) NULL,
	[LocationId] [varchar](30) NULL,
	[LocationNumber] [varchar](30) NULL,
	[Latitude] [varchar](30) NULL,
	[Longitude] [varchar](30) NULL,
	[isxcblAcceptanceRequired] [bit] NOT NULL,
	[isxcblProcessed] [bit] NOT NULL,
	[isxcblRejected] [bit] NOT NULL,
	[ProcessingDate] [datetime2](7) NULL,
	[Action] [varchar](150) NULL,
	[TrailerNumber] [varchar](150) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [varchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[SummaryHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
