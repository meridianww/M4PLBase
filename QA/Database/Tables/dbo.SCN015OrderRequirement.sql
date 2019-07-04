SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN015OrderRequirement](
	[RequirementID] [bigint] NULL,
	[RequirementCode] [nvarchar](20) NULL,
	[JobID] [bigint] NULL,
	[Notes] [nvarchar](max) NULL,
	[Complete] [nvarchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
