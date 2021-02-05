SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure inserts the EDI orders from the flat file into the EDI204Summary Header table.
-- =============================================
ALTER Procedure [dbo].[ediInsertEDI204Header]
	@TradingPartner varchar(20),
	@GroupControlNo bigint,
	@BOLNo nvarchar(30),
	@MasterBOLNo varchar(30),
	@MethodOfPayment varchar(10),
	@SetPurpose varchar(10),
	@CustomerReferenceNo varchar(30),
	@LocationId varchar(30),
	@ShipDescription varchar(30),
	@OrderType varchar(30),
	@PurchaseOrderNo varchar(30),
	@LocationNumber varchar(30),
	@ShipDate datetime2(7),
	@ArrivalDate3PL datetime2(7),
	@ProductType varchar(30),
	@Latitude varchar(30),
	@Longitude varchar(30),
	@ReasonCodeCancellation varchar(30),
	@ManifestNo varchar(30),
	@TotalWeight decimal(18,2),
	@TotalCubicFeet decimal(18,2),
	@TotalPieces bigint,
	@ServiceMode varchar(30),
	@DeliveryCommitmentType varchar(30),
	@ScheduledPickupDate datetime2(7),
	@ScheduledDeliveryDate datetime2(7),
	@SpecialNotes varchar(30),
	@ConsigneeName varchar(60),
	@ConsigneeNameID bigint,
	@ConsigneeAddress1 varchar(75),
	@ConsigneeAddress2 varchar(75),
	@ConsigneeCity varchar(75),
	@ConsigneeState varchar(25),
	@ConsigneePostalCode varchar(15),
	@ConsigneeCountryCode varchar(10),
	@ConsigneeContactName varchar(75),
	@ConsigneeContactNumber varchar(80),
	@ConsigneeContactEmail varchar(80),
	@ConsigneeAltContName varchar(75),
	@ConsigneeAltContNumber varchar(80),
	@ConsigneeAltContEmail varchar(80),
	@InterConsigneeName varchar(60),
	@InterConsigneeNameID bigint,
	@InterConsigneeAddress1 varchar(75),
	@InterConsigneeAddress2 varchar(75),
	@InterConsigneeCity varchar(75),
	@InterConsigneeState varchar(25),
	@InterConsigneePostalCode varchar(15),
	@InterConsigneeCountryCode varchar(10),
	@InterConsigneeContactName varchar(75),
	@InterConsigneeContactNumber varchar(80),
	@InterConsigneeContactEmail varchar(80),
	@InterConsigneeAltContName varchar(75),
	@InterConsigneeAltContNumber varchar(80),
	@InterConsigneeAltContEmail varchar(80),
	@ShipFromName varchar(60),
	@ShipFromNameID bigint,
	@ShipFromAddress1 varchar(75),
	@ShipFromAddress2 varchar(75),
	@ShipFromCity varchar(75),
	@ShipFromState varchar(25),
	@ShipFromPostalCode varchar(15),
	@ShipFromCountryCode varchar(10),
	@ShipFromContactName varchar(75),
	@ShipFromContactNumber varchar(80),
	@ShipFromContactEmail varchar(80),
	@ShipFromAltContName varchar(75),
	@ShipFromAltContNumber varchar(80),
	@ShipFromAltContEmail varchar(80),
	@BillToName varchar(60),
	@BillToNameID bigint,
	@BillToAddress1 varchar(75),
	@BillToAddress2 varchar(75),
	@BillToCity varchar(75),
	@BillToState varchar(25),
	@BillToPostalCode varchar(15),
	@BillToCountryCode varchar(10),
	@BillToContactName varchar(75),
	@BillToContactNumber varchar(80),
	@BillToContactEmail varchar(80),
	@BillToAltContName varchar(75),
	@BillToAltContNumber varchar(80),	
	@BillToAltContEmail varchar(80),	
	@TextData varchar(Max),
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

