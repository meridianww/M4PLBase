SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/14/2018              
-- Description:               Ins a Job            
-- Execution:                 EXEC [dbo].[InsJob]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:          
-- =============================================              
ALTER PROCEDURE [dbo].[InsJob] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@jobMITJobId BIGINT = NULL
	,@programId BIGINT = NULL
	,@jobSiteCode NVARCHAR(30) = NULL
	,@jobConsigneeCode NVARCHAR(30) = NULL
	,@jobCustomerSalesOrder NVARCHAR(30) = NULL
	,@jobBOL NVARCHAR(30) = NULL
	,@jobBOLMaster NVARCHAR(30) = NULL
	,@jobBOLChild NVARCHAR(30) = NULL
	,@jobCustomerPurchaseOrder NVARCHAR(30) = NULL
	,@jobCarrierContract NVARCHAR(30) = NULL
	,@jobManifestNo VARCHAR(30) = NULL
	,@jobGatewayStatus NVARCHAR(50) = NULL
	,@statusId INT = NULL
	,@jobStatusedDate DATETIME2(7) = NULL
	,@jobCompleted BIT = NULL
	,@jobType NVARCHAR(20) = NULL
	,@shipmentType NVARCHAR(20) = NULL
	,@jobDeliveryAnalystContactID BIGINT = NULL
	,@jobDeliveryResponsibleContactId BIGINT = NULL
	,@jobDeliverySitePOC NVARCHAR(75) = NULL
	,@jobDeliverySitePOCPhone NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail NVARCHAR(50) = NULL
	,@jobDeliverySiteName NVARCHAR(50) = NULL
	,@jobDeliveryStreetAddress NVARCHAR(100) = NULL
	,@jobDeliveryStreetAddress2 NVARCHAR(100) = NULL
	,@jobDeliveryCity NVARCHAR(50) = NULL
	,@jobDeliveryState NVARCHAR(50) = NULL
	,@jobDeliveryPostalCode NVARCHAR(50) = NULL
	,@jobDeliveryCountry NVARCHAR(50) = NULL
	,@jobDeliveryTimeZone NVARCHAR(15) = NULL
	,@jobDeliveryDateTimePlanned DATETIME2(7) = NULL
	,@jobDeliveryDateTimeActual DATETIME2(7) = NULL
	,@jobDeliveryDateTimeBaseline DATETIME2(7) = NULL
	,@jobDeliveryRecipientPhone NVARCHAR(50) = NULL
	,@jobDeliveryRecipientEmail NVARCHAR(50) = NULL
	,@jobLatitude NVARCHAR(50) = NULL
	,@jobLongitude NVARCHAR(50) = NULL
	,@jobOriginResponsibleContactId BIGINT = NULL
	,@jobOriginSitePOC NVARCHAR(75) = NULL
	,@jobOriginSitePOCPhone NVARCHAR(50) = NULL
	,@jobOriginSitePOCEmail NVARCHAR(50) = NULL
	,@jobOriginSiteName NVARCHAR(50) = NULL
	,@jobOriginStreetAddress NVARCHAR(100) = NULL
	,@jobOriginStreetAddress2 NVARCHAR(100) = NULL
	,@jobOriginCity NVARCHAR(50) = NULL
	,@jobOriginState NVARCHAR(50) = NULL
	,@jobOriginPostalCode NVARCHAR(50) = NULL
	,@jobOriginCountry NVARCHAR(50) = NULL
	,@jobOriginTimeZone NVARCHAR(15) = NULL
	,@jobOriginDateTimePlanned DATETIME2(7) = NULL
	,@jobOriginDateTimeActual DATETIME2(7) = NULL
	,@jobOriginDateTimeBaseline DATETIME2(7) = NULL
	,@jobProcessingFlags NVARCHAR(20) = NULL
	,@jobDeliverySitePOC2 NVARCHAR(75) = NULL
	,@jobDeliverySitePOCPhone2 NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail2 NVARCHAR(50) = NULL
	,@jobOriginSitePOC2 NVARCHAR(75) = NULL
	,@jobOriginSitePOCPhone2 NVARCHAR(50) = NULL
	,@jobOriginSitePOCEmail2 NVARCHAR(50) = NULL
	,@jobSellerCode NVARCHAR(20) = NULL
	,@jobSellerSitePOC NVARCHAR(75) = NULL
	,@jobSellerSitePOCPhone NVARCHAR(50) = NULL
	,@jobSellerSitePOCEmail NVARCHAR(50) = NULL
	,@jobSellerSitePOC2 NVARCHAR(75) = NULL
	,@jobSellerSitePOCPhone2 NVARCHAR(50) = NULL
	,@jobSellerSitePOCEmail2 NVARCHAR(50) = NULL
	,@jobSellerSiteName NVARCHAR(50) = NULL
	,@jobSellerStreetAddress NVARCHAR(100) = NULL
	,@jobSellerStreetAddress2 NVARCHAR(100) = NULL
	,@jobSellerCity NVARCHAR(50) = NULL
	,@jobSellerState NVARCHAR(50) = NULL
	,@jobSellerPostalCode NVARCHAR(50) = NULL
	,@jobSellerCountry NVARCHAR(50) = NULL
	,@jobUser01 NVARCHAR(20) = NULL
	,@jobUser02 NVARCHAR(20) = NULL
	,@jobUser03 NVARCHAR(20) = NULL
	,@jobUser04 NVARCHAR(20) = NULL
	,@jobUser05 NVARCHAR(20) = NULL
	,@jobStatusFlags NVARCHAR(20) = NULL
	,@jobScannerFlags NVARCHAR(20) = NULL
	,@plantIDCode NVARCHAR(30) = NULL
	,@carrierID NVARCHAR(30) = NULL
	,@jobDriverId BIGINT = NULL
	,@windowDelStartTime DATETIME2(7) = NULL
	,@windowDelEndTime DATETIME2(7) = NULL
	,@windowPckStartTime DATETIME2(7) = NULL
	,@windowPckEndTime DATETIME2(7) = NULL
	,@jobRouteId NVARCHAR(20)
	,@jobStop NVARCHAR(20) = NULL
	,@jobSignText NVARCHAR(75) = NULL
	,@jobSignLatitude NVARCHAR(50) = NULL
	,@jobSignLongitude NVARCHAR(50) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@jobQtyOrdered INT
	,@jobQtyActual INT
	,@jobQtyUnitTypeId INT
	,@jobPartsOrdered INT
	,@jobPartsActual INT
	,@JobTotalCubes DECIMAL(18, 2)
	,@jobServiceMode NVARCHAR(30)
	,@jobChannel NVARCHAR(30)
	,@jobProductType NVARCHAR(30)
	,@JobOrderedDate DATETIME2(7)
	,@JobShipmentDate DATETIME2(7)
	,@JobInvoicedDate DATETIME2(7)
	,@JobShipFromSiteName NVARCHAR(50)
	,@JobShipFromStreetAddress NVARCHAR(100)
	,@JobShipFromStreetAddress2 NVARCHAR(100)
	,@JobShipFromCity NVARCHAR(50)
	,@JobShipFromState NVARCHAR(50)
	,@JobShipFromPostalCode NVARCHAR(50)
	,@JobShipFromCountry NVARCHAR(50)
	,@JobShipFromSitePOC NVARCHAR(75)
	,@JobShipFromSitePOCPhone NVARCHAR(50)
	,@JobShipFromSitePOCEmail NVARCHAR(50)
	,@JobShipFromSitePOC2 NVARCHAR(75)
	,@JobShipFromSitePOCPhone2 NVARCHAR(50)
	,@JobShipFromSitePOCEmail2 NVARCHAR(50)
	,@jobElectronicInvoice BIT
	,@JobOriginStreetAddress3 NVARCHAR(100)
	,@JobOriginStreetAddress4 NVARCHAR(100)
	,@JobDeliveryStreetAddress3 NVARCHAR(100)
	,@JobDeliveryStreetAddress4 NVARCHAR(100)
	,@JobSellerStreetAddress3 NVARCHAR(100)
	,@JobSellerStreetAddress4 NVARCHAR(100)
	,@JobShipFromStreetAddress3 NVARCHAR(100)
	,@JobShipFromStreetAddress4 NVARCHAR(100)
	,@JobCubesUnitTypeId INT
	,@JobTotalWeight DECIMAL(18, 2)
	,@JobWeightUnitTypeId INT
	,@JobPreferredMethod INT
	,@JobMileage DECIMAL(18, 2)
	,@IsRelatedAttributeUpdate BIT = 1
	,@JobServiceOrder INT = 0
	,@JobServiceActual INT = 0
	,@IsJobVocSurvey BIT = 0
	,@ProFlags12 [nvarchar](1) = NULL
	,@isDayLightSavingEnable BIT = 0
	,@isManualUpdate BIT = 1
	,@JobDriverAlert NVARCHAR(Max)
	,@IsCancelled BIT = 0
	,@JobDeliveryCommentText VARCHAR(MAX)=NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT
		,@VendDCLocationId BIGINT
		,@ProFlags02 NVARCHAR(1) = NULL
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@OriginUTCValue INT
		,@IsOriginDayLightSaving BIT
	--Adding this to handle job gatweay item number issue
	DECLARE @updatedItemNumber INT;

	IF (
			ISNULL(@JobDeliveryPostalCode, '') <> ''
			AND LEN(@JobDeliveryPostalCode) > 4
			)
	BEGIN
		DECLARE @UpdatedJobDeliveryPostalCode VARCHAR(20)

		IF (dbo.IsCandaPostalCode(@JobDeliveryPostalCode) = 0)
		BEGIN
			SET @UpdatedJobDeliveryPostalCode = @JobDeliveryPostalCode
		END
		ELSE
		BEGIN
			SELECT TOP 1 @UpdatedJobDeliveryPostalCode = Item
			FROM dbo.[fnSplitString](@JobDeliveryPostalCode, '-')
		END

		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
			,@JobDeliveryTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @UpdatedJobDeliveryPostalCode
	END

	IF (
			ISNULL(@JobOriginPostalCode, '') <> ''
			AND LEN(@JobOriginPostalCode) > 4
			)
	BEGIN
		DECLARE @UpdatedJobOriginPostalCode VARCHAR(20)

		IF (dbo.IsCandaPostalCode(@JobOriginPostalCode) = 0)
		BEGIN
			SET @UpdatedJobOriginPostalCode = @JobOriginPostalCode
		END
		ELSE
		BEGIN
			SELECT TOP 1 @UpdatedJobOriginPostalCode = Item
			FROM dbo.[fnSplitString](@JobOriginPostalCode, '-')
		END

		SELECT TOP 1 @OriginUTCValue = UTC
			,@IsOriginDayLightSaving = IsDayLightSaving
			,@JobOriginTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @UpdatedJobOriginPostalCode
	END

	IF (ISNULL(@DeliveryUTCValue, 0) = 0)
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END

	IF (ISNULL(@OriginUTCValue, 0) = 0)
	BEGIN
		SELECT TOP 1 @OriginUTCValue = UTC
			,@IsOriginDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END

	SELECT @DeliveryUTCValue = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @DeliveryUTCValue + 1
			ELSE @DeliveryUTCValue
			END

	SELECT @OriginUTCValue = CASE 
			WHEN @IsOriginDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @OriginUTCValue + 1
			ELSE @OriginUTCValue
			END

	IF (ISNULL(@isManualUpdate, 0) = 1)
	BEGIN
		SELECT @JobDeliveryDateTimePlanned = CASE 
				WHEN ISNULL(@JobDeliveryDateTimePlanned, '') <> ''
					THEN DATEADD(HOUR, @DeliveryUTCValue, @JobDeliveryDateTimePlanned)
				ELSE @JobDeliveryDateTimePlanned
				END
			,@JobDeliveryDateTimeActual = CASE 
				WHEN ISNULL(@JobDeliveryDateTimeActual, '') <> ''
					THEN DATEADD(HOUR, @DeliveryUTCValue, @JobDeliveryDateTimeActual)
				ELSE @JobDeliveryDateTimeActual
				END
			,@JobDeliveryDateTimeBaseline = CASE 
				WHEN ISNULL(@JobDeliveryDateTimeBaseline, '') <> ''
					THEN DATEADD(HOUR, @DeliveryUTCValue, @JobDeliveryDateTimeBaseline)
				ELSE @JobDeliveryDateTimeBaseline
				END
			,@JobOriginDateTimePlanned = CASE 
				WHEN ISNULL(@JobOriginDateTimePlanned, '') <> ''
					THEN DATEADD(HOUR, @OriginUTCValue, @JobOriginDateTimePlanned)
				ELSE @JobOriginDateTimePlanned
				END
			,@JobOriginDateTimeActual = CASE 
				WHEN ISNULL(@JobOriginDateTimeActual, '') <> ''
					THEN DATEADD(HOUR, @OriginUTCValue, @JobOriginDateTimeActual)
				ELSE @JobOriginDateTimeActual
				END
			,@JobOriginDateTimeBaseline = CASE 
				WHEN ISNULL(@JobOriginDateTimeBaseline, '') <> ''
					THEN DATEADD(HOUR, @OriginUTCValue, @JobOriginDateTimeBaseline)
				ELSE @JobOriginDateTimeBaseline
				END
	END

	SELECT @VendDCLocationId = ISNULL(VendDCLocationId, 0)
	FROM [PRGRM051VendorLocations]
	WHERE PvlLocationCode = @jobSiteCode

	IF NOT EXISTS (
			SELECT 1
			FROM PRGRM051VendorLocations
			WHERE PvlLocationCode = @jobSiteCode
				AND PvlProgramID = @programId
				AND StatusId IN (1, 2)
			)
	BEGIN
		SET @ProFlags02 = 'V'
	END

	INSERT INTO [dbo].[JOBDL000Master] (
		[JobMITJobID]
		,[ProgramID]
		,[JobSiteCode]
		,[JobConsigneeCode]
		,[JobCustomerSalesOrder]
		,[JobBOL]
		,[JobBOLMaster]
		,[JobBOLChild]
		,[JobCustomerPurchaseOrder]
		,[JobCarrierContract]
		,[JobManifestNo]
		,[JobGatewayStatus]
		,[StatusId]
		,[JobStatusedDate]
		,[JobCompleted]
		,[JobType]
		,[ShipmentType]
		,[JobDeliveryAnalystContactID]
		,[JobDeliveryResponsibleContactID]
		,[JobDeliverySitePOC]
		,[JobDeliverySitePOCPhone]
		,[JobDeliverySitePOCEmail]
		,[JobDeliverySiteName]
		,[JobDeliveryStreetAddress]
		,[JobDeliveryStreetAddress2]
		,[JobDeliveryCity]
		,[JobDeliveryState]
		,[JobDeliveryPostalCode]
		,[JobDeliveryCountry]
		,[JobDeliveryTimeZone]
		--,[JobDeliveryDateTimePlanned]
		--,[JobDeliveryDateTimeActual]
		,[JobDeliveryDateTimeBaseline]
		,[JobDeliveryRecipientPhone]
		,[JobDeliveryRecipientEmail]
		,[JobLatitude]
		,[JobLongitude]
		,[JobOriginResponsibleContactID]
		,[JobOriginSitePOC]
		,[JobOriginSitePOCPhone]
		,[JobOriginSitePOCEmail]
		,[JobOriginSiteName]
		,[JobOriginStreetAddress]
		,[JobOriginStreetAddress2]
		,[JobOriginCity]
		,[JobOriginState]
		,[JobOriginPostalCode]
		,[JobOriginCountry]
		,[JobOriginTimeZone]
		,[JobOriginDateTimePlanned]
		,[JobOriginDateTimeActual]
		,[JobOriginDateTimeBaseline]
		,[JobProcessingFlags]
		,[JobDeliverySitePOC2]
		,[JobDeliverySitePOCPhone2]
		,[JobDeliverySitePOCEmail2]
		,[JobOriginSitePOC2]
		,[JobOriginSitePOCPhone2]
		,[JobOriginSitePOCEmail2]
		,[JobSellerCode]
		,[JobSellerSitePOC]
		,[JobSellerSitePOCPhone]
		,[JobSellerSitePOCEmail]
		,[JobSellerSitePOC2]
		,[JobSellerSitePOCPhone2]
		,[JobSellerSitePOCEmail2]
		,[JobSellerSiteName]
		,[JobSellerStreetAddress]
		,[JobSellerStreetAddress2]
		,[JobSellerCity]
		,[JobSellerState]
		,[JobSellerPostalCode]
		,[JobSellerCountry]
		,[JobUser01]
		,[JobUser02]
		,[JobUser03]
		,[JobUser04]
		,[JobUser05]
		,[JobStatusFlags]
		,[JobScannerFlags]
		,[PlantIDCode]
		,[CarrierID]
		,[JobDriverId]
		,[WindowDelStartTime]
		,[WindowDelEndTime]
		,[WindowPckStartTime]
		,[WindowPckEndTime]
		,[JobRouteId]
		,[JobStop]
		,[JobSignText]
		,[JobSignLatitude]
		,[JobSignLongitude]
		,[JobQtyOrdered]
		,[JobQtyActual]
		,[JobQtyUnitTypeId]
		,[JobPartsOrdered]
		,[JobPartsActual]
		,[JobTotalCubes]
		,[JobServiceMode]
		,[JobChannel]
		,[JobProductType]
		,[EnteredBy]
		,[DateEntered]
		,[JobOrderedDate]
		,[JobShipmentDate]
		,[JobInvoicedDate]
		,JobShipFromSiteName
		,JobShipFromStreetAddress
		,JobShipFromStreetAddress2
		,JobShipFromCity
		,JobShipFromState
		,JobShipFromPostalCode
		,JobShipFromCountry
		,JobShipFromSitePOC
		,JobShipFromSitePOCPhone
		,JobShipFromSitePOCEmail
		,JobShipFromSitePOC2
		,JobShipFromSitePOCPhone2
		,JobShipFromSitePOCEmail2
		,VendDCLocationId
		,JobElectronicInvoice
		,JobOriginStreetAddress3
		,JobOriginStreetAddress4
		,JobDeliveryStreetAddress3
		,JobDeliveryStreetAddress4
		,JobSellerStreetAddress3
		,JobSellerStreetAddress4
		,JobShipFromStreetAddress3
		,JobShipFromStreetAddress4
		,JobCubesUnitTypeId
		,JobTotalWeight
		,JobWeightUnitTypeId
		,JobPreferredMethod
		,JobMileage
		,ProFlags02
		,JobServiceOrder
		,JobServiceActual
		,IsJobVocSurvey
		,ProFlags12
		,JobDriverAlert
		,JobIsSchedule
		,IsCancelled
		,JobDeliveryCommentText
		)
	VALUES (
		@jobMITJobId
		,@programId
		,@jobSiteCode
		,@jobConsigneeCode
		,@jobCustomerSalesOrder
		,@jobBOL
		,@jobBOLMaster
		,@jobBOLChild
		,@jobCustomerPurchaseOrder
		,@jobCarrierContract
		,@jobManifestNo
		,@jobgatewayStatus
		,@statusId
		,@jobStatusedDate
		,@jobCompleted
		,@jobType
		,@shipmentType
		,@jobDeliveryAnalystContactID
		,@jobDeliveryResponsibleContactId
		,@jobDeliverySitePOC
		,@jobDeliverySitePOCPhone
		,@jobDeliverySitePOCEmail
		,@jobDeliverySiteName
		,@jobDeliveryStreetAddress
		,@jobDeliveryStreetAddress2
		,@jobDeliveryCity
		,@jobDeliveryState
		,@jobDeliveryPostalCode
		,@jobDeliveryCountry
		,CASE 
			WHEN ISNULL(@jobDeliveryTimeZone, '') <> '' AND ISNULL(@jobDeliveryPostalCode, '') <> '' AND LEN(@jobDeliveryPostalCode) > 4
				THEN @jobDeliveryTimeZone
			ELSE 'Unknown'
			END
		--,@jobDeliveryDateTimePlanned
		--,@JobDeliveryDateTimeActual
		,@jobDeliveryDateTimeBaseline
		,@jobDeliveryRecipientPhone
		,@jobDeliveryRecipientEmail
		,@jobLatitude
		,@jobLongitude
		,@jobOriginResponsibleContactID
		,@jobOriginSitePOC
		,@jobOriginSitePOCPhone
		,@jobOriginSitePOCEmail
		,@jobOriginSiteName
		,@jobOriginStreetAddress
		,@jobOriginStreetAddress2
		,@jobOriginCity
		,@jobOriginState
		,@jobOriginPostalCode
		,@jobOriginCountry
		,CASE 
			WHEN ISNULL(@jobOriginTimeZone, '') <> '' AND ISNULL(@jobOriginPostalCode, '') <> '' AND LEN(@jobOriginPostalCode) > 4
				THEN @jobOriginTimeZone
			ELSE 'Unknown'
			END
		,@jobOriginDateTimePlanned
		,NULL
		,@jobOriginDateTimeBaseline
		,@jobProcessingFlags
		,@jobDeliverySitePOC2
		,@jobDeliverySitePOCPhone2
		,@jobDeliverySitePOCEmail2
		,@jobOriginSitePOC2
		,@jobOriginSitePOCPhone2
		,@jobOriginSitePOCEmail2
		,@jobSellerCode
		,@jobSellerSitePOC
		,@jobSellerSitePOCPhone
		,@jobSellerSitePOCEmail
		,@jobSellerSitePOC2
		,@jobSellerSitePOCPhone2
		,@jobSellerSitePOCEmail2
		,@jobSellerSiteName
		,@jobSellerStreetAddress
		,@jobSellerStreetAddress2
		,@jobSellerCity
		,@jobSellerState
		,@jobSellerPostalCode
		,@jobSellerCountry
		,@jobUser01
		,@jobUser02
		,@jobUser03
		,@jobUser04
		,@jobUser05
		,@jobStatusFlags
		,@jobScannerFlags
		,@plantIDCode
		,@carrierID
		,@jobDriverId
		,@windowDelStartTime
		,@windowDelEndTime
		,@windowPckStartTime
		,@windowPckEndTime
		,@jobRouteId
		,@jobStop
		,@jobSignText
		,@jobSignLatitude
		,@jobSignLongitude
		,@jobQtyOrdered
		,@jobQtyActual
		,@jobQtyUnitTypeId
		,@jobPartsOrdered
		,@jobPartsActual
		,@JobTotalCubes
		,@jobServiceMode
		,@jobChannel
		,@jobProductType
		,@enteredBy
		,@dateEntered
		,@JobOrderedDate
		,@JobShipmentDate
		,@JobInvoicedDate
		,@JobShipFromSiteName
		,@JobShipFromStreetAddress
		,@JobShipFromStreetAddress2
		,@JobShipFromCity
		,@JobShipFromState
		,@JobShipFromPostalCode
		,@JobShipFromCountry
		,@JobShipFromSitePOC
		,@JobShipFromSitePOCPhone
		,@JobShipFromSitePOCEmail
		,@JobShipFromSitePOC2
		,@JobShipFromSitePOCPhone2
		,@JobShipFromSitePOCEmail2
		,ISNULL(@VendDCLocationId, 0)
		,@jobElectronicInvoice
		,@JobOriginStreetAddress3
		,@JobOriginStreetAddress4
		,@JobDeliveryStreetAddress3
		,@JobDeliveryStreetAddress4
		,@JobSellerStreetAddress3
		,@JobSellerStreetAddress4
		,@JobShipFromStreetAddress3
		,@JobShipFromStreetAddress4
		,@JobCubesUnitTypeId
		,@JobTotalWeight
		,@JobWeightUnitTypeId
		,@JobPreferredMethod
		,@JobMileage
		,@ProFlags02
		,@JobServiceOrder
		,@JobServiceActual
		,@IsJobVocSurvey
		,@ProFlags12
		,@JobDriverAlert
		,0
		,@IsCancelled
		,@JobDeliveryCommentText
		)

	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[CopyJobGatewayFromProgram] @currentId
		,@programId
		,@dateEntered
		,@enteredBy
		,@userId
		,@IsRelatedAttributeUpdate
		,@DeliveryUTCValue

	-- INSERT DEFAULT  PROGRAM ATTRIBUTES INTO Job ATTRIBUTES              
	INSERT INTO JOBDL030Attributes (
		JobID
		,AjbLineOrder
		,AjbAttributeCode
		,AjbAttributeTitle
		,AjbAttributeDescription
		,AjbAttributeComments
		,AjbAttributeQty
		,AjbUnitTypeId
		,AjbDefault
		,StatusId
		,DateEntered
		,EnteredBy
		)
	SELECT @currentId
		,ROW_NUMBER() OVER (
			ORDER BY prgm.AttItemNumber
			)
		,prgm.AttCode
		,prgm.AttTitle
		,prgm.AttDescription
		,prgm.AttComments
		,prgm.AttQuantity
		,prgm.UnitTypeId
		,prgm.AttDefault
		,prgm.StatusId
		,@dateEntered
		,@enteredBy
	FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	WHERE AttDefault = 1
		AND prgm.ProgramID = @programId
	ORDER BY prgm.AttItemNumber;

	-- INSERT INTO CustomerContacts vendorContact and programContacts WHERE JobGateway Analyst Is Selected In RefRole    
	DECLARE @orgId BIGINT
		,@custId BIGINT

	SELECT @orgId = pgm.PrgOrgID
		,@custId = pgm.PrgCustID
	FROM [JOBDL000Master] job
	INNER JOIN PRGRM000Master pgm ON job.ProgramID = pgm.Id
	WHERE job.Id = @currentId;

	EXEC [dbo].[GetJob] @userId
		,@roleId
		,0
		,@currentId
		,@programId;                
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
