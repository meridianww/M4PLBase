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
-- Execution:                 EXEC [dbo].[GetJobActions] 0
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobActions] @jobId BIGINT 
,@entity NVARCHAR(30)
AS
BEGIN TRY
	DECLARE @GatewayTypeId BIGINT
		,@ScheduleActionCount BIGINT = 0

	SELECT @GatewayTypeId = Id
	FROM dbo.[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action';

	IF (@entity = 'JOB')
	BEGIN
		SELECT DISTINCT shipApptCode.PacApptReasonCode
			,shipApptCode.PacApptTitle
			,shipReasonCode.PscShipReasonCode
			,shipReasonCode.PscShipTitle
			,prgGateway.PgdGatewayCode
			,prgGateway.PgdGatewayTitle
			,prgGateway.PgdGatewaySortOrder
			,prg.Id AS ProgramId
		FROM [dbo].[PRGRM000Master] prg
		JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
			AND prgGateway.GatewayTypeId = @GatewayTypeId
			AND prgGateway.[StatusId] = 1
		LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
			AND prg.Id = shipReasonCode.PscProgramID
			AND shipReasonCode.[StatusId] = 1
		LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
			AND prg.Id = shipApptCode.[PacProgramID]
			AND shipApptCode.[StatusId] = 1
		WHERE prg.Id = @jobId
		    AND prgGateway.GatewayTypeId = @GatewayTypeId
			AND prgGateway.PgdGatewayCode NOT IN (
				SELECT PgdGatewayCode
				FROM [PRGRM010Ref_GatewayDefaults]
				WHERE PgdGatewayCode LIKE 'Schedule%'
					OR PgdGatewayCode LIKE 'Reschedule%'
					OR PgdGatewayCode LIKE 'Delivery Window%'
				)
		ORDER BY prgGateway.PgdGatewaySortOrder ASC
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
			AND GwyGatewayCode LIKE 'Schedule%'

		IF (
				@ScheduleActionCount = 0
				OR (
					SELECT Count(*)
					FROM JOBDL020Gateways
					WHERE JobID = @jobId
						AND GwyDDPNew IS NULL
					) = (
					SELECT Count(*)
					FROM JOBDL020Gateways
					WHERE JobID = @jobId
					)
				)
		BEGIN
			SET NOCOUNT ON;

			SELECT DISTINCT shipApptCode.PacApptReasonCode
				,shipApptCode.PacApptTitle
				,shipReasonCode.PscShipReasonCode
				,shipReasonCode.PscShipTitle
				,prgGateway.PgdGatewayCode
				,prgGateway.PgdGatewayTitle
				,prgGateway.PgdGatewaySortOrder
				,prg.Id AS ProgramId
			FROM [dbo].[JOBDL000Master] job
			JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
			JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.[StatusId] = 1
			--AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
			LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
				AND prg.Id = shipReasonCode.PscProgramID
				AND shipReasonCode.[StatusId] = 1
			LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
				AND prg.Id = shipApptCode.[PacProgramID]
				AND shipApptCode.[StatusId] = 1
			WHERE job.Id = @jobId
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.PgdGatewayCode <> 'Delivery Window'
				AND prgGateway.PgdGatewayCode NOT IN (
					SELECT PgdGatewayCode
					FROM [PRGRM010Ref_GatewayDefaults]
					WHERE PgdGatewayCode LIKE 'Reschedule%'
					)
			ORDER BY prgGateway.PgdGatewaySortOrder ASC
		END
		ELSE IF (
				@ScheduleActionCount > 0
				AND (
					SELECT Count(*)
					FROM JOBDL020Gateways
					WHERE JobID = @jobId
						AND GwyDDPNew IS NULL
					) <> (
					SELECT Count(*)
					FROM JOBDL020Gateways
					WHERE JobID = @jobId
					)
				)
		BEGIN
			SET NOCOUNT ON;

			SELECT DISTINCT shipApptCode.PacApptReasonCode
				,shipApptCode.PacApptTitle
				,shipReasonCode.PscShipReasonCode
				,shipReasonCode.PscShipTitle
				,prgGateway.PgdGatewayCode
				,prgGateway.PgdGatewayTitle
				,prgGateway.PgdGatewaySortOrder
				,prg.Id AS ProgramId
			FROM [dbo].[JOBDL000Master] job
			JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
			JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.[StatusId] = 1
			--AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
			LEFT JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode
				AND prg.Id = shipReasonCode.PscProgramID
				AND shipReasonCode.[StatusId] = 1
			LEFT JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode]
				AND prg.Id = shipApptCode.[PacProgramID]
				AND shipApptCode.[StatusId] = 1
			WHERE job.Id = @jobId
				AND prgGateway.GatewayTypeId = @GatewayTypeId
				AND prgGateway.PgdGatewayCode NOT IN (
					SELECT PgdGatewayCode
					FROM [PRGRM010Ref_GatewayDefaults]
					WHERE PgdGatewayCode LIKE 'Schedule%'
					)
			ORDER BY prgGateway.PgdGatewaySortOrder ASC
		END
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

