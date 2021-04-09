SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000JobPurchaseOrderMapping_Bak](
	[JobPurchaseOrderMappingId] [bigint] NULL,
	[PONumber] [nvarchar](150) NULL,
	[IsElectronicInvoiced] [bit] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[JobId] [bigint] NULL)
GO


