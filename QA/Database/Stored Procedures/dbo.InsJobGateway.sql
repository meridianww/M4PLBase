SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kirty        
-- Create date:               02/06/2020        
-- Description:               Ins a Job Gateway    
-- Execution:                 EXEC [dbo].[InsJobGateway]  
-- Modified on:               
-- Modified Desc:              
-- Modified on:                
-- =============================================        
ALTER PROCEDURE [dbo].[InsJobGateway] (
	 @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@jobId BIGINT
	,@programId BIGINT
	,@gwyGatewaySortOrder INT
	,@gwyGatewayCode NVARCHAR(20)
	,@gwyGatewayTitle NVARCHAR(50)
	,@gwyGatewayDuration DECIMAL(18, 2)
	,@gwyGatewayDefault BIT
	,@gatewayTypeId INT
	,@gwyGatewayAnalyst BIGINT
	,@gwyGatewayResponsible BIGINT
	,@gwyGatewayPCD DATETIME2(7)
	,@gwyGatewayECD DATETIME2(7)
	,@gwyGatewayACD DATETIME2(7)
	,@gwyCompleted BIT
	,@gatewayUnitId INT
	,@gwyAttachments INT
	,@gwyProcessingFlags NVARCHAR(20)
	,@gwyDateRefTypeId INT
	,@scanner BIT
	,@gwyShipApptmtReasonCode NVARCHAR(20)
	,@gwyShipStatusReasonCode NVARCHAR(20)
	,@gwyOrderType NVARCHAR(20)
	,@gwyShipmentType NVARCHAR(20)
	,@statusId INT
	,@gwyUpdatedById INT
	,@gwyClosedOn DATETIME2(7)
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
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@where NVARCHAR(200) = NULL
	,@isScheduleReschedule BIT = 0
	,@gwyPreferredMethod INT = 0
	,@gwyExceptionTitleId BIGINT = NULL
	,@gwyCargoId BIGINT = NULL
	,@gwyExceptionStatusId BIGINT = NULL
	,@gwyAddtionalComment NVARCHAR(MAX) = NULL
	,@gwyDateCancelled DATETIME2(7) = NULL
	,@gwyCancelOrder BIT = 0
	,@statusCode NVARCHAR(50) = NULL
	,@JobTransitionStatusId INT
	,@isDayLightSavingEnable BIT = 0
	,@isMultiOperation BIT = 0
	,@cargoQuantity DECIMAL(18,2) = NULL
	,@cargoField NVARCHAR(150) = NULL
	,@GwyGatewayText VARCHAR(MAX) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @GtyTypeId INT
		,@endTime TIME
		,@delDay BIT = NULL
		,@GtyGatewayTypeId INT
		,@PickUpDateRefId INT
		,@DeliverUpDateRefId INT
		,@JobGatewayStatus NVARCHAR(50)
		,@updatedItemNumber INT
		,@PODTransitionStatusId INT
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@DeliveredTransitionStatusId INT = 0
		,@WillCallTransitionStatusId INT = 0
		,@sqlCommand NVARCHAR(MAX) = NULL
		,@CustomerId BIGINT
		,@OrderType NVARCHAR(20)
		,@PgdGatewayNavOrderOption INT = NULL

		SELECT @CustomerId = PrgCustId, @ProgramId = Prg.Id
		FROM PRGRM000Master Prg
		INNER JOIN dbo.JOBDL000Master Job ON Job.ProgramID = Prg.Id
		WHERE Job.Id = @JobId

		Select @PgdGatewayNavOrderOption = PgdGatewayNavOrderOption From dbo.PRGRM010Ref_GatewayDefaults 
		Where PgdProgramID = @ProgramId AND PgdGatewayCode = @gwyGatewayCode

	 SELECT TOP 1 @cargoField = CargoField
		FROM JOBDL021GatewayExceptionCode
		WHERE CustomerId = @CustomerId
			AND JgeReferenceCode = @gwyGatewayCode+'-'+@statusCode
			AND ISNULL(CargoField,'')<>''
	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone,@programId = ProgramID,@OrderType = JobType
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

	IF (@gwyExceptionTitleId = 0)
	BEGIN
		SET @gwyExceptionTitleId = NULL
	END

	IF (@gwyCargoId = 0)
	BEGIN
		SET @gwyCargoId = NULL
	END

	IF (@gwyExceptionStatusId = 0)
	BEGIN
		SET @gwyExceptionStatusId = NULL
	END

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

	SELECT @PickUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Pickup Date'

	SELECT @DeliverUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Delivery Date'

	SELECT @GtyTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	SELECT @GtyGatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @PODTransitionStatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'POD Completion'

	SELECT @WillCallTransitionStatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'Will Call'

	SELECT @DeliveredTransitionStatusId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'TransitionStatus'
		AND SysOptionName = 'Delivered'

	IF (@statusId IS NULL)
	BEGIN
		SET @statusId = (
				SELECT TOP 1 ID
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'GatewayStatus'
					AND SysOptionName = 'Active'
				)
	END

	SELECT TOP 1 @delDay = DelDay
	FROM PRGRM000Master
	WHERE ID = (
			SELECT TOP 1 PROGRAMID
			FROM JOBDL000Master
			WHERE ID = @jobId
			)
  -- SET DATETIME IN JOB GATEWAY FROM PROGRAM 
	IF (@isScheduleReschedule = 1)
	BEGIN
		IF (ISNULL(@delDay, 0) = 1)
		BEGIN
			SET @gwyUprDate = @gwyDDPNew
			SET @gwyLwrDate = NULL --@gwyDDPNew
		END
		ELSE IF (
				@gwyUprWindow = NULL
				AND @gwyLwrWindow = NULL
				)
		BEGIN
			SET @gwyUprDate = @gwyDDPNew
			SET @gwyLwrDate = @gwyDDPNew
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
				SET @gwyUprDate = DATEADD(HOUR, CONVERT(INT, @LgwyUprWindow), @gwyDDPNew)

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
				SET @gwyLwrDate = DATEADD(HOUR, CONVERT(INT, @LgwyLwrWindow), @gwyDDPNew)

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
	END

	IF (@programId = 0)
	BEGIN
		SELECT @programId = ProgramID
		FROM JOBDL000Master
		WHERE Id = @jobId;
	END

	DECLARE @currentId BIGINT;

     -- INSERT OPERATION
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
		,[GwyGatewayText]
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
		,CASE 
				WHEN @gwyCompleted = 1
					THEN CASE WHEN ISNULL(@gwyGatewayACD,'') = ''  THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) ELSE @gwyGatewayACD END
				END
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
		,@GwyGatewayText
		)

	SET @currentId = SCOPE_IDENTITY();

	IF (@currentId > 0)
	BEGIN
	    IF(@cargoField IS NOT NULL AND  @cargoQuantity IS NOT NULL AND @gwyCargoId > 0)
		BEGIN 
		    SET @sqlCommand = 'UPDATE JOBDL010Cargo SET ' + @cargoField + ' = ' + CONVERT(NVARCHAR(30),@cargoQuantity) +' WHERE JobID = ' 
			+ CONVERT(NVARCHAR(30),@jobId) + ' AND ID = ' + CONVERT(NVARCHAR(30),@gwyCargoId)
			EXEC sp_executesql @sqlCommand
			IF(ISNULL(@gwyAddtionalComment,'')<>'')
			BEGIN
			UPDATE JOBDL010Cargo SET CgoReasonCodeOSD=LEFT(@gwyAddtionalComment,30)
			WHERE ID =@gwyCargoId AND JobId=@jobId
			END
		END

	    IF(@isMultiOperation = 1) -- if multi gateway will come have to check gateway type
		BEGIN
		  UPDATE gateway SET GwyPerson = job.JobDeliverySitePOC,GwyEmail = job.JobDeliverySitePOCEmail,
		  GwyPhone =job.JobDeliverySitePOCPhone,GwyPreferredMethod = job.JobPreferredMethod 
		  FROM JOBDL020Gateways gateway
		  INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		  WHERE gateway.JobID = @JobID
		  AND gateway.[Id] = @currentId
		END
		UPDATE [JOBDL000Master]
		SET JobPreferredMethod = ISNULL(@gwyPreferredMethod,JobPreferredMethod)
			,JobDeliverySitePOC2 = ISNULL(@gwyPerson,JobDeliverySitePOC2)
			,JobDeliverySitePOCPhone2 = ISNULL(@gwyPhone,JobDeliverySitePOCPhone2)
			,JobDeliverySitePOCEmail2 = ISNULL(@gwyEmail,JobDeliverySitePOCPhone2)
			,ProFlags12 = CASE 
				WHEN @gwyGatewayCode = 'In Transit'
					THEN 'S'
				ELSE ProFlags12
				END
		WHERE Id = @jobId

		IF(@gwyGatewayCode = 'On Hand' OR @gwyGatewayCode = 'DS On Hand' OR @gwyGatewayCode = 'Onhand')
		BEGIN
		UPDATE Cargo
        SET CgoQtyOnHand = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
        ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
        FROM dbo.JobDL010Cargo Cargo
        INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'On Hand') ItemCount ON ItemCount.CargoId = Cargo.Id
		END

		IF(@gwyGatewayCode = 'On Truck' OR @gwyGatewayCode = 'Loaded on Truck' OR @gwyGatewayCode = 'DS On Truck')
		BEGIN
		UPDATE Cargo
        SET CgoQtyExpected = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
        ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
        FROM dbo.JobDL010Cargo Cargo
        INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'On Truck') ItemCount ON ItemCount.CargoId = Cargo.Id
		END

		IF(@gwyGatewayCode = 'Delivered' OR @gwyGatewayCode = 'DS Delivered')
		BEGIN
		UPDATE Cargo
        SET CgoQtyOnHold = CASE WHEN ISNULL(ItemCount.ExceptionCount, 0) <= 0 THEN ItemCount.ActualCount
        ELSE (ISNULL(ItemCount.ActualCount, 0) - ItemCount.ExceptionCount) END
        FROM dbo.JobDL010Cargo Cargo
        INNER JOIN [dbo].[fnGetCargoItemCount](@jobId, 'Delivered') ItemCount ON ItemCount.CargoId = Cargo.Id
		END
	END

	IF (
			@isScheduleReschedule = 1
			AND @gwyGatewayCode <> 'Comment'
			)
	BEGIN
		UPDATE [JOBDL000Master]
		SET JobDeliveryDateTimePlanned = @gwyDDPNew
		WHERE Id = @jobId
	END
	-- GATEWAY TYPE IS GATEWAY TYPE RELATED OPERATION
	IF (@gatewayTypeId = @GtyGatewayTypeId)
	BEGIN
		UPDATE gateway
		SET gateway.GwyGatewayPCD = CASE 
				WHEN @gwyDateRefTypeId = @DeliverUpDateRefId
					AND job.JobDeliveryDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobDeliveryDateTimePlanned)
				WHEN @gwyDateRefTypeId = @PickUpDateRefId
					AND job.JobOriginDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobOriginDateTimePlanned)
				ELSE NULL
				END,
		gateway.GwyOrderType = job.JobType,
		gateway.GwyShipmentType =job.ShipmentType
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @currentId

		UPDATE job
		SET job.JobGatewayStatus = gateway.GwyGatewayCode
			,Job.JobTransitionStatusId = @JobTransitionStatusId
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
		SET job.JobOriginDateTimeActual = gateway.GwyGatewayACD
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @currentId
			AND gateway.GatewayTypeId = @GtyGatewayTypeId
			AND gateway.GwyGatewayCode = 'On Hand'
	END
	ELSE
	BEGIN
		UPDATE [dbo].[JOBDL020Gateways]
		SET GwyGatewayPCD = DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,GwyGatewayECD = DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,GwyGatewayACD = CASE WHEN ISNULL(@gwyGatewayACD, '') = '' THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) ELSE @gwyGatewayACD END
		WHERE JobID = @jobId
			AND [Id] = @currentId

		UPDATE gateway
		SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](ISNULL(GatewayUnitId, 0), ISNULL(GwyGatewayDuration, 0), ISNULL(GwyDDPNew, ISNULL(GwyDDPCurrent, CASE 
							WHEN GwyDateRefTypeId = @PickUpDateRefId
								THEN JobOriginDateTimePlanned
							WHEN GwyDateRefTypeId = @DeliverUpDateRefId
								THEN JobDeliveryDateTimePlanned
							ELSE NULL
							END)))
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @jobId
			AND gateway.GatewayTypeId = @GtyGatewayTypeId
			AND gateway.StatusId = @statusId
	END

	IF (
			(
				(
					@JobTransitionStatusId = @PODTransitionStatusId
					OR @gwyGatewayCode = 'POD Completion'
					)
				OR (
					@JobTransitionStatusId = @WillCallTransitionStatusId
					OR @gwyGatewayCode = 'Will Call'
					)
				) AND @gwyCompleted = 1
			)
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
		SET job.JobDeliveryDateTimeActual = gateway.GwyGatewayACD
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JOBID = @jobId
			AND gateway.ID = @currentId;
	END

	-- GATEWAY TYPE IS ACTION TYPE RELATED OPERATION
