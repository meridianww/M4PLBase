SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI214ShipmentStatusHeader](
	[eshHeaderID] [bigint] IDENTITY(1,1) NOT NULL,
	[eshTradingPartner] [varchar](20) NULL,
	[eshOrderNumber] [varchar](30) NULL,
	[eshShipmentID] [varchar](30) NULL,
	[eshSCAC] [varchar](10) NULL,
	[eshDomicileSiteNo] [varchar](30) NULL,
	[eshRouteNumber] [varchar](30) NULL,
	[eshSignedBy] [varchar](60) NULL,
	[eshTerminalName] [varchar](60) NULL,
	[eshTerminalAddress1] [varchar](75) NULL,
	[eshTerminalAddress2] [varchar](75) NULL,
	[eshTerminalCity] [varchar](75) NULL,
	[eshTerminalState] [varchar](25) NULL,
	[eshTerminalPostalCode] [varchar](15) NULL,
	[eshTerminalCountryCode] [varchar](10) NULL,
	[eshStatus] [varchar](20) NULL,
	[eshStatusReason] [varchar](20) NULL,
	[eshStatusDate] [varchar](50) NULL,
	[eshStatusTime] [varchar](50) NULL,
	[eshLocationCity] [varchar](75) NULL,
	[eshLocationState] [varchar](25) NULL,
	[eshLocationCountryCode] [varchar](10) NULL,
	[eshLatitude] [varchar](30) NULL,
	[eshLongitude] [varchar](30) NULL,
	[eshDirection] [varchar](20) NULL,
	[eshOverage] [bigint] NULL,
	[eshPartial] [bigint] NULL,
	[eshDamage] [bigint] NULL,
	[ProFlags02] [varchar](1) NULL,
	[ProFlags03] [varchar](1) NULL,
	[ProFlags04] [varchar](1) NULL,
	[ProFlags05] [varchar](1) NULL,
	[ProFlags06] [varchar](1) NULL,
	[ProFlags07] [varchar](1) NULL,
	[ProFlags08] [varchar](1) NULL,
	[ProFlags09] [varchar](1) NULL,
	[ProFlags10] [varchar](1) NULL,
	[ProFlags11] [varchar](1) NULL,
	[ProFlags12] [varchar](1) NULL,
	[ProFlags13] [varchar](1) NULL,
	[ProFlags14] [varchar](1) NULL,
	[ProFlags15] [varchar](1) NULL,
	[ProFlags16] [varchar](1) NULL,
	[ProFlags17] [varchar](1) NULL,
	[ProFlags18] [varchar](1) NULL,
	[ProFlags19] [varchar](1) NULL,
	[ProFlags20] [varchar](1) NULL,
	[eshEquipmentNumber] [varchar](10) NULL,
	[eshOrderType] [varchar](30) NULL,
	[eshWeightQualifier] [varchar](10) NULL,
	[eshWeightUnitCode] [varchar](10) NULL,
	[eshWeight] [decimal](18, 2) NULL,
	[eshQuanity] [bigint] NULL,
	[eshParts] [bigint] NULL,
	[eshVolumeQualifier] [varchar](10) NULL,
	[eshVolume] [decimal](18, 2) NULL,
 CONSTRAINT [PK_EDI214ShipmentStatusHeader] PRIMARY KEY CLUSTERED 
(
	[eshHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshOrderNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipment ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshShipmentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SCAC Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshSCAC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Domicile Site Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshDomicileSiteNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Route Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshRouteNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Signed By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshSignedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Terminal Country Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshTerminalCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Reason - Appointment Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshStatusReason'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshStatusDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshStatusTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'City where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshLocationCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshLocationState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Country where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshLocationCountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshLatitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshLongitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude/Longitude Direction where the status change occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusHeader', @level2type=N'COLUMN',@level2name=N'eshDirection'
GO
