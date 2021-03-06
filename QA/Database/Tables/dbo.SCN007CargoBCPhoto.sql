SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN007CargoBCPhoto](
	[CargoID] [bigint] NULL,
	[CargoIDText]  AS (isnull(CONVERT([nvarchar](30),[CargoID]),'')) PERSISTED NOT NULL,
	[Photo] [image] NULL,
	[Step] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
