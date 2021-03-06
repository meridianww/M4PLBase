SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL060Ref_CostSheetJob](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[CstLineItem] [nvarchar](20) NULL,
	[CstChargeID] [int] NULL,
	[CstChargeCode] [nvarchar](25) NULL,
	[CstTitle] [nvarchar](50) NULL,
	[CstSurchargeOrder] [bigint] NULL,
	[CstSurchargePercent] [float] NULL,
	[ChargeTypeId] [int] NULL,
	[CstNumberUsed] [int] NULL,
	[CstDuration] [decimal](18, 2) NULL,
	[CstQuantity] [decimal](18, 2) NULL,
	[CostUnitId] [int] NULL,
	[CstCostRate] [decimal](18, 2) NULL,
	[CstCost] [decimal](18, 2) NULL,
	[CstMarkupPercent] [float] NULL,
	[CstRevenueRate] [decimal](18, 2) NULL,
	[CstRevDuration] [decimal](18, 2) NULL,
	[CstRevQuantity] [decimal](18, 2) NULL,
	[CstRevBillable] [decimal](18, 2) NULL,
	[CstComments] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_JOBDL060Ref_CostSheetJob] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] ADD  CONSTRAINT [DF_Table_1_JbsEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_ChargeType_SYSTM000Ref_Options] FOREIGN KEY([ChargeTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] CHECK CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_ChargeType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_CostUnit_SYSTM000Ref_Options] FOREIGN KEY([CostUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] CHECK CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_CostUnit_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] CHECK CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_JOBDL000Master]
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] CHECK CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Sheet ID ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstLineItem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Charge ID from Charge Ledger' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstChargeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Charge Code (Internal)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstChargeCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order number (Note how Surcharges are calculated)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstSurchargeOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% surcharge needs to be input only for surcharge line item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstSurchargePercent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Direct or Surcharge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'ChargeTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'How many used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstNumberUsed'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Duration - How many Hours, days or weeks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstDuration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Quantity should be the same for Rev Quantity but can be different if Input' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstQuantity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit of measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CostUnitId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Rate Could be Calculated by Rate = Cost/QTY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstCostRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Cost for Line Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstCost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Markup percent can be %=(100% - (cost/billable))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstMarkupPercent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RevRate can be calculated by Billable/Quantity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstRevenueRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'How long used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstRevDuration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Revenue Quantity should equal cost quantity, but could be different' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstRevQuantity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Billable Amount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstRevBillable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commentary on the line item if any' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'CstComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Earned, Posted, Archived' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Record was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL060Ref_CostSheetJob', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
