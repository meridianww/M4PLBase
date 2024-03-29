SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MVOC010Ref_Questions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MVOCID] [bigint] NULL,
	[QueQuestionNumber] [int] NULL,
	[QueCode] [nvarchar](20) NULL,
	[QueTitle] [nvarchar](50) NULL,
	[QueDescription] [varbinary](max) NULL,
	[QuesTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[QueType_YNAnswer] [bit] NULL,
	[QueType_YNDefault] [bit] NULL,
	[QueType_RangeLo] [int] NULL,
	[QueType_RangeHi] [int] NULL,
	[QueType_RangeAnswer] [int] NULL,
	[QueType_RangeDefault] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[QueDescriptionText] [nvarchar](max) NULL,
 CONSTRAINT [PK_MVOC010Ref_Questions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] ADD  CONSTRAINT [DF_MVOC010Ref_Questions_QueType_YNAnswer]  DEFAULT ((0)) FOR [QueType_YNAnswer]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] ADD  CONSTRAINT [DF_MVOC010Ref_Questions_QueType_YNDefault]  DEFAULT ((0)) FOR [QueType_YNDefault]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] ADD  CONSTRAINT [DF_Table_1_vocDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC010Ref_Questions_MVOC000Program] FOREIGN KEY([MVOCID])
REFERENCES [dbo].[MVOC000Program] ([Id])
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] CHECK CONSTRAINT [FK_MVOC010Ref_Questions_MVOC000Program]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC010Ref_Questions_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] CHECK CONSTRAINT [FK_MVOC010Ref_Questions_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC010Ref_Questions_SYSTM000Ref_Options] FOREIGN KEY([QuesTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[MVOC010Ref_Questions] CHECK CONSTRAINT [FK_MVOC010Ref_Questions_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Survey question record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Related MVOC ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'MVOCID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Question Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueQuestionNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SHort Code for Printing Purposes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Verbiage for the Question' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longer description of question script' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'YesNo, Range' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QuesTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Yes or No question or Blank ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_YNAnswer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Yes or No Default value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_YNDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Range Low Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_RangeLo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Range Hi Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_RangeHi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Desireable Answer Inclusive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_RangeAnswer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default Answer for Range' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'QueType_RangeDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Survey was entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC010Ref_Questions', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
