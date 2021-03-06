SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- ===========================================================================       
-- Author:                    Kamal        
-- Create date:               02/26/2020      
-- Execution:                 EXEC [dbo].[GetJobGatewayFromProgram]  126881,2,0,'On Hand'
-- Modified on:                     
-- Modified Desc:          
-- Description:               Get Job not completed job gateway from program
-- ============================================================================
CREATE PROCEDURE [dbo].[GetJobGatewayFromProgram] @jobId BIGINT
	,@userId BIGINT
	,@isDayLightSavingEnable BIT = 0
	,@gatewayCode NVARCHAR(150) = NULL
	,@jobIds NVARCHAR(MAX) = NULL
	,@isMultiJob BIT =0
AS
BEGIN
		IF(@isMultiJob = 1)
			BEGIN
			   DECLARE @CountGatewayStatus INT = 0, @JobTypeCount INT = 0, @ShipmentTypeCount INT = 0;
			   DECLARE @TempJobIds AS TABLE (JobId BIGINT)
				INSERT INTO @TempJobIds
					SELECT Item
					FROM fnSplitString(@jobIds, ',')
				SELECT @CountGatewayStatus = COUNT(DISTINCT JobGatewayStatus), 
						@JobTypeCount = COUNT(DISTINCT JobType),
						@ShipmentTypeCount=COUNT(DISTINCT ShipmentType) 
						FROM JOBDL000Master JOB INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
				IF(@CountGatewayStatus =1 AND @JobTypeCount = 1 AND @ShipmentTypeCount = 1)
				BEGIN
					SET @JobID =(SELECT TOP 1 JobId FROM @TempJobIds)					
				END
				ELSE
				BEGIN
				  SET @JobID = 0
				END
			END

IF(ISNULL(@gatewayCode, '') = '')
BEGIN
EXEC [dbo].[GetJobGatewayContextMenu]  @jobId
END
ELSE
BEGIN
	DECLARE @GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		,@ProgramId BIGINT
		,@DeliveryUTCValue INT
		,@OriginUTCValue INT
		,@jobDeliveryTimeZone NVARCHAR(15)
		,@jobOriginTimeZone NVARCHAR(15)
		,@CustomerId BIGINT
		,@JobOriginDateTimeBaseline DateTime2(7)
		,@JobOriginDateTimePlanned  DateTime2(7)
		,@JobOriginDateTimeActual  DateTime2(7)
		,@JobDeliveryDateTimeBaseline DateTime2(7)
		,@JobDeliveryDateTimePlanned DateTime2(7)
		,@JobDeliveryDateTimeActual DateTime2(7)
		 
	IF OBJECT_ID('tempdb..#ProgramGateway') IS NOT NULL
		DROP TABLE #ProgramGateway

	SELECT @JobDeliveryTimeZone = JobDeliveryTimeZone
		,@jobOriginTimeZone = JobOriginTimeZone
		,@GatewayOrderType = JobType
		,@GatewayShipmentType = ShipmentType
		,@ProgramId = ProgramId
		,@JobOriginDateTimeBaseline = JobOriginDateTimeBaseline
		,@JobOriginDateTimePlanned = JobOriginDateTimePlanned
		,@JobOriginDateTimeActual = JobOriginDateTimeActual
		,@JobDeliveryDateTimeBaseline = JobDeliveryDateTimeBaseline
		,@JobDeliveryDateTimePlanned = JobDeliveryDateTimePlanned
		,@JobDeliveryDateTimeActual = JobDeliveryDateTimeActual
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId

	SELECT MappingId
		,PgdGatewayCode
		,PgdProgramID
		,Id
		,PgdGatewayTitle
		,PgdGatewayDuration
		,UnitTypeId
		,PgdGatewayDefault
		,GatewayTypeId
		,GatewayDateRefTypeId
		,Scanner
		,PgdShipApptmtReasonCode
		,PgdShipStatusReasonCode
		,PgdOrderType
		,PgdShipmentType
		,PgdGatewayResponsible
		,PgdGatewayAnalyst
		,StatusId
		,PgdGatewayDefaultComplete
		,TransitionStatusId
		,PgdGatewaySortOrder
	INTO #ProgramGateway
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdProgramID = @ProgramId AND StatusId = 1 AND PgdOrderType = @GatewayOrderType AND PgdShipmentType = @GatewayShipmentType AND GatewayTypeId = 85
	AND PgdGatewayDefault = 1

	Select @CustomerId = Id From PRGRM000Master Where Id = @ProgramId
SELECT TOP 1 @DeliveryUTCValue = CASE 
		WHEN IsDayLightSaving = 1
			AND @isDayLightSavingEnable = 1
			THEN UTC + 1
		ELSE UTC
		END
FROM Location000Master
WHERE TimeZoneShortName = CASE 
		WHEN ISNULL(@JobDeliveryTimeZone, 'Unknown') = 'Unknown'
			THEN 'Pacific'
		ELSE @JobDeliveryTimeZone
		END

SELECT TOP 1 @OriginUTCValue = CASE 
		WHEN IsDayLightSaving = 1
			AND @isDayLightSavingEnable = 1
			THEN UTC + 1
		ELSE UTC
		END
FROM Location000Master
WHERE TimeZoneShortName = CASE 
		WHEN ISNULL(@jobOriginTimeZone, 'Unknown') = 'Unknown'
			THEN 'Pacific'
		ELSE @jobOriginTimeZone
		END	
			SELECT @jobId AS JobID
				,prgm.[PgdProgramID] AS ProgramID
				,prgm.[PgdGatewayCode] AS GwyGatewayCode
				,prgm.[PgdGatewayTitle] AS GwyGatewayTitle
				,prgm.[PgdGatewayDuration] AS GwyGatewayDuration
				,prgm.[UnitTypeId] AS GatewayUnitId
				,prgm.[PgdGatewayDefault] AS GwyGatewayDefault
				,prgm.[GatewayTypeId] AS GatewayTypeId
				,prgm.[GatewayDateRefTypeId] AS GwyDateRefTypeId
				,prgm.[Scanner] AS Scanner
				,prgm.[PgdShipApptmtReasonCode] AS GwyShipApptmtReasonCode
				,prgm.[PgdShipStatusReasonCode] AS GwyShipStatusReasonCode
				,prgm.[PgdOrderType] AS GwyOrderType
				,prgm.[PgdShipmentType] AS GwyShipmentType
				,prgm.[PgdGatewayResponsible] AS GwyGatewayResponsible
				,prgm.[PgdGatewayAnalyst] AS GwyGatewayAnalyst
				,prgm.[PgdGatewayDefaultComplete]
				,prgm.[StatusId] AS StatusId
				,@JobOriginDateTimeBaseline JobOriginDateTimeBaseline
				,@JobOriginDateTimePlanned  JobOriginDateTimePlanned
				,@JobOriginDateTimeActual   JobOriginDateTimeActual
				,@JobDeliveryDateTimeBaseline JobDeliveryDateTimeBaseline
				,@JobDeliveryDateTimePlanned JobDeliveryDateTimePlanned
				,@JobDeliveryDateTimeActual  JobDeliveryDateTimeActual
				,ISNULL(PgdGatewayDefaultComplete, 0) AS GwyCompleted
				,@CustomerId CustomerId
				,prgm.TransitionStatusId JobTransitionStatusId
				,@DeliveryUTCValue DeliveryUTCValue
				,@OriginUTCValue OriginUTCValue
			FROM #ProgramGateway prgm
			Where prgm.[PgdGatewayCode] = @gatewayCode
END
END
GO
