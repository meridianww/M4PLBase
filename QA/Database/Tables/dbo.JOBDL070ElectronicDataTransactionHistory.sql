SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[JOBDL070ElectronicDataTransactionHistory](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EdtCode] [nvarchar](20) NULL,
	[EdtTitle] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[EdtData] [nvarchar](max) NULL,
	[EdtTypeId] [int] NOT NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[TransactionDate] [datetime2](7) NULL,
 CONSTRAINT [PK_JOBDL070ElectronicDataTransactionHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[JOBDL070ElectronicDataTransactionHistory]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL070ElectronicDataTransactionHistory_SYSTM000Ref_Options] FOREIGN KEY([EdtTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[JOBDL070ElectronicDataTransactionHistory] CHECK CONSTRAINT [FK_JOBDL070ElectronicDataTransactionHistory_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[JOBDL070ElectronicDataTransactionHistory]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL070ElectronicDataTransactionHistory_SYSTM000Ref_Options1] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[JOBDL070ElectronicDataTransactionHistory] CHECK CONSTRAINT [FK_JOBDL070ElectronicDataTransactionHistory_SYSTM000Ref_Options1]
GO


