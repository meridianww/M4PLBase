SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN006CargoDetail](
	[CargoDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[CargoID] [bigint] NULL,
	[DetSerialNumber] [nvarchar](255) NULL,
	[DetQtyCounted] [decimal](18, 2) NULL,
	[DetQtyDamaged] [decimal](18, 2) NULL,
	[DetQtyShort] [decimal](18, 2) NULL,
	[DetQtyOver] [decimal](18, 2) NULL,
	[DetPickStatus] [nvarchar](20) NULL,
	[DetLong] [nvarchar](30) NULL,
	[DetLat] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[CargoDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
