SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL061BillableSheet](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[PrcLineItem] [nvarchar](20) NULL,
	[PrcChargeID] [bigint] NULL,
	[PrcChargeCode] [nvarchar](25) NULL,
	[PrcTitle] [nvarchar](50) NULL,
	[PrcSurchargeOrder] [bigint] NULL,
	[PrcSurchargePercent] [float] NULL,
	[ChargeTypeId] [int] NULL,
	[PrcNumberUsed] [int] NULL,
	[PrcDuration] [decimal](18, 2) NULL,
	[PrcQuantity] [decimal](18, 2) NULL,
	[PrcUnitId] [int] NULL,
	[PrcRate] [decimal](18, 2) NULL,
	[PrcAmount] [decimal](18, 2) NULL,
	[PrcMarkupPercent] [float] NULL,
	[PrcComments] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[LineNumber] [int] NULL,
	[PrcElectronicBilling] [bit] NOT NULL,
	[IsProblem] [bit] NOT NULL,
 CONSTRAINT [PK_JOBDL061BillableSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] ADD  DEFAULT ((0)) FOR [PrcElectronicBilling]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] ADD  DEFAULT ((0)) FOR [IsProblem]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL061BillableSheet_PrcChargeID] FOREIGN KEY([PrcChargeID])
REFERENCES [dbo].[PRGRM040ProgramBillableRate] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_JOBDL061BillableSheet_PrcChargeID]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL061BillableSheet_PrcUnitId] FOREIGN KEY([PrcUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_JOBDL061BillableSheet_PrcUnitId]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062BillableSheet_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_JOBDL062BillableSheet_Status_SYSTM000Ref_Options]
GO
