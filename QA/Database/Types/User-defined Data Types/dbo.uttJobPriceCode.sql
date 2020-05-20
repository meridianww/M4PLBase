CREATE TYPE [dbo].[uttJobPriceCode] AS TABLE(
[LineNumber] [int] NULL
,[JobID] [bigint] NULL
,[prcLineItem] [nvarchar](20)
,[prcChargeID] [bigint] NULL
,[prcChargeCode] [nvarchar](25) NULL
,[prcTitle] [nvarchar](50) NULL
,[prcUnitId] [int] NULL
,[prcRate] [decimal](18, 2) NULL
,[ChargeTypeId] [int] NULL
,[prcElectronicBilling] [bit] NULL
,[IsProblem] [bit] NOT NULL
,[StatusId] [int] NULL
,[EnteredBy] [nvarchar](50) NULL
,[DateEntered] [datetime2](7) NULL
)
GO