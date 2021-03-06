SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardSubCategory](
	[DashboardSubCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[DashboardSubCategoryName] [varchar](150) NULL,
	[DashboardSubCategoryDisplayName] [varchar](150) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DashboardSubCategory] PRIMARY KEY CLUSTERED 
(
	[DashboardSubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DashboardSubCategory] ADD  DEFAULT ((1)) FOR [IsActive]
GO
