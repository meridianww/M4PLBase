SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobUpdateDecisionMaker](
	[JobUpdateDecisionMakerId] [int] IDENTITY(1,1) NOT NULL,
	[ActionCode] [nvarchar](40) NOT NULL,
	[xCBLColumnName] [varchar](50) NOT NULL,
	[JobColumnName] [varchar](50) NOT NULL,
	[IsAutoUpdate] [bit] NOT NULL,
	[XcblTableName] [varchar](50) NULL,
 CONSTRAINT [PK_JobUpdateDecisionMaker] PRIMARY KEY CLUSTERED 
(
	[JobUpdateDecisionMakerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
