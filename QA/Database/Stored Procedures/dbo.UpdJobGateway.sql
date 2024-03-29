/****** Object:  StoredProcedure [dbo].[UpdJobGateway]    Script Date: 2/8/2021 2:24:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job Gateway   
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
ALTER PROCEDURE [dbo].[UpdJobGateway] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@jobId BIGINT = NULL
	,@programId BIGINT = NULL
	,@gwyGatewaySortOrder INT = NULL
	,@gwyGatewayCode NVARCHAR(20) = NULL
	,@gwyGatewayTitle NVARCHAR(50) = NULL
	,@gwyGatewayDuration DECIMAL(18, 2) = NULL
	,@gwyGatewayDefault BIT = NULL
	,@gatewayTypeId INT = NULL
	,@gwyGatewayAnalyst BIGINT = NULL
	,@gwyGatewayResponsible BIGINT = NULL
	,@gwyGatewayPCD DATETIME2(7) = NULL
	,@gwyGatewayECD DATETIME2(7) = NULL
	,@gwyGatewayACD DATETIME2(7) = NULL
	,@gwyCompleted BIT = NULL
	,@gatewayUnitId INT = NULL
	,@gwyAttachments INT = NULL
	,@gwyProcessingFlags NVARCHAR(20) = NULL
	,@gwyDateRefTypeId INT = NULL
	,@scanner BIT = NULL
	,@gwyShipApptmtReasonCode NVARCHAR(20)
	,@gwyShipStatusReasonCode NVARCHAR(20)
	,@gwyOrderType NVARCHAR(20)
	,@gwyShipmentType NVARCHAR(20)
	,@statusId INT = NULL
	--,@gwyUpdatedStatusOn  datetime2(7)    =NULL    
	,@gwyUpdatedById INT = NULL
	,@gwyClosedOn DATETIME2(7) = NULL
	,@gwyClosedBy NVARCHAR(50) = NULL
	,@gwyPerson NVARCHAR(50) = NULL
	,@gwyPhone NVARCHAR(25) = NULL
	,@gwyEmail NVARCHAR(25) = NULL
	,@gwyTitle NVARCHAR(50) = NULL
	,@gwyDDPCurrent DATETIME2(7) = NULL
	,@gwyDDPNew DATETIME2(7) = NULL
	,@gwyUprWindow DECIMAL(18, 2) = NULL
	,@gwyLwrWindow DECIMAL(18, 2) = NULL
	,@gwyUprDate DATETIME2(7) = NULL
	,@gwyLwrDate DATETIME2(7) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
	,@gwyPreferredMethod INT = 0
	,@gwyExceptionTitleId BIGINT = NULL
	,@gwyCargoId BIGINT = NULL
	,@gwyExceptionStatusId BIGINT = NULL
	,@gwyAddtionalComment NVARCHAR(MAX) = NULL
	,@where NVARCHAR(200) = NULL
	,@gwyDateCancelled DATETIME2(7) = NULL
	,@gwyCancelOrder BIT = 0
	,@JobTransitionStatusId INT
	,@isDayLightSavingEnable BIT = 0
	,@GwyGatewayText NVARCHAR(MAX) = NULL
	,@DeliveredTransitionStatusId INT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@CommentGatewayType INT
		,@GtyGatewayTypeId INT
		,@PickUpDateRefId INT
		,@DeliverUpDateRefId INT
		,@JobOriginDateplanned DATETIME2(7)
		,@JobGatewayStatus NVARCHAR(50)
		,@JobOriginDateTimeActual DATETIME2(7) = NULL
		,@PODTransitionStatusId INT
		,@WillCallTransitionStatusId INT
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@OriginUTCValue INT
		,@IsOriginDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@jobOriginTimeZone NVARCHAR(15)
		
		DECLARE @TemptABLE AS TABLE (Id INT)
		INSERT INTO @TemptABLE
		SELECT Id FROM SYSTM000Ref_Options WHERE SysLookupCode = 'GatewayStatus' AND SysOptionName in ('Discarded', 'Archive')

	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
		,@jobOriginTimeZone = JobOriginTimeZone
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId

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

	SELECT @PickUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Pickup Date'

	SELECT @DeliverUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Delivery Date'

	SELECT @GtyGatewayTypeId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @CommentGatewayType = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Comment'

	SELECT @PODTransitionStatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'POD Completion'

		SELECT @WillCallTransitionStatusId = Id 
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'Will Call' 

	SET @gatewayTypeId = (
			SELECT TOP 1 GatewayTypeId
			FROM [JOBDL020Gateways]
			WHERE JobID = @jobId
				AND ID = @ID
			)

	SELECT @JobOriginDateplanned = JobOriginDateTimePlanned
	FROM JOBDL000Master
	WHERE ID = @jobId
		AND StatusId = 1

	UPDATE [dbo].[JOBDL020Gateways]
	SET [JobID] = ISNULL(@jobId, JobID)
		,[ProgramID] = ISNULL(@programId, ProgramID)
		,[GwyGatewayCode] = ISNULL(@gwyGatewayCode, GwyGatewayCode)
		,[GwyGatewayTitle] = ISNULL(@gwyGatewayTitle, GwyGatewayTitle)
		,[GwyGatewayDuration] = ISNULL(@gwyGatewayDuration, GwyGatewayDuration)
		,[GwyGatewayDefault] = ISNULL(@gwyGatewayDefault, GwyGatewayDefault)
		,[GwyGatewayAnalyst] = ISNULL(@gwyGatewayAnalyst, GwyGatewayAnalyst)
		,[GwyGatewayResponsible] = ISNULL(@gwyGatewayResponsible, GwyGatewayResponsible)
		,[GwyGatewayACD] = ISNULL(@gwyGatewayACD, GwyGatewayACD)
		,[GwyCompleted] = ISNULL(@gwyCompleted, GwyCompleted)
		,[GatewayUnitId] = ISNULL(@gatewayUnitId, GatewayUnitId)
		,[GwyProcessingFlags] = ISNULL(@gwyProcessingFlags, GwyProcessingFlags)
		,[GwyDateRefTypeId] = ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)
		,[Scanner] = ISNULL(@scanner, Scanner)
		,GwyShipApptmtReasonCode = ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode)
		,GwyShipStatusReasonCode = ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode)
		,[GwyOrderType] = ISNULL(@gwyOrderType, GwyOrderType)
		,[GwyShipmentType] = ISNULL(@gwyShipmentType, GwyShipmentType)
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[GwyUpdatedById] = ISNULL(@gwyUpdatedById, GwyUpdatedById)
		,[GwyClosedOn] = ISNULL(@gwyClosedOn, GwyClosedOn)
		,[GwyClosedBy] = ISNULL(@gwyClosedBy, GwyClosedBy)
		,[GwyPerson] = ISNULL(@gwyPerson, GwyPerson)
		,[GwyPhone] = ISNULL(@gwyPhone, GwyPhone)
		,[GwyEmail] = ISNULL(@gwyEmail, GwyEmail)
		,[GwyTitle] = ISNULL(@gwyTitle, GwyTitle)
		,[GwyDDPCurrent] = ISNULL(@gwyDDPCurrent, GwyDDPCurrent)
		,[GwyDDPNew] = ISNULL(@gwyDDPNew, GwyDDPNew)
		,[GwyUprDate] = ISNULL(@gwyUprDate, GwyUprDate)
		,[GwyLwrDate] = ISNULL(@gwyLwrDate, GwyLwrDate)
		,[GwyUprWindow] = ISNULL(@gwyUprWindow, GwyUprWindow)
		,[GwyLwrWindow] = ISNULL(@gwyLwrWindow, GwyLwrWindow)
		,[GwyDateCancelled] = GwyDateCancelled
		,[GwyCancelOrder] = @gwyCancelOrder
		,[DateChanged] = CASE 
			WHEN @isDayLightSavingEnable = 1
				THEN DATEADD(HOUR, - 7, GETUTCDATE())
			ELSE DATEADD(HOUR, - 8, GETUTCDATE())
			END
		,[ChangedBy] = ISNULL(@changedBy, ChangedBy)
		,GwyPreferredMethod = ISNULL(@gwyPreferredMethod, GwyPreferredMethod)
		,GwyGatewayText = ISNULL(@GwyGatewayText,GwyGatewayText)
	WHERE [Id] = @id;

	IF ((
	(@JobTransitionStatusId = @PODTransitionStatusId OR @gwyGatewayCode = 'POD Completion') OR 
	(@JobTransitionStatusId = @WillCallTransitionStatusId OR @gwyGatewayCode = 'Will Call')) 
	AND @gwyCompleted = 1)
	BEGIN
		UPDATE JOBDL000Master
		SET JobCompleted = 1
		WHERE id = @jobId;
	END

	IF (
			(
				@JobTransitionStatusId = @DeliveredTransitionStatusId
				OR @gwyGatewayCode = 'Delivered'
				)
			AND @gwyCompleted = 1
			)
	BEGIN
		UPDATE job
		SET job.JobDeliveryDateTimeActual = CASE 
				WHEN @gwyGatewayACD IS NOT NULL
					THEN gateway.GwyGatewayACD
				ELSE CASE 
						WHEN @isDayLightSavingEnable = 1
							THEN DATEADD(HOUR, - 7, GETUTCDATE())
						ELSE DATEADD(HOUR, - 8, GETUTCDATE())
						END
				END
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JOBID = @jobId
			AND gateway.ID = @id;
	END

	IF (@gatewayTypeId IS NULL) -- batch update
	BEGIN
		SET @gatewayTypeId = (
				SELECT TOP 1 GatewayTypeId
				FROM [JOBDL020Gateways]
				WHERE JobID = @jobId
					AND ID = @ID
				)
	END

	UPDATE [JOBDL020Gateways]
	SET [GwyGatewayACD] = DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
	WHERE [GwyGatewayACD] IS NULL
		AND [GwyCompleted] = 1
		AND [Id] = @id;

	IF (@gatewayTypeId = @GtyGatewayTypeId)
	BEGIN
		UPDATE gateway
		SET GwyGatewayPCD = CASE 
				WHEN @gwyDateRefTypeId = @DeliverUpDateRefId
					AND job.JobDeliveryDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobDeliveryDateTimePlanned)
				WHEN @gwyDateRefTypeId = @PickUpDateRefId
					AND job.JobOriginDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobOriginDateTimePlanned)
				ELSE NULL
				END
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @id

		UPDATE job
		SET job.JobGatewayStatus = gateway.GwyGatewayCode
			,@JobGatewayStatus = gateway.GwyGatewayCode
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = (
				SELECT MAX(ID)
				FROM JOBDL020Gateways
				WHERE GatewayTypeId = @GtyGatewayTypeId
					AND GwyCompleted = 1
				)

		UPDATE job
		SET job.JobOriginDateTimeActual = ISNULL(gateway.GwyGatewayACD, DATEADD(HOUR, @OriginUTCValue, GetUTCDate()))
			,@JobOriginDateTimeActual = gateway.GwyGatewayACD
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @id
			AND gateway.GatewayTypeId = @GtyGatewayTypeId
			AND gateway.GwyGatewayCode = 'On Hand'
			AND job.JobOriginDateTimeActual IS NULL
	END
	IF EXISTS(SELECT 1 FROM @TemptABLE WHERE Id = @statusId)
	BEGIN
		;with activeGatewaysByJobId as 
		(
			SELECT TOP 1 GwyGatewayCode, JobId FROM JOBDL020Gateways
			WHERE GatewayTypeId = 85 AND StatusId in (194, 195) AND JOBID = @jobId
			ORDER BY Id DESC
		)
		UPDATE JOB SET JOB.JobGatewayStatus = TMP.GwyGatewayCode FROM JOBDL000Master JOB 
		INNER JOIN activeGatewaysByJobId TMP ON JOB.Id = TMP.JobID
	END
	SELECT JGW.[Id]
		,JGW.[JobID]
		,JGW.[ProgramID]
		,JGW.[GwyGatewaySortOrder]
		,JGW.[GwyGatewayCode]
		,JGW.[GwyGatewayTitle]
		,JGW.[GwyGatewayDuration]
		,JGW.[GwyGatewayDefault]
		,JGW.[GatewayTypeId]
		,JGW.[GwyGatewayAnalyst]
		,JGW.[GwyGatewayResponsible]
		,JGW.[GwyGatewayPCD]
		,JGW.[GwyGatewayECD]
		,JGW.[GwyGatewayACD]
		,JGW.[GwyCompleted]
		,JGW.[GatewayUnitId]
		,JGW.[GwyAttachments]
		,JGW.[GwyProcessingFlags]
		,JGW.[GwyDateRefTypeId]
		,JGW.[Scanner]
		,JGW.[StatusId]
		,JGW.[GwyUpdatedById]
		,JGW.[GwyClosedOn]
		,JGW.[GwyClosedBy]
		,JGW.[DateEntered]
		,JGW.[EnteredBy]
		,JGW.[DateChanged]
		,JGW.[ChangedBy]
		,JGW.[GwyShipApptmtReasonCode]
		,JGW.[GwyShipStatusReasonCode]
		,JGW.[GwyOrderType]
		,JGW.[GwyShipmentType]
		,@JobGatewayStatus AS JobGatewayStatus
		,@JobOriginDateTimeActual AS JobOriginActual
		,Prg.PrgCustId CustomerId
		,JGW.GwyGatewayText
	FROM [dbo].[JOBDL020Gateways] JGW
	INNER JOIN JOBDL000Master Job ON Job.Id = JGW.JobId
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramId
	WHERE JGW.[Id] = @id
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
