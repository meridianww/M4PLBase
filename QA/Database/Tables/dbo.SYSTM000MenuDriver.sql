SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000MenuDriver](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[MnuModuleId] [int] NULL,
	[MnuTableName] [nvarchar](100) NULL,
	[MnuBreakDownStructure] [nvarchar](20) NULL,
	[MnuTitle] [nvarchar](50) NULL,
	[MnuDescription] [varbinary](max) NULL,
	[MnuTabOver] [nvarchar](25) NULL,
	[MnuMenuItem] [bit] NULL,
	[MnuRibbon] [bit] NULL,
	[MnuRibbonTabName] [nvarchar](50) NULL,
	[MnuIconVerySmall] [image] NULL,
	[MnuIconSmall] [image] NULL,
	[MnuIconMedium] [image] NULL,
	[MnuIconLarge] [image] NULL,
	[MnuExecuteProgram] [nvarchar](255) NULL,
	[MnuClassificationId] [int] NULL,
	[MnuProgramTypeId] [int] NULL,
	[MnuOptionLevelId] [int] NULL,
	[MnuAccessLevelId] [int] NULL,
	[MnuHelpFile] [varbinary](max) NULL,
	[MnuHelpBookMark] [nvarchar](max) NULL,
	[MnuHelpPageNumber] [int] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000MenuDriver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] ADD  CONSTRAINT [DF_SYSTM000MenuDriver_MnuMenuItem]  DEFAULT ((0)) FOR [MnuMenuItem]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] ADD  CONSTRAINT [DF_SYSTM000MenuDriver_MnuRibbon]  DEFAULT ((0)) FOR [MnuRibbon]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] ADD  CONSTRAINT [DF_SYSTM000MenuDriver_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_Access_SYSTM000Ref_Options] FOREIGN KEY([MnuAccessLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_Access_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_Classification_SYSTM000Ref_Options] FOREIGN KEY([MnuClassificationId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_Classification_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_MainModule_SYSTM000Ref_Options] FOREIGN KEY([MnuModuleId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_MainModule_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_Option_SYSTM000Ref_Options] FOREIGN KEY([MnuOptionLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_Option_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_Program_SYSTM000Ref_Options] FOREIGN KEY([MnuProgramTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_Program_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_SYSTM000Ref_Table] FOREIGN KEY([MnuTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_SYSTM000Ref_Table]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record ID for Menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code: EN-English, ES-Spanish, FR-French' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Driver Breakdown Structure (MB) (Hierarchical)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuBreakDownStructure'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tab Over Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuTabOver'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is On Ribbon (Could be Either Or)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuRibbon'
GO