INSERT INTO dbo.EDI204SummaryHeader(
eshTradingPartner
,eshGroupControlNo
,eshBOLNo
,eshMasterBOLNo
,eshMethodOfPayment
,eshSetPurpose
,eshCustomerReferenceNo
,eshLocationId
,eshShipDescription
,eshOrderType
,eshPurchaseOrderNo
,eshLocationNumber
,eshShipDate
,eshArrivalDate3PL
,eshProductType
,eshLatitude
,eshLongitude
,eshReasonCodeCancellation
,eshManifestNo
,eshTotalWeight
,eshTotalCubicFeet
,eshTotalPieces
,eshServiceMode
,eshDeliveryCommitmentType
,eshScheduledPickupDate
,eshScheduledDeliveryDate
,eshSpecialNotes
,eshConsigneeName
,eshConsigneeNameID
,eshConsigneeAddress1
,eshConsigneeAddress2
,eshConsigneeCity
,eshConsigneeState
,eshConsigneePostalCode
,eshConsigneeCountryCode
,eshConsigneeContactName
,eshConsigneeContactNumber
,eshConsigneeContactEmail
,eshConsigneeAltContName
,eshConsigneeAltContNumber
,eshConsigneeAltContEmail
,eshInterConsigneeName
,eshInterConsigneeNameID
,eshInterConsigneeAddress1
,eshInterConsigneeAddress2
,eshInterConsigneeCity
,eshInterConsigneeState
,eshInterConsigneePostalCode
,eshInterConsigneeCountryCode
,eshInterConsigneeContactName
,eshInterConsigneeContactNumber
,eshInterConsigneeContactEmail
,eshInterConsigneeAltContName
,eshInterConsigneeAltContNumber
,eshInterConsigneeAltContEmail
,eshShipFromName
,eshShipFromNameID
,eshShipFromAddress1
,eshShipFromAddress2
,eshShipFromCity
,eshShipFromState
,eshShipFromPostalCode
,eshShipFromCountryCode
,eshShipFromContactName
,eshShipFromContactNumber
,eshShipFromContactEmail
,eshShipFromAltContName
,eshShipFromAltContNumber
,eshShipFromAltContEmail
,eshBillToName
,eshBillToNameID
,eshBillToAddress1
,eshBillToAddress2
,eshBillToCity
,eshBillToState
,eshBillToPostalCode
,eshBillToCountryCode
,eshBillToContactName
,eshBillToContactNumber
,eshBillToContactEmail
,eshBillToAltContName
,eshBillToAltContNumber
,eshBillToAltContEmail
,eshTextData
,eshUDF01
,eshUDF02
,eshUDF03
,eshUDF04
,eshUDF05
,eshUDF06
,eshUDF07
,eshUDF08
,eshUDF09
,eshUDF10
,EnteredBy
 ) VALUES (@TradingPartner,
	@GroupControlNo,
	@BOLNo,
	@MasterBOLNo,
	@MethodOfPayment,
	@SetPurpose,
	@CustomerReferenceNo,
	@LocationId,
	@ShipDescription,
	@OrderType,
	@PurchaseOrderNo,
	@LocationNumber,
	@ShipDate,
	@ArrivalDate3PL,
	@ProductType,
	@Latitude,
	@Longitude,
	@ReasonCodeCancellation,
	@ManifestNo,
	@TotalWeight,
	@TotalCubicFeet,
	@TotalPieces,
	@ServiceMode,
	@DeliveryCommitmentType,
	@ScheduledPickupDate,
	@ScheduledDeliveryDate,
	@SpecialNotes,
	@ConsigneeName,
	@ConsigneeNameID,
	@ConsigneeAddress1,
	@ConsigneeAddress2,
	@ConsigneeCity,
	@ConsigneeState,
	@ConsigneePostalCode,
	@ConsigneeCountryCode,
	@ConsigneeContactName,
	@ConsigneeContactNumber,
	@ConsigneeContactEmail,
	@ConsigneeAltContName,
	@ConsigneeAltContNumber,
	@ConsigneeAltContEmail,
	@InterConsigneeName,
	@InterConsigneeNameID,
	@InterConsigneeAddress1,
	@InterConsigneeAddress2,
	@InterConsigneeCity,
	@InterConsigneeState,
	@InterConsigneePostalCode,
	@InterConsigneeCountryCode,
	@InterConsigneeContactName,
	@InterConsigneeContactNumber,
	@InterConsigneeContactEmail,
	@InterConsigneeAltContName,
	@InterConsigneeAltContNumber,
	@InterConsigneeAltContEmail,
	@ShipFromName,
	@ShipFromNameID,
	@ShipFromAddress1,
	@ShipFromAddress2,
	@ShipFromCity,
	@ShipFromState,
	@ShipFromPostalCode,
	@ShipFromCountryCode,
	@ShipFromContactName,
	@ShipFromContactNumber,
	@ShipFromContactEmail,
	@ShipFromAltContName,
	@ShipFromAltContNumber,
	@ShipFromAltContEmail,
	@BillToName,
	@BillToNameID,
	@BillToAddress1,
	@BillToAddress2,
	@BillToCity,
	@BillToState,
	@BillToPostalCode,
	@BillToCountryCode,
	@BillToContactName,
	@BillToContactNumber,
	@BillToContactEmail,
	@BillToAltContName,
	@BillToAltContNumber,
	@BillToAltContEmail,
	@TextData,
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
	@EnteredBy); Select SCOPE_IDENTITY();

END
GO
