CREATE TABLE [dbo].[SMTPServerDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SMTPServerName] [varchar] (100) NOT NULL,
[SMTPServerPort] [int] NOT NULL,
[SMTPLoginUserName] [varchar] (100) NOT NULL,
[SMTPLoginPassword] [varchar] (100) NOT NULL,
[IsSSLEnabled] [bit] NOT NULL,
[DefaultFromAddress] [varchar] (50) NOT NULL,
[CreatedDate] [datetime] NOT NULL DEFAULT (GetUTCDate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SMTPServerDetail] ADD PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SMTPServerDetail] ON [dbo].[SMTPServerDetail] ([ID]) ON [PRIMARY]
GO