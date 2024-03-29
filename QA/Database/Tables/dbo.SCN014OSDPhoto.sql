SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN014OSDPhoto](
	[PhotoID] [bigint] NULL,
	[PhotoIDText]  AS (isnull(CONVERT([nvarchar](30),[PhotoID]),'')) PERSISTED NOT NULL,
	[CargoOSDID] [bigint] NULL,
	[CargoOSDIDText]  AS (isnull(CONVERT([nvarchar](30),[CargoOSDID]),'')) PERSISTED NOT NULL,
	[Step] [nvarchar](50) NULL,
	[Photo] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
