SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL030Attributes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[AjbLineOrder] [int] NULL,
	[AjbAttributeCode] [nvarchar](20) NULL,
	[AjbAttributeTitle] [nvarchar](50) NULL,
	[AjbAttributeDescription] [varbinary](max) NULL,
	[AjbAttributeComments] [varbinary](max) NULL,
	[AjbAttributeQty] [decimal](18, 2) NULL,
	[AjbUnitTypeId] [int] NULL,
	[AjbDefault] [bit] NULL,
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
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_JOBDL030Attributes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL030Attributes] ADD  CONSTRAINT [DF_JOBDL030Attributes_AjbDefault]  DEFAULT ((0)) FOR [AjbDefault]
GO
ALTER TABLE [dbo].[JOBDL030Attributes] ADD  CONSTRAINT [DF_Table_1_GwyDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL030Attributes]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL030Attributes_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL030Attributes] CHECK CONSTRAINT [FK_JOBDL030Attributes_JOBDL000Master]
GO
ALTER TABLE [dbo].[JOBDL030Attributes]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL030Attributes_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL030Attributes] CHECK CONSTRAINT [FK_JOBDL030Attributes_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL030Attributes]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL030Attributes_UnitType_SYSTM000Ref_Options] FOREIGN KEY([AjbUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL030Attributes] CHECK CONSTRAINT [FK_JOBDL030Attributes_UnitType_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Attribute ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job ID Relationship' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order number or line item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbLineOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbAttributeCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbAttributeTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description prose/Verbiaige' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbAttributeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'More Comments' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbAttributeComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity if Measurable' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbAttributeQty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbUnitTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is this a default data element or non-default choice by user' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'AjbDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Attribute Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL030Attributes', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
