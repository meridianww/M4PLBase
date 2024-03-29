SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM041ProgramCostRate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PcrCode] [nvarchar](20) NULL,
	[PcrVendorCode] [nvarchar](20) NULL,
	[PcrEffectiveDate] [datetime2](7) NULL,
	[PcrTitle] [nvarchar](50) NULL,
	[RateCategoryTypeId] [int] NULL,
	[RateTypeId] [int] NULL,
	[PcrCostRate] [decimal](18, 2) NULL,
	[RateUnitTypeId] [int] NULL,
	[PcrFormat] [nvarchar](20) NULL,
	[PcrDescription] [varbinary](max) NULL,
	[PcrExpression01] [nvarchar](255) NULL,
	[PcrLogic01] [nvarchar](255) NULL,
	[PcrExpression02] [nvarchar](255) NULL,
	[PcrLogic02] [nvarchar](255) NULL,
	[PcrExpression03] [nvarchar](255) NULL,
	[PcrLogic03] [nvarchar](255) NULL,
	[PcrExpression04] [nvarchar](255) NULL,
	[PcrLogic04] [nvarchar](255) NULL,
	[PcrExpression05] [nvarchar](255) NULL,
	[PcrLogic05] [nvarchar](255) NULL,
	[StatusId] [int] NULL,
	[PcrCustomerID] [bigint] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ProgramLocationId] [bigint] NULL,
	[PcrElectronicBilling] [bit] NOT NULL,
 CONSTRAINT [PK_PRGRM041ProgramCostRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] ADD  CONSTRAINT [DF_PRGRM041ProgramCostRate_RatEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] ADD  DEFAULT ((0)) FOR [PcrElectronicBilling]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_CUST000Master] FOREIGN KEY([PcrCustomerID])
REFERENCES [dbo].[CUST000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_CUST000Master]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_PRGRM043ProgramCostLocations] FOREIGN KEY([ProgramLocationId])
REFERENCES [dbo].[PRGRM043ProgramCostLocations] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_PRGRM043ProgramCostLocations]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_RateCatType_SYSTM000Ref_Options] FOREIGN KEY([RateCategoryTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_RateCatType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_RateType_SYSTM000Ref_Options] FOREIGN KEY([RateTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_RateType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_RateUnitType_SYSTM000Ref_Options] FOREIGN KEY([RateUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_RateUnitType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal Rate Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What the Vendor abbreviates the name to be' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrVendorCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Date (Date By Which It is Active; same rate code uses max effective date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrEffectiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Summarizing Catagory (Pivotable)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'RateCategoryTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is there a calculation to do? Is it Empirical? Simple, Expression, Tierd, Compounded, Derivative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'RateTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrCostRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'RateUnitTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Format of Number (Percent, Currency, Number, Calcualtion)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrFormat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Rich Description of the rate with rules.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression and Logic - Five Tiers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrExpression01'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrLogic01'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 02' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrExpression02'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrLogic02'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression03' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrExpression03'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrLogic03'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 04' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrExpression04'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrLogic04'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 05' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrExpression05'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrLogic05'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active,Inactive,delete and archive(combobox)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer identifier ? Used to Match a Rate to a Cost' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM041ProgramCostRate', @level2type=N'COLUMN',@level2name=N'PcrCustomerID'
GO
