SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[ID] [int] NOT NULL,
	[EventName] [varchar](250) NOT NULL,
	[EventShortName] [varchar](50) NOT NULL,
	[FromMail] [varchar](200) NOT NULL,
	[Description] [varchar](4000) NULL,
	[XSLTPath] [varchar](200) NULL,
	[StatusId] [int] NULL,
	[EventTypeId] [int] NULL,
	[EnteredBy] [varchar](150) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [varchar](150) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK__Event__3214EC27FC224528] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
