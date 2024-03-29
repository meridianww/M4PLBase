SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dashboard](
	[DashboardId] [bigint] IDENTITY(1,1) NOT NULL,
	[DashboardTypeId] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[DashboardName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_Dashboard] PRIMARY KEY CLUSTERED 
(
	[DashboardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dashboard] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Dashboard]  WITH CHECK ADD  CONSTRAINT [FK_Dashboard_DashboardType] FOREIGN KEY([DashboardTypeId])
REFERENCES [dbo].[DashboardType] ([DashboardTypeId])
GO
ALTER TABLE [dbo].[Dashboard] CHECK CONSTRAINT [FK_Dashboard_DashboardType]
GO
