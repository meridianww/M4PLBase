SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Sys000AuditTrail](
	[EntityId] [bigint] NOT NULL,
	[EntityType] Varchar(100),
	[EntityTypeId] [int] NOT NULL,
	[OrigionalDataXml] [xml] NOT NULL,
	[ChangedDataXml] [xml] NOT NULL,
	ChangedByUserId BIGINT,
	[ChangedBy] [varchar](150) NULL,
	[ChangedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Sys000AuditTrail] ADD  DEFAULT (getutcdate()) FOR [ChangedDate]
GO


