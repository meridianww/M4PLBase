SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EventSubscriberRelation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriberId] [int] NOT NULL,
	[EventEntityRelationId] [int] NOT NULL,
	[EmailAddresses] [nvarchar](max) NULL,
	[EventSubscriberTypeId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[EventSubscriberRelation]  WITH CHECK ADD FOREIGN KEY([EventEntityRelationId])
REFERENCES [dbo].[EventEntityRelation] ([ID])
GO

ALTER TABLE [dbo].[EventSubscriberRelation]  WITH CHECK ADD FOREIGN KEY([EventSubscriberTypeId])
REFERENCES [dbo].[EventSubscriberType] ([Id])
GO

ALTER TABLE [dbo].[EventSubscriberRelation]  WITH CHECK ADD FOREIGN KEY([SubscriberId])
REFERENCES [dbo].[EventSubscriber] ([SubscriberId])
GO


