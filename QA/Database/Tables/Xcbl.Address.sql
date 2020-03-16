SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[Address](
	[AddressId] [bigint] NOT NULL,
	[SummaryHeaderId] [bigint] NOT NULL,
	[AddressTypeId] [tinyint] NOT NULL,
	[ConsigneeName] [varchar](60) NULL,
	[ConsigneeNameID] [bigint] NULL,
	[ConsigneeAddress1] [varchar](75) NULL,
	[ConsigneeAddress2] [varchar](75) NULL,
	[ConsigneeCity] [varchar](75) NULL,
	[ConsigneeState] [varchar](25) NULL,
	[ConsigneePostalCode] [varchar](15) NULL,
	[ConsigneeCountryCode] [varchar](10) NULL,
	[ConsigneeContactName] [varchar](75) NULL,
	[ConsigneeContactNumber] [varchar](80) NULL,
	[ConsigneeAltContName] [varchar](75) NULL,
	[ConsigneeAltContNumber] [varchar](80) NULL,
	[ConsigneeStreetAddress3] [nvarchar](75) NULL,
	[ConsigneeStreetAddress4] [nvarchar](75) NULL,
	[InterConsigneeName] [varchar](60) NULL,
	[InterConsigneeNameID] [bigint] NULL,
	[InterConsigneeAddress1] [varchar](75) NULL,
	[InterConsigneeAddress2] [varchar](75) NULL,
	[InterConsigneeCity] [varchar](75) NULL,
	[InterConsigneeState] [varchar](25) NULL,
	[InterConsigneePostalCode] [varchar](15) NULL,
	[InterConsigneeCountryCode] [varchar](10) NULL,
	[InterConsigneeContactName] [varchar](75) NULL,
	[InterConsigneeContactNumber] [varchar](80) NULL,
	[InterConsigneeAltContName] [varchar](75) NULL,
	[InterConsigneeAltContNumber] [varchar](80) NULL,
	[InterConsigneeStreetAddress3] [varchar](75) NULL,
	[InterConsigneeStreetAddress4] [varchar](75) NULL,
	[ShipFromName] [varchar](60) NULL,
	[ShipFromNameID] [bigint] NULL,
	[ShipFromAddress1] [varchar](75) NULL,
	[ShipFromAddress2] [varchar](75) NULL,
	[ShipFromCity] [varchar](75) NULL,
	[ShipFromState] [varchar](25) NULL,
	[ShipFromPostalCode] [varchar](15) NULL,
	[ShipFromCountryCode] [varchar](10) NULL,
	[ShipFromContactName] [varchar](75) NULL,
	[ShipFromContactNumber] [varchar](80) NULL,
	[ShipFromAltContName] [varchar](75) NULL,
	[ShipFromAltContNumber] [varchar](80) NULL,
	[ShipFromStreetAddress3] [varchar](75) NULL,
	[ShipFromStreetAddress4] [varchar](75) NULL,
	[BillToName] [varchar](60) NULL,
	[BillToNameID] [bigint] NULL,
	[BillToAddress1] [varchar](75) NULL,
	[BillToAddress2] [varchar](75) NULL,
	[BillToCity] [varchar](75) NULL,
	[BillToState] [varchar](25) NULL,
	[BillToPostalCode] [varchar](15) NULL,
	[BillToCountryCode] [varchar](10) NULL,
	[BillToContactName] [varchar](75) NULL,
	[BillToContactNumber] [varchar](80) NULL,
	[BillToAltContName] [varchar](75) NULL,
	[BillToAltContNumber] [varchar](80) NULL,
	[BillToStreetAddress3] [varchar](75) NULL,
	[BillToStreetAddress4] [varchar](75) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Xcbl].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_AddressType] FOREIGN KEY([AddressTypeId])
REFERENCES [Xcbl].[AddressType] ([AddressTypeId])
GO

ALTER TABLE [Xcbl].[Address] CHECK CONSTRAINT [FK_Address_AddressType]
GO

ALTER TABLE [Xcbl].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_SummaryHeaderId] FOREIGN KEY([SummaryHeaderId])
REFERENCES [Xcbl].[SummaryHeader] ([SummaryHeaderId])
GO

ALTER TABLE [Xcbl].[Address] CHECK CONSTRAINT [FK_Address_SummaryHeaderId]
GO


