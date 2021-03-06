SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sys000AuditTrail](
	[EntityId] [bigint] NOT NULL,
	[EntityType] [varchar](100) NULL,
	[EntityTypeId] [int] NOT NULL,
	[OrigionalData] [nvarchar](max) NOT NULL,
	[ChangedData] [nvarchar](max) NOT NULL,
	[ChangedByUserId] [bigint] NULL,
	[ChangedBy] [varchar](150) NULL,
	[ChangedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sys000AuditTrail] ADD  DEFAULT (getutcdate()) FOR [ChangedDate]
GO
