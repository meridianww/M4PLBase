SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000JobOrderItemMapping_Bak](
	[JobOrderItemMappingId] [bigint] NULL,
	[JobId] [bigint] NOT NULL,
	[EntityName] [nvarchar](150) NULL,
	[LineNumber] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[M4PLItemId] [bigint] NULL,
	[Document_Number] [varchar](50) NULL)
