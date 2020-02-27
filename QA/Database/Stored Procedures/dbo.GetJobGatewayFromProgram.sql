SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- ===========================================================================       
-- Author:                    Kamal        
-- Create date:               02/26/2020      
-- Execution:                 EXEC [dbo].[GetJobGatewayFromProgram]  102902,14  
-- Modified on:                     
-- Modified Desc:          
-- Description:               Get Job not completed job gateway from program
-- ============================================================================
CREATE PROCEDURE GetJobGatewayFromProgram @jobId BIGINT
	,@userId BIGINT
AS
BEGIN
	DECLARE @GtyGatewayId INT
		,@GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		,@CurretGatewayItemNumber INT
		,@ProgramId BIGINT
		,@StatusID INT
		,@GatewayCompleted BIT = 0

	SELECT @GtyGatewayId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE [SysLookupCode] = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SET @GatewayCompleted = (
			SELECT GwyCompleted
			FROM [JOBDL020Gateways]
			WHERE ID = (
					SELECT MAX(ID)
					FROM [JOBDL020Gateways]
					WHERE JobID = @jobId
						AND GatewayTypeId = @GtyGatewayId
					)
			)

	IF (@GatewayCompleted = 1)
	BEGIN
		SELECT @StatusID = Id
		FROM [dbo].[SYSTM000Ref_Options]
		WHERE [SysLookupCode] = 'GatewayStatus'
			AND SysOptionName = 'Active'

		SELECT @GatewayOrderType = JobType
			,@GatewayShipmentType = ShipmentType
			,@ProgramId = ProgramID
		FROM dbo.JOBDL000Master
		WHERE Id = @jobId

			SELECT @CurretGatewayItemNumber = ISNULL(Max(GwyGatewaySortOrder), 0) + 1
			FROM [dbo].[JOBDL020Gateways]
			WHERE JobId = @jobId
				AND GwyOrderType = @GatewayOrderType
				AND GwyShipmentType = @GatewayShipmentType
				AND StatusId = @StatusID
				AND GatewayTypeId = @GtyGatewayId

				print @CurretGatewayItemNumber

		SELECT prgm.[PgdGatewayCode]
			,prgm.[PgdGatewayTitle]
			,prgm.PgdShipApptmtReasonCode AS PacApptReasonCode
			,prgm.PgdShipStatusReasonCode AS PscShipReasonCode
		FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
		INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = prgm.PgdProgramID
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
		INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID
			AND job.Id = @jobId
		WHERE prgm.PgdProgramID = @ProgramId
			AND prgm.[PgdGatewaySortOrder] = @CurretGatewayItemNumber
			AND prgm.PgdOrderType = @GatewayOrderType
			AND prgm.PgdShipmentType = @GatewayShipmentType
			AND prgm.GatewayTypeId = @GtyGatewayId
			AND prgm.PgdGatewayDefault = 1
			AND prgm.StatusId = 1
	END
END