SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN030Credentials](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[CreItemNumber] [int] NULL,
	[CreCode] [nvarchar](20) NULL,
	[CreTitle] [nvarchar](50) NULL,
	[CreDescription] [varbinary](max) NULL,
	[CreExpDate] [datetime2](7) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_ORGAN030Credentials] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN030Credentials] ADD  CONSTRAINT [DF_ORGAN030Credentials_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN030Credentials]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN030Credentials_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN030Credentials] CHECK CONSTRAINT [FK_ORGAN030Credentials_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN030Credentials]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN030Credentials_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN030Credentials] CHECK CONSTRAINT [FK_ORGAN030Credentials_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Sorting (Open for Edit)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code Meaning' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Credential' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description Long Text Memo field of Credential' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expiration Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreExpDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Credential Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
