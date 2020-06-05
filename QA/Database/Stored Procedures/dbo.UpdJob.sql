SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job     
-- Execution:                 EXEC [dbo].[UpdJob]    
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================       
CREATE PROCEDURE [dbo].[UpdJob] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
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
	,@jobRouteId INT = NULL
	,@jobStop NVARCHAR(20) = NULL
	,@jobSignText NVARCHAR(75) = NULL
	,@jobSignLatitude NVARCHAR(50) = NULL
	,@jobSignLongitude NVARCHAR(50) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	,@jobQtyOrdered INT = NULL
	,@jobQtyActual INT = NULL
	,@jobQtyUnitTypeId INT = NULL
	,@jobPartsOrdered INT = NULL
	,@jobPartsActual INT = NULL
	,@JobTotalCubes DECIMAL(18, 2) = NULL
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
	,@JobServiceOrder INT = 0
	,@JobServiceActual INT = 0
	,@IsRelatedAttributeUpdate BIT = 1
	,@IsJobVocSurvey BIT = 0
	,@ProFlags12 [nvarchar](1) = null
	,@IsSellerTabEdited BIT = NULL
	,@IsPODTabEdited BIT = NULL
	,@isDayLightSavingEnable BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;


	SET @IsSellerTabEdited = ISNULL(@IsSellerTabEdited,0)
	SET @IsPODTabEdited = ISNULL(@IsPODTabEdited,0)

	DECLARE @VendDCLocationId BIGINT
		,@OldjobSiteCode NVARCHAR(30)
		,@ProFlags02 NVARCHAR(1) = NULL
	    ,@OldOrderType NVARCHAR(20)
		,@OldShipmentType NVARCHAR(20)
		,@OldjobDeliveryTimeZone NVARCHAR(15)
		,@OldjobOriginTimeZone NVARCHAR(15)
		,@DeliveryUTCValue INT, 
		 @IsDeliveryDayLightSaving BIT,
		 @OriginUTCValue INT, 
		 @IsOriginDayLightSaving BIT
		,@OldDeliveryUTCValue INT, 
		 @OldIsDeliveryDayLightSaving BIT,
		 @OldOriginUTCValue INT, 
		 @OldIsOriginDayLightSaving BIT

	SELECT @OldOrderType = JobType
		,@OldShipmentType = ShipmentType
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @id

	SET @OldjobDeliveryTimeZone = @jobDeliveryTimeZone
	SET @OldjobOriginTimeZone = @jobOriginTimeZone

	SET @dateChanged = GETUTCDATE();

	IF (
			ISNULL(@JobDeliveryPostalCode, '') <> ''
			AND LEN(@JobDeliveryPostalCode) > 4
			)
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC, 
		@IsDeliveryDayLightSaving = IsDayLightSaving,
		@JobDeliveryTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @JobDeliveryPostalCode
	END

	IF (
			ISNULL(@JobOriginPostalCode, '') <> ''
			AND LEN(@JobOriginPostalCode) > 4
			)
	BEGIN
		SELECT TOP 1 @OriginUTCValue = UTC, 
		@IsOriginDayLightSaving = IsDayLightSaving, 
		@JobOriginTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @JobOriginPostalCode
	END

	IF(@IsRelatedAttributeUpdate = 1 AND ISNULL(@JobDeliveryTimeZone,'') <> ISNULL(@OldJobDeliveryTimeZone,''))
	BEGIN
	IF(ISNULL(@DeliveryUTCValue, 0) = 0)
	BEGIN
	Select TOP 1 @DeliveryUTCValue = UTC, @IsDeliveryDayLightSaving = IsDayLightSaving 
	From Location000Master 
	Where TimeZoneShortName='Pacific'
	END

	Select @DeliveryUTCValue = CASE WHEN @IsDeliveryDayLightSaving = 1 AND @isDayLightSavingEnable = 1 
	THEN @DeliveryUTCValue + 1 
	ELSE @DeliveryUTCValue END

	Select TOP 1 @OldDeliveryUTCValue = UTC, @OldIsDeliveryDayLightSaving = IsDayLightSaving 
	From Location000Master 
	Where TimeZoneShortName= @OldJobDeliveryTimeZone

	Select @OldDeliveryUTCValue = CASE WHEN @OldIsDeliveryDayLightSaving = 1 AND @isDayLightSavingEnable = 1 
	THEN @OldDeliveryUTCValue + 1 
	ELSE @OldDeliveryUTCValue END

	SELECT @JobDeliveryDateTimePlanned = CASE 
		WHEN ISNULL(@JobDeliveryDateTimePlanned, '') <> ''
			THEN DATEADD(HOUR, - @OldDeliveryUTCValue, @JobDeliveryDateTimePlanned)
		ELSE @JobDeliveryDateTimePlanned
		END
	,@JobDeliveryDateTimeActual = CASE 
		WHEN ISNULL(@JobDeliveryDateTimeActual, '') <> ''
			THEN DATEADD(HOUR, - @OldDeliveryUTCValue, @JobDeliveryDateTimeActual)
		ELSE @JobDeliveryDateTimeActual
		END
	,@JobDeliveryDateTimeBaseline = CASE 
		WHEN ISNULL(@JobDeliveryDateTimeBaseline, '') <> ''
			THEN DATEADD(HOUR, - @OldDeliveryUTCValue, @JobDeliveryDateTimeBaseline)
		ELSE @JobDeliveryDateTimeBaseline
		END

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
	END

	IF(@IsRelatedAttributeUpdate = 1 AND ISNULL(@JobOriginTimeZone,'') <> ISNULL(@OldJobOriginTimeZone,''))
	BEGIN
	IF(ISNULL(@OriginUTCValue, 0) = 0)
	BEGIN
	Select TOP 1 @OriginUTCValue = UTC, @IsOriginDayLightSaving = IsDayLightSaving 
	From Location000Master 
	Where TimeZoneShortName='Pacific'
	END

	Select @OriginUTCValue = CASE WHEN @IsOriginDayLightSaving = 1 AND @isDayLightSavingEnable = 1 
	THEN @OriginUTCValue + 1 
	ELSE @OriginUTCValue END

	Select TOP 1 @OldOriginUTCValue = UTC, @OldIsOriginDayLightSaving = IsDayLightSaving 
	From Location000Master 
	Where TimeZoneShortName= @OldJobOriginTimeZone

	Select @OldOriginUTCValue = CASE WHEN @OldIsOriginDayLightSaving = 1 AND @isDayLightSavingEnable = 1 
	THEN @OldOriginUTCValue + 1 
	ELSE @OldOriginUTCValue END

	SELECT @JobOriginDateTimePlanned = CASE 
		WHEN ISNULL(@JobOriginDateTimePlanned, '') <> ''
			THEN DATEADD(HOUR, - @OldOriginUTCValue, @JobOriginDateTimePlanned)
		ELSE @JobOriginDateTimePlanned
		END
	,@JobOriginDateTimeActual = CASE 
		WHEN ISNULL(@JobOriginDateTimeActual, '') <> ''
			THEN DATEADD(HOUR, - @OldOriginUTCValue, @JobOriginDateTimeActual)
		ELSE @JobOriginDateTimeActual
		END
	,@JobOriginDateTimeBaseline = CASE 
		WHEN ISNULL(@JobOriginDateTimeBaseline, '') <> ''
			THEN DATEADD(HOUR, - @OldOriginUTCValue, @JobOriginDateTimeBaseline)
		ELSE @JobOriginDateTimeBaseline
		END

		SELECT @JobOriginDateTimePlanned = CASE 
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

	UPDATE [dbo].[JOBDL000Master]
	SET [JobMITJobID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobMITJobID
			ELSE ISNULL(@jobMITJobID, JobMITJobID)
			END
		,[JobPreferredMethod] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobPreferredMethod
			ELSE ISNULL(@JobPreferredMethod, [JobPreferredMethod])
			END
		,[JobSiteCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobSiteCode
			ELSE ISNULL(@jobSiteCode, JobSiteCode)
			END
		,[JobConsigneeCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobConsigneeCode
			ELSE ISNULL(@jobConsigneeCode, JobConsigneeCode)
			END
		,[JobCustomerSalesOrder] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobCustomerSalesOrder
			ELSE ISNULL(@jobCustomerSalesOrder, JobCustomerSalesOrder)
			END
		,[JobBOL] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobBOL
			ELSE ISNULL(@jobBOL, JobBOL)
			END
		,[JobBOLMaster] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobBOLMaster
			ELSE ISNULL(@jobBOLMaster, JobBOLMaster)
			END
		,[JobBOLChild] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobBOLChild
			ELSE ISNULL(@jobBOLChild, JobBOLChild)
			END
		,[JobCustomerPurchaseOrder] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobCustomerPurchaseOrder
			ELSE ISNULL(@jobCustomerPurchaseOrder, JobCustomerPurchaseOrder)
			END
		,[JobCarrierContract] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobCarrierContract
			ELSE ISNULL(@jobCarrierContract, JobCarrierContract)
			END
		,[JobManifestNo] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobManifestNo
			ELSE ISNULL(@jobManifestNo, JobManifestNo)
			END
		,[JobGatewayStatus] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobGatewayStatus
			ELSE ISNULL(@jobGatewayStatus, JobGatewayStatus)
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			ELSE ISNULL(@statusId, StatusId)
			END
		,[JobStatusedDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobStatusedDate
			ELSE ISNULL(@jobStatusedDate, JobStatusedDate)
			END
		,[JobCompleted] = ISNULL(@jobCompleted, JobCompleted)
		,[JobElectronicInvoice] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobElectronicInvoice
			ELSE JobElectronicInvoice
			END
		,[JobType] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobType
			ELSE ISNULL(@jobType, JobType)
			END
		,[ShipmentType] = CASE 
			WHEN (@isFormView = 1)
				THEN @shipmentType
			ELSE ISNULL(@shipmentType, ShipmentType)
			END
		,[JobDeliveryAnalystContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryAnalystContactID
			ELSE ISNULL(@jobDeliveryAnalystContactID, JobDeliveryAnalystContactID)
			END
		,[JobDeliveryResponsibleContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryResponsibleContactID
			ELSE ISNULL(@jobDeliveryResponsibleContactID, JobDeliveryResponsibleContactID)
			END
		,[JobDeliverySitePOC] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOC
			ELSE ISNULL(@jobDeliverySitePOC, JobDeliverySitePOC)
			END
		,[JobDeliverySitePOCPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCPhone
			ELSE ISNULL(@jobDeliverySitePOCPhone, JobDeliverySitePOCPhone)
			END
		,[JobDeliverySitePOCEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCEmail
			ELSE ISNULL(@jobDeliverySitePOCEmail, JobDeliverySitePOCEmail)
			END
		,[JobDeliverySiteName] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySiteName
			ELSE ISNULL(@jobDeliverySiteName, JobDeliverySiteName)
			END
		,[JobDeliveryStreetAddress] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryStreetAddress
			ELSE ISNULL(@jobDeliveryStreetAddress, JobDeliveryStreetAddress)
			END
		,[JobDeliveryStreetAddress2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryStreetAddress2
			ELSE ISNULL(@jobDeliveryStreetAddress2, JobDeliveryStreetAddress2)
			END
		,[JobDeliveryCity] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryCity
			ELSE ISNULL(@jobDeliveryCity, JobDeliveryCity)
			END
		,[JobDeliveryState] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryState
			ELSE ISNULL(@jobDeliveryState, JobDeliveryState)
			END
		,[JobDeliveryPostalCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryPostalCode
			ELSE ISNULL(@jobDeliveryPostalCode, JobDeliveryPostalCode)
			END
		,[JobDeliveryCountry] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryCountry
			ELSE ISNULL(@jobDeliveryCountry, JobDeliveryCountry)
			END
		,[JobDeliveryTimeZone] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE WHEN ISNULL(@jobDeliveryTimeZone,'') <> '' THEN @jobDeliveryTimeZone ELSE 'Unknown' END
			ELSE ISNULL(@jobDeliveryTimeZone, JobDeliveryTimeZone)
			END
		,[JobDeliveryDateTimePlanned] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryDateTimePlanned
			ELSE ISNULL(@jobDeliveryDateTimePlanned, JobDeliveryDateTimePlanned)
			END
		,[JobDeliveryDateTimeActual] = ISNULL(@jobDeliveryDateTimeActual, JobDeliveryDateTimeActual)
		,[JobDeliveryDateTimeBaseline] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryDateTimeBaseline
			ELSE ISNULL(@jobDeliveryDateTimeBaseline, JobDeliveryDateTimeBaseline)
			END
		,[JobDeliveryRecipientPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryRecipientPhone
			ELSE ISNULL(@jobDeliveryRecipientPhone, JobDeliveryRecipientPhone)
			END
		,[JobDeliveryRecipientEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryRecipientEmail
			ELSE ISNULL(@jobDeliveryRecipientEmail, JobDeliveryRecipientEmail)
			END
		,[JobLatitude] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@jobLatitude, JobLatitude)
			ELSE ISNULL(@jobLatitude, JobLatitude)
			END
		,[JobLongitude] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@jobLongitude, JobLongitude)
			ELSE ISNULL(@jobLongitude, JobLongitude)
			END
		,[JobOriginResponsibleContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginResponsibleContactID
			ELSE ISNULL(@jobOriginResponsibleContactID, JobOriginResponsibleContactID)
			END
		,[JobOriginSitePOC] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOC
			ELSE ISNULL(@jobOriginSitePOC, JobOriginSitePOC)
			END
		,[JobOriginSitePOCPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCPhone
			ELSE ISNULL(@jobOriginSitePOCPhone, JobOriginSitePOCPhone)
			END
		,[JobOriginSitePOCEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCEmail
			ELSE ISNULL(@jobOriginSitePOCEmail, JobOriginSitePOCEmail)
			END
		,[JobOriginSiteName] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSiteName
			ELSE ISNULL(@jobOriginSiteName, JobOriginSiteName)
			END
		,[JobOriginStreetAddress] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginStreetAddress
			ELSE ISNULL(@jobOriginStreetAddress, JobOriginStreetAddress)
			END
		,[JobOriginStreetAddress2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginStreetAddress2
			ELSE ISNULL(@jobOriginStreetAddress2, JobOriginStreetAddress2)
			END
		,[JobOriginCity] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginCity
			ELSE ISNULL(@jobOriginCity, JobOriginCity)
			END
		,[JobOriginState] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginState
			ELSE ISNULL(@jobOriginState, JobOriginState)
			END
		,[JobOriginPostalCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginPostalCode
			ELSE ISNULL(@jobOriginPostalCode, JobOriginPostalCode)
			END
		,[JobOriginCountry] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginCountry
			ELSE ISNULL(@jobOriginCountry, JobOriginCountry)
			END
		,[JobOriginTimeZone] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE WHEN ISNULL(@jobOriginTimeZone,'') <> '' THEN @jobOriginTimeZone ELSE 'Unknown' END
			ELSE ISNULL(@jobOriginTimeZone, JobOriginTimeZone)
			END
		,[JobOriginDateTimePlanned] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginDateTimePlanned
			ELSE ISNULL(@jobOriginDateTimePlanned, JobOriginDateTimePlanned)
			END
		,[JobOriginDateTimeActual] = ISNULL(@jobOriginDateTimeActual, JobOriginDateTimeActual)
		,[JobOriginDateTimeBaseline] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginDateTimeBaseline
			ELSE ISNULL(@jobOriginDateTimeBaseline, JobOriginDateTimeBaseline)
			END
		,[JobProcessingFlags] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobProcessingFlags
			ELSE ISNULL(@jobProcessingFlags, JobProcessingFlags)
			END
		,[JobDeliverySitePOC2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOC2
			ELSE ISNULL(@jobDeliverySitePOC2, JobDeliverySitePOC2)
			END
		,[JobDeliverySitePOCPhone2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCPhone2
			ELSE ISNULL(@jobDeliverySitePOCPhone2, JobDeliverySitePOCPhone2)
			END
		,[JobDeliverySitePOCEmail2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCEmail2
			ELSE ISNULL(@jobDeliverySitePOCEmail2, JobDeliverySitePOCEmail2)
			END
		,[JobOriginSitePOC2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOC2
			ELSE ISNULL(@jobOriginSitePOC2, JobOriginSitePOC2)
			END
		,[JobOriginSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCPhone2
			ELSE ISNULL(@jobOriginSitePOCPhone2, JobOriginSitePOCPhone2)
			END
		,[JobOriginSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCEmail2
			ELSE ISNULL(@jobOriginSitePOCEmail2, JobOriginSitePOCEmail2)
			END
		,[JobSellerCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCode
			ELSE ISNULL(@jobSellerCode, JobSellerCode)
			END
		,[JobSellerSitePOC] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOC
			ELSE ISNULL(@jobSellerSitePOC, JobSellerSitePOC)
			END
		,[JobSellerSitePOCPhone] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCPhone
			ELSE ISNULL(@jobSellerSitePOCPhone, JobSellerSitePOCPhone)
			END
		,[JobSellerSitePOCEmail] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCEmail
			ELSE ISNULL(@jobSellerSitePOCEmail, JobSellerSitePOCEmail)
			END
		,[JobSellerSitePOC2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOC2
			ELSE ISNULL(@jobSellerSitePOC2, JobSellerSitePOC2)
			END
		,[JobSellerSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCPhone2
			ELSE ISNULL(@jobSellerSitePOCPhone2, JobSellerSitePOCPhone2)
			END
		,[JobSellerSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCEmail2
			ELSE ISNULL(@jobSellerSitePOCEmail2, JobSellerSitePOCEmail2)
			END
		,[JobSellerSiteName] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSiteName
			ELSE ISNULL(@jobSellerSiteName, JobSellerSiteName)
			END
		,[JobSellerStreetAddress] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerStreetAddress
			ELSE ISNULL(@jobSellerStreetAddress, JobSellerStreetAddress)
			END
		,[JobSellerStreetAddress2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerStreetAddress2
			ELSE ISNULL(@jobSellerStreetAddress2, JobSellerStreetAddress2)
			END
		,[JobSellerCity] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCity
			ELSE ISNULL(@jobSellerCity, JobSellerCity)
			END
		,[JobSellerState] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerState
			ELSE ISNULL(@jobSellerState, JobSellerState)
			END
		,[JobSellerPostalCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerPostalCode
			ELSE ISNULL(@jobSellerPostalCode, JobSellerPostalCode)
			END
		,[JobSellerCountry] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCountry
			ELSE ISNULL(@jobSellerCountry, JobSellerCountry)
			END
		,[JobUser01] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobUser01
			ELSE ISNULL(@jobUser01, JobUser01)
			END
		,[JobUser02] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobUser02
			ELSE ISNULL(@jobUser02, JobUser02)
			END
		,[JobUser03] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobUser03
			ELSE ISNULL(@jobUser03, JobUser03)
			END
		,[JobUser04] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobUser04
			ELSE ISNULL(@jobUser04, JobUser04)
			END
		,[JobUser05] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobUser05
			ELSE ISNULL(@jobUser05, JobUser05)
			END
		,[JobStatusFlags] = ISNULL(@jobStatusFlags, JobStatusFlags)
		,[JobScannerFlags] = ISNULL(@jobScannerFlags, JobScannerFlags)
		,[PlantIDCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @plantIDCode
			ELSE ISNULL(@plantIDCode, PlantIDCode)
			END
		,[CarrierID] = CASE 
			WHEN (@isFormView = 1)
				THEN @carrierID
			ELSE ISNULL(@carrierID, CarrierID)
			END
		,[JobDriverId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDriverId
			ELSE ISNULL(@jobDriverId, JobDriverId)
			END
		,[WindowDelStartTime] = CASE 
			WHEN (@isFormView = 1)
				THEN @windowDelStartTime
			ELSE ISNULL(@windowDelStartTime, WindowDelStartTime)
			END
		,[WindowDelEndTime] = CASE 
			WHEN (@isFormView = 1)
				THEN @windowDelEndTime
			ELSE ISNULL(@windowDelEndTime, WindowDelEndTime)
			END
		,[WindowPckStartTime] = CASE 
			WHEN (@isFormView = 1)
				THEN @windowPckStartTime
			ELSE ISNULL(@windowPckStartTime, WindowPckStartTime)
			END
		,[WindowPckEndTime] = CASE 
			WHEN (@isFormView = 1)
				THEN @windowPckEndTime
			ELSE ISNULL(@windowPckEndTime, WindowPckEndTime)
			END
		,[JobRouteId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobRouteId
			ELSE ISNULL(@jobRouteId, JobRouteId)
			END
		,[JobStop] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobStop
			ELSE ISNULL(@jobStop, JobStop)
			END
		,[JobSignText] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignText
			ELSE ISNULL(@jobSignText, JobSignText)
			END
		,[JobSignLatitude] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignLatitude
			ELSE ISNULL(@jobSignLatitude, JobSignLatitude)
			END
		,[JobSignLongitude] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignLongitude
			ELSE ISNULL(@jobSignLongitude, JobSIgnLongitude)
			END
		,[JobQtyOrdered] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobQtyOrdered
			ELSE ISNULL(@jobQtyOrdered, JobQtyOrdered)
			END
		,[JobTotalWeight] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobTotalWeight
			ELSE ISNULL(@JobTotalWeight, JobTotalWeight)
			END
		,[JobQtyActual] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@jobQtyActual, 0) > 0
							THEN @jobQtyActual
						ELSE NULL
						END
			ELSE CASE 
					WHEN ISNULL(@jobQtyActual, 0) > 0
						THEN @jobQtyActual
					ELSE jobQtyActual
					END
			END
		,[JobQtyUnitTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobQtyUnitTypeId
			ELSE ISNULL(@jobQtyUnitTypeId, JobQtyUnitTypeId)
			END
		,[JobWeightUnitTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobWeightUnitTypeId
			ELSE ISNULL(@JobWeightUnitTypeId, JobWeightUnitTypeId)
			END
		,[JobCubesUnitTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobCubesUnitTypeId
			ELSE ISNULL(@JobCubesUnitTypeId, JobCubesUnitTypeId)
			END
		,[JobPartsOrdered] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@jobPartsOrdered, 0) > 0
							THEN @jobPartsOrdered
						ELSE NULL
						END
			ELSE CASE 
					WHEN ISNULL(@jobPartsOrdered, 0) > 0
						THEN @jobPartsOrdered
					ELSE JobPartsOrdered
					END
			END
		,[JobPartsActual] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@jobPartsActual, 0) > 0
							THEN @jobPartsActual
						ELSE NULL
						END
			ELSE CASE 
					WHEN ISNULL(@jobPartsActual, 0) > 0
						THEN @jobPartsActual
					ELSE JobPartsActual
					END
			END
		,[JobTotalCubes] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobTotalCubes
			ELSE ISNULL(@JobTotalCubes, JobTotalCubes)
			END
		,[JobServiceMode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobServiceMode
			ELSE ISNULL(@jobServiceMode, JobServiceMode)
			END
		,[JobChannel] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobChannel
			ELSE ISNULL(@jobChannel, JobChannel)
			END
		,[JobProductType] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobProductType
			ELSE ISNULL(@jobProductType, JobProductType)
			END
		,[JobOrderedDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobOrderedDate
			ELSE ISNULL(@JobOrderedDate, JobOrderedDate)
			END
		,[JobShipmentDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobShipmentDate
			ELSE ISNULL(@JobShipmentDate, JobShipmentDate)
			END
		,[JobInvoicedDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobInvoicedDate
			ELSE ISNULL(@JobInvoicedDate, JobInvoicedDate)
			END
		,JobShipFromSiteName = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSiteName
			ELSE ISNULL(@JobShipFromSiteName, JobShipFromSiteName)
			END
		,JobShipFromStreetAddress = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress
			ELSE ISNULL(@JobShipFromStreetAddress, JobShipFromStreetAddress)
			END
		,JobShipFromStreetAddress2 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress2
			WHEN (
					(@isFormView = 0)
					AND (@JobShipFromStreetAddress2 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@JobShipFromStreetAddress2, JobShipFromStreetAddress2)
			END
		,[JobShipFromCity] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromCity
			ELSE ISNULL(@JobShipFromCity, JobShipFromCity)
			END
		,[JobShipFromState] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromState
			ELSE ISNULL(@JobShipFromState, JobShipFromState)
			END
		,[JobShipFromPostalCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromPostalCode
			ELSE ISNULL(@JobShipFromPostalCode, JobShipFromPostalCode)
			END
		,[JobShipFromCountry] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromCountry
			ELSE ISNULL(@JobShipFromCountry, JobShipFromCountry)
			END
		,[JobShipFromSitePOC] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOC
			ELSE ISNULL(@JobShipFromSitePOC, JobShipFromSitePOC)
			END
		,[JobShipFromSitePOCPhone] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCPhone
			ELSE ISNULL(@JobShipFromSitePOCPhone, JobShipFromSitePOCPhone)
			END
		,[JobShipFromSitePOCEmail] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCEmail
			ELSE ISNULL(@JobShipFromSitePOCEmail, JobShipFromSitePOCEmail)
			END
		,[JobShipFromSitePOC2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOC2
			ELSE ISNULL(@JobShipFromSitePOC2, JobShipFromSitePOC2)
			END
		,[JobShipFromSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCPhone2
			ELSE ISNULL(@JobShipFromSitePOCPhone2, JobShipFromSitePOCPhone2)
			END
		,[JobShipFromSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCEmail2
			ELSE ISNULL(@JobShipFromSitePOCEmail2, JobShipFromSitePOCEmail2)
			END
		,JobOriginStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobOriginStreetAddress3
			ELSE ISNULL(@JobOriginStreetAddress3, JobOriginStreetAddress3)
			END
		,JobOriginStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobOriginStreetAddress4
			ELSE ISNULL(@JobOriginStreetAddress4, JobOriginStreetAddress4)
			END
		,JobDeliveryStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobDeliveryStreetAddress3
			ELSE ISNULL(@JobDeliveryStreetAddress3, JobDeliveryStreetAddress3)
			END
		,JobDeliveryStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobDeliveryStreetAddress4
			ELSE ISNULL(@JobDeliveryStreetAddress4, JobDeliveryStreetAddress4)
			END
		,JobSellerStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobSellerStreetAddress3
			ELSE ISNULL(@JobSellerStreetAddress3, JobSellerStreetAddress3)
			END
		,JobSellerStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobSellerStreetAddress4
			ELSE ISNULL(@JobSellerStreetAddress4, JobSellerStreetAddress4)
			END
		,JobShipFromStreetAddress3 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress3
			ELSE ISNULL(@JobShipFromStreetAddress3, JobShipFromStreetAddress3)
			END
		,JobShipFromStreetAddress4 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress4
			ELSE ISNULL(@JobShipFromStreetAddress4, JobShipFromStreetAddress4)
			END
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
		,[VendDCLocationId] = CASE 
			WHEN ISNULL(@OldjobSiteCode, '') <> ISNULL(@jobSiteCode, '')
				THEN ISNULL(@VendDCLocationId, 0)
			ELSE VendDCLocationId
			END
		,[JobMileage] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@JobMileage, JobMileage)
			WHEN (
					(@isFormView = 0)
					AND (@JobMileage = - 100)
					)
				THEN 0
			ELSE ISNULL(@JobMileage, JobMileage)
			END
		,ProFlags02 = @ProFlags02
		,[JobServiceOrder] = @JobServiceOrder
		,[JobServiceActual] = @JobServiceActual
		,[IsJobVocSurvey] =  @IsJobVocSurvey
		,[ProFlags12] = ISNULL(@ProFlags12, ProFlags12)
	WHERE [Id] = @id;

	IF (
			@programId <> (
				SELECT TOP 1 ProgramID
				FROM JOBDL000Master
				WHERE ID = @id
					AND StatusId IN (
						1
						,2
						)
				)
			)
	BEGIN
	    IF NOT EXISTS(SELECT 1 FROM PRGRM051VendorLocations WHERE PvlProgramID = @programId AND PvlLocationCode = @jobSiteCode)
		BEGIN
		  SET @jobSiteCode = NULL;
		END
		EXEC [dbo].[UpdateGatewayPriceAndCostCode] @id
			,@programId
			,@userId
			,NULL
			,@changedBy
			,@jobSiteCode
	END

		IF NOT EXISTS (
				SELECT 1
				FROM PRGRM051VendorLocations PVL
				INNER JOIN dbo.JOBDL000Master Job ON Job.ProgramID = PVL.PvlProgramID
				WHERE PVL.PvlLocationCode = @jobSiteCode
					AND Job.Id = @id
					AND PVL.StatusId IN (
						1
						,2
						)
				)
		BEGIN
			SET @ProFlags02 = 'V'
		END

		IF (@jobOriginDateTimePlanned IS NOT NULL)
		BEGIN
			UPDATE [dbo].[JOBDL020Gateways]
			SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration, @jobOriginDateTimePlanned)
			WHERE JobID = @id
				AND GwyDateRefTypeId = (
					SELECT TOP 1 id
					FROM SYSTM000Ref_Options
					WHERE SysOptionName = 'Pickup Date'
					)
		END

		IF (@jobDeliveryDateTimePlanned IS NOT NULL)
		BEGIN
			UPDATE [dbo].[JOBDL020Gateways]
			SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration, @jobDeliveryDateTimePlanned)
			WHERE JobID = @id
				AND GwyDateRefTypeId = (
					SELECT TOP 1 id
					FROM SYSTM000Ref_Options
					WHERE SysOptionName = 'Delivery Date'
					)
		END

		IF (
				ISNULL(@jobCompleted, 0) = 0
				AND (
					(@jobType <> @OldOrderType)
					OR (@OldShipmentType <> @ShipmentType)
					)
				)
		BEGIN
			UPDATE JOBDL020Gateways SET StatusId = NULL WHERE JobID = @Id
			UPDATE JOBDL000Master SET JobGatewayStatus = NULL WHERE ID = @id
			EXEC [dbo].[CopyJobGatewayFromProgram] @JobID = @Id
				,@ProgramID = @programId
				,@dateEntered = @dateChanged
				,@enteredBy = @changedBy
				,@userId = @userId
				,@IsRelatedAttributeUpdate = @IsRelatedAttributeUpdate
		END


	EXEC [dbo].[GetJob] @userId
		,@roleId
		,0
		,@id
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