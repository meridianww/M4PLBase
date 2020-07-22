SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 2/27/2020
-- Description:	Insert Next Avaliable Job Gateway
-- EXEC [dbo].[InsertNextAvaliableJobGateway] 37371,2,'2020-01-02',''
-- =============================================
CREATE PROCEDURE [dbo].[InsertNextAvaliableJobGateway] (
	@JobId BIGINT
	,@gatewayStatusCode NVARCHAR(50)
	,@userId BIGINT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@isDayLightSavingEnable BIT=0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

 DECLARE @GwyGatewayId INT
		,@GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		--,@CurretGatewayItemNumber INT
		,@ProgramId BIGINT
		,@GatewayCompleted BIT = 0
		,@StatusID INT
		,@updatedGatewayId BIGINT
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@gwyGatewayCode NVARCHAR(20)

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

	SELECT @DeliveryUTCValue = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @DeliveryUTCValue + 1
			ELSE @DeliveryUTCValue
			END

	SELECT @GwyGatewayId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Gateway'
		AND [SysLookupCode] = 'GatewayType'

    SELECT @StatusID = Id
		FROM [dbo].[SYSTM000Ref_Options]
		WHERE [SysLookupCode] = 'GatewayStatus'
			AND SysOptionName = 'Active'

	SET @GatewayCompleted = (
			SELECT GwyCompleted
			FROM [JOBDL020Gateways]
			WHERE ID = (
					SELECT MAX(ID)
					FROM [JOBDL020Gateways]
					WHERE JobID = @jobId
						AND GatewayTypeId = @GwyGatewayId
						--AND StatusId = @StatusID
					)
			)

		SELECT @GatewayOrderType = JobType
			,@GatewayShipmentType = ShipmentType
			,@ProgramId = ProgramID
		FROM dbo.JOBDL000Master
		WHERE Id = @JobId

		

		--SELECT @CurretGatewayItemNumber = COUNT(Id) + 1
		--FROM [dbo].[JOBDL020Gateways]
		--WHERE JobId = @JobId
		--	AND GwyOrderType = @GatewayOrderType
		--	AND GwyShipmentType = @GatewayShipmentType
		--	AND GatewayTypeId = @GwyGatewayId		
		--	AND StatusId IN (SELECT  Id
		--					FROM [dbo].[SYSTM000Ref_Options]
		--					WHERE [SysLookupCode] = 'GatewayStatus'
		--					AND SysOptionName IN ('Active','Completed'))

		INSERT INTO [dbo].[JOBDL020Gateways] (
			JobID
			,ProgramID
			,GwyGatewaySortOrder
			,GwyGatewayCode
			,GwyGatewayTitle
			,GwyGatewayDuration
			,GwyGatewayDescription
			,GwyComment
			,GatewayUnitId
			,GwyGatewayDefault
			,GatewayTypeId
			,GwyDateRefTypeId
			,Scanner
			,GwyShipApptmtReasonCode
			,GwyShipStatusReasonCode
			,GwyGatewayResponsible
			,GwyGatewayAnalyst
			,GwyOrderType
			,GwyShipmentType
			,StatusId
			,DateEntered
			,EnteredBy
			,GwyGatewayPCD
			,GwyGatewayECD
			,GwyGatewayACD
			,GwyUprWindow
			,GwyLwrWindow
			,GwyCompleted
			)
		SELECT @JobID
			,prgm.[PgdProgramID]
			,prgm.[PgdGatewaySortOrder]
			,prgm.[PgdGatewayCode]
			,prgm.[PgdGatewayTitle]
			,prgm.[PgdGatewayDuration]
			,prgm.[PgdGatewayDescription]
			,prgm.[PgdGatewayComment]
			,prgm.[UnitTypeId]
			,prgm.[PgdGatewayDefault]
			,prgm.GatewayTypeId
			,prgm.[GatewayDateRefTypeId]
			,prgm.[Scanner]
			,prgm.PgdShipApptmtReasonCode
			,prgm.PgdShipStatusReasonCode
			,prgm.PgdGatewayResponsible
			,prgm.PgdGatewayAnalyst
			,prgm.PgdOrderType
			,prgm.PgdShipmentType
			,@StatusID
			,@dateEntered
			,@enteredBy
			,job.JobDeliveryDateTimePlanned
			,job.JobDeliveryDateTimeBaseline
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,prg.DelLatest
			,prg.DelEarliest
			,prgm.[PgdGatewayDefaultComplete]
		FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
		INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = prgm.PgdProgramID
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
		INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID
			AND job.Id = @JobId
		WHERE prgm.PgdProgramID = @ProgramId
			--AND prgm.[PgdGatewaySortOrder] = @CurretGatewayItemNumber
			AND prgm.PgdOrderType = @GatewayOrderType
			AND prgm.PgdShipmentType = @GatewayShipmentType
			AND prgm.GatewayTypeId = @GwyGatewayId
			AND ISNULL(@gatewayStatusCode, '') <> ''
			AND Prgm.PgdGatewayStatusCode = @gatewayStatusCode
			AND prgm.StatusId = 1

		SET @updatedGatewayId = SCOPE_IDENTITY()

		UPDATE job
		SET job.JobGatewayStatus = gateway.GwyGatewayCode
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
		AND gateway.[Id] = (SELECT MAX(ID) FROM JOBDL020Gateways WHERE GatewayTypeId = @GwyGatewayId AND GwyCompleted = 1)

		IF (@updatedGatewayId > 0)
	    BEGIN
		Select @gwyGatewayCode = GwyGatewayCode From [dbo].[JOBDL020Gateways] 
		Where Id = @updatedGatewayId

		IF(@gwyGatewayCode = 'On Hand' OR @gwyGatewayCode = 'DS On Hand' OR @gwyGatewayCode = 'Onhand')
		BEGIN
		UPDATE dbo.JOBDL010Cargo
		SET CgoQtyOnHand = CASE 
		WHEN (ISNULL(CgoQTYOrdered, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))) > 0
		THEN ISNULL(CgoQTYOrdered, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))
		ELSE 0 
		END
		Where JobId = @jobId
		END

		IF(@gwyGatewayCode = 'On Truck' OR @gwyGatewayCode = 'Loaded on Truck' OR @gwyGatewayCode = 'DS On Truck')
		BEGIN
		UPDATE dbo.JOBDL010Cargo
		SET CgoQtyExpected = CASE 
		WHEN (ISNULL(CgoQtyOnHand, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))) > 0
		THEN ISNULL(CgoQtyOnHand, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))
		ELSE 0 
		END
		Where JobId = @jobId
		END

		IF(@gwyGatewayCode = 'Delivered' OR @gwyGatewayCode = 'DS Delivered')
		BEGIN
		UPDATE dbo.JOBDL010Cargo
		SET CgoQtyOnHold = CASE 
		WHEN (ISNULL(CgoQtyExpected, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))) > 0
		THEN ISNULL(CgoQtyExpected, 0) - (ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0))
		ELSE 0 
		END
		Where JobId = @jobId
		END

		END

		SELECT @updatedGatewayId
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
