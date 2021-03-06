SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI856ManifestDetail](
	[emdDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[emhHeaderID] [bigint] NULL,
	[emdTradingPartner] [varchar](20) NULL,
	[emdGroupControlNo] [int] NULL,
	[emdBOLNo] [varchar](30) NULL,
	[emdManifestNo] [varchar](30) NULL,
	[emdItemWeight] [decimal](18, 2) NULL,
	[emdWeightQualifier] [varchar](10) NULL,
	[emdWeightUnitOfMeasure] [varchar](10) NULL,
	[emdItemVolume] [decimal](18, 2) NULL,
	[emdVolumeQualifier] [varchar](10) NULL,
	[emdVolumeUnitOfMeasure] [varchar](10) NULL,
	[emdItemQuantity] [int] NULL,
	[emdBarCodeSerialNumber] [varchar](50) NULL,
	[emdItemDescription] [varchar](80) NULL,
	[emdShipQuantity] [varchar](30) NULL,
	[emdPackagingCode] [varchar](50) NULL,
	[emdCommodityCode] [varchar](50) NULL,
	[emdMasterLblQualifier] [nvarchar](30) NULL,
	[emdMasterSerialNumber] [nvarchar](30) NULL,
	[emdUDF01] [varchar](30) NULL,
	[emdUDF02] [varchar](30) NULL,
	[emdUDF03] [varchar](30) NULL,
	[emdUDF04] [varchar](30) NULL,
	[emdUDF05] [varchar](30) NULL,
	[emdUDF06] [varchar](30) NULL,
	[emdUDF07] [varchar](30) NULL,
	[emdUDF08] [varchar](30) NULL,
	[emdUDF09] [varchar](30) NULL,
	[emdUDF10] [varchar](30) NULL,
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
 CONSTRAINT [PK_EDI856ManifestDetail] PRIMARY KEY CLUSTERED 
(
	[emdDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI856ManifestDetail] ADD  CONSTRAINT [DF_EDI856ManifestDetail_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
