SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        

-- Author:                    Kamal         
-- Create date:               03/11/2019      
-- Description:               Get all job Actions
-- Execution:                 EXEC [dbo].[GetJobActions] 248582, 'jobgateway', 0
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetJobActions] @jobId BIGINT
	,@entity NVARCHAR(30)
	,@isScheduleAciton BIGINT = NULL
AS
BEGIN
	DECLARE @GatewayTypeId BIGINT
		,@ScheduleActionCount BIGINT = 0
		,@ShipmentType NVARCHAR(40)
		,@OrderType NVARCHAR(40)
		,@ProgramId BIGINT

	SELECT @GatewayTypeId = Id
	FROM dbo.[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action';

		/* Commenting this part based on Nathan's comments  */
	SELECT
		  @OrderType = JobType
	     --,@ShipmentType = ShipmentType		
		--,@ProgramId = ProgramID
	FROM JOBDL000Master
	WHERE ID = @jobId

	IF (
			@entity = 'JOB'
			OR @entity = 'JOBCARD'
			)
	BEGIN
		DECLARE @IsCargoLebelException BIT = 0

		IF EXISTS (
				SELECT 1
				FROM JOBDL021GatewayExceptionCode
				WHERE CustomerId = (
						SELECT PrgCustID
						FROM PRGRM000Master
						WHERE ID = @ProgramId
						)
					AND IsCargoRequired = 1
				)
		BEGIN
			SET @IsCargoLebelException = 1
		END

		DECLARE @TempActionCode AS TABLE (PgdGatewayCode VARCHAR(20),PgdGatewayTitle VARCHAR(100))

		INSERT INTO @TempActionCode
		SELECT PgdGatewayCode,PgdGatewayTitle
		FROM [PRGRM010Ref_GatewayDefaults]
		WHERE (
				(@isScheduleAciton IS NULL)
				AND (
					PgdGatewayCode LIKE 'Schedule%'
					OR PgdGatewayCode LIKE 'Reschedule%'
					OR PgdGatewayCode LIKE 'Delivery Window%'
					OR (
						PgdGatewayCode LIKE CASE 
							WHEN @IsCargoLebelException = 1
								THEN 'Exception%'
							ELSE NULL
							END
						)
					)
				)
			OR (
				(@isScheduleAciton = 1)
				AND (
				    	PgdGatewayCode IN (
							'Schedule-NS'
							,'Schedule'
							,'XCBL-Schedule New'
							,'XCBL-Schedule'
							,'xCBL-Schedule Change'
							,'Sched Pick Up'
							)			
					OR (
						PgdGatewayCode LIKE CASE 
							WHEN @IsCargoLebelException = 1
								THEN 'Exception%'
							ELSE NULL
							END
						)
					)
				)
			OR (
				(@isScheduleAciton = 0)
				AND (
					PgdGatewayCode LIKE 'Reschedule%'
					OR PgdGatewayCode LIKE 'Delivery Window%'			
					OR (
						PgdGatewayCode LIKE CASE 
							WHEN @IsCargoLebelException = 1
								THEN 'Exception%'
							ELSE NULL
							END
						)
					)
				)

		SELECT DISTINCT 
			-- shipApptCode.PacApptReasonCode
			--,shipApptCode.PacApptTitle
			--,shipReasonCode.PscShipReasonCode
			--,shipReasonCode.PscShipTitle
			 prgGateway.PgdGatewayCode
			,prgGateway.PgdGatewayTitle
			--,prgGateway.PgdGatewaySortOrder
			,prg.Id AS ProgramId
		FROM [dbo].[JOBDL000Master] job
		INNER JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
		INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
			AND prgGateway.GatewayTypeId = @GatewayTypeId
			AND prgGateway.[StatusId] = 1
		--LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
		--	AND prg.Id = shipReasonCode.PscProgramID
		--	AND shipReasonCode.[StatusId] = 1
		--LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
		--	AND prg.Id = shipApptCode.[PacProgramID]
		--	AND shipApptCode.[StatusId] = 1
		LEFT JOIN @TempActionCode TEM ON TEM.PgdGatewayCode = prgGateway.PgdGatewayCode
		WHERE job.Id = @jobId
			AND prgGateway.GatewayTypeId = @GatewayTypeId
			--AND prgGateway.PgdShipmentType = @ShipmentType
			--AND prgGateway.PgdOrderType = @OrderType
			AND TEM.PgdGatewayCode IS NULL
			AND TEM.PgdGatewayTitle NOT IN( CASE WHEN @OrderType = 'RETURN' THEN 'Initial Appointment'
												           WHEN @OrderType = 'Original' THEN 'Scheduled Pick Up'
														   ELSE '' END)
		--ORDER BY prgGateway.PgdGatewaySortOrder ASC
			--TODO: Exception:- Based on client feed back need to add the logic
	END
	ELSE
	BEGIN
		SELECT @ScheduleActionCount = COUNT(ID)
		FROM JOBDL020Gateways
		WHERE JobID = @jobId
			AND StatusId = (
				SELECT ID
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'GatewayStatus'
					AND SysOptionName = 'Active'
				)
			AND (
				GwyGatewayCode IN ('Schedule','XCBL-Schedule','Schedule Pick Up')
				OR GwyGatewayTitle IN ('xCBL Schedule','xCBL Schedule Change','Scheduled Pick Up')
				)

		IF (@ScheduleActionCount = 0)
		BEGIN
			SET NOCOUNT ON;

			SELECT DISTINCT 
				-- shipApptCode.PacApptReasonCode
				--,shipApptCode.PacApptTitle
				--,shipReasonCode.PscShipReasonCode
				--,shipReasonCode.PscShipTitle
				 prgGateway.PgdGatewayCode
				,prgGateway.PgdGatewayTitle
				--,prgGateway.PgdGatewaySortOrder
				,prg.Id AS ProgramId
			FROM [dbo].[JOBDL000Master] job
			INNER JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
			INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.[StatusId] = 1
			--AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
			--LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
			--	AND prg.Id = shipReasonCode.PscProgramID
			--	AND shipReasonCode.[StatusId] = 1
			--LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
			--	AND prg.Id = shipApptCode.[PacProgramID]
			--	AND shipApptCode.[StatusId] = 1
			WHERE job.Id = @jobId
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				--AND prgGateway.PgdShipmentType = @ShipmentType
				--AND prgGateway.PgdOrderType = @OrderType
				AND prgGateway.PgdGatewayTitle NOT IN( CASE WHEN @OrderType = 'RETURN' THEN 'Initial Appointment'
												           WHEN @OrderType = 'Original' THEN 'Scheduled Pick Up'
														   ELSE '' END)
				AND prgGateway.PgdGatewayCode <> 'Delivery Window'
				AND prgGateway.PgdGatewayCode NOT IN (
					SELECT PgdGatewayCode
					FROM [PRGRM010Ref_GatewayDefaults]
					WHERE PgdGatewayCode LIKE 'Reschedule%'
					)
			--ORDER BY prgGateway.PgdGatewaySortOrder ASC
		END
		ELSE IF (@ScheduleActionCount > 0)
		BEGIN
			SET NOCOUNT ON;

			SELECT DISTINCT 
				-- shipApptCode.PacApptReasonCode
				--,shipApptCode.PacApptTitle
				--,shipReasonCode.PscShipReasonCode
				--,shipReasonCode.PscShipTitle
				 prgGateway.PgdGatewayCode
				,prgGateway.PgdGatewayTitle
				--,prgGateway.PgdGatewaySortOrder
				,prg.Id AS ProgramId
			FROM [dbo].[JOBDL000Master] job
			JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
			JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.[StatusId] = 1
			--AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
			--LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
			--	AND prg.Id = shipReasonCode.PscProgramID
			--	AND shipReasonCode.[StatusId] = 1
			--LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
			--	AND prg.Id = shipApptCode.[PacProgramID]
			--	AND shipApptCode.[StatusId] = 1
			WHERE job.Id = @jobId
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				--AND prgGateway.PgdShipmentType = @ShipmentType
				--AND prgGateway.PgdOrderType = @OrderType
				AND prgGateway.PgdGatewayCode NOT IN (
					SELECT DISTINCT PgdGatewayCode
					FROM [PRGRM010Ref_GatewayDefaults]
					WHERE (PgdGatewayCode LIKE 'Schedule%' OR  PgdGatewayCode LIKE 'XCBL-Schedule%')
				)
			--ORDER BY prgGateway.PgdGatewaySortOrder ASC
		END
	END
END
GO
