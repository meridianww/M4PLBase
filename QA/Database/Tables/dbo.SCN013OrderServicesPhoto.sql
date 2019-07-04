SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN013OrderServicesPhoto](
	[ServicesID] [bigint] NULL,
	[ServiceIDText]  AS (isnull(CONVERT([nvarchar](30),[ServicesID]),'')) PERSISTED NOT NULL,
	[JobID] [bigint] NULL,
	[JobIDText]  AS (isnull(CONVERT([nvarchar](30),[JobID]),'')) PERSISTED NOT NULL,
	[Photo] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
