DROP PROCEDURE [Xcbl].[InsertXcblData]

ALTER TABLE [Xcbl].[SummaryHeader]
ALTER COLUMN SPECIALNOTES VARCHAR(MAX);

/****** Object:  UserDefinedTableType [Xcbl].[UttSummaryHeader]    Script Date: 2020-05-05 16:59:03 ******/
CREATE TYPE [Xcbl].[UttSummaryHeader] AS TABLE(
	[TradingPartner] [varchar](20) NULL,
	[GroupControlNo] [bigint] NULL,
	[BOLNo] [varchar](30) NULL,
	[MasterBOLNo] [varchar](30) NULL,
	[MethodOfPayment] [varchar](10) NULL,
	[SetPurpose] [varchar](10) NULL,
	[CustomerReferenceNo] [varchar](30) NULL,
	[ShipDescription] [varchar](30) NULL,
	[OrderType] [varchar](30) NULL,
	[PurchaseOrderNo] [varchar](30) NULL,
	[ShipDate] [datetime2](7) NULL,
	[ArrivalDate3PL] [datetime2](7) NULL,
	[ServiceMode] [nvarchar](30) NULL,
	[ProductType] [nvarchar](30) NULL,
	[ReasonCodeCancellation] [varchar](30) NULL,
	[ManifestNo] [varchar](30) NULL,
	[TotalWeight] [decimal](18, 2) NULL,
	[TotalCubicFeet] [decimal](18, 2) NULL,
	[TotalPieces] [bigint] NULL,
	[DeliveryCommitmentType] [varchar](30) NULL,
	[ScheduledPickupDate] [datetime2](7) NULL,
	[ScheduledDeliveryDate] [datetime2](7) NULL,
	[SpecialNotes] [varchar](max) NULL,
	[OrderedDate] [datetime2](7) NULL,
	[TextData] [varchar](max) NULL,
	[LocationId] [varchar](30) NULL,
	[LocationNumber] [varchar](30) NULL,
	[Latitude] [varchar](30) NULL,
	[Longitude] [varchar](30) NULL,
	[isxcblAcceptanceRequired] [bit] NOT NULL,
	[isxcblProcessed] [bit] NOT NULL,
	[isxcblRejected] [bit] NOT NULL,
	[ProcessingDate] [datetime2](7) NULL,
	[Action] [varchar](150) NULL,
	[TrailerNumber] [varchar](150) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [varchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [varchar](50) NULL
)


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
