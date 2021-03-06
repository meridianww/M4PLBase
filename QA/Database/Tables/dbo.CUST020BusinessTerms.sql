SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUST020BusinessTerms](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[CbtOrgID] [bigint] NULL,
	[CbtCustomerId] [bigint] NULL,
	[CbtItemNumber] [int] NULL,
	[CbtCode] [nvarchar](20) NULL,
	[CbtTitle] [nvarchar](50) NULL,
	[CbtDescription] [varbinary](max) NULL,
	[BusinessTermTypeId] [int] NULL,
	[CbtActiveDate] [datetime2](7) NULL,
	[CbtValue] [decimal](18, 2) NULL,
	[CbtHiThreshold] [decimal](18, 2) NULL,
	[CbtLoThreshold] [decimal](18, 2) NULL,
	[CbtAttachment] [int] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_CUST020BusinessTerms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUST020BusinessTerms] ADD  CONSTRAINT [DF_CUST020BusinessTerms_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[CUST020BusinessTerms]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST020BusinessTerms_BusinessTerm_SYSTM000Ref_Options] FOREIGN KEY([BusinessTermTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST020BusinessTerms] CHECK CONSTRAINT [FK_CUST020BusinessTerms_BusinessTerm_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CUST020BusinessTerms]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST020BusinessTerms_CUST000Master] FOREIGN KEY([CbtCustomerId])
REFERENCES [dbo].[CUST000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST020BusinessTerms] CHECK CONSTRAINT [FK_CUST020BusinessTerms_CUST000Master]
GO
ALTER TABLE [dbo].[CUST020BusinessTerms]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST020BusinessTerms_ORGAN000Master] FOREIGN KEY([CbtOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST020BusinessTerms] CHECK CONSTRAINT [FK_CUST020BusinessTerms_ORGAN000Master]
GO
ALTER TABLE [dbo].[CUST020BusinessTerms]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST020BusinessTerms_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST020BusinessTerms] CHECK CONSTRAINT [FK_CUST020BusinessTerms_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Term ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'? Language Code Default is EN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtCustomerId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Sorting' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Term Code (Short Name Like TERM30 for Terms Net 30 Days)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Code Note Code''s Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripiton of the Term for Clarity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Integer, Decimal, Currency, Days, Percentage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'BusinessTermTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Works With Archive Status So AS Not To Lose Data Integrity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtActiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Term Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hi Threshold value (Format as Value)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtHiThreshold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Low Value Formatted as Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtLoThreshold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attachments Count Needed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'CbtAttachment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default = Active, Delete, Archive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST020BusinessTerms', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
