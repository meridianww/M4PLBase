SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM040ProgramBillableRate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PbrCode] [nvarchar](20) NULL,
	[PbrCustomerCode] [nvarchar](20) NULL,
	[PbrEffectiveDate] [datetime2](7) NULL,
	[PbrTitle] [nvarchar](50) NULL,
	[RateCategoryTypeId] [int] NULL,
	[RateTypeId] [int] NULL,
	[PbrBillablePrice] [decimal](18, 2) NULL,
	[RateUnitTypeId] [int] NULL,
	[PbrFormat] [nvarchar](20) NULL,
	[PbrDescription] [varbinary](max) NULL,
	[PbrExpression01] [nvarchar](255) NULL,
	[PbrLogic01] [nvarchar](255) NULL,
	[PbrExpression02] [nvarchar](255) NULL,
	[PbrLogic02] [nvarchar](255) NULL,
	[PbrExpression03] [nvarchar](255) NULL,
	[PbrLogic03] [nvarchar](255) NULL,
	[PbrExpression04] [nvarchar](255) NULL,
	[PbrLogic04] [nvarchar](255) NULL,
	[PbrExpression05] [nvarchar](255) NULL,
	[PbrLogic05] [nvarchar](255) NULL,
	[StatusId] [int] NULL,
	[PbrVendLocationID] [bigint] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ProgramLocationId] [bigint] NULL,
	[PbrElectronicBilling] [bit] NOT NULL,
 CONSTRAINT [PK_PRGRM040ProgramBillableRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] ADD  CONSTRAINT [DF_PRGRM040ProgramBillableRate_RatEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] ADD  DEFAULT ((0)) FOR [PbrElectronicBilling]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_PRGRM042ProgramBillableLocations] FOREIGN KEY([ProgramLocationId])
REFERENCES [dbo].[PRGRM042ProgramBillableLocations] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_PRGRM042ProgramBillableLocations]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateCatType_SYSTM000Ref_Options] FOREIGN KEY([RateCategoryTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateCatType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateType_SYSTM000Ref_Options] FOREIGN KEY([RateTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateUnitType_SYSTM000Ref_Options] FOREIGN KEY([RateUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_RateUnitType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_VEND040DCLocations] FOREIGN KEY([PbrVendLocationID])
REFERENCES [dbo].[VEND040DCLocations] ([Id])
GO
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_VEND040DCLocations]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal Rate Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What the customer abbreviates the name to be' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrCustomerCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Date (Date By Which It is Active; same rate code uses max effective date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrEffectiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Summarizing Catagory (Pivotable)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'RateCategoryTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is there a calculation to do? Is it Empirical? Simple, Expression, Tierd, Compounded, Derivative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'RateTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrBillablePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit of Measure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'RateUnitTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Format of Number (Percent, Currency, Number, Calcualtion)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrFormat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Rich Description of the rate with rules.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression and Logic - Five Tiers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrExpression01'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrLogic01'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 02' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrExpression02'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrLogic02'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression03' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrExpression03'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrLogic03'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 04' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrExpression04'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrLogic04'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expression 05' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrExpression05'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logic; this repeats four more times.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrLogic05'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active,Inactive,delete and archive(combobox)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendor location  identifier ? Used to Match a Rate to a Cost' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM040ProgramBillableRate', @level2type=N'COLUMN',@level2name=N'PbrVendLocationID'
GO
