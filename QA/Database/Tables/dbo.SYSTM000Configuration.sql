SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Configuration](
	[KeyName] [varchar](250) NOT NULL,
	[Value] [varchar](5000) NOT NULL,
	[Environment] [smallint] NOT NULL
) ON [PRIMARY]
GO
