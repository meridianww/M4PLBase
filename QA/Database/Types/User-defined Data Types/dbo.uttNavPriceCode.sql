CREATE TYPE [dbo].[uttNavPriceCode] AS TABLE(
	[ItemId] Varchar(50)  NULL,
	[SalesType] Varchar(50) NULL,
	[SalesCode] Varchar(50) NULL,
	[StartingDate] Varchar(50) NULL,
	[CurrencyCode] Varchar(50) NULL,
	[VariantCode] Varchar(50) NULL,
	[MeasureCodeUnit] Varchar(50) NULL,
	[MinimumQuantity] Varchar(50) NULL,
	[SalesTypeFilter] Varchar(50) NULL,
	[SalesCodeFilterCtrl] Varchar(50) NULL,
	[ItemNoFilterCtrl] Varchar(50) NULL,
	[StartingDateFilter] Varchar(50) NULL,
	[SalesCodeFilterCtrl2] Varchar(50) NULL,
	[GetFilterDescription] Varchar(50) NULL,
	[UnitPrice] Varchar(50) NULL,
	[EndingDate] Varchar(50) NULL,
	[PriceIncludesVAT] Varchar(50) NULL,
	[AllowLineDisc] Varchar(50) NULL,
	[AllowInvoiceDisc] Varchar(50) NULL,
	[VATBusPostingGrPrice] Varchar(50) NULL

)
GO


