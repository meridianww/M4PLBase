USE [M4PL_DEV]
GO

/****** Object:  Table [dbo].[JOBDL062CostSheetJob]    Script Date: 7/29/2019 4:25:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[JOBDL062CostSheet](
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
  CONSTRAINT [PK_JOBDL062CostSheet] PRIMARY KEY CLUSTERED (	[Id] ASC),
  CONSTRAINT FK_CostSheet_JobMaster FOREIGN KEY (JobID) REFERENCES [dbo].[JOBDL000Master] (Id)
  
  )

/****** Object:  Table [dbo].[JOBDL061BillableSheet]    Script Date: 7/29/2019 4:25:03 PM ******/
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
	  CONSTRAINT [PK_JOBDL061BillableSheet] PRIMARY KEY CLUSTERED (	[Id] ASC),
  CONSTRAINT FK_BillableSheet_JobMaster FOREIGN KEY (JobID) REFERENCES [dbo].[JOBDL000Master] (Id)

  )