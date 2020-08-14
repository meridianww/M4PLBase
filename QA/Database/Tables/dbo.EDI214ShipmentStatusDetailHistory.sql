SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI214ShipmentStatusDetailHistory](
	[esdHeaderID] [bigint] NOT NULL,
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
 CONSTRAINT [PK_EDI214ShipmentStatusDetailHistory] PRIMARY KEY CLUSTERED 
(
	[esdHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


