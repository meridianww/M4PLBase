SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000_StatusLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramID] [bigint] NULL,
	[JobID] [bigint] NULL,
	[SiteName] [nvarchar](20) NULL,
	[GatewayID] [bigint] NULL,
	[GatewayCode] [nvarchar](20) NULL,
	[GatewayType] [nvarchar](20) NULL,
	[StatusCode] [nvarchar](30) NULL,
	[SeverityId] [int] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_SYSTM000_StatusLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] ADD  CONSTRAINT [DF_SYSTM000_StatusLog_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000_StatusLog_JobID_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] CHECK CONSTRAINT [FK_SYSTM000_StatusLog_JobID_JOBDL000Master]
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000_StatusLog_ProgramID_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] CHECK CONSTRAINT [FK_SYSTM000_StatusLog_ProgramID_PRGRM000Master]
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000_StatusLog_Severity_SYSTM000Ref_Options] FOREIGN KEY([SeverityId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] CHECK CONSTRAINT [FK_SYSTM000_StatusLog_Severity_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000_StatusLog_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] CHECK CONSTRAINT [FK_SYSTM000_StatusLog_StatusId_SYSTM000Ref_Options]
GO