IF(@gatewayTypeId = 85 AND @OrderType = 'Return' AND @currentId > 0)
BEGIN
UPDATE job
			SET JobDeliveryDateTimeActual = @gwyGatewayACD,
			JobOriginDateTimeActual = @gwyGatewayACD,
			JobCompleted = 1
			FROM JOBDL020Gateways Gateway
			INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
			WHERE gateway.ID = @currentId;
END

	IF (@gatewayTypeId = 86)
	BEGIN
		IF (@OrderType = 'Return' AND @currentId > 0)
		BEGIN
			UPDATE job
			SET JobOriginDateTimePlanned = CASE WHEN @gwyGatewayCode IN ('Schedule', '3PL Arrival','Schedule Pick Up')
			                               THEN Gateway.GwyDDPCurrent
										   WHEN @gwyGatewayCode Like '%Reschedule%' 
										   THEN Gateway.GwyDDPNew
										   ELSE JobOriginDateTimePlanned END
			   ,JobDeliveryDateTimePlanned = CASE WHEN @gwyGatewayCode IN ('Schedule', '3PL Arrival','Schedule Pick Up')
			                               THEN Gateway.GwyDDPCurrent
										   WHEN @gwyGatewayCode Like '%Reschedule%' 
										   THEN Gateway.GwyDDPNew
										   ELSE JobDeliveryDateTimePlanned END
			FROM JOBDL020Gateways Gateway
			INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
			WHERE gateway.ID = @currentId;
		END

		IF (@gwyGatewayCode = 'Delivery Window')
		BEGIN
			UPDATE JOBDL000Master
			SET JobDeliveryDateTimePlanned = @gwyUprDate
				,WindowDelEndTime = @gwyUprDate
				,WindowDelStartTime = @gwyLwrDate
			WHERE id = @jobId;
		END

		IF (@gwyGatewayCode = 'Canceled')
		BEGIN
			UPDATE JOBDL000Master
			SET JobCompleted = 1
				,IsCancelled = 1
				,StatusId = 2
			WHERE ID = @jobId
		END

		IF (@gwyGatewayCode = 'Schedule' OR @gwyGatewayCode = 'Schedule-NS' OR @gwyGatewayTitle = 'Schedule Pick Up' OR  @gwyGatewayTitle = 'Sched Pick Up')
		BEGIN
			UPDATE JOBDL000Master
			SET JobIsSchedule = 1
			WHERE ID = @jobId
		END

		UPDATE [dbo].[JOBDL020Gateways]
		SET isActionAdded = 1
		WHERE Id = @currentId
	END

	-- SELECT QUERY
	IF (@gwyGatewayCode <> 'Canceled')
	BEGIN
		SELECT @JobGatewayStatus AS JobGatewayStatus
			,JGW.*
			,SO.SysOptionName GwyPreferredMethodName
			,SOW.SysOptionName GatewayTypeIdName
			,Job.JobCustomerSalesOrder ContractNumber
			,Prg.PrgCustId CustomerId
			,@PgdGatewayNavOrderOption PgdGatewayNavOrderOption
		FROM [dbo].[JOBDL020Gateways] JGW
		INNER JOIN JOBDL000Master Job ON Job.Id = JGW.JobId
		INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramId
		LEFT JOIN [SYSTM000Ref_Options] SO ON SO.Id = JGW.GwyPreferredMethod
		LEFT JOIN [SYSTM000Ref_Options] SOW ON SOW.Id = JGW.GatewayTypeId
		WHERE JGW.Id = @currentId;
	END
	ELSE
	BEGIN
		SELECT *
		,@PgdGatewayNavOrderOption PgdGatewayNavOrderOption
		FROM (
			SELECT JG.*,Job.JobCustomerSalesOrder ContractNumber
			FROM [dbo].[JOBDL020Gateways] JG
			INNER JOIN JOBDL000Master Job ON Job.Id = JG.JobId
			WHERE JG.Id = @currentId
			) A
		JOIN (
			SELECT ID AS JobId
				,StatusId AS StaID
				,JobCompleted AS Completed
			FROM JOBDL000Master
			WHERE Id = @jobId
			) B ON A.JobID = B.JobId
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
