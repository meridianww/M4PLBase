SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI214ShipmentStatusHeaderHistory](
	[eshHeaderID] [bigint] NOT NULL,
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
 CONSTRAINT [PK_EDI214ShipmentStatusHeaderHistory] PRIMARY KEY CLUSTERED 
(
	[eshHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


