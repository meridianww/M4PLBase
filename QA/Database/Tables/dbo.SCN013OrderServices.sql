SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN013OrderServices](
	[ServicesID] [bigint] NULL,
	[ServicesCode] [nvarchar](50) NULL,
	[JobID] [bigint] NULL,
	[Notes] [nvarchar](max) NULL,
	[Complete] [nvarchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
