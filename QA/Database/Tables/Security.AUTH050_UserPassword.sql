SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH050_UserPassword](
	[UserId] [bigint] NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDatetime] [datetime] NOT NULL,
	[UpdatedTimestamp] [timestamp] NOT NULL,
 CONSTRAINT [IX_AUTH050_UserPassword] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Security].[AUTH050_UserPassword] ADD  CONSTRAINT [DF_AUTH050_UserPassword_UpdatedDatetime]  DEFAULT (getutcdate()) FOR [UpdatedDatetime]
GO
ALTER TABLE [Security].[AUTH050_UserPassword]  WITH NOCHECK ADD  CONSTRAINT [FK_AUTH050_UserPassword_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id])
GO
ALTER TABLE [Security].[AUTH050_UserPassword] CHECK CONSTRAINT [FK_AUTH050_UserPassword_User]
GO
