SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[LineDetail](
	[LineDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[SummaryHeaderId] [bigint] NOT NULL,
	[LineNumber] [varchar](150) NULL,
	[ItemID] [varchar](150) NULL,
	[ItemDescription] [varchar](500) NULL,
	[ShipQuantity] [int] NULL,
	[Weight] [decimal](18, 0) NULL,
	[WeightUnitOfMeasure] [varchar](150) NULL,
	[Volume] [varchar](150) NULL,
	[VolumeUnitOfMeasure] [varchar](50) NULL,
	[SecondaryLocation] [varchar](500) NULL,
	[MaterialType] [varchar](500) NULL,
	[ShipUnitOfMeasure] [varchar](50) NULL,
	[CustomerStockNumber] [varchar](150) NULL,
	[StatusCode] [varchar](150) NULL,
	[EDILINEID] [varchar](150) NULL,
	[MaterialTypeDescription] [varchar](150) NULL,
	[LineNumberReference] [varchar](150) NULL,
 CONSTRAINT [PK_LineDetail] PRIMARY KEY CLUSTERED 
(
	[LineDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Xcbl].[LineDetail]  WITH CHECK ADD  CONSTRAINT [FK_LineDetail_SummaryHeaderId] FOREIGN KEY([SummaryHeaderId])
REFERENCES [Xcbl].[SummaryHeader] ([SummaryHeaderId])
GO

ALTER TABLE [Xcbl].[LineDetail] CHECK CONSTRAINT [FK_LineDetail_SummaryHeaderId]
GO


