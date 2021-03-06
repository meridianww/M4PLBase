SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure inserts the EDI orders from the flat file into the EDI856Manifest Detail table.
-- =============================================
CREATE Procedure [dbo].[ediInsertEDI856Detail]
	@HeaderID bigint,
	@TradingPartner varchar(20),
	@GroupControlNo int,
	@BOLNo varchar(30),
	@ManifestNo varchar(30),
	@ItemWeight decimal(18,2),
	@WeightQualifier varchar(10),
	@WeightUnitOfMeasure varchar(10),
	@ItemVolume decimal(18,2),
	@VolumeQualifier varchar(10),
	@VolumeUnitOfMeasure varchar(10),
	@ItemQuantity int,
	@BarCodeSerialNumber varchar(50),
	@ItemDescription varchar(80),
	@ShipQuantity varchar(30),
	@PackagingCode varchar(50),
	@CommodityCode varchar(50),
	@MasterLblQualifier varchar(30),
	@MasterLblSerialNumber varchar(30),
	@UDF01 varchar(30),
	@UDF02 varchar(30),
	@UDF03 varchar(30),
	@UDF04 varchar(30),
	@UDF05 varchar(30),
	@UDF06 varchar(30),
	@UDF07 varchar(30),
	@UDF08 varchar(30),
	@UDF09 varchar(30),
	@UDF10 varchar(30),
	@EnteredBy varchar(50)

As BEGIN

INSERT INTO dbo.EDI856ManifestDetail(
	emhHeaderID,
	emdTradingPartner,
	emdGroupControlNo,
	emdBOLNo,
	emdManifestNo,
	emdItemWeight,
	emdWeightQualifier,
	emdWeightUnitOfMeasure,
	emdItemVolume,
	emdVolumeQualifier,
	emdVolumeUnitOfMeasure,
	emdItemQuantity,
	emdBarCodeSerialNumber,
	emdItemDescription,
	emdShipQuantity,
	emdPackagingCode,
	emdCommodityCode,
	emdMasterLblQualifier,
	emdMasterSerialNumber,
	emdUDF01,
	emdUDF02,
	emdUDF03,
	emdUDF04,
	emdUDF05,
	emdUDF06,
	emdUDF07,
	emdUDF08,
	emdUDF09,
	emdUDF10,
	EnteredBy ) VALUES (
	@HeaderID,
	@TradingPartner,
	@GroupControlNo,
	@BOLNo,
	@ManifestNo,
	@ItemWeight, 
	@WeightQualifier,
	@WeightUnitOfMeasure,
	@ItemVolume, 
	@VolumeQualifier,
	@VolumeUnitOfMeasure,
	@ItemQuantity,
	@BarCodeSerialNumber,
	@ItemDescription,
	@ShipQuantity, 
	@PackagingCode,
	@CommodityCode,
	@MasterLblQualifier,
	@MasterLblSerialNumber,
	@UDF01,
	@UDF02,
	@UDF03,
	@UDF04,
	@UDF05,
	@UDF06,
	@UDF07,
	@UDF08,
	@UDF09,
	@UDF10,
	@EnteredBy)

END
GO
