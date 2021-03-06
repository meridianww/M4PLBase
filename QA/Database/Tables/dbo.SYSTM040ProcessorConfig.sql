SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM040ProcessorConfig](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[PrcProcessorID] [bigint] NULL,
	[PrcConfigKey] [nvarchar](50) NULL,
	[PrcConfigValue] [nvarchar](255) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_SYSTM040ProcessorConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM040ProcessorConfig] ADD  CONSTRAINT [DF_SYSTM040ProcessorConfig_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM040ProcessorConfig]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM040ProcessorConfig_SYSTMProcessorMaster] FOREIGN KEY([PrcProcessorID])
REFERENCES [dbo].[SYSTM000ProcessorMaster] ([ID])
GO
ALTER TABLE [dbo].[SYSTM040ProcessorConfig] CHECK CONSTRAINT [FK_SYSTM040ProcessorConfig_SYSTMProcessorMaster]
GO
