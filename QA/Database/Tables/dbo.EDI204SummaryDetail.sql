SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI204SummaryDetail](
	[esdDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[eshHeaderID] [bigint] NULL,
	[esdTradingPartner] [varchar](20) NULL,
	[esdBOLNo] [varchar](30) NULL,
	[esdManifestNo] [varchar](30) NULL,
	[esdCommodityType] [varchar](50) NULL,
	[esdCommodityDescription] [varchar](50) NULL,
	[esdUnitOfMeasure] [varchar](10) NULL,
	[esdWeight] [decimal](18, 2) NULL,
	[esdQuantity] [bigint] NULL,
	[esdCubicFeet] [decimal](18, 2) NULL,
	[esdUDF01] [varchar](30) NULL,
	[esdUDF02] [varchar](30) NULL,
	[esdUDF03] [varchar](30) NULL,
	[esdUDF04] [varchar](30) NULL,
	[esdUDF05] [varchar](30) NULL,
	[esdUDF06] [varchar](30) NULL,
	[esdUDF07] [varchar](30) NULL,
	[esdUDF08] [varchar](30) NULL,
	[esdUDF09] [varchar](30) NULL,
	[esdUDF10] [varchar](30) NULL,
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
 CONSTRAINT [PK_EDI204SummaryDetail] PRIMARY KEY CLUSTERED 
(
	[esdDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI204SummaryDetail] ADD  CONSTRAINT [DF_PK_EDI204SummaryDetail_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI 204 Summary Detail Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdDetailID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill of Lading' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdBOLNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commodity Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdCommodityType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commodity Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdCommodityDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight Unit of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdUnitOfMeasure'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Line Weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdWeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lading Quantity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdQuantity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Line Item Volume' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI204SummaryDetail', @level2type=N'COLUMN',@level2name=N'esdCubicFeet'
GO
