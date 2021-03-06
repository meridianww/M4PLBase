SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM071EdiMapping](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PemHeaderID] [bigint] NULL,
	[PemEdiTableName] [nvarchar](50) NULL,
	[PemEdiFieldName] [nvarchar](50) NULL,
	[PemEdiFieldDataType] [nvarchar](20) NULL,
	[PemSysTableName] [nvarchar](50) NULL,
	[PemSysFieldName] [nvarchar](50) NULL,
	[PemSysFieldDataType] [nvarchar](20) NULL,
	[StatusId] [int] NULL,
	[PemInsertUpdate] [int] NULL,
	[PemDateStart] [datetime2](7) NULL,
	[PemDateEnd] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_PRGRM071EdiMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping] ADD  CONSTRAINT [DF_PRGRM071EdiMapping_PehEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM071EdiMapping_PemInsertUpdate_SYSTM000Ref_Options] FOREIGN KEY([PemInsertUpdate])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping] CHECK CONSTRAINT [FK_PRGRM071EdiMapping_PemInsertUpdate_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM071EdiMapping_PRGRM070EdiHeader] FOREIGN KEY([PemHeaderID])
REFERENCES [dbo].[PRGRM070EdiHeader] ([Id])
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping] CHECK CONSTRAINT [FK_PRGRM071EdiMapping_PRGRM070EdiHeader]
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM071EdiMapping_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM071EdiMapping] CHECK CONSTRAINT [FK_PRGRM071EdiMapping_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program ID Affiliation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemHeaderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Table ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemEdiTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Field in EDI Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemEdiFieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M4PL Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemSysTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M4PL Field in Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemSysFieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Start Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'PemDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM071EdiMapping', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
