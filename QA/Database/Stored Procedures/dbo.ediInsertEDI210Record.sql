SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 63, number of rows retrieved: 388793

-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 12/13/2019
-- Description:	The stored procedure inserts the EDI invoices into the EDI210Invoice table
-- =============================================
ALTER PROCEDURE [dbo].[ediInsertEDI210Record]
	-- Add the parameters for the stored procedure here
	@TradingPartner varchar(20),
	@ShipmentID varchar(30),
	@InvoiceNumber VARCHAR(30),
	@PaymentType varchar(10),
	@CurrencyCode varchar(10),
	@InvoiceDate varchar(50),
	@TotalAmountDue decimal(18,2),
	@DeliveryDate varchar(50),
	@SCACCode varchar(80),
	@PickupDate varchar(50),
	@TotalWeight decimal(18,2),
	@ShipperName varchar(60),
	@ShipperAddress1 varchar(75),
	@ShipperAddress2 varchar(75),
	@ShipperCity varchar(75),
	@ShipperState varchar(25),
	@ShipperPostalCode varchar(15),
	@ShipperCountryCode varchar(10),
	@ShipFromName varchar(60),
	@ShipFromAddress1 varchar(75),
	@ShipFromAddress2 varchar(75),
	@ShipFromCity varchar(75),
	@ShipFromState varchar(25),
	@ShipFromPostalCode varchar(15),
	@ShipFromCountryCode varchar(10),
	@ConsigneeName varchar(60),
	@ConsigneeAddress1 varchar(75),
	@ConsigneeAddress2 varchar(75),
	@ConsigneeCity varchar(75),
	@ConsigneeState varchar(25),
	@ConsigneePostalCode varchar(15),
	@ConsigneeCountryCode varchar(10),
	@ShipToName varchar(60),
	@ShipToAddress1 varchar(75),
	@ShipToAddress2 varchar(75),
	@ShipToCity varchar(75),
	@ShipToState varchar(25),
	@ShipToPostalCode varchar(15),
	@ShipToCountryCode varchar(10),
	@BillToName varchar(60),
	@BillToAddress1 varchar(75),
	@BillToAddress2 varchar(75),
	@BillToCity varchar(75),
	@BillToState varchar(25),
	@BillToPostalCode varchar(15),
	@BillToCountryCode varchar(10),
	@Weight decimal(18,2),
	@WeightQualifier varchar(10),
	@LadingDescription varchar(50),
	@CommodityCode varchar(50),
	@Pieces bigint,
	@FreightCharge decimal(18,2),
	@FuelSurcharge decimal(18,2),
	@Volume decimal(18,2),
	@VolumeQualifier varchar(10),
	@AdditionalHandling varchar(45),
	@CabinetReturn varchar(45),
	@GoodSalesTax varchar(45),
	@HarmonizedServiceTax varchar(45),
	@InsideDelivery varchar(45),
	@MinimumCharge varchar(45),
	@OutOfRangeMiles varchar(45),
	@PickupCharge varchar(45),
	@Reconsignment varchar(45),
	@RedeliveryAttempt varchar(45),
	@HolidayOrWeekendDelivery varchar(45),
	@SpecialDelivery varchar(45),
	@StairsExcessDelivery varchar(45),
	@Storage varchar(45),
	@StanisciHandling varchar(45),
	@UnloadingFee varchar(45),
	@BridgeToll varchar(45),
	@ExtraLabor varchar(45),
	@HighwayToll varchar(45),
	@Accessorial1 INT,
	@Accessorial2 INT,
	@Accessorial3 INT,
	@Accessorial4 INT,
	@Accessorial5 INT,
	@Accessorial6 INT,
	@Accessorial7 INT,
	@Accessorial8 INT,
	@Accessorial9 INT,
	@Accessorial10 INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO dbo.EDI210Invoice(
		einTradingPartner
		,einShipmentID
		,einInvoiceNumber
		,einPaymentType 
		,einCurrencyCode
		,einInvoiceDate 
		,einTotalAmountDue
		,einDeliveryDate
		,einSCACCode 
		,einPickupDate 
		,einTotalWeight 
		,einShipperName
		,einShipperAddress1
		,einShipperAddress2
		,einShipperCity
		,einShipperState
		,einShipperPostalCode
		,einShipperCountryCode
		,einShipFromName
		,einShipFromAddress1
		,einShipFromAddress2
		,einShipFromCity
		,einShipFromState
		,einShipFromPostalCode
		,einShipFromCountryCode
		,einConsigneeName
		,einConsigneeAddress1
		,einConsigneeAddress2
		,einConsigneeCity
		,einConsigneeState
		,einConsigneePostalCode
		,einConsigneeCountryCode
		,einShipToName
		,einShipToAddress1
		,einShipToAddress2
		,einShipToCity
		,einShipToState
		,einShipToPostalCode
		,einShipToCountryCode
		,einBillToName
		,einBillToAddress1
		,einBillToAddress2
		,einBillToCity
		,einBillToState
		,einBillToPostalCode
		,einBillToCountryCode
		,einWeight
		,einWeightQualifier
		,einLadingDescription
		,einCommodityCode
		,einPieces
		,einFreightCharge
		,einFuelSurcharge
		,einVolume
		,einVolumeQualifier
		,einAdditionalHandling
		,einCabinetReturn
		,einGoodSalesTax
		,einHarmonizedServiceTax
		,einInsideDelivery
		,einMinimumCharge
		,einOutOfRangeMiles
		,einPickupCharge
		,einReconsignment
		,einRedeliveryAttempt
		,einHolidayOrWeekendDelivery
		,einSpecialDelivery
		,einStairsExcessDelivery
		,einStorage
		,einStanisciHandling
		,einUnloadingFee
		,einBridgeToll
		,einExtraLabor
		,einHighwayToll
		,einAccessorial1Qty
		,einAccessorial2Qty
		,einAccessorial3Qty
		,einAccessorial4Qty
		,einAccessorial5Qty
		,einAccessorial6Qty
		,einAccessorial7Qty
		,einAccessorial8Qty
		,einAccessorial9Qty
		,einAccessorial10Qty
	) VALUES
	(
		@TradingPartner,
		@ShipmentID,
		@InvoiceNumber,
		@PaymentType,
		@CurrencyCode,
		@InvoiceDate,
		@TotalAmountDue,
		@DeliveryDate,
		@SCACCode,
		@PickupDate,
		@TotalWeight,
		@ShipperName,
		@ShipperAddress1,
		@ShipperAddress2,
		@ShipperCity,
		@ShipperState,
		@ShipperPostalCode,
		@ShipperCountryCode,
		@ShipFromName,
		@ShipFromAddress1,
		@ShipFromAddress2,
		@ShipFromCity,
		@ShipFromState,
		@ShipFromPostalCode,
		@ShipFromCountryCode,
		@ConsigneeName,
		@ConsigneeAddress1,
		@ConsigneeAddress2,
		@ConsigneeCity,
		@ConsigneeState, 
		@ConsigneePostalCode,
		@ConsigneeCountryCode,
		@ShipToName,
		@ShipToAddress1,
		@ShipToAddress2,
		@ShipToCity,
		@ShipToState, 
		@ShipToPostalCode,
		@ShipToCountryCode,
		@BillToName,
		@BillToAddress1,
		@BillToAddress2,
		@BillToCity,
		@BillToState,
		@BillToPostalCode,
		@BillToCountryCode,
		@Weight,
		@WeightQualifier,
		@LadingDescription,
		@CommodityCode,
		@Pieces,
		@FreightCharge,
		@FuelSurcharge,
		@Volume,
		@VolumeQualifier,
		@AdditionalHandling,
		@CabinetReturn,
		@GoodSalesTax,
		@HarmonizedServiceTax,
		@InsideDelivery,
		@MinimumCharge,
		@OutOfRangeMiles,
		@PickupCharge,
		@Reconsignment,
		@RedeliveryAttempt,
		@HolidayOrWeekendDelivery,
		@SpecialDelivery,
		@StairsExcessDelivery,
		@Storage,
		@StanisciHandling,
		@UnloadingFee,
		@BridgeToll,
		@ExtraLabor,
		@HighwayToll,
		@Accessorial1,
		@Accessorial2,
		@Accessorial3,
		@Accessorial4,
		@Accessorial5,
		@Accessorial6,
		@Accessorial7,
		@Accessorial8,
		@Accessorial9,
		@Accessorial10
	);
END