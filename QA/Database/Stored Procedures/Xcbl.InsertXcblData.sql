SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 03/31/2020
-- Description:	Insert data into Xcbl Summary header tables.
-- =============================================
CREATE PROCEDURE [Xcbl].[InsertXcblData] @UttSummaryHeader xcbl.UttSummaryHeader READONLY
	,@UttAddress xcbl.UttAddress READONLY 
	,@UttCustomAttribute xcbl.UttCustomAttribute READONLY
	,@UttUserDefinedField xcbl.UttUserDefinedField READONLY
	,@UttLineDetail [Xcbl].[UttLineDetail] READONLY
	,@UttCopiedGatewayIds dbo.uttIDList READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SummaryHeaderId BIGINT

	INSERT INTO [Xcbl].[SummaryHeader] (
		[TradingPartner]
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
		,[Action]
	    ,[TrailerNumber]
		,[DateEntered]
		,[EnteredBy]
		,[DateChanged]
		,[ChangedBy]
		)
	SELECT [TradingPartner]
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
		,[Action]
	    ,[TrailerNumber]
		,[DateEntered]
		,[EnteredBy]
		,[DateChanged]
		,[ChangedBy]
	FROM @UttSummaryHeader

	SET @SummaryHeaderId = SCOPE_IDENTITY()

	INSERT INTO [Xcbl].[Address] (
		[SummaryHeaderId]
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
		)
	SELECT @SummaryHeaderId
		,AddressTypeId
		,Name
		,NameID
		,Address1
		,Address2
		,City
		,[State]
		,PostalCode
		,CountryCode
		,ContactName
		,ContactNumber
		,AltContName
		,AltContNumber
		,StreetAddress3
		,StreetAddress4
		,LocationID
		,LocationName
		,ContactEmail
	FROM @UttAddress

	INSERT INTO [Xcbl].[CustomAttribute] (
		[SummaryHeaderId]
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
		)
	SELECT @SummaryHeaderId
		,CustomAttribute01
		,CustomAttribute02
		,CustomAttribute03
		,CustomAttribute04
		,CustomAttribute05
		,CustomAttribute06
		,CustomAttribute07
		,CustomAttribute08
		,CustomAttribute09
		,CustomAttribute10
		,CustomAttribute11
		,CustomAttribute12
		,CustomAttribute13
		,CustomAttribute14
		,CustomAttribute15
		,CustomAttribute16
		,CustomAttribute17
		,CustomAttribute18
		,CustomAttribute19
		,CustomAttribute20
	FROM @UttCustomAttribute

	INSERT INTO [Xcbl].[UserDefinedField] (
		[SummaryHeaderId]
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
		)
	SELECT @SummaryHeaderId
		,UDF01
		,UDF02
		,UDF03
		,UDF04
		,UDF05
		,UDF06
		,UDF07
		,UDF08
		,UDF09
		,UDF10
	FROM @UttUserDefinedField

	INSERT INTO [Xcbl].[LineDetail] (
		[SummaryHeaderId]
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
		)
	SELECT @SummaryHeaderId
		,LineNumber
		,ItemID
		,ItemDescription
		,ShipQuantity
		,Weight
		,WeightUnitOfMeasure
		,Volume
		,VolumeUnitOfMeasure
		,SecondaryLocation
		,MaterialType
		,ShipUnitOfMeasure
		,CustomerStockNumber
		,StatusCode
		,EDILINEID
		,MaterialTypeDescription
		,LineNumberReference
	FROM @UttLineDetail


	UPDATE gateway
	SET xCBLHeaderId = @SummaryHeaderId
	FROM [dbo].[JOBDL020Gateways] gateway
	INNER JOIN @UttCopiedGatewayIds uttGateway ON gateway.Id = uttGateway.Id

	SELECT @SummaryHeaderId
END
GO
