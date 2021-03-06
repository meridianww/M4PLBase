SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ProcessorMaster](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProCode] [nvarchar](20) NULL,
	[ProTitle] [nvarchar](50) NULL,
	[ProDescription] [varchar](max) NULL,
	[ProLocation] [nvarchar](100) NULL,
	[ProProcess] [nvarchar](100) NULL,
	[ProEnabled] [bit] NULL,
	[ProFrequency] [nvarchar](20) NULL,
	[ProIntervalValue] [nvarchar](20) NULL,
	[ProIntervalUnit] [int] NULL,
	[ProStartTime] [datetime2](7) NULL,
	[ProEndTime] [datetime2](7) NULL,
	[ProSunday] [bit] NULL,
	[ProMonday] [bit] NULL,
	[ProTuesday] [bit] NULL,
	[ProWednesday] [bit] NULL,
	[ProThursday] [bit] NULL,
	[ProFriday] [bit] NULL,
	[ProSaturday] [bit] NULL,
	[ProLastRun] [datetime2](7) NULL,
	[ProFinished] [bit] NULL,
	[ProFinishStatus] [nvarchar](50) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ProApiServerName] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYSTMProcessorMaster] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProEnabled]  DEFAULT ((0)) FOR [ProEnabled]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProSunday]  DEFAULT ((0)) FOR [ProSunday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProMonday]  DEFAULT ((0)) FOR [ProMonday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProTuesday]  DEFAULT ((0)) FOR [ProTuesday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProWednesday]  DEFAULT ((0)) FOR [ProWednesday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProThursday]  DEFAULT ((0)) FOR [ProThursday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProFriday]  DEFAULT ((0)) FOR [ProFriday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProSaturday]  DEFAULT ((0)) FOR [ProSaturday]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTM000ProcessorMaster_ProFinished]  DEFAULT ((0)) FOR [ProFinished]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] ADD  CONSTRAINT [DF_SYSTMProcessorMaster_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000ProcessorMaster_ProIntervalUnit_SYSTM000Ref_Options] FOREIGN KEY([ProIntervalUnit])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000ProcessorMaster] CHECK CONSTRAINT [FK_SYSTM000ProcessorMaster_ProIntervalUnit_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Short Code to identify the Process' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Processor Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Processor Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Location of the Processor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProLocation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name Of The Processor''s Executable' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProProcess'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is the Processor Enabled to run' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProEnabled'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Frequency of When the Processor Runs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProFrequency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Interval Value Of How Often the Processor Runs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProIntervalValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unit Value Of the Interval' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProIntervalUnit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Start Time Of When The Processor Can Run' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProStartTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What Is the Latest The Processor Can Run' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProEndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Sunday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProSunday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Monday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProMonday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on  Tuesday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProTuesday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Wednesday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProWednesday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Thursday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProThursday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Friday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProFriday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is The Processor Set to Run on Saturday' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProSaturday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Did The Processor Run Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProLastRun'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Did The Processor Finish' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProFinished'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What Was The Status Of The Processor When Finished' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ProcessorMaster', @level2type=N'COLUMN',@level2name=N'ProFinishStatus'
GO
