CREATE TYPE [dbo].[uttJobCostCode] AS TABLE(
[LineNumber]  [int] NULL
,[JobID] [bigint] NULL
,[CstLineItem] [nvarchar](20)
,[CstChargeID] [bigint] NULL
,[CstChargeCode] [nvarchar](25) NULL
,[CstTitle] [nvarchar](50) NULL
,[CstUnitId] [int] NULL
,[CstRate] [decimal](18, 2) NULL
,[ChargeTypeId] [int] NULL
,[CstElectronicBilling] [bit] NULL
,[StatusId] [int] NULL
,[EnteredBy] [nvarchar](50) NULL
,[DateEntered] [datetime2](7) NULL
)
GO