SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL010Cargo](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[CgoLineItem] [int] NULL,
	[CgoPartNumCode] [nvarchar](30) NULL,
	[CgoTitle] [nvarchar](50) NULL,
	[CgoSerialNumber] [nvarchar](255) NULL,
	[CgoMasterLabel] [nvarchar](30) NULL,
	[CgoPackagingType] [nvarchar](20) NULL,
	[CgoMasterCartonLabel] [nvarchar](30) NULL,
	[CgoWeight] [decimal](18, 2) NULL,
	[CgoWeightUnits] [nvarchar](20) NULL,
	[CgoLength] [decimal](18, 2) NULL,
	[CgoWidth] [decimal](18, 2) NULL,
	[CgoHeight] [decimal](18, 2) NULL,
	[CgoVolumeUnits] [nvarchar](20) NULL,
	[CgoCubes] [decimal](18, 2) NULL,
	[CgoNotes] [varbinary](max) NULL,
	[CgoQtyExpected] [int] NULL,
	[CgoQtyOnHand] [int] NULL,
	[CgoQtyDamaged] [int] NULL,
	[CgoQtyOnHold] [int] NULL,
	[CgoQtyUnits] [nvarchar](20) NULL,
	[CgoQtyOrdered] [int] NULL,
	[CgoQtyCounted] [decimal](18, 2) NULL,
	[CgoQtyShortOver] [int] NULL,
	[CgoQtyOver] [int] NULL,
	[CgoLongitude] [nvarchar](50) NULL,
	[CgoLatitude] [nvarchar](50) NULL,
	[CgoReasonCodeOSD] [nvarchar](30) NULL,
	[CgoReasonCodeHold] [nvarchar](20) NULL,
	[CgoSeverityCode] [int] NULL,
	[StatusId] [int] NULL,
	[ProFlags01] [nvarchar](1) NULL,
	[ProFlags02] [nvarchar](1) NULL,
	[ProFlags03] [nvarchar](1) NULL,
	[ProFlags04] [nvarchar](1) NULL,
	[ProFlags05] [nvarchar](1) NULL,
	[ProFlags06] [nvarchar](1) NULL,
	[ProFlags07] [nvarchar](1) NULL,
	[ProFlags08] [nvarchar](1) NULL,
	[ProFlags09] [nvarchar](1) NULL,
	[ProFlags10] [nvarchar](1) NULL,
	[ProFlags11] [nvarchar](1) NULL,
	[ProFlags12] [nvarchar](1) NULL,
	[ProFlags13] [nvarchar](1) NULL,
	[ProFlags14] [nvarchar](1) NULL,
	[ProFlags15] [nvarchar](1) NULL,
	[ProFlags16] [nvarchar](1) NULL,
	[ProFlags17] [nvarchar](1) NULL,
	[ProFlags18] [nvarchar](1) NULL,
	[ProFlags19] [nvarchar](1) NULL,
	[ProFlags20] [nvarchar](1) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[CgoPackagingTypeId] [int] NULL,
	[CgoWeightUnitsId] [int] NULL,
	[CgoVolumeUnitsId] [int] NULL,
	[CgoQtyUnitsId] [int] NULL,
	[CgoComment] [varchar](5000) NULL,
	[CgoDateLastScan] [datetime2](7) NULL,
	[CgoWhLoc] [nvarchar](20) NULL,
	[CgoSerialBarcode] [varchar](50) NULL,
	[CgoLineNumber] [varchar](50) NULL,
 CONSTRAINT [PK_JOBDL010Cargo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL010Cargo] ADD  CONSTRAINT [DF_JOBDL010Cargo_EnteredBy]  DEFAULT (getutcdate()) FOR [EnteredBy]
GO
ALTER TABLE [dbo].[JOBDL010Cargo] ADD  CONSTRAINT [DF_Table_1_JobEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_Cal_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_Cal_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoPackagingTypeId_SYSTM000Ref_Options] FOREIGN KEY([CgoPackagingTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_CgoPackagingTypeId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoQtyUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoQtyUnitsId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_CgoQtyUnitsId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoVolumeUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoVolumeUnitsId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_CgoVolumeUnitsId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoWeightUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoWeightUnitsId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_CgoWeightUnitsId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL010Cargo]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL010Cargo] CHECK CONSTRAINT [FK_JOBDL010Cargo_JOBDL000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Cargo ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Identification Number to which Cargo Item is Linked' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line Item Order Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoLineItem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Part Number - Not Inventoried - But Serviced' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoPartNumCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Serial Number of Part or Piece' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoSerialNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Packaging Type: Cabinets, Parts, Case, Pallet' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoPackagingType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoWeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lbs, KGs, or other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoWeightUnits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Length' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Width' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoWidth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Height' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoHeight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Volume Units' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoVolumeUnits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cubes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoCubes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes on Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity Expected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoQtyExpected'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity On Hand' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoQtyOnHand'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity Damaged' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoQtyDamaged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity On Hold' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoQtyOnHold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Units of Measure: Cabinets, Parts, Case, Pallet' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoQtyUnits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference Codes in Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoReasonCodeOSD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference Codes in Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoReasonCodeHold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes from Reference Severity Code Table Reference' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'CgoSeverityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Code (Gateway Codes (Scanner))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Information Was Entered for First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed Date when last updated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL010Cargo', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
