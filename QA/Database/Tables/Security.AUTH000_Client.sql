SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH000_Client](
	[Id] [varchar](128) NOT NULL,
	[Secret] [varchar](1000) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ApplicationType] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[RefreshTokenLifeTime] [int] NOT NULL,
	[AllowedOrigin] [varchar](100) NULL,
	[AccessTokenExpireTimeSpan] [int] NOT NULL,
	[WarningTime] [int] NULL,
	[ApplicationSessionTimeout] [int] NULL,
 CONSTRAINT [PK_dbp.AUTH000_Client] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Security].[AUTH000_Client] ADD  CONSTRAINT [DF_AUTH000_Client_TokenLifeTime]  DEFAULT ((30)) FOR [AccessTokenExpireTimeSpan]
GO
