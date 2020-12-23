SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL022GatewayExceptionReason](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JGExceptionId] [bigint] NULL,
	[JgeTitle] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL022GatewayExceptionReason]  WITH CHECK ADD  CONSTRAINT [FK_GatewayExceptionCode] FOREIGN KEY([JGExceptionId])
REFERENCES [dbo].[JOBDL021GatewayExceptionCode] ([Id])
GO
ALTER TABLE [dbo].[JOBDL022GatewayExceptionReason] CHECK CONSTRAINT [FK_GatewayExceptionCode]
GO
