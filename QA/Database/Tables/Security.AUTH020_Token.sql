SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH020_Token](
	[Id] [varchar](36) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[AuthClientId] [varchar](128) NULL,
	[IssuedUtc] [datetime] NOT NULL,
	[ExpiresUtc] [datetime] NOT NULL,
	[AccessToken] [varchar](8000) NULL,
	[IsLoggedIn] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsExpired]  AS (CONVERT([bit],case when [ExpiresUtc]<getutcdate() OR [IsLoggedIn]=(0) then (1) else (0) end,(0))),
	[IPAddress] [varchar](15) NOT NULL,
	[UserAgent] [varchar](500) NULL,
 CONSTRAINT [PK_AUTH020_Token] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Security].[AUTH020_Token] ADD  CONSTRAINT [DF_UserAuthToken_UserAuthTokenId]  DEFAULT (replace(CONVERT([varchar](36),newid(),(0)),'-','')) FOR [Id]
GO
ALTER TABLE [Security].[AUTH020_Token] ADD  CONSTRAINT [DF_UserAuthToken_IsLoggedIn]  DEFAULT ((0)) FOR [IsLoggedIn]
GO
ALTER TABLE [Security].[AUTH020_Token] ADD  CONSTRAINT [DF_UserAuthToken_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [Security].[AUTH020_Token] ADD  CONSTRAINT [DF_UserAuthToken_UpdatedDate]  DEFAULT (getutcdate()) FOR [UpdatedDate]
GO
ALTER TABLE [Security].[AUTH020_Token]  WITH NOCHECK ADD  CONSTRAINT [FK_AUTH020_Token_SYSTM000OpnSezMe] FOREIGN KEY([UserId])
REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id])
GO
ALTER TABLE [Security].[AUTH020_Token] CHECK CONSTRAINT [FK_AUTH020_Token_SYSTM000OpnSezMe]
GO
