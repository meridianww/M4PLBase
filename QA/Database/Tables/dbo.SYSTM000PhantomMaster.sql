SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000PhantomMaster](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SpmDatabase] [nvarchar](50) NOT NULL,
	[SpmTitle] [nvarchar](50) NULL,
	[SpmDescription] [nvarchar](4000) NULL,
	[SpmLocation] [nvarchar](4000) NOT NULL,
	[SpmProcess] [nvarchar](255) NOT NULL,
	[SpmIntervalMinutes] [int] NOT NULL,
	[SpmEnable] [bit] NULL,
	[SpmSunday] [bit] NULL,
	[SpmMonday] [bit] NULL,
	[SpmTuesday] [bit] NULL,
	[SpmWednesday] [bit] NULL,
	[SpmThursday] [bit] NULL,
	[SpmFriday] [bit] NULL,
	[SpmSaturday] [bit] NULL,
	[SpmFinished] [bit] NULL,
	[SpmFinish Status] [nvarchar](50) NULL,
	[SpmRetry] [int] NULL,
	[SpmStartTime] [time](7) NULL,
	[SpmEndTime] [time](7) NULL,
	[SpmLastRun] [datetime] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYST010Phantom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmEnable]  DEFAULT ((0)) FOR [SpmEnable]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmSunday]  DEFAULT ((0)) FOR [SpmSunday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmMonday]  DEFAULT ((0)) FOR [SpmMonday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmTuesday]  DEFAULT ((0)) FOR [SpmTuesday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmWednesday]  DEFAULT ((0)) FOR [SpmWednesday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmThursday]  DEFAULT ((0)) FOR [SpmThursday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmFriday]  DEFAULT ((0)) FOR [SpmFriday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmSaturday]  DEFAULT ((0)) FOR [SpmSaturday]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_SYSTM000PhantomMaster_SpmFinished]  DEFAULT ((0)) FOR [SpmFinished]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] ADD  CONSTRAINT [DF_Table_1_SpmDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000PhantomMaster_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000PhantomMaster] CHECK CONSTRAINT [FK_SYSTM000PhantomMaster_StatusId_SYSTM000Ref_Options]
GO
