SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM041ProcessorErrorLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PelProcessorName] [varchar](50) NULL,
	[PelPriority] [int] NULL,
	[PelSourceTable] [varchar](100) NULL,
	[PelSourceId] [varchar](100) NULL,
	[PelInnerException] [nvarchar](1024) NULL,
	[PelMessage] [nvarchar](max) NULL,
	[PelMethod] [nvarchar](64) NULL,
	[PelStackTrace] [nvarchar](max) NULL,
	[PelAdditionalMessage] [nvarchar](4000) NULL,
	[PelDateStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_SYSTM041ProcessorErrorLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processor Name of Where The Exception Occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelProcessorName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What Is The Priority Of The Exception' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If Possible, What Database Table Did The Exception Occur On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelSourceTable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If Possible, What Table Field Did The Exception Occur On ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelSourceId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inner Exception Message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelInnerException'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processor Message Of the Exception' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What Method Did The Exception Occur In' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processor Stack Trace Of The Exception' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelStackTrace'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Any Additional Message For The Exception' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelAdditionalMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Did The Exception Occur' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM041ProcessorErrorLog', @level2type=N'COLUMN',@level2name=N'PelDateStamp'
GO
