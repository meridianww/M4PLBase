SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal          
-- Create date:               12/29/2020      
-- Description:               InsJobIsSchedule 
-- =============================================
CREATE PROCEDURE InsJobIsSchedule @JobId BIGINT
	,@StatusCode NVARCHAR(6) = NULL
	,@GwyDDPNew DATETIME2(7) = NULL
	,@IsDayLightSavingEnable BIT = 0
	,@DateEntered DATETIME2(7) = NULL
	,@EnteredBy NVARCHAR(30) = NULL
AS
BEGIN
	DECLARE @jobIsSchedule BIT = NULL
		,@orderType NVARCHAR(15) = NULL
		,@shipmentType NVARCHAR(50) = NULL
		,@programId BIGINT = 0
		,@gwyGatewayCode NVARCHAR(50) = NULL
		,@gwyGatewayTitle NVARCHAR(50) = NULL
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@currentId BIGINT = 0
		,@gwyShipApptmtReasonCode NVARCHAR(10) = NULL
		,@gwyShipStatusReasonCode NVARCHAR(10) = NULL
		,@gwyPerson NVARCHAR(50) = NULL
		,@gwyPhone NVARCHAR(50) = NULL
		,@gwyEmail NVARCHAR(50) = NULL
		,@gwyTitle NVARCHAR(50) = NULL
		,@gwyPreferredMethod INT = NULL
		,@delDay BIT = NULL
		,@gwyUprDate DATETIME2(7) = NULL
		,@gwyLwrDate DATETIME2(7) = NULL
		,@gwyUprWindow DECIMAL(18, 2) = NULL
		,@gwyLwrWindow DECIMAL(18, 2) = NULL
		,@updatedItemNumber INT = 0

	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
		,@programId = ProgramID
		,@jobIsSchedule = JobIsSchedule
		,@orderType = JobType
		,@shipmentType = ShipmentType
		,@gwyPreferredMethod = JobPreferredMethod
		,@gwyPerson = JobDeliverySitePOC2
		,@gwyPhone = JobDeliverySitePOCPhone2
		,@gwyEmail = JobDeliverySitePOCEmail2
	FROM JOBDL000Master
	WHERE Id = @JobId
		AND StatusId IN (
			1
			,2
			)

	SELECT TOP 1 @gwyGatewayCode = PgdGatewayCode
		,@gwyGatewayTitle = PgdGatewayTitle
		,@gwyShipApptmtReasonCode = PgdShipApptmtReasonCode
		,@gwyShipStatusReasonCode = PgdShipStatusReasonCode
	FROM PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @programId
		AND PgdOrderType = @orderType
		AND PgdShipmentType = @shipmentType
		AND GatewayTypeId = 86
		AND StatusId = 1
		AND PgdGatewayCode like ('%-' + @StatusCode)
		--AND (PgdGatewayCode like ('%-' + @StatusCode) OR PgdGatewayCode LIKE 'Schedule%' OR PgdGatewayCode LIKE 'XCBL-Schedule%')

	IF(CHARINDEX('-',@gwyGatewayCode) > 0)
	BEGIN
		SET @gwyGatewayCode = SUBSTRING(@gwyGatewayCode,0,CHARINDEX('-',@gwyGatewayCode))
	END

	SELECT TOP 1 @updatedItemNumber = GwyGatewaySortOrder
	FROM JOBDL020Gateways
	WHERE JobID = @JobId
		AND StatusId IN (
			194
			,195
			)
	ORDER BY Id DESC
	SELECT TOP 1 @delDay = DelDay
	FROM PRGRM000Master
	WHERE ID = (
			SELECT TOP 1 PROGRAMID
			FROM JOBDL000Master
			WHERE ID = @jobId
			)

	-- SET DATETIME IN JOB GATEWAY FROM PROGRAM 
	IF (ISNULL(@delDay, 0) = 1)
	BEGIN
		SET @gwyUprDate = @GwyDDPNew
		SET @gwyLwrDate = NULL --@gwyDDPNew
	END
	ELSE IF (
			@gwyUprWindow = NULL
			AND @gwyLwrWindow = NULL
			)
	BEGIN
		SET @gwyUprDate = @GwyDDPNew
		SET @gwyLwrDate = @GwyDDPNew
	END
	ELSE IF (ISNULL(@delDay, 0) = 0)
	BEGIN
		IF OBJECT_ID('tempdb..#TempgwyUprWindow') IS NOT NULL
		BEGIN
			DROP TABLE #TempgwyUprWindow
		END

		CREATE TABLE #TempgwyUprWindow (
			ID INT IDENTITY(1, 1)
			,item VARCHAR(10)
			)

		INSERT INTO #TempgwyUprWindow
		SELECT item
		FROM dbo.fnSplitString(CONVERT(NVARCHAR(10), @gwyUprWindow), '.')

		IF OBJECT_ID('tempdb..#TempgwyLwrWindow') IS NOT NULL
		BEGIN
			DROP TABLE #TempgwyLwrWindow
		END

		CREATE TABLE #TempgwyLwrWindow (
			ID INT IDENTITY(1, 1)
			,item VARCHAR(10)
			)

		INSERT INTO #TempgwyLwrWindow
		SELECT item
		FROM dbo.fnSplitString(CONVERT(NVARCHAR(10), @gwyLwrWindow), '.')

		DECLARE @LgwyUprWindow INT
			,@RgwyUprWindow INT
			,@LgwyLwrWindow INT
			,@RgwyLwrWindow INT

		SELECT @LgwyUprWindow = CONVERT(INT, ITEM)
		FROM #TempgwyUprWindow
		WHERE ID = 1

		SELECT @RgwyUprWindow = CONVERT(INT, ITEM)
		FROM #TempgwyUprWindow
		WHERE ID = 2

		SELECT @LgwyLwrWindow = CONVERT(INT, ITEM)
		FROM #TempgwyLwrWindow
		WHERE ID = 1

		SELECT @RgwyLwrWindow = CONVERT(INT, ITEM)
		FROM #TempgwyLwrWindow
		WHERE ID = 2

		IF (@LgwyUprWindow IS NOT NULL)
		BEGIN
			SET @gwyUprDate = DATEADD(HOUR, CONVERT(INT, @LgwyUprWindow), @GwyDDPNew)

			IF (@RgwyUprWindow IS NOT NULL)
			BEGIN
				IF (CONVERT(INT, @LgwyUprWindow) < 0)
				BEGIN
					SET @RgwyUprWindow = '-' + @RgwyUprWindow;
				END

				SET @gwyUprDate = DATEADD(MINUTE, CONVERT(INT, @RgwyUprWindow), @gwyUprDate)
			END
		END

		IF (@LgwyLwrWindow IS NOT NULL)
		BEGIN
			SET @gwyLwrDate = DATEADD(HOUR, CONVERT(INT, @LgwyLwrWindow), @GwyDDPNew)

			IF (@RgwyLwrWindow IS NOT NULL)
			BEGIN
				IF (CONVERT(INT, @LgwyLwrWindow) < 0)
				BEGIN
					SET @RgwyLwrWindow = '-' + @RgwyLwrWindow;
				END

				SET @gwyLwrDate = DATEADD(MINUTE, CONVERT(INT, @RgwyLwrWindow), @gwyLwrDate)
			END
		END
	END
	IF (ISNULL(@gwyGatewayCode, '') <> '')
	BEGIN
		SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
			,@programId = ProgramID
			,@OrderType = JobType
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
					AND @IsDayLightSavingEnable = 1
					THEN @DeliveryUTCValue + 1
				ELSE @DeliveryUTCValue
				END
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
			,[StatusCode]
			,[isActionAdded]
			)
		VALUES (
			@jobId
			,@programId
			,@updatedItemNumber
			,@gwyGatewayCode
			,@gwyGatewayTitle
			,0
			,1
			,86
			,NULL
			,NULL
			,@GwyDDPNew
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,1
			,NULL
			,NULL
			,0
			,NULL
			,0
			,@gwyShipApptmtReasonCode
			,@gwyShipStatusReasonCode
			,@orderType
			,@shipmentType
			,194
			,@gwyPerson
			,@gwyPhone
			,@gwyEmail
			,@gwyTitle
			,@gwyPreferredMethod
			,CASE 
				WHEN @orderType = 'Return'
					THEN @GwyDDPNew
				ELSE DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
				END
			,CASE 
				WHEN @orderType <> 'Return'
					THEN @GwyDDPNew
				ELSE DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
				END
			,@gwyUprWindow
			,@gwyLwrWindow
			,@gwyUprDate
			,@gwyLwrDate
			,@DateEntered
			,@EnteredBy
			,@StatusCode
			,1
			)

		SET @currentId = SCOPE_IDENTITY();

		IF (@currentId > 0)
		BEGIN
			UPDATE job
			SET JobIsSchedule = 1
				,JobDeliveryDateTimePlanned = CASE 
					WHEN @orderType = 'Return'
						THEN NULL
					ELSE @GwyDDPNew
					END
				,JobOriginDateTimePlanned = CASE 
					WHEN @orderType = 'Return'
						THEN @GwyDDPNew
					ELSE NULL
					END
			FROM JOBDL000Master job
			INNER JOIN JOBDL020Gateways gateway ON gateway.JobID = job.Id
			WHERE job.Id = @JobId
				AND job.StatusId IN (
					1
					,2
					)
		END

		SELECT @currentId
	END
END