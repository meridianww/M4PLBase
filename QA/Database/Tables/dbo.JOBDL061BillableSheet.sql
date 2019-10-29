SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOBDL061BillableSheet](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[PrcLineItem] [nvarchar](20) NULL,
	[PrcChargeID] [int] NULL,
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
 CONSTRAINT [PK_JOBDL061BillableSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH CHECK ADD  CONSTRAINT [FK_BillableSheet_ChargeTypeId] FOREIGN KEY([ChargeTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_BillableSheet_ChargeTypeId]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH CHECK ADD  CONSTRAINT [FK_BillableSheet_JobMaster] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_BillableSheet_JobMaster]
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062BillableSheet_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_JOBDL062BillableSheet_Status_SYSTM000Ref_Options]
GO
