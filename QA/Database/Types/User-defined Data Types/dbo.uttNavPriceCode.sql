CREATE TYPE [dbo].[uttNavPriceCode] AS TABLE(
	[ItemId] [varchar](50) NULL,
	[SalesType] [varchar](50) NULL,
	[SalesCode] [varchar](50) NULL,
	[StartingDate] [varchar](50) NULL,
	[CurrencyCode] [varchar](50) NULL,
	[VariantCode] [varchar](50) NULL,
	[MeasureCodeUnit] [varchar](50) NULL,
	[MinimumQuantity] [varchar](50) NULL,
	[SalesTypeFilter] [varchar](50) NULL,
	[SalesCodeFilterCtrl] [varchar](50) NULL,
	[ItemNoFilterCtrl] [varchar](50) NULL,
	[StartingDateFilter] [varchar](50) NULL,
	[SalesCodeFilterCtrl2] [varchar](50) NULL,
	[GetFilterDescription] [varchar](50) NULL,
	[UnitPrice] [varchar](50) NULL,
	[EndingDate] [varchar](50) NULL,
	[PriceIncludesVAT] [varchar](50) NULL,
	[AllowLineDisc] [varchar](50) NULL,
	[AllowInvoiceDisc] [varchar](50) NULL,
	[VATBusPostingGrPrice] [varchar](50) NULL
)
GO
