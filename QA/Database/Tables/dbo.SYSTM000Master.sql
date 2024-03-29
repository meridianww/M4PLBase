SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysMessageCode] [nvarchar](25) NULL,
	[SysRefId] [int] NOT NULL,
	[SysMessageScreenTitle] [nvarchar](50) NULL,
	[SysMessageTitle] [nvarchar](50) NULL,
	[SysMessageDescription] [nvarchar](max) NULL,
	[SysMessageInstruction] [nvarchar](max) NULL,
	[SysMessageButtonSelection] [nvarchar](100) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Master] ADD  CONSTRAINT [DF__SYSTM000M__DateE__4D5F7D71]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Master_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Master] CHECK CONSTRAINT [FK_SYSTM000Master_StatusId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Master_SysRefId_SYSTM000Ref_Options] FOREIGN KEY([SysRefId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Master] CHECK CONSTRAINT [FK_SYSTM000Master_SysRefId_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System Message Record Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language: EN, ES, FR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Code for Organizing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System Reference Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysRefId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Title for Window of Message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageScreenTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title Internal to Message Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Written Description of Error and can be apended with Systemic Issues' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What to do to Correct Issue' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageInstruction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Button Selection' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageButtonSelection'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Message Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
