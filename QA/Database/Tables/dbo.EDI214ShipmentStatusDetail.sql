SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI214ShipmentStatusDetail](
	[esdHeaderID] [bigint] IDENTITY(1,1) NOT NULL,
	[eshHeaderID] [bigint] NULL,
	[esdTradingPartner] [varchar](20) NULL,
	[esdShipmentID] [varchar](30) NULL,
	[esdMasterCartonBarCode] [varchar](30) NULL,
	[esdOSDQty] [varchar](10) NULL,
	[esdExceptionNote] [varchar](30) NULL,
	[esdOverageShortageDamage] [varchar](10) NULL,
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
 CONSTRAINT [PK_EDI214ShipmentStatusDetail] PRIMARY KEY CLUSTERED 
(
	[esdHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trading Partner Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusDetail', @level2type=N'COLUMN',@level2name=N'esdTradingPartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipment ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusDetail', @level2type=N'COLUMN',@level2name=N'esdShipmentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Master Carton Barcode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI214ShipmentStatusDetail', @level2type=N'COLUMN',@level2name=N'esdMasterCartonBarCode'
GO
