SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM020Ref_Attachments](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AttTableName] [nvarchar](100) NULL,
	[AttPrimaryRecordID] [bigint] NULL,
	[AttItemNumber] [int] NULL,
	[AttTitle] [nvarchar](50) NULL,
	[AttTypeId] [int] NULL,
	[AttFileName] [nvarchar](50) NULL,
	[AttData] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[AttDownloadDate] [nvarchar](50) NULL,
	[AttDownloadedDate] [datetime2](7) NULL,
	[AttDownloadedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSMS020Ref_Attachments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM020Ref_Attachments] ADD  CONSTRAINT [DF_SYSTM020Ref_Attachments_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM020Ref_Attachments]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM020Ref_Attachments_SYSTM000Ref_Table] FOREIGN KEY([AttTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM020Ref_Attachments] CHECK CONSTRAINT [FK_SYSTM020Ref_Attachments_SYSTM000Ref_Table]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Attachment ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Table Name - Allows us to have an attachment to anything within the system (Concerns that we may need to multipurpose an attachment at several levels) ProgramID, Job, Contact EC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Any Primary Key within a Table - Points to the Record (required)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttPrimaryRecordID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type (See List) (Add To Reference Table Default = Document)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FileName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttFileName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'File attachment stored as binary value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Attachment Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Downloaded Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Downloaded By Whom' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadedBy'
GO
