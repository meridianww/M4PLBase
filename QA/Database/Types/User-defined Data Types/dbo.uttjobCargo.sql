CREATE TYPE [dbo].[uttjobCargo] AS TABLE(
	[JobID] [bigint] NULL,
	[CgoLineItem] [int] NULL,
	[CgoPartNumCode] [nvarchar](30) NULL,
	[CgoTitle] [nvarchar](50) NULL,
	[CgoSerialNumber] [nvarchar](255) NULL,
	[CgoPackagingType] [nvarchar](20) NULL,
	[CgoWeight] [decimal](18, 2) NULL,
	[CgoWeightUnits] [nvarchar](20) NULL,
	[CgoVolumeUnits] [nvarchar](20) NULL,
	[CgoCubes] [decimal](18, 2) NULL,
	[CgoQtyUnits] [nvarchar](20) NULL,
	[CgoQtyOrdered] [int] NULL,
	[CgoPackagingTypeId] [int] NULL,
	[CgoQtyUnitsId] [int] NULL,
	[CgoWeightUnitsId] [int] NULL,
	[CgoVolumeUnitsId] [int] NULL,
	[CgoSerialBarcode] [varchar](50) NULL,
	[CgoLineNumber] [varchar](50) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL
)
GO
