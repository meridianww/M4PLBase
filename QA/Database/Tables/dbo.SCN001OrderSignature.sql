SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN001OrderSignature](
	[JobID] [bigint] NULL,
	[JobIDText]  AS (isnull(CONVERT([nvarchar](30),[JobID]),'')) PERSISTED NOT NULL,
	[JobSignCapture] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
