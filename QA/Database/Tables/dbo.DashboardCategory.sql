SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardCategory](
	[DashboardCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[DashboardCategoryName] [varchar](150) NULL,
	[DashboardCategoryDisplayName] [varchar](150) NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_DashboardCategory] PRIMARY KEY CLUSTERED 
(
	[DashboardCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
