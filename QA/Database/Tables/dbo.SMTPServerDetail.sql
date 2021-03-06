SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMTPServerDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SMTPServerName] [varchar](100) NOT NULL,
	[SMTPServerPort] [int] NOT NULL,
	[SMTPLoginUserName] [varchar](100) NOT NULL,
	[SMTPLoginPassword] [varchar](100) NOT NULL,
	[IsSSLEnabled] [bit] NOT NULL,
	[DefaultFromAddress] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SMTPServerDetail] ADD  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
