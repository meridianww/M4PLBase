SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VEND040DCLocations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VdcVendorID] [bigint] NULL,
	[VdcItemNumber] [int] NULL,
	[VdcLocationCode] [nvarchar](20) NULL,
	[VdcCustomerCode] [nvarchar](20) NULL,
	[VdcLocationTitle] [nvarchar](50) NULL,
	[VdcContactMSTRID] [bigint] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_VEND040DCLocations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VEND040DCLocations] ADD  CONSTRAINT [DF_VEND040DCLocations_VdcEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[VEND040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND040DCLocations_CONTC000Master] FOREIGN KEY([VdcContactMSTRID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND040DCLocations] CHECK CONSTRAINT [FK_VEND040DCLocations_CONTC000Master]
GO
ALTER TABLE [dbo].[VEND040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND040DCLocations_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND040DCLocations] CHECK CONSTRAINT [FK_VEND040DCLocations_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND040DCLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND040DCLocations_VEND000Master] FOREIGN KEY([VdcVendorID])
REFERENCES [dbo].[VEND000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND040DCLocations] CHECK CONSTRAINT [FK_VEND040DCLocations_VEND000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vend Contact ID - This list is for key personnel contact associated to this Vendomer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Only Show Short Code for the Vendomer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'VdcVendorID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sorting Order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'VdcItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'VdcLocationCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Title and Oriented on What They Are to the Organization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'VdcLocationTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Information Stored with Contact and Associated to actual Contact Master Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'VdcContactMSTRID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Archive, Delete, Suspend' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND040DCLocations', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
