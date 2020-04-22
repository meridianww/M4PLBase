SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- ===========================================================================       
-- Author:                    Kamal        
-- Create date:               02/26/2020      
-- Execution:                 EXEC [dbo].[GetJobGatewayFromProgram]  126958,2  
-- Modified on:                     
-- Modified Desc:          
-- Description:               Get Job not completed job gateway from program
-- ============================================================================
ALTER PROCEDURE GetJobGatewayFromProgram @jobId BIGINT
	,@userId BIGINT
AS
BEGIN
	DECLARE @GtyGatewayId INT
		,@GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		,@CurretGatewayItemNumber INT
		,@ProgramId BIGINT
		,@StatusId INT
		,@GatewayCompleted BIT = 0

	SELECT @GtyGatewayId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE [SysLookupCode] = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @StatusId = Id
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
						AND GatewayTypeId = @GtyGatewayId
					)
			)

	IF (@GatewayCompleted = 1)
	BEGIN
		SELECT @GatewayOrderType = JobType
			,@GatewayShipmentType = ShipmentType
			,@ProgramId = ProgramID
		FROM dbo.JOBDL000Master
		WHERE Id = @jobId

		SELECT @CurretGatewayItemNumber = COUNT(Id) + 1
		FROM [dbo].[JOBDL020Gateways]
		WHERE JobId = @jobId
			AND GwyOrderType = @GatewayOrderType
			AND GwyShipmentType = @GatewayShipmentType
			AND GatewayTypeId = @GtyGatewayId
			AND StatusId = @StatusId

		PRINT @CurretGatewayItemNumber

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
			,job.JobOriginDateTimeBaseline
			,job.JobOriginDateTimePlanned
			,job.JobOriginDateTimeActual
			,JobDeliveryDateTimeBaseline
			,JobDeliveryDateTimePlanned
			,job.JobDeliveryDateTimeActual
			,ISNULL(PgdGatewayDefaultComplete, 0) AS GwyCompleted
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