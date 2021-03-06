SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL062CostSheet](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[CstLineItem] [nvarchar](20) NULL,
	[CstChargeID] [bigint] NULL,
	[CstChargeCode] [nvarchar](25) NULL,
	[CstTitle] [nvarchar](50) NULL,
	[CstSurchargeOrder] [bigint] NULL,
	[CstSurchargePercent] [float] NULL,
	[ChargeTypeId] [int] NULL,
	[CstNumberUsed] [int] NULL,
	[CstDuration] [decimal](18, 2) NULL,
	[CstQuantity] [decimal](18, 2) NULL,
	[CstUnitId] [int] NULL,
	[CstRate] [decimal](18, 2) NULL,
	[CstAmount] [decimal](18, 2) NULL,
	[CstMarkupPercent] [float] NULL,
	[CstComments] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[LineNumber] [int] NULL,
	[CstElectronicBilling] [bit] NOT NULL,
	[IsProblem] [bit] NOT NULL,
 CONSTRAINT [PK_JOBDL062CostSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] ADD  DEFAULT ((0)) FOR [CstElectronicBilling]
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] ADD  DEFAULT ((0)) FOR [IsProblem]
GO
ALTER TABLE [dbo].[JOBDL062CostSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062CostSheet_CstUnitId] FOREIGN KEY([CstUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] CHECK CONSTRAINT [FK_JOBDL062CostSheet_CstUnitId]
GO
ALTER TABLE [dbo].[JOBDL062CostSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062CostSheet_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] CHECK CONSTRAINT [FK_JOBDL062CostSheet_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL062CostSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062CostSheet_SYSTM000Ref_Options] FOREIGN KEY([ChargeTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] CHECK CONSTRAINT [FK_JOBDL062CostSheet_SYSTM000Ref_Options]
GO
