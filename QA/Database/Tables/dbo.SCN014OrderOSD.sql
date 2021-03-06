SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN014OrderOSD](
	[CargoOSDID] [bigint] NOT NULL,
	[OSDID] [bigint] NULL,
	[DateTime] [datetime2](7) NULL,
	[CargoDetailID] [bigint] NULL,
	[CargoID] [bigint] NULL,
	[CgoSerialNumber] [nvarchar](255) NULL,
	[OSDReasonID] [bigint] NULL,
	[OSDQty] [decimal](18, 2) NULL,
	[Notes] [nvarchar](max) NULL,
	[EditCD] [nvarchar](50) NULL,
	[StatusID] [nvarchar](30) NULL,
	[CgoSeverityCode] [nvarchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
