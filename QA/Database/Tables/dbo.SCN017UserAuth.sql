SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCN017UserAuth](
	[UserPhone] [nvarchar](20) NULL,
	[Confirmed] [nvarchar](1) NULL,
	[ProgramID] [bigint] NULL,
	[ProgramIDText]  AS (isnull(CONVERT([nvarchar](30),[ProgramID]),'')) PERSISTED NOT NULL,
	[LocationNumber] [nvarchar](30) NULL
) ON [PRIMARY]
GO
