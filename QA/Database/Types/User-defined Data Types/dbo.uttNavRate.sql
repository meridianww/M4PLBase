CREATE TYPE [dbo].[uttNavRate] AS TABLE(
	[Location] [nvarchar](150) NULL,
	[Code] [nvarchar](50) NULL,
	[CustomerCode] [nvarchar](50) NULL,
	[VendorCode] [nvarchar](50) NULL,
	[EffectiveDate] [datetime2](7) NULL,
	[Title] [nvarchar](150) NULL,
	[BillablePrice] [decimal](18, 2) NULL,
	[CostRate] [decimal](18, 2) NULL,
	[BillableElectronicInvoice] [bit] NULL,
	[CostElectronicInvoice] [bit] NULL,
	[Category] [int] NULL
)
GO
