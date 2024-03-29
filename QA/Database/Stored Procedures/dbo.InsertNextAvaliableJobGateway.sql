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
	,@isDayLightSavingEnable BIT = 0
	,@gatewayACD DATETIME2(7) = NULL
	,@deliveredDate DATETIME2(7) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @GwyGatewayId INT
		,@GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		,@ProgramId BIGINT
		,@GatewayCompleted BIT = 0
		,@StatusID INT
		,@updatedGatewayId BIGINT
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@gwyGatewayCode NVARCHAR(20)
		,@CurrentGatewayCode NVARCHAR(150)
		,@UpdatedGatewayCode NVARCHAR(150)
		,@UpdatedProgramGatewayId BIGINT
		,@PgdGatewayNavOrderOption INT = NULL
		,@OrderType NVARCHAR(20)
		,@gwyGatewayTitle NVARCHAR(50)

	SELECT @GwyGatewayId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Gateway'
		AND [SysLookupCode] = 'GatewayType'

	SELECT @GatewayOrderType = JobType
		,@GatewayShipmentType = ShipmentType
		,@ProgramId = ProgramID
	FROM dbo.JOBDL000Master
	WHERE Id = @JobId

	SELECT TOP 1 @CurrentGatewayCode = GwyGatewayCode
	FROM [dbo].[JOBDL020Gateways]
	WHERE JObId = @JobId
		AND GatewayTypeId = @GwyGatewayId
		AND StatusId = 194
	ORDER BY ID DESC

	SELECT @UpdatedProgramGatewayId = ID, 
	       @UpdatedGatewayCode = PgdGatewayCode,
		   @PgdGatewayNavOrderOption = PgdGatewayNavOrderOption
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdProgramID = @ProgramId
		AND PgdOrderType = @GatewayOrderType
		AND PgdShipmentType = @GatewayShipmentType
		AND GatewayTypeId = @GwyGatewayId
		AND ISNULL(@gatewayStatusCode, '') <> ''
		AND PgdGatewayStatusCode = @gatewayStatusCode
		AND StatusId = 1

	IF (
			ISNULL(@CurrentGatewayCode, '') <> ''
			AND ISNULL(@UpdatedGatewayCode, '') <> ''
			AND ISNULL(@CurrentGatewayCode, '') <> ISNULL(@UpdatedGatewayCode, '')
			)
	BEGIN
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
						)
				)

		--AND StatusId = @StatusID
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
			,CASE WHEN ISNULL(@gatewayACD, '') = '' THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) ELSE @gatewayACD END
			,prg.DelLatest
			,prg.DelEarliest
			,prgm.[PgdGatewayDefaultComplete]
		FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
		INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = prgm.PgdProgramID
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
		INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID AND job.Id = @JobId
		WHERE prgm.Id = @UpdatedProgramGatewayId

		SET @updatedGatewayId = SCOPE_IDENTITY()

		UPDATE job
		SET job.JobGatewayStatus = gateway.GwyGatewayCode
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = (
				SELECT MAX(ID)
				FROM JOBDL020Gateways
				WHERE GatewayTypeId = @GwyGatewayId
					AND GwyCompleted = 1
				)

		IF (@updatedGatewayId > 0)
		BEGIN
			SELECT @gwyGatewayCode = GwyGatewayCode,
			@gwyGatewayTitle = GwyGatewayTitle
			FROM [dbo].[JOBDL020Gateways]
			WHERE Id = @updatedGatewayId

			IF (@GatewayOrderType = 'Return')
		    BEGIN
			UPDATE job
			SET JobOriginDateTimePlanned = CASE WHEN (@gwyGatewayCode = 'Schedule' OR
													  @gwyGatewayCode = '3PL Arrival' OR 
			                                          @gwyGatewayTitle = 'Schedule Pick Up' OR 
			                                          @gwyGatewayTitle = 'Sched Pick Up') THEN Gateway.GwyDDPCurrent 
												WHEN  @gwyGatewayCode Like '%Reschedule%' THEN Gateway.GwyDDPNew
													  ELSE JobOriginDateTimePlanned END,

                Job.JobCompleted =                    CASE WHEN @gwyGatewayCode Like 'Return to%' THEN 1 
				                                      ELSE Job.JobCompleted END,
			   Job.JobDeliveryDateTimeActual = CASE WHEN @gwyGatewayCode Like 'Return to%' THEN 
			                                     CASE WHEN ISNULL(@deliveredDate, '') = '' 
				                                         THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) 
														 ELSE @deliveredDate END
														 ELSE JobDeliveryDateTimeActual END
			FROM JOBDL020Gateways Gateway
			INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
			WHERE gateway.ID = @updatedGatewayId;
		END

			IF (
					@gwyGatewayCode = 'On Hand'
					OR @gwyGatewayCode = 'DS On Hand'
					OR @gwyGatewayCode = 'Onhand'
					)
			BEGIN
				UPDATE job
				SET job.JobOriginDateTimeActual = DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
				FROM JOBDL000Master job
				WHERE Id = @JobID

				  UPDATE Cargo
                  SET CgoQtyOnHand = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
                  ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
                  FROM dbo.JobDL010Cargo Cargo
                  INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'On Hand') ItemCount ON ItemCount.CargoId = Cargo.Id
			END

			IF (
					@gwyGatewayCode = 'On Truck'
					OR @gwyGatewayCode = 'Loaded on Truck'
					OR @gwyGatewayCode = 'DS On Truck'
					)
			BEGIN
				UPDATE Cargo
                SET CgoQtyExpected = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
                ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
                FROM dbo.JobDL010Cargo Cargo
                INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'On Truck') ItemCount ON ItemCount.CargoId = Cargo.Id
			END

			IF (
					@gwyGatewayCode = 'Delivered'
					OR @gwyGatewayCode = 'DS Delivered'
					)
			BEGIN
				UPDATE job
				SET job.JobDeliveryDateTimeActual = CASE WHEN ISNULL(@deliveredDate, '') = '' 
				                                         THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) 
														 ELSE @deliveredDate END
				FROM JOBDL000Master job
				WHERE Id = @JobID

				UPDATE Cargo
                SET CgoQtyOnHold = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
                ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
                FROM dbo.JobDL010Cargo Cargo
                INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'Delivered') ItemCount ON ItemCount.CargoId = Cargo.Id
			END
		END
	END
	
	SELECT JGW.*,Prg.PrgCustId CustomerId,@PgdGatewayNavOrderOption PgdGatewayNavOrderOption
	FROM [dbo].[JOBDL020Gateways] JGW
	INNER JOIN JOBDL000Master Job ON Job.Id = JGW.JobId
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramId
	WHERE JGW.[Id] = @updatedGatewayId
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
