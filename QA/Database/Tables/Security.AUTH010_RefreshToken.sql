SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH010_RefreshToken](
	[Id] [varchar](128) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[AuthClientId] [varchar](128) NOT NULL,
	[IssuedUtc] [datetime] NOT NULL,
	[ExpiresUtc] [datetime] NOT NULL,
	[ProtectedTicket] [varchar](8000) NOT NULL,
	[UserAuthTokenId] [varchar](36) NULL,
 CONSTRAINT [PK_dbo.AUTH010_RefreshToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Security].[AUTH010_RefreshToken]  WITH NOCHECK ADD  CONSTRAINT [FK_AUTH010_RefreshToken_AUTH000_Client] FOREIGN KEY([AuthClientId])
REFERENCES [Security].[AUTH000_Client] ([Id])
GO
ALTER TABLE [Security].[AUTH010_RefreshToken] CHECK CONSTRAINT [FK_AUTH010_RefreshToken_AUTH000_Client]
GO
