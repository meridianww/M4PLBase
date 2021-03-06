SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/20/2020
-- Description:	Get the xCBL Details
-- =============================================
CREATE PROCEDURE [Xcbl].[GetXCBLDataByGatewayId] (@gatewayId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;


	DECLARE @SummaryHeaderId BIGINT

		SELECT @SummaryHeaderId = XCBLHeaderId
		FROM [dbo].[JOBDL020Gateways]
		WHERE Id = @gatewayId

	SELECT @SummaryHeaderId AS [SummaryHeaderId]
		,[TradingPartner]
		,[GroupControlNo]
		,[BOLNo]
		,[MasterBOLNo]
		,[MethodOfPayment]
		,[SetPurpose]
		,[CustomerReferenceNo]
		,[ShipDescription]
		,[OrderType]
		,[PurchaseOrderNo]
		,[ShipDate]
		,[ArrivalDate3PL]
		,[ServiceMode]
		,[ProductType]
		,[ReasonCodeCancellation]
		,[ManifestNo]
		,[TotalWeight]
		,[TotalCubicFeet]
		,[TotalPieces]
		,[DeliveryCommitmentType]
		,[ScheduledPickupDate]
		,[ScheduledDeliveryDate]
		,[SpecialNotes]
		,[OrderedDate]
		,[TextData]
		,[LocationId]
		,[LocationNumber]
		,[Latitude]
		,[Longitude]
		,[isxcblAcceptanceRequired]
		,[isxcblProcessed]
		,[isxcblRejected]
		,[ProcessingDate]
		,[DateEntered]
		,[EnteredBy]
		,[DateChanged]
		,[ChangedBy]
	FROM [Xcbl].[SummaryHeader]
	WHERE SummaryHeaderId = @SummaryHeaderId

	SELECT [AddressId]
		,[SummaryHeaderId]
		,[AddressTypeId]
		,[Name]
		,[NameID]
		,[Address1]
		,[Address2]
		,[City]
		,[State]
		,[PostalCode]
		,[CountryCode]
		,[ContactName]
		,[ContactNumber]
		,[AltContName]
		,[AltContNumber]
		,[StreetAddress3]
		,[StreetAddress4]
		,[LocationID]
		,[LocationName]
		,[ContactEmail]
	FROM [Xcbl].[Address]
	WHERE [SummaryHeaderId] = @SummaryHeaderId

	SELECT [CustomAttributeId]
		,[SummaryHeaderId]
		,[CustomAttribute01]
		,[CustomAttribute02]
		,[CustomAttribute03]
		,[CustomAttribute04]
		,[CustomAttribute05]
		,[CustomAttribute06]
		,[CustomAttribute07]
		,[CustomAttribute08]
		,[CustomAttribute09]
		,[CustomAttribute10]
		,[CustomAttribute11]
		,[CustomAttribute12]
		,[CustomAttribute13]
		,[CustomAttribute14]
		,[CustomAttribute15]
		,[CustomAttribute16]
		,[CustomAttribute17]
		,[CustomAttribute18]
		,[CustomAttribute19]
		,[CustomAttribute20]
	FROM [Xcbl].[CustomAttribute]
	WHERE [SummaryHeaderId] = @SummaryHeaderId

	SELECT [UserDefinedFieldId]
		,[SummaryHeaderId]
		,[UDF01]
		,[UDF02]
		,[UDF03]
		,[UDF04]
		,[UDF05]
		,[UDF06]
		,[UDF07]
		,[UDF08]
		,[UDF09]
		,[UDF10]
	FROM [Xcbl].[UserDefinedField]
	WHERE [SummaryHeaderId] = @SummaryHeaderId

	SELECT [LineDetailId]
		,[SummaryHeaderId]
		,[LineNumber]
		,[ItemID]
		,[ItemDescription]
		,[ShipQuantity]
		,[Weight]
		,[WeightUnitOfMeasure]
		,[Volume]
		,[VolumeUnitOfMeasure]
		,[SecondaryLocation]
		,[MaterialType]
		,[ShipUnitOfMeasure]
		,[CustomerStockNumber]
		,[StatusCode]
		,[EDILINEID]
		,[MaterialTypeDescription]
		,[LineNumberReference]
	FROM [Xcbl].[LineDetail]
	WHERE [SummaryHeaderId] = @SummaryHeaderId
END
GO
