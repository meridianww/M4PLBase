SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job Gateway  
-- Execution:                 EXEC [dbo].[GetJobGateway] 2,14,1,0,170730,'Action',0,0,'Reschedule-39'
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================  
CREATE PROCEDURE [dbo].[GetJobGateway] 
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT
	,@entityFor NVARCHAR(20) = NULL
	,@is3PlAction BIT = 0
	,@isDayLightSavingEnable BIT = 0
	,@gatewayCode NVARCHAR(150) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (@entityFor = 'Contact')
	BEGIN
		SET @entityFor = NULL;
	END

	DECLARE @pickupBaselineDate DATETIME2(7)
		,@pickupPlannedDate DATETIME2(7)
		,@pickupActualDate DATETIME2(7)
		,@deliveryBaselineDate DATETIME2(7)
		,@deliveryPlannedDate DATETIME2(7)
		,@deliveryActualDate DATETIME2(7)
		,@deliverySitePOC NVARCHAR(75)
		,@deliverySitePOCPhone NVARCHAR(50)
		,@deliverySitePOCEmail NVARCHAR(100)
		,@jobCompleted BIT
		,@programId BIGINT
		,@jobDeliveryDatePlanned DATETIME2(7)
		,@DefaultTimeFromProgram DATETIME2(7)
		,@DefaultUprWindow DECIMAL
		,@DefaultLwrWindow DECIMAL
		,@GwyDDPNew DATETIME2(7)
		,@GwyDDPLatest DATETIME2(7)
		,@GwyDDPEarliest DATETIME2(7)
		,@delDay BIT = NULL
		,@GwyGatewayACD DATETIME2(7)
		,@JobDeliverySitePOC2 NVARCHAR(75)
		,@JobDeliverySitePOCPhone2 NVARCHAR(50)
		,@JobDeliverySitePOCEmail2 NVARCHAR(50)
		,@IsOnSitePOCExists BIT = 0
		,@JobPreferredMethod INT
		,@DeliveryJobPreferredMethod INT
		,@GwyDDPCurrent DATETIME2(7) = NULL
		,@GwyPreferredMethodId INT = 0
		,@GwyActionTypeID INT = 0
		,@GwyStatusId INT = 0
		,@CustomerId BIGINT = 0
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@OriginUTCValue INT
		,@IsOriginDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@jobOriginTimeZone NVARCHAR(15)
		,@isCargoRequired BIT = 0
		,@cargoField NVARCHAR(150) = NULL
		,@cutomerId BIGINT = 0
		,@cargoQuantity DECIMAL(18, 2) = NULL
		,@sqlCommand NVARCHAR(MAX) = NULL
		,@gwyCargoId BIGINT = 0
		,@gwyStatusExceptionId BIGINT = 0
		,@gwyShipStatusReasonCode VARCHAR(30)
		,@gwyShipApptmtReasonCode VARCHAR(30)
		,@ContractNumber VARCHAR(150)

	SELECT @cutomerId = PrgCustID
	FROM PRGRM000Master
	WHERE Id IN (
			SELECT ProgramID
			FROM JOBDL000Master
			WHERE ID = @parentId
			)

	SELECT @cargoField = CargoField
		,@isCargoRequired = IsCargoRequired
	FROM JOBDL021GatewayExceptionCode
	WHERE CustomerId = @cutomerId
		AND JgeReferenceCode = @gatewayCode

	SELECT TOP 1 @gwyStatusExceptionId = InstallStatus.ID
	FROM COMP000Master COMP
	INNER JOIN CUST000Master CUST ON CUST.Id = COMP.CompPrimaryRecordId
		AND CompTableName = 'Customer'
		AND COMP.CompPrimaryRecordId = @cutomerId
	INNER JOIN JOBDL023GatewayInstallStatusMaster InstallStatus ON COMP.Id = InstallStatus.CompanyId
	WHERE CUST.CustCode <> 'Electrolux'

	IF (@id > 0)
	BEGIN
		SELECT @gatewayCode = GwyGatewayTitle
			,@gwyCargoId = GwyCargoId
		FROM JOBDL020Gateways
		WHERE JobID = @parentId
			AND Id = @id

		SELECT TOP 1 @cargoField = CargoField
		FROM JOBDL021GatewayExceptionCode
		WHERE JgeReasonCode = @gatewayCode

		IF (@cargoField IS NOT NULL)
		BEGIN
			DECLARE @ParmDefinition NVARCHAR(500);

			SET @sqlCommand = 'SELECT @retvalOUT = ' + @cargoField + ' FROM JOBDL010Cargo WHERE JobID = ' + CONVERT(NVARCHAR(30), @parentId) + ' AND Id = ' + CONVERT(NVARCHAR(30), @gwyCargoId)
			SET @ParmDefinition = N'@retvalOUT decimal(18,2) OUTPUT';

			EXEC sp_executesql @sqlCommand
				,@ParmDefinition
				,@retvalOUT = @cargoQuantity OUTPUT;
		END
	END

	SELECT @GwyStatusId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayStatus'
		AND SysOptionName = 'Active'

	SELECT @GwyActionTypeID = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	SELECT @DeliveryJobPreferredMethod = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'JobPreferredMethod'
		AND SysDefault = 1

	SELECT TOP 1 @GwyDDPNew = GW.GwyDDPNew
		,@GwyDDPLatest = GW.GwyUprDate
		,@GwyDDPEarliest = GW.GwyLwrDate
		,@GwyGatewayACD = GW.GwyGatewayACD
		,@GwyDDPCurrent = GW.GwyDDPCurrent
		,@CustomerId = PrgCustId
		,@JobDeliveryTimeZone = Job.JobDeliveryTimeZone
		,@jobOriginTimeZone = Job.JobOriginTimeZone
		,@ContractNumber = Job.JobCustomerSalesOrder
	FROM [JOBDL020Gateways] GW
	INNER JOIN dbo.JobDL000Master Job ON JOb.Id = GW.JOBID
	INNER JOIN PRGRM000Master PRG ON PRG.Id = Job.ProgramId
	WHERE GW.JOBID = @parentId
		AND GW.GatewayTypeId = @GwyActionTypeID
		AND GW.GwyGatewayCode IN ('Schedule', 'Reschedule')
	ORDER BY GW.ID DESC

	SELECT @gwyShipStatusReasonCode = PgdShipStatusReasonCode
		,@gwyShipApptmtReasonCode = PgdShipApptmtReasonCode
	FROM PRGRM010Ref_GatewayDefaults GD
	INNER JOIN dbo.JobDL000Master Job ON JOb.ProgramId = GD.PgdProgramId
		AND Job.JobType = GD.PgdOrderType
		AND Job.ShipmentType = GD.PgdShipmentType
	WHERE Job.Id = @parentId
		AND PgdGatewayCode = @gatewayCode

	IF (ISNULL(@JobDeliveryTimeZone, 'Unknown') = 'Unknown')
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = @JobDeliveryTimeZone
	END

	SELECT @DeliveryUTCValue = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @DeliveryUTCValue + 1
			ELSE @DeliveryUTCValue
			END

	IF (ISNULL(@jobOriginTimeZone, 'Unknown') = 'Unknown')
	BEGIN
		SELECT TOP 1 @OriginUTCValue = UTC
			,@IsOriginDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END
	ELSE
	BEGIN
		SELECT TOP 1 @OriginUTCValue = UTC
			,@IsOriginDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = @jobOriginTimeZone
	END

	SELECT @OriginUTCValue = CASE 
			WHEN @IsOriginDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @OriginUTCValue + 1
			ELSE @OriginUTCValue
			END

	SELECT TOP 1 @delDay = DelDay
	FROM PRGRM000Master
	WHERE ID = (
			SELECT TOP 1 PROGRAMID
			FROM JOBDL000Master
			WHERE ID = @parentId
			)

	SELECT @pickupBaselineDate = Job.[JobOriginDateTimeBaseline]
		,@pickupPlannedDate = Job.[JobOriginDateTimePlanned]
		,@pickupActualDate = Job.[JobOriginDateTimeActual]
		,@deliveryBaselineDate = Job.[JobDeliveryDateTimeBaseline]
		,@deliveryPlannedDate = Job.[JobDeliveryDateTimePlanned]
		,@deliveryActualDate = Job.[JobDeliveryDateTimeActual]
		,@jobCompleted = Job.[JobCompleted]
		,@deliverySitePOC = Job.[JobDeliverySitePOC]
		,@deliverySitePOCPhone = Job.[JobDeliverySitePOCPhone]
		,@deliverySitePOCEmail = Job.[JobDeliverySitePOCEmail]
		,@programId = job.ProgramID
		,@jobDeliveryDatePlanned = JobDeliveryDateTimePlanned
		,@JobDeliverySitePOC2 = job.JobDeliverySitePOC2
		,@JobDeliverySitePOCPhone2 = job.JobDeliverySitePOCPhone2
		,@JobDeliverySitePOCEmail2 = job.JobDeliverySitePOCEmail2
		,@JobPreferredMethod = job.JobPreferredMethod
		,@CustomerId = PrgCustId
		,@ContractNumber = Job.JobCustomerSalesOrder
		,@IsOnSitePOCExists = CASE 
			WHEN (
					job.JobDeliverySitePOC2 IS NOT NULL
					OR job.JobDeliverySitePOCPhone2 IS NOT NULL
					OR job.JobDeliverySitePOCEmail2 IS NOT NULL
					)
				THEN 1
			ELSE 0
			END
	FROM JOBDL000Master(NOLOCK) job
	INNER JOIN PRGRM000Master PRG ON PRG.Id = Job.ProgramId
	WHERE job.Id = @parentId

	UPDATE PRGRM000Master
	SET @DefaultTimeFromProgram = CASE 
			WHEN @is3PlAction = 1
				THEN PrgPickUpTimeDefault
			ELSE PrgDeliveryTimeDefault
			END
		,@DefaultUprWindow = DelLatest
		,@DefaultLwrWindow = DelEarliest
	WHERE Id = (
			SELECT TOP 1 ProgramID
			FROM JOBDL000Master
			WHERE Id = @parentId
			)
		AND DelDay = @delDay

	IF (
			@id = 0
			AND @entityFor = 'Gateway'
			)
	BEGIN
		EXEC GetJobGatewayFromProgram @parentId
			,@userId
			,@isDayLightSavingEnable
	END
	ELSE IF (
			@id = 0
			AND (
				@entityFor IS NULL
				OR @entityFor = 'Action'
				)
			)
	BEGIN
		SELECT @parentId AS JobID
			,@pickupBaselineDate AS [JobOriginDateTimeBaseline]
			,@pickupPlannedDate AS [JobOriginDateTimePlanned]
			,@pickupActualDate AS [JobOriginDateTimeActual]
			,@deliveryBaselineDate AS [JobDeliveryDateTimeBaseline]
			,@deliveryPlannedDate AS [JobDeliveryDateTimePlanned]
			,@deliveryActualDate AS [JobDeliveryDateTimeActual]
			,@programId AS ProgramID
			,@DefaultTimeFromProgram AS [DefaultTime]
			,@DefaultUprWindow AS [GwyUprWindow]
			,@DefaultLwrWindow AS [GwyLwrWindow]
			,@GwyDDPNew AS [GwyDDPNew]
			,@GwyDDPLatest AS [GwyUprDate]
			,@GwyDDPEarliest AS [GwyLwrDate]
			,@delDay AS [DelDay]
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOC2, @deliverySitePOC) AS GwyPerson
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCPhone2, @deliverySitePOCPhone) AS GwyPhone
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCEmail2, @deliverySitePOCEmail) AS GwyEmail
			--,IIF(@IsOnSitePOCExists = 1, @JobPreferredMethod, @DeliveryJobPreferredMethod) AS GwyPreferredMethod
			,@DeliveryJobPreferredMethod AS GwyPreferredMethod
			,@GwyGatewayACD AS GwyGatewayACD
			,@GwyDDPCurrent AS GwyDDPCurrent
			,@CustomerId CustomerId
			,@DeliveryUTCValue DeliveryUTCValue
			,@OriginUTCValue OriginUTCValue
			,@cargoField AS CargoField
			,@isCargoRequired AS IsCargoRequired
			,@gwyStatusExceptionId AS GwyExceptionStatusId
			,@gwyShipStatusReasonCode GwyShipStatusReasonCode
			,@gwyShipApptmtReasonCode GwyShipApptmtReasonCode
			,@ContractNumber ContractNumber
	END
	ELSE
	BEGIN
		SELECT job.[Id]
			,job.[JobID]
			,job.[ProgramID]
			,job.[GwyGatewaySortOrder]
			,job.[GwyGatewayCode]
			,job.[GwyGatewayTitle]
			,job.[GwyGatewayDuration]
			,job.[GwyGatewayDefault]
			,job.[GatewayTypeId]
			,job.[GwyGatewayAnalyst]
			,job.[GwyGatewayResponsible]
			,job.[GwyGatewayPCD]
			,job.[GwyGatewayECD]
			,job.[GwyGatewayACD]
			,job.[GwyCompleted]
			,job.[GatewayUnitId]
			,job.[GwyAttachments]
			,job.[GwyProcessingFlags]
			,job.[GwyDateRefTypeId]
			,job.[Scanner]
			,job.GwyShipApptmtReasonCode
			,job.GwyShipStatusReasonCode
			,job.GwyOrderType
			,job.GwyShipmentType
			,job.[StatusId]
			,job.[GwyUpdatedById]
			,job.[GwyClosedOn]
			,job.[GwyClosedBy]
			--,CASE WHEN (cont.Id > 0 OR job.GwyUpdatedById IS NULL) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist  
			,CASE 
				WHEN (
						cont.Id > 0
						OR job.GwyClosedBy IS NULL
						)
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS ClosedByContactExist
			,job.GwyPerson
			,job.GwyPhone
			,job.GwyEmail
			,job.GwyPreferredMethod
			,job.GwyTitle
			,COALESCE(job.GwyDDPCurrent, @deliveryPlannedDate) AS [GwyDDPCurrent]
			,job.GwyDDPNew
			,job.GwyUprWindow
			,job.GwyLwrWindow
			,job.GwyUprDate
			,job.GwyLwrDate
			,CASE 
				WHEN job.GwyPerson IS NULL
					THEN CAST(0 AS BIT)
				ELSE CAST(1 AS BIT)
				END AS 'isScheduled'
			,job.[DateEntered]
			,job.[EnteredBy]
			,job.[DateChanged]
			,job.[ChangedBy]
			,@pickupBaselineDate AS [JobOriginDateTimeBaseline]
			,@pickupPlannedDate AS [JobOriginDateTimePlanned]
			,@pickupActualDate AS [JobOriginDateTimeActual]
			,@deliveryBaselineDate AS [JobDeliveryDateTimeBaseline]
			,@deliveryPlannedDate AS [JobDeliveryDateTimePlanned]
			,@deliveryActualDate AS [JobDeliveryDateTimeActual]
			,@jobCompleted AS [JobCompleted]
			,@DefaultTimeFromProgram AS [DefaultTime]
			,GwyCargoId
			,GwyExceptionTitleId
			,GwyExceptionStatusId
			,GwyAddtionalComment
			,PRG.PrgCustId CustomerId
			,@DeliveryUTCValue DeliveryUTCValue
			,@OriginUTCValue OriginUTCValue
			,StatusCode
			,@cargoField AS CargoField
			,@isCargoRequired AS IsCargoRequired
			,@cargoQuantity AS CargoQuantity
			,Job1.JobCustomerSalesOrder ContractNumber
		FROM [dbo].[JOBDL020Gateways] job
		INNER JOIN dbo.JobDL000Master Job1 ON JOb1.Id = Job.JOBID
		INNER JOIN PRGRM000Master PRG ON PRG.Id = Job.ProgramId
		LEFT JOIN CONTC000Master cont ON job.GwyClosedBy = cont.ConFullName
			AND cont.StatusId = 1 -- In(1,2)  
		WHERE job.[Id] = @id
	END
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

