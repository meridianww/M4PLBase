SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DashboardCategoryRelation](
	[DashboardCategoryRelationId] [bigint] IDENTITY(1,1) NOT NULL,
	[DashboardId] [bigint] NOT NULL,
	[DashboardCategoryId] [int] NOT NULL,
	[DashboardSubCategory] [int] NOT NULL,
	[CustomQuery] [varchar](5000) NULL,
 CONSTRAINT [PK_DashboardCategoryRelation] PRIMARY KEY CLUSTERED 
(
	[DashboardCategoryRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DashboardCategoryRelation]  WITH CHECK ADD  CONSTRAINT [FK_DashboardCategoryRelation_Dashboard] FOREIGN KEY([DashboardId])
REFERENCES [dbo].[Dashboard] ([DashboardId])
GO

ALTER TABLE [dbo].[DashboardCategoryRelation] CHECK CONSTRAINT [FK_DashboardCategoryRelation_Dashboard]
GO

ALTER TABLE [dbo].[DashboardCategoryRelation]  WITH CHECK ADD  CONSTRAINT [FK_DashboardCategoryRelation_DashboardCategory] FOREIGN KEY([DashboardCategoryId])
REFERENCES [dbo].[DashboardCategory] ([DashboardCategoryId])
GO

ALTER TABLE [dbo].[DashboardCategoryRelation] CHECK CONSTRAINT [FK_DashboardCategoryRelation_DashboardCategory]
GO

ALTER TABLE [dbo].[DashboardCategoryRelation]  WITH CHECK ADD  CONSTRAINT [FK_DashboardCategoryRelation_DashboardSubCategory] FOREIGN KEY([DashboardCategoryId])
REFERENCES [dbo].[DashboardSubCategory] ([DashboardSubCategoryId])
GO

ALTER TABLE [dbo].[DashboardCategoryRelation] CHECK CONSTRAINT [FK_DashboardCategoryRelation_DashboardSubCategory]
GO


