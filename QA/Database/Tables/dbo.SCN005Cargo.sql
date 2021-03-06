SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN005Cargo](
	[CargoID] [bigint] NOT NULL,
	[JobID] [bigint] NULL,
	[CgoLineItem] [int] NULL,
	[CgoPartNumCode] [nvarchar](30) NULL,
	[CgoQtyOrdered] [decimal](18, 2) NULL,
	[CgoQtyExpected] [decimal](18, 2) NULL,
	[CgoQtyCounted] [decimal](18, 2) NULL,
	[CgoQtyDamaged] [decimal](18, 2) NULL,
	[CgoQtyOnHold] [decimal](18, 2) NULL,
	[CgoQtyShort] [decimal](18, 2) NULL,
	[CgoQtyOver] [decimal](18, 2) NULL,
	[CgoQtyUnits] [nvarchar](20) NULL,
	[CgoStatus] [nvarchar](20) NULL,
	[CgoInfoID] [nvarchar](50) NULL,
	[ColorCD] [int] NULL,
	[CgoSerialCD] [nvarchar](255) NULL,
	[CgoLong] [nvarchar](30) NULL,
	[CgoLat] [nvarchar](30) NULL,
	[CgoMasterLabel] [nvarchar](30) NULL,
	[CgoProFlag01] [nvarchar](1) NULL,
	[CgoProFlag02] [nvarchar](1) NULL,
	[CgoProFlag03] [nvarchar](1) NULL,
	[CgoProFlag04] [nvarchar](1) NULL,
	[CgoProFlag05] [nvarchar](1) NULL,
	[CgoProFlag06] [nvarchar](1) NULL,
	[CgoProFlag07] [nvarchar](1) NULL,
	[CgoProFlag08] [nvarchar](1) NULL,
	[CgoProFlag09] [nvarchar](1) NULL,
	[CgoProFlag10] [nvarchar](1) NULL,
	[CgoProFlag11] [nvarchar](1) NULL,
	[CgoProFlag12] [nvarchar](1) NULL,
	[CgoProFlag13] [nvarchar](1) NULL,
	[CgoProFlag14] [nvarchar](1) NULL,
	[CgoProFlag15] [nvarchar](1) NULL,
	[CgoProFlag16] [nvarchar](1) NULL,
	[CgoProFlag17] [nvarchar](1) NULL,
	[CgoProFlag18] [nvarchar](1) NULL,
	[CgoProFlag19] [nvarchar](1) NULL,
	[CgoProFlag20] [nvarchar](1) NULL,
 CONSTRAINT [PK__SCN005Ca__B4E665ED3E6CD243] PRIMARY KEY CLUSTERED 
(
	[CargoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
