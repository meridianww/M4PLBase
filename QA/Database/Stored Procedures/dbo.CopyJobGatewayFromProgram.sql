SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Sanyogita Pandey               
-- Create date:               11/16/2018              
-- Description:              Copy Job gateway from program        
-- Execution:                 EXEC [dbo].[CopyJobGatewayFromProgram]    37083,20129,null,null,2     
-- Modified on:                     
-- Modified Desc:          
-- =============================================              
ALTER PROCEDURE [dbo].[CopyJobGatewayFromProgram] (
	@JobID BIGINT
	,@ProgramID BIGINT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@userId BIGINT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @OrderType NVARCHAR(20)
		,@ShipmentType NVARCHAR(20)
		,@StatusId INT
		,@GatewayTypeId INT
		,@GwyUprWindow DECIMAL
		,@GwyLwrWindow DECIMAL
		,@Counter INT = 1
		,@Count INT
		,@CurrentJobId BIGINT
		,@CurrentGatewayType INT
		,@CurrentGwyOrderType NVARCHAR(20)
		,@CurrentGwyShipmentType NVARCHAR(20)
		,@copiedProgramGatewayId BIGINT
		,@GatewayTypeIdForPickUp INT
		,@GatewayTypeIdForDeliver INT
		,@ProgramDatereferenceID INT
		,@updatedGatewayId BIGINT

	SELECT @GwyUprWindow = DelLatest
		,@GwyLwrWindow = DelEarliest
	FROM PRGRM000Master
	WHERE Id = @ProgramID
		AND DelEarliest IS NOT NULL

	SELECT @OrderType = JobType
		,@ShipmentType = ShipmentType
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobID

	SELECT @StatusId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Active'
		AND [SysLookupCode] = 'GatewayStatus'

	SELECT @GatewayTypeId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Gateway'
		AND [SysLookupCode] = 'GatewayType'

	SELECT @GatewayTypeIdForPickUp = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Pickup Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

	SELECT @GatewayTypeIdForDeliver = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Delivery Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

	UPDATE [dbo].[JOBDL020Gateways]
	SET StatusId = @StatusId
	WHERE JobID = @JobID
		AND ProgramID = @ProgramID

	SELECT @copiedProgramGatewayId = MAX(Id)
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdGatewayDefault = 1
		AND PgdProgramID = @programId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND GatewayTypeId = @GatewayTypeId
		AND PgdGatewayCode = 'IN TRANSIT'
		AND PgdGatewaySortOrder = 1
		AND StatusId = 1

	UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]
	SET PgdGatewayDefaultComplete = 1
		,@ProgramDatereferenceID = GatewayDateRefTypeId
	WHERE Id = @copiedProgramGatewayId

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
		,GwyUprWindow
		,GwyLwrWindow
		,GwyCompleted
		,GwyGatewayACD
		)
	SELECT @JobID
		,prgm.[PgdProgramID]
		,ROW_NUMBER() OVER (
			ORDER BY prgm.[PgdGatewaySortOrder]
			)
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
		,194 --prgm.[StatusId]     given 194 as gateway status lookup's 'Active' status id            
		,@dateEntered
		,@enteredBy
		,@GwyUprWindow
		,@GwyLwrWindow
		,prgm.[PgdGatewayDefaultComplete]
		,GETUTCDATE()
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID
	WHERE prgm.Id = @copiedProgramGatewayId
		AND job.Id = @JobID

	SET @updatedGatewayId = SCOPE_IDENTITY()
	IF(@updatedGatewayId > 0)
	BEGIN
		UPDATE gateway
		SET GwyGatewayPCD = CASE 
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForDeliver
					AND job.JobDeliveryDateTimeBaseline IS NULL
					THEN NULL
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForDeliver
					AND job.JobDeliveryDateTimeBaseline IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, ISNULL(GwyGatewayDuration, 0), job.JobDeliveryDateTimeBaseline)
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForPickUp
					AND job.JobOriginDateTimeBaseline IS NULL
					THEN NULL
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForPickUp
					AND job.JobOriginDateTimeBaseline IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, ISNULL(GwyGatewayDuration, 0), job.JobOriginDateTimeBaseline)
				END
			,GwyGatewayECD = CASE 
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForPickUp
					THEN job.JobOriginDateTimeBaseline
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForDeliver
					THEN job.JobDeliveryDateTimeBaseline
				END
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.id = @updatedGatewayId

	   UPDATE job SET job.JobGatewayStatus = gateway.StatusId	
	    FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.id = @updatedGatewayId
		END

	CREATE TABLE #GatewayType (
		Id INT IDENTITY(1, 1)
		,JobId BIGINT
		,GatewayTypeId INT
		,GwyOrderType NVARCHAR(20)
		,GwyShipmentType NVARCHAR(20)
		)

	INSERT INTO #GatewayType (
		JobId
		,GatewayTypeId
		,GwyOrderType
		,GwyShipmentType
		)
	SELECT DISTINCT JobId
		,GatewayTypeId
		,GwyOrderType
		,GwyShipmentType
	FROM dbo.JOBDL020Gateways
	WHERE JobId = @JobID

	SELECT @Count = ISNULL(Count(Id), 0)
	FROM #GatewayType

	IF (@Count > 0)
	BEGIN
		WHILE (@Count > 0)
		BEGIN
			SELECT @CurrentJobId = JobId
				,@CurrentGatewayType = GatewayTypeId
				,@CurrentGwyOrderType = GwyOrderType
				,@CurrentGwyShipmentType = GwyShipmentType
			FROM #GatewayType
			WHERE Id = @Counter

			EXEC [dbo].[UpdateLineNumberForJOBDL020Gateways] @CurrentJobId
				,@CurrentGatewayType
				,@CurrentGwyOrderType
				,@CurrentGwyShipmentType

			SET @Count = @Count - 1
			SET @Counter = @Counter + 1
		END
	END

	DROP TABLE #GatewayType
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

