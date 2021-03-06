SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ErrorLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrRelatedTo] [nvarchar](500) NULL,
	[ErrInnerException] [nvarchar](max) NULL,
	[ErrMessage] [nvarchar](max) NULL,
	[ErrSource] [nvarchar](364) NULL,
	[ErrStackTrace] [nvarchar](max) NULL,
	[ErrAdditionalMessage] [nvarchar](max) NULL,
	[ErrDateStamp] [datetime] NOT NULL,
	[LogType] [nvarchar](150) NULL,
 CONSTRAINT [PK_SYSTM000ErrorLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
