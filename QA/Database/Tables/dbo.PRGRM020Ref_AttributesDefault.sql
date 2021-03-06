SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM020Ref_AttributesDefault](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramID] [bigint] NULL,
	[AttItemNumber] [int] NULL,
	[AttCode] [nvarchar](20) NULL,
	[AttTitle] [nvarchar](50) NULL,
	[AttDescription] [varbinary](max) NULL,
	[AttComments] [varbinary](max) NULL,
	[AttQuantity] [int] NULL,
	[UnitTypeId] [int] NULL,
	[AttDefault] [bit] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_PRGRM020Ref_AttributesDefault] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault] ADD  CONSTRAINT [DF_PRGRM020Ref_AttributesDefault_AttDefault]  DEFAULT ((0)) FOR [AttDefault]
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault] ADD  CONSTRAINT [DF_PRGRM020Ref_AttributesDefault_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault] CHECK CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault] CHECK CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_SYSTM000Ref_Options] FOREIGN KEY([UnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Ref_AttributesDefault] CHECK CONSTRAINT [FK_PRGRM020Ref_AttributesDefault_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Sorting' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description on Program, Project, or Phase' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Comments' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Quantity if countable' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttQuantity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Units of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'UnitTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attribute Default Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'AttDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Attribute Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Ref_AttributesDefault', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
