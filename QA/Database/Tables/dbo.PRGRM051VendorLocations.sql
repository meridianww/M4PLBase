SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM051VendorLocations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PvlProgramID] [bigint] NULL,
	[PvlVendorID] [bigint] NULL,
	[PvlItemNumber] [int] NULL,
	[PvlLocationCode] [nvarchar](20) NULL,
	[PvlLocationCodeCustomer] [nvarchar](20) NULL,
	[PvlLocationTitle] [nvarchar](50) NULL,
	[PvlContactMSTRID] [bigint] NULL,
	[StatusId] [int] NULL,
	[PvlDateStart] [datetime2](7) NULL,
	[PvlDateEnd] [datetime2](7) NULL,
	[PvlUserCode1] [nvarchar](20) NULL,
	[PvlUserCode2] [nvarchar](20) NULL,
	[PvlUserCode3] [nvarchar](20) NULL,
	[PvlUserCode4] [nvarchar](20) NULL,
	[PvlUserCode5] [nvarchar](20) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[VendDCLocationId] [bigint] NULL,
 CONSTRAINT [PK_PRGRM051VendorLocations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] ADD  CONSTRAINT [DF_PRGRM051VendorLocations_PvlEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM051VendorLocations_CONTC000Master] FOREIGN KEY([PvlContactMSTRID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] CHECK CONSTRAINT [FK_PRGRM051VendorLocations_CONTC000Master]
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM051VendorLocations_PRGRM000Master] FOREIGN KEY([PvlProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] CHECK CONSTRAINT [FK_PRGRM051VendorLocations_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM051VendorLocations_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] CHECK CONSTRAINT [FK_PRGRM051VendorLocations_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM051VendorLocations_VEND000Master] FOREIGN KEY([PvlVendorID])
REFERENCES [dbo].[VEND000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] CHECK CONSTRAINT [FK_PRGRM051VendorLocations_VEND000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Affiliation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendor Relationship' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlVendorID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Program Ordering' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location Code From System (Pre-Defined with Location)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlLocationCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Designation if different than Location Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlLocationCodeCustomer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlLocationTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Master ID for Address Information and Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlContactMSTRID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Start Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'PvlDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modify On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM051VendorLocations', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
