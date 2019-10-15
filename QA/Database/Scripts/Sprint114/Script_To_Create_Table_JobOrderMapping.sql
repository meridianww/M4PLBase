SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000JobOrderMapping](
	[JobOrderMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[SONumber] [nvarchar](150) NULL,
	[PONumber] [nvarchar](150) NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_JobOrderMapping] PRIMARY KEY CLUSTERED 
(
	[JobOrderMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[JobOrderMapping] ADD  CONSTRAINT [DF_JobOrderMapping_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO

ALTER TABLE [dbo].[JobOrderMapping]  WITH CHECK ADD  CONSTRAINT [FK_JobOrderMapping_JOBDL000Master] FOREIGN KEY([JobId])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO

ALTER TABLE [dbo].[JobOrderMapping] CHECK CONSTRAINT [FK_JobOrderMapping_JOBDL000Master]
GO


