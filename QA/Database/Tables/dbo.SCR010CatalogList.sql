SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCR010CatalogList](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdText]  AS (isnull(CONVERT([nvarchar](30),[Id]),'')) PERSISTED NOT NULL,
	[CatalogProgramID] [bigint] NULL,
	[CatalogProgramIDText]  AS (isnull(CONVERT([nvarchar](30),[CatalogProgramID]),'')) PERSISTED NOT NULL,
	[CatalogItemNumber] [int] NULL,
	[CatalogCode] [nvarchar](20) NULL,
	[CatalogCustCode] [nvarchar](20) NULL,
	[CatalogTitle] [nvarchar](50) NULL,
	[CatalogDesc] [nvarchar](max) NULL,
	[CatalogPhoto] [image] NULL,
	[CatalogUoMCode] [nvarchar](20) NULL,
	[CatalogCubes] [decimal](18, 2) NULL,
	[CatalogWidth] [decimal](18, 2) NULL,
	[CatalogLength] [decimal](18, 2) NULL,
	[CatalogHeight] [decimal](18, 2) NULL,
	[CatalogWeight] [int] NULL,
	[CatalogWLHUoM] [int] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SCR010CatalogList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCR010CatalogList] ADD  CONSTRAINT [DF_SCR010CatalogList_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SCR010CatalogList]  WITH CHECK ADD  CONSTRAINT [FK_SCR010CatalogList_CatalogWeight_SYSTM000Ref_Options] FOREIGN KEY([CatalogWeight])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_CatalogWeight_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SCR010CatalogList]  WITH CHECK ADD  CONSTRAINT [FK_SCR010CatalogList_CatalogWLHUoM_SYSTM000Ref_Options] FOREIGN KEY([CatalogWLHUoM])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_CatalogWLHUoM_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SCR010CatalogList]  WITH NOCHECK ADD  CONSTRAINT [FK_SCR010CatalogList_PRGRM000Master] FOREIGN KEY([CatalogProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_PRGRM000Master]
GO
ALTER TABLE [dbo].[SCR010CatalogList]  WITH NOCHECK ADD  CONSTRAINT [FK_SCR010CatalogList_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scanner Catalog Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key to scanner Program belongs to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'item Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code -Unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title for Catalog' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogDesc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Photo of the Catalog' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'CatalogPhoto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'StatusId(Active.Inactive,Archive,Delete)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who creates the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When the record is modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who modified the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR010CatalogList', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
