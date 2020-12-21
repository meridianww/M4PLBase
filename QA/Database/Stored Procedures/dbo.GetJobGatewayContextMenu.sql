SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- ===========================================================================       
-- Author:                    Kamal        
-- Create date:               02/26/2020      
-- Execution:                 EXEC [dbo].[GetJobGatewayContextMenu]  126881,2  
-- Modified on:                     
-- Modified Desc:          
-- Description:               Get Job not completed job gateway from program
-- ============================================================================
ALTER PROCEDURE [dbo].[GetJobGatewayContextMenu] @jobId BIGINT
AS
BEGIN
	DECLARE @GtyGatewayId INT
		,@GatewayOrderType VARCHAR(20)
		,@GatewayShipmentType VARCHAR(20)
		,@CurretGatewayItemNumber INT
		,@ProgramId BIGINT
		,@GatewayCompleted BIT = 0
		,@CurrentGatewayCode NVARCHAR(20)
		,@MappingIds NVARCHAR(100)


   SELECT @GatewayOrderType = JobType
		,@GatewayShipmentType = ShipmentType
		,@ProgramId = ProgramId
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId AND JobCompleted = 0

	Select TOP 1 @GatewayCompleted = GwyCompleted, @CurrentGatewayCode = GwyGatewayCode 
	From dbo.JOBDL020Gateways
	WHERE JobId = @JobId
	AND GwyOrderType = @GatewayOrderType
	AND GwyShipmentType = @GatewayShipmentType
	AND GatewayTypeId = 85
	AND StatusId IN (194,195) Order BY ID DESC

	IF OBJECT_ID('tempdb..#ProgramGateway') IS NOT NULL
		DROP TABLE #ProgramGateway

		SELECT MappingId
		,PgdGatewayCode
		,PgdProgramID
		,Id
		,PgdGatewayTitle
	INTO #ProgramGateway
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdProgramID = @ProgramId AND StatusId = 1 AND PgdOrderType = @GatewayOrderType AND PgdShipmentType = @GatewayShipmentType AND GatewayTypeId = 85
	AND PgdGatewayDefault = 1

	IF (@GatewayCompleted = 1)
	BEGIN	
		SELECT @MappingIds = MappingId
		FROM #ProgramGateway
		WHERE PgdGatewayCode = @CurrentGatewayCode

		IF (ISNULL(@MappingIds, '') <> '')
		BEGIN
			SELECT @jobId AS JobID
				,prgm.[PgdGatewayCode] AS GwyGatewayCode
				,prgm.[PgdGatewayTitle] AS GwyGatewayTitle
			FROM #ProgramGateway prgm
			INNER JOIN [dbo].[fnSplitString](@MappingIds, ',') res ON res.Item = prgm.Id
		END
	END
END
GO

