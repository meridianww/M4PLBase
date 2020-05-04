SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DashboardSubCategory](
	[DashboardSubCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[DashboardSubCategoryName] [varchar](150) NULL,
	[DashboardSubCategoryDisplayName] [varchar](150) NULL,
 CONSTRAINT [PK_DashboardSubCategory] PRIMARY KEY CLUSTERED 
(
	[DashboardSubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
