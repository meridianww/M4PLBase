SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobDL070DeliveryUpdateProcessingLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NULL,
	[IsProcessed] [bit] NULL,
	[ProcessingDate] [datetime2](7) NULL,
 CONSTRAINT [PK_JobDL070DeliveryUpdateProcessingLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
