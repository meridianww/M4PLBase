SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EmailDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FromAddress] [varchar](50) NULL,
	[ReplyToAddress] [varchar](50) NULL,
	[ToAddress] [varchar](500) NOT NULL,
	[CCAddress] [varchar](500) NULL,
	[BCCAddress] [varchar](500) NULL,
	[Subject] [nvarchar](998) NOT NULL,
	[IsBodyHtml] [bit] NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[EmailPriority] [tinyint] NOT NULL,
	[QueuedDate] [datetime] NOT NULL,
	[LastAttemptDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[RetryAttempt] [tinyint] NOT NULL,
 CONSTRAINT [PK_EmailDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[EmailDetail] ADD  DEFAULT ((1)) FOR [EmailPriority]
GO

ALTER TABLE [dbo].[EmailDetail] ADD  DEFAULT (GetUTCDate()) FOR [QueuedDate]
GO

ALTER TABLE [dbo].[EmailDetail] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [dbo].[EmailDetail] ADD  DEFAULT ((0)) FOR [RetryAttempt]
GO


