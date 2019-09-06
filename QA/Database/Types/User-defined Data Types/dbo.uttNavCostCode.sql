CREATE TYPE [dbo].[uttNavCostCode] AS TABLE(
	[ItemId] Varchar(50)  NULL,
	[VendorNo] Varchar(50) NULL,
	[StartDate] Varchar(50) NULL,
	[CurrencyCode] Varchar(50) NULL,
	[VariantCode] Varchar(50) NULL,
	[MeasureCodeUnit] Varchar(50) NULL,
	[MinimumQuantity] Varchar(50) NULL,
	[VendNoFilterCtrl] Varchar(50) NULL,
	[ItemNoFIlterCtrl] Varchar(50) NULL,
	[StartingDateFilter] Varchar(50) NULL,
	[DirectUnitCost] Varchar(50) NULL,
	[EndingDate] Varchar(50) NULL
)
GO
