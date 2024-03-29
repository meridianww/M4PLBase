SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN015OrderRequirementPhoto](
	[RequirementID] [bigint] NULL,
	[RequirementIDText]  AS (isnull(CONVERT([nvarchar](30),[RequirementID]),'')) PERSISTED NOT NULL,
	[JobID] [bigint] NULL,
	[JobIDText]  AS (isnull(CONVERT([nvarchar](30),[JobID]),'')) PERSISTED NOT NULL,
	[Photo] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
