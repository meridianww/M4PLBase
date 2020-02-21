SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAV000JobSalesOrderMapping](
	[JobSalesOrderMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[SONumber] [nvarchar](150) NULL,
	[IsElectronicInvoiced] [bit] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_NAV000JobSalesOrderMapping] PRIMARY KEY CLUSTERED 
(
	[JobSalesOrderMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[NAV000JobSalesOrderMapping] ADD  CONSTRAINT [DF_NAV000JobSalesOrderMapping_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[NAV000JobSalesOrderMapping] ADD  CONSTRAINT [DF_NAV000JobSalesOrderMapping_IsElectronicInvoiced]  DEFAULT (0) FOR [IsElectronicInvoiced]
GO
ALTER TABLE [dbo].[NAV000JobSalesOrderMapping]  WITH CHECK ADD  CONSTRAINT [FK_NAV000JobSalesOrderMapping_JOBDL000Master] FOREIGN KEY([JobId])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[NAV000JobSalesOrderMapping] CHECK CONSTRAINT [FK_NAV000JobSalesOrderMapping_JOBDL000Master]
GO
