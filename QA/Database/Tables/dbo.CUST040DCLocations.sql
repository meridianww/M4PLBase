SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUST040DCLocations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CdcCustomerID] [bigint] NULL,
	[CdcItemNumber] [int] NULL,
	[CdcLocationCode] [nvarchar](20) NULL,
	[CdcCustomerCode] [nvarchar](20) NULL,
	[CdcLocationTitle] [nvarchar](50) NULL,
	[CdcContactMSTRID] [bigint] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_CUST040DCLocations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUST040DCLocations] ADD  CONSTRAINT [DF_CUST040DCLocations_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[CUST040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST040DCLocations_CONTC000Master] FOREIGN KEY([CdcContactMSTRID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST040DCLocations] CHECK CONSTRAINT [FK_CUST040DCLocations_CONTC000Master]
GO
ALTER TABLE [dbo].[CUST040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST040DCLocations_CUST000Master] FOREIGN KEY([CdcCustomerID])
REFERENCES [dbo].[CUST000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST040DCLocations] CHECK CONSTRAINT [FK_CUST040DCLocations_CUST000Master]
GO
ALTER TABLE [dbo].[CUST040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST040DCLocations_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST040DCLocations] CHECK CONSTRAINT [FK_CUST040DCLocations_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cust Contact ID - This list is for key personnel contact associated to this Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Only Show Short Code for the Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'CdcCustomerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sorting Order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'CdcItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'CdcLocationCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Title and Oriented on What They Are to the Organization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'CdcLocationTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Information Stored with Contact and Associated to actual Contact Master Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'CdcContactMSTRID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Archive, Delete, Suspend' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST040DCLocations', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
