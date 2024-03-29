SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MVOC000Program](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VocOrgID] [bigint] NULL,
	[VocProgramID] [bigint] NULL,
	[VocSurveyCode] [nvarchar](20) NULL,
	[VocSurveyTitle] [nvarchar](50) NULL,
	[VocDescription] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[VocDateOpen] [datetime2](7) NULL,
	[VocDateClose] [datetime2](7) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[VocAllStar] [bit] NOT NULL,
 CONSTRAINT [PK_MVOC000Program] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MVOC000Program] ADD  CONSTRAINT [DF_MVOC000Program_vocDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[MVOC000Program] ADD  DEFAULT ((0)) FOR [VocAllStar]
GO
ALTER TABLE [dbo].[MVOC000Program]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC000Program_ORGAN000Master] FOREIGN KEY([VocOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[MVOC000Program] CHECK CONSTRAINT [FK_MVOC000Program_ORGAN000Master]
GO
ALTER TABLE [dbo].[MVOC000Program]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC000Program_PRGRM000Master] FOREIGN KEY([VocProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[MVOC000Program] CHECK CONSTRAINT [FK_MVOC000Program_PRGRM000Master]
GO
ALTER TABLE [dbo].[MVOC000Program]  WITH NOCHECK ADD  CONSTRAINT [FK_MVOC000Program_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[MVOC000Program] CHECK CONSTRAINT [FK_MVOC000Program_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MVOC Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MVOC Survey Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocSurveyCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MVOC Survey Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocSurveyTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MVOC Survey Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status: Active, Archive, Opened, Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Survey Date Opened' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocDateOpen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Survey Date Closed (Auto Archive)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'VocDateClose'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Survey was entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVOC000Program', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
