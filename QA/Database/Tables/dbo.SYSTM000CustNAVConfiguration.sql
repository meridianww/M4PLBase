SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000CustNAVConfiguration](
	[NAVConfigurationId] [bigint] IDENTITY(1,1) NOT NULL,
	[ServiceUrl] [nvarchar](200) NULL,
	[ServiceUserName] [nvarchar](100) NULL,
	[ServicePassword] [nvarchar](500) NULL,
	[CustomerId] [bigint] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[IsProductionEnvironment] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[NAVConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000CustNAVConfiguration] ADD  DEFAULT ((0)) FOR [IsProductionEnvironment]
GO
