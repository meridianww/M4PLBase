SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM070EdiHeader](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PehParentEDI] [bit] NULL,
	[PehProgramID] [bigint] NULL,
	[PehItemNumber] [int] NULL,
	[PehEdiCode] [nvarchar](20) NULL,
	[PehEdiTitle] [nvarchar](50) NULL,
	[PehEdiDescription] [varbinary](max) NULL,
	[PehTradingPartner] [nvarchar](20) NULL,
	[PehEdiDocument] [nvarchar](20) NULL,
	[PehEdiVersion] [nvarchar](20) NULL,
	[PehSCACCode] [nvarchar](20) NULL,
	[PehSndRcv] [bit] NULL,
	[PehInsertCode] [nvarchar](20) NULL,
	[PehUpdateCode] [nvarchar](20) NULL,
	[PehCancelCode] [nvarchar](20) NULL,
	[PehHoldCode] [nvarchar](20) NULL,
	[PehOriginalCode] [nvarchar](20) NULL,
	[PehReturnCode] [nvarchar](20) NULL,
	[PehInOutFolder] [nvarchar](255) NULL,
	[PehArchiveFolder] [nvarchar](255) NULL,
	[PehProcessFolder] [nvarchar](255) NULL,
	[UDF01] [nvarchar](20) NULL,
	[UDF02] [nvarchar](20) NULL,
	[UDF03] [nvarchar](20) NULL,
	[UDF04] [nvarchar](20) NULL,
	[UDF05] [nvarchar](20) NULL,
	[UDF06] [nvarchar](20) NULL,
	[UDF07] [nvarchar](20) NULL,
	[UDF08] [nvarchar](20) NULL,
	[UDF09] [nvarchar](20) NULL,
	[UDF10] [nvarchar](20) NULL,
	[PehAttachments] [int] NULL,
	[StatusId] [int] NULL,
	[PehDateStart] [datetime2](7) NULL,
	[PehDateEnd] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[PehFtpServerUrl] [nvarchar](255) NULL,
	[PehFtpUsername] [nvarchar](50) NULL,
	[PehFtpPassword] [nvarchar](50) NULL,
	[PehFtpPort] [nvarchar](10) NULL,
	[IsSFTPUsed] [bit] NOT NULL,
 CONSTRAINT [PK_PRGRM070EdiHeader] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader] ADD  CONSTRAINT [DF_PRGRM070EdiHeader_PehSndRcv]  DEFAULT ((0)) FOR [PehSndRcv]
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader] ADD  CONSTRAINT [DF_PRGRM070EdiHeader_PvlEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader] ADD  DEFAULT ((0)) FOR [IsSFTPUsed]
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM070EdiHeader_PRGRM000Master] FOREIGN KEY([PehProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader] CHECK CONSTRAINT [FK_PRGRM070EdiHeader_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM070EdiHeader_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM070EdiHeader] CHECK CONSTRAINT [FK_PRGRM070EdiHeader_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Program ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program ID Affiliation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for sorting' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Short Code for Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehEdiCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Program Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehEdiTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Program Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehEdiDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Document Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehEdiDocument'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Version Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehEdiVersion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EDI Carrier SCAC Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehSCACCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attachment Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehAttachments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Start Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'PehDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM070EdiHeader', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
