SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000JobSalesOrderMapping_Bak](
	[JobSalesOrderMappingId] [bigint] NULL,
	[JobId] [bigint] NOT NULL,
	[SONumber] [nvarchar](150) NULL,
	[IsElectronicInvoiced] [bit] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[IsParentOrder] [bit] NULL)
