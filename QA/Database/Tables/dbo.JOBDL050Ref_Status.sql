SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL050Ref_Status](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[JbsOutlineCode] [nvarchar](20) NULL,
	[JbsStatusCode] [nvarchar](25) NULL,
	[JbsTitle] [nvarchar](50) NULL,
	[JbsDescription] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[SeverityId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_JOBDL050Ref_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] ADD  CONSTRAINT [DF_Table_1_JobEnteredOn_1]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL050Ref_Status_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] CHECK CONSTRAINT [FK_JOBDL050Ref_Status_JOBDL000Master]
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL050Ref_Status_Severity_SYSTM000Ref_Options] FOREIGN KEY([SeverityId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] CHECK CONSTRAINT [FK_JOBDL050Ref_Status_Severity_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL050Ref_Status_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] CHECK CONSTRAINT [FK_JOBDL050Ref_Status_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Status ID (Table Used for Job Statusing) Could be a System Status Table JBS = Job Status)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What job is this related to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Outline Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'JbsOutlineCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'JbsStatusCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'JbsTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description in Long Text Format' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'JbsDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Tyoe (Possible List: Check?)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Severity 1 through 5 5 being the worst case...' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'SeverityId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Record was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL050Ref_Status', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
