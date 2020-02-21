SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAV000JobPurchaseOrderMapping](
	[JobPurchaseOrderMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobSalesOrderMappingId] [bigint] NOT NULL,
	[PONumber] [nvarchar](150) NULL,
	[IsElectronicInvoiced] [bit] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_NAV000JobPurchaseOrderMapping] PRIMARY KEY CLUSTERED 
(
	[JobPurchaseOrderMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] ADD  CONSTRAINT [DF_NAV000JobPurchaseOrderMapping_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO

ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] ADD  CONSTRAINT [DF_NAV000JobPurchaseOrderMapping_IsElectronicInvoiced]  DEFAULT (0) FOR [IsElectronicInvoiced]
GO

ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping]  WITH CHECK ADD  CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_NAV000JobSalesOrderMapping] FOREIGN KEY([JobSalesOrderMappingId])
REFERENCES [dbo].[NAV000JobSalesOrderMapping] ([JobSalesOrderMappingId])
GO
ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] CHECK CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_NAV000JobSalesOrderMapping]
GO
