SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Event](
	[ID] [int] NOT NULL,
	[EventName] [varchar](250) NOT NULL,
	[EventShortName] [varchar](50) NOT NULL,
	[FromMail] [varchar](200) NOT NULL,
	[Description] [varchar](4000) NULL,
	[CreatedDate] [date] NOT NULL CONSTRAINT [DF__Event__CreatedDa__60BD35FF]  DEFAULT (getdate()),
	[XSLTPath] [varchar](200) NULL,
	[StatusId] [int] NULL,
	[EventTypeId] [int] NULL,
 CONSTRAINT [PK__Event__3214EC27FC224528] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Event]  WITH NOCHECK ADD  CONSTRAINT [FK_Event_EventType_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventType] ([ID])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_EventType_EventTypeId]
GO

ALTER TABLE [dbo].[Event]  WITH NOCHECK ADD  CONSTRAINT [FK_Event_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Status_SYSTM000Ref_Options]
GO


