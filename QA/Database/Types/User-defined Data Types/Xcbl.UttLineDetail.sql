CREATE TYPE [Xcbl].[UttLineDetail] AS TABLE(
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
	[LineNumberReference] [varchar](150) NULL
)
GO


