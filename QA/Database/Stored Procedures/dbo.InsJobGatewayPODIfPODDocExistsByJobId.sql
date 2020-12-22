SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: June 19 2020
-- Description:	Add POD gateway if POD exists for JOB and mark Job as completed
-- =============================================
CREATE PROCEDURE [dbo].[InsJobGatewayPODIfPODDocExistsByJobId] (
	@jobId BIGINT
	,@isDayLightSavingEnable BIT
	,@enteredBy VARCHAR(50)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrentPacificTime DATETIME2(7) = CASE 
			WHEN @isDayLightSavingEnable = 1
				THEN DATEADD(HOUR, - 7, GETUTCDATE())
			ELSE DATEADD(HOUR, - 8, GETUTCDATE())
			END
	DECLARE @DocTypeId INT
		,@IsPODExists BIT = 0
		,@ProgramId BIGINT
		,@updatedItemNumber INT
		,@gwyGatewayCode VARCHAR(20) = N'POD Completion'
		,@gwyGatewayTitle VARCHAR(50) = N'Proof of Delivery Image Upload'
		,@gwyGatewayDuration DECIMAL(18, 2) = 2
		,@gwyGatewayDefault BIT = 1
		,@gatewayTypeId INT
		,@gwyGatewayAnalyst BIGINT = NULL
		,@gwyGatewayResponsible BIGINT = NULL
		,@gwyGatewayPCD DATETIME2(7) = NULL
		,@gwyGatewayECD DATETIME2(7) = @CurrentPacificTime
		,@gwyGatewayACD DATETIME2(7) = @CurrentPacificTime
		,@gwyCompleted BIT = 1
		,@gatewayUnitId INT
		,@gwyAttachments INT = NULL
		,@gwyProcessingFlags NVARCHAR(20) = NULL
		,@gwyDateRefTypeId INT
		,@scanner BIT = 0
		,@gwyShipApptmtReasonCode NVARCHAR(20) = NULL
		,@gwyShipStatusReasonCode NVARCHAR(20) = NULL
		,@gwyOrderType NVARCHAR(20) = 'Original'
		,@gwyShipmentType NVARCHAR(20) = 'Cross-Dock Shipment'
		,@statusId INT
		,@gwyUpdatedById INT = NULL
		,@gwyClosedOn DATETIME2(7) = NULL
		,@gwyClosedBy NVARCHAR(50) = NULL
		,@gwyPerson NVARCHAR(50) = NULL
		,@gwyPhone NVARCHAR(25) = NULL
		,@gwyEmail NVARCHAR(25) = NULL
		,@gwyTitle NVARCHAR(50) = NULL
		,@gwyDDPCurrent DATETIME2(7) = @CurrentPacificTime
		,@gwyDDPNew DATETIME2(7) = NULL
		,@gwyUprWindow DECIMAL(18, 2) = NULL
		,@gwyLwrWindow DECIMAL(18, 2) = NULL
		,@gwyUprDate DATETIME2(7) = NULL
		,@gwyLwrDate DATETIME2(7) = NULL
		,@dateEntered DATETIME2(7) = @CurrentPacificTime
		,@gwyPreferredMethod INT = NULL
		,@gwyExceptionTitleId BIGINT = NULL
		,@gwyCargoId BIGINT = NULL
		,@gwyExceptionStatusId BIGINT = NULL
		,@gwyAddtionalComment NVARCHAR(MAX) = NULL
		,@gwyDateCancelled DATETIME2(7) = NULL
		,@gwyCancelOrder BIT = 0
		,@statusCode NVARCHAR(50) = NULL
		,@JobDeliveryTimeZone NVARCHAR(15)
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@CurrentId BIGINT = 0
		,@IsEligible BIT = 0
		,@PODTransitionStatusId INT

	SELECT @gatewayUnitId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'UnitQuantity'
		AND SysOptionName = 'Hours'

	SELECT @PODTransitionStatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'POD Completion'

	SELECT @gwyDateRefTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Delivery Date'

	SELECT @StatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayStatus'
		AND SysOptionName = 'Active'

	SELECT @gatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @DocTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'JobDocReferenceType'
		AND SysOptionName = 'POD'

	SELECT @ProgramId = ProgramId
	FROM [JOBDL000Master]
	WHERE Id = @jobId

	SELECT @updatedItemNumber = CASE 
			WHEN COUNT(Id) IS NULL
				THEN 1
			ELSE COUNT(Id) + 1
			END
	FROM JOBDL020Gateways
	WHERE JobID = @jobId
		AND StatusId = (
			SELECT ID
			FROM SYSTM000Ref_Options
			WHERE SysLookupCode = 'GatewayStatus'
				AND SysOptionName = 'Active'
			)

	IF EXISTS (
			SELECT 1
			FROM [dbo].[JOBDL040DocumentReference] docRef
			INNER JOIN [dbo].[SYSTM020Ref_Attachments] att ON docRef.Id = att.AttPrimaryRecordId
				AND att.AttTableName = 'JobDocReference'
			WHERE docRef.JobId = @jobId
				AND docRef.StatusId = 1
				AND docRef.DocTypeId = @DocTypeId
			)
	BEGIN
		SET @IsPODExists = 1
	END

	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
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

	IF NOT EXISTS (
			SELECT 1
			FROM JOBDL000Master
			WHERE Id = @jobId
				AND JobGatewayStatus = 'POD Completion'
			)
	BEGIN
		SET @IsEligible = 1
	END

	IF (
			@IsPODExists = 1
			AND @IsEligible = 1
			)
	BEGIN
		INSERT INTO [dbo].[JOBDL020Gateways] (
			[JobID]
			,[ProgramID]
			,[GwyGatewaySortOrder]
			,[GwyGatewayCode]
			,[GwyGatewayTitle]
			,[GwyGatewayDuration]
			,[GwyGatewayDefault]
			,[GatewayTypeId]
			,[GwyGatewayAnalyst]
			,[GwyGatewayResponsible]
			,[GwyGatewayPCD]
			,[GwyGatewayECD]
			,[GwyGatewayACD]
			,[GwyCompleted]
			,[GatewayUnitId]
			,[GwyAttachments]
			,[GwyProcessingFlags]
			,[GwyDateRefTypeId]
			,[Scanner]
			,[GwyShipApptmtReasonCode]
			,[GwyShipStatusReasonCode]
			,[GwyOrderType]
			,[GwyShipmentType]
			,[StatusId]
			,[GwyUpdatedById]
			,[GwyClosedOn]
			,[GwyClosedBy]
			,[GwyPerson]
			,[GwyPhone]
			,[GwyEmail]
			,[GwyTitle]
			,[GwyPreferredMethod]
			,[GwyDDPCurrent]
			,[GwyDDPNew]
			,[GwyUprWindow]
			,[GwyLwrWindow]
			,[GwyUprDate]
			,[GwyLwrDate]
			,[DateEntered]
			,[EnteredBy]
			,[GwyCargoId]
			,[GwyExceptionTitleId]
			,[GwyExceptionStatusId]
			,[GwyAddtionalComment]
			,[GwyDateCancelled]
			,[GwyCancelOrder]
			,[StatusCode]
			)
		VALUES (
			@jobId
			,@programId
			,@updatedItemNumber
			,@gwyGatewayCode
			,@gwyGatewayTitle
			,@gwyGatewayDuration
			,@gwyGatewayDefault
			,@gatewayTypeId
			,@gwyGatewayAnalyst
			,@gwyGatewayResponsible
			,@gwyGatewayPCD
			,@gwyGatewayECD
			,ISNULL(@gwyGatewayACD, CASE 
					WHEN @gwyCompleted = 1
						THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
					END)
			,@gwyCompleted
			,@gatewayUnitId
			,@gwyAttachments
			,@gwyProcessingFlags
			,@gwyDateRefTypeId
			,@scanner
			,@gwyShipApptmtReasonCode
			,@gwyShipStatusReasonCode
			,@gwyOrderType
			,@gwyShipmentType
			,@statusId
			,@gwyUpdatedById
			,@gwyClosedOn
			,@gwyClosedBy
			,@gwyPerson
			,@gwyPhone
			,@gwyEmail
			,@gwyTitle
			,@gwyPreferredMethod
			,@gwyDDPCurrent
			,@gwyDDPNew
			,@gwyUprWindow
			,@gwyLwrWindow
			,@gwyUprDate
			,@gwyLwrDate
			,@dateEntered
			,@enteredBy
			,@gwyCargoId
			,@gwyExceptionTitleId
			,@gwyExceptionStatusId
			,@gwyAddtionalComment
			,@gwyDateCancelled
			,@gwyCancelOrder
			,@statusCode
			)
	END

	SET @currentId = SCOPE_IDENTITY();

	UPDATE job
	SET job.JobGatewayStatus = gateway.GwyGatewayCode
		,JobCompleted = 1
		,Job.JobTransitionStatusId = @PODTransitionStatusId
	FROM JOBDL020Gateways gateway
	INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		AND gateway.Id = @currentId

	SELECT JGW.*,Prg.PrgCustId CustomerId
	FROM [dbo].[JOBDL020Gateways] JGW
	INNER JOIN JOBDL000Master Job ON Job.Id = JGW.JobId
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramId
	WHERE JGW.[Id] = @currentId
END
GO

