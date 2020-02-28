SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[XcblSummaryDetail](
	[xcblDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[xcblHeaderID] [bigint] NULL,
	[xcblTradingPartner] [varchar](20) NULL,
	[xcblBOLNo] [varchar](30) NULL,
	[xcblManifestNo] [varchar](30) NULL,
	[xcblCommodityType] [varchar](50) NULL,
	[xcblCommodityDescription] [varchar](50) NULL,
	[xcblUnitOfMeasure] [varchar](10) NULL,
	[xcblWeight] [decimal](18, 2) NULL,
	[xcblQuantity] [bigint] NULL,
	[xcblCubicFeet] [decimal](18, 2) NULL,
	[xcblUDF01] [varchar](30) NULL,
	[xcblUDF02] [varchar](30) NULL,
	[xcblUDF03] [varchar](30) NULL,
	[xcblUDF04] [varchar](30) NULL,
	[xcblUDF05] [varchar](30) NULL,
	[xcblUDF06] [varchar](30) NULL,
	[xcblUDF07] [varchar](30) NULL,
	[xcblUDF08] [varchar](30) NULL,
	[xcblUDF09] [varchar](30) NULL,
	[xcblUDF10] [varchar](30) NULL,
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
 CONSTRAINT [PK_XcblSummaryDetail] PRIMARY KEY CLUSTERED 
(
	[xcblDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[XcblSummaryDetail] ADD  CONSTRAINT [DF_PK_XcblSummaryDetail_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO

ALTER TABLE [dbo].[XcblSummaryDetail]  WITH CHECK ADD  CONSTRAINT [FK_XcblSummaryDetail_xcblHeaderID] FOREIGN KEY([xcblHeaderID])
REFERENCES [dbo].[XcblSummaryHeader] ([xcblHeaderID])
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI 204 Summary Detail Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblDetailID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblTradingPartner'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill of Lading' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblBOLNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commodity Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblCommodityType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commodity Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblCommodityDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight Unit of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblUnitOfMeasure'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Line Weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblWeight'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lading Quantity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblQuantity'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Line Item Volume' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'XcblSummaryDetail', @level2type=N'COLUMN',@level2name=N'xcblCubicFeet'
GO


