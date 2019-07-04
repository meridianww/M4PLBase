SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ErrorLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrRelatedTo] [varchar](100) NULL,
	[ErrInnerException] [nvarchar](1024) NULL,
	[ErrMessage] [nvarchar](max) NULL,
	[ErrSource] [nvarchar](64) NULL,
	[ErrStackTrace] [nvarchar](max) NULL,
	[ErrAdditionalMessage] [nvarchar](4000) NULL,
	[ErrDateStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_SYSTM000ErrorLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
