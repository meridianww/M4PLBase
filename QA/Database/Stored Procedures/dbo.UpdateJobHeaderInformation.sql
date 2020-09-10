SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kirty Anurag           
-- Create date:               09/08/2020        
-- Description:               Update Job Header Information        
-- =============================================       
CREATE PROCEDURE [dbo].[UpdateJobHeaderInformation] (
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
	,@jobDeliveryDateTimePlanned DATETIME2(7) = NULL
	,@jobDeliveryDateTimeActual DATETIME2(7) = NULL
	,@jobDeliveryDateTimeBaseline DATETIME2(7) = NULL
	,@jobDeliveryRecipientPhone NVARCHAR(50) = NULL
	,@jobDeliveryRecipientEmail NVARCHAR(50) = NULL
	,@jobOriginResponsibleContactId BIGINT = NULL
	,@jobOriginDateTimePlanned DATETIME2(7) = NULL
	,@jobOriginDateTimeActual DATETIME2(7) = NULL
	,@jobOriginDateTimeBaseline DATETIME2(7) = NULL
	,@jobProcessingFlags NVARCHAR(20) = NULL
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
	,@jobElectronicInvoice BIT
	,@JobCubesUnitTypeId INT
	,@JobTotalWeight DECIMAL(18, 2)
	,@JobWeightUnitTypeId INT
	,@JobServiceOrder INT = 0
	,@JobServiceActual INT = 0
	,@ProFlags12 [nvarchar](1) = NULL
	,@JobDriverAlert NVARCHAR(Max)
	,@IsCancelled BIT = 0
	,@isDayLightSavingEnable BIT = 0
	,@isManualUpdate BIT = 1
	,@IsRelatedAttributeUpdate BIT = 1
	,@jobDeliveryTimeZone NVARCHAR(15) = NULL
	,@jobOriginTimeZone NVARCHAR(15) = NULL
	,@JobIsDirtyDestination BIT = 1
	,@jobOriginPostalCode NVARCHAR(50) = NULL
	,@jobDeliveryPostalCode NVARCHAR(50) = NULL
	,@OldOrderType NVARCHAR(20)
	,@OldShipmentType NVARCHAR(20)
	,@IsJobReactivated BIT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @VendDCLocationId BIGINT
		,@OldjobSiteCode NVARCHAR(30)
		,@ProFlags02 NVARCHAR(1) = NULL
		,@OldjobDeliveryTimeZone NVARCHAR(15)
		,@OldjobOriginTimeZone NVARCHAR(15)
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@OriginUTCValue INT
		,@IsOriginDayLightSaving BIT
		,@OldDeliveryUTCValue INT
		,@OldIsDeliveryDayLightSaving BIT
		,@OldOriginUTCValue INT
		,@OldIsOriginDayLightSaving BIT

  IF(ISNULL(@JobIsDirtyDestination, 1) = 1)
  BEGIN
	SET @OldjobDeliveryTimeZone = @jobDeliveryTimeZone
	SET @OldjobOriginTimeZone = @jobOriginTimeZone

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

	IF (
			@isManualUpdate = 1
			AND ISNULL(@JobDeliveryTimeZone, '') <> ISNULL(@OldJobDeliveryTimeZone, '')
			)
	BEGIN
		IF (ISNULL(@DeliveryUTCValue, 0) = 0)
		BEGIN
			SELECT TOP 1 @DeliveryUTCValue = UTC
				,@IsDeliveryDayLightSaving = IsDayLightSaving
			FROM Location000Master
			WHERE TimeZoneShortName = 'Pacific'
		END

		SELECT @DeliveryUTCValue = CASE 
				WHEN @IsDeliveryDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN @DeliveryUTCValue + 1
				ELSE @DeliveryUTCValue
				END

		SELECT TOP 1 @OldDeliveryUTCValue = UTC
			,@OldIsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = CASE 
				WHEN ISNULL(@OldJobDeliveryTimeZone, 'Unknown') = 'Unknown'
					THEN 'Pacific'
				ELSE @OldJobDeliveryTimeZone
				END

		SELECT @OldDeliveryUTCValue = CASE 
				WHEN @OldIsDeliveryDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN @OldDeliveryUTCValue + 1
				ELSE @OldDeliveryUTCValue
				END

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

	SET @dateChanged = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN DATEADD(HOUR, - 7, GETUTCDATE())
			ELSE DATEADD(HOUR, - 8, GETUTCDATE())
			END;

	IF (
			@isManualUpdate = 1
			AND ISNULL(@JobOriginTimeZone, '') <> ISNULL(@OldJobOriginTimeZone, '')
			)
	BEGIN
		IF (ISNULL(@OriginUTCValue, 0) = 0)
		BEGIN
			SELECT TOP 1 @OriginUTCValue = UTC
				,@IsOriginDayLightSaving = IsDayLightSaving
			FROM Location000Master
			WHERE TimeZoneShortName = 'Pacific'
		END

		SELECT @OriginUTCValue = CASE 
				WHEN @IsOriginDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN @OriginUTCValue + 1
				ELSE @OriginUTCValue
				END

		SELECT TOP 1 @OldOriginUTCValue = UTC
			,@OldIsOriginDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = CASE 
				WHEN ISNULL(@OldJobOriginTimeZone, 'Unknown') = 'Unknown'
					THEN 'Pacific'
				ELSE @OldJobOriginTimeZone
				END

		SELECT @OldOriginUTCValue = CASE 
				WHEN @OldIsOriginDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN @OldOriginUTCValue + 1
				ELSE @OldOriginUTCValue
				END

		--SET  @OriginUTCValue = @OriginUTCValue - @OldOriginUTCValue
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
END
	UPDATE [dbo].[JOBDL000Master]
	SET [JobMITJobID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobMITJobID
			ELSE ISNULL(@jobMITJobID, JobMITJobID)
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
		,[JobDeliveryTimeZone] = CASE 
			WHEN (@isFormView = 1 AND ISNULL(@JobIsDirtyDestination, 0) = 1)
				THEN CASE 
						WHEN ISNULL(@jobDeliveryTimeZone, '') <> ''
							AND ISNULL(@jobDeliveryPostalCode, '') <> ''
							AND LEN(@jobDeliveryPostalCode) > 4
							THEN @jobDeliveryTimeZone
						ELSE 'Unknown'
						END
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
		,[JobOriginResponsibleContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginResponsibleContactID
			ELSE ISNULL(@jobOriginResponsibleContactID, JobOriginResponsibleContactID)
			END
		,[JobOriginTimeZone] = CASE 
			WHEN (@isFormView = 1 AND ISNULL(@JobIsDirtyDestination, 0) = 1)
				THEN CASE 
						WHEN ISNULL(@jobOriginTimeZone, '') <> ''
							AND ISNULL(@jobOriginPostalCode, '') <> ''
							AND LEN(@jobOriginPostalCode) > 4
							THEN @jobOriginTimeZone
						ELSE 'Unknown'
						END
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
		,JobDriverAlert = CASE 
			WHEN (@isFormView = 1)
				THEN @JobDriverAlert
			ELSE ISNULL(@JobDriverAlert, JobDriverAlert)
			END
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
		,[VendDCLocationId] = CASE 
			WHEN ISNULL(@OldjobSiteCode, '') <> ISNULL(@jobSiteCode, '')
				THEN ISNULL(@VendDCLocationId, 0)
			ELSE VendDCLocationId
			END
		,ProFlags02 = @ProFlags02
		,[JobServiceOrder] = @JobServiceOrder
		,[JobServiceActual] = @JobServiceActual
		,[ProFlags12] = ISNULL(@ProFlags12, ProFlags12)
		,IsCancelled = @IsCancelled
	WHERE [Id] = @id;

	IF (
			@programId <> (
				SELECT TOP 1 ProgramID
				FROM JOBDL000Master
				WHERE ID = @id
					AND StatusId IN (1, 2)
				)
			)
	BEGIN
		IF NOT EXISTS (
				SELECT 1
				FROM PRGRM051VendorLocations
				WHERE PvlProgramID = @programId
					AND PvlLocationCode = @jobSiteCode
				)
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
				AND PVL.StatusId IN (1, 2)
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
		UPDATE JOBDL020Gateways
		SET StatusId = NULL
		WHERE JobID = @Id

		UPDATE JOBDL000Master
		SET JobGatewayStatus = NULL
		WHERE ID = @id

		EXEC [dbo].[CopyJobGatewayFromProgram] @JobID = @Id
			,@ProgramID = @programId
			,@dateEntered = @dateChanged
			,@enteredBy = @changedBy
			,@userId = @userId
			,@IsRelatedAttributeUpdate = @IsRelatedAttributeUpdate
	END

	IF(ISNULL(@IsJobReactivated, 0) = 1)
	BEGIN

	UPDATE dbo.JOBDL020Gateways 
	SET StatusId = 196
	Where JobId = @id AND GatewayTypeId = 85

	EXEC [dbo].[CopyJobGatewayFromProgram] @id
		,@programId
		,@dateChanged
		,@changedBy
		,@userId
		,@IsRelatedAttributeUpdate
	END
END 
GO

