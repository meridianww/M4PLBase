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
CREATE PROCEDURE [dbo].[CopyJobGatewayFromProgram] (
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

	SELECT @GwyUprWindow = DelLatest,@GwyLwrWindow =DelEarliest
   FROM PRGRM000Master WHERE Id = @ProgramID and DelEarliest IS NOT NULL

	SELECT @OrderType = JobType
		,@ShipmentType = ShipmentType
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobID

	Select @StatusId = Id FROM [dbo].[SYSTM000Ref_Options] 
	Where SysOptionName='Archive' AND [SysLookupCode] = 'GatewayStatus'

	Select @GatewayTypeId = Id FROM [dbo].[SYSTM000Ref_Options] 
	Where SysOptionName='Gateway' AND [SysLookupCode] = 'GatewayType'

	UPDATE [dbo].[JOBDL020Gateways] SET StatusId = @StatusId 
	Where JobID = @JobID  AND ProgramID = @ProgramID

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
		--,GwyLwrDate
		--,GwyUprDate
		,GwyUprWindow
		,GwyLwrWindow
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
		,job.JobDeliveryDateTimePlanned
		,job.JobDeliveryDateTimeBaseline
		--,@StartDate
		--,@EndDate
		,@GwyUprWindow
		,@GwyLwrWindow
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	INNER JOIN [dbo].[JOBDL000Master] job on prgm.[PgdProgramID] = job.ProgramID
	WHERE PgdGatewayDefault = 1
		AND prgm.PgdProgramID = @programId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND job.Id = @JobID
		AND prgm.GatewayTypeId =@GatewayTypeId
	ORDER BY prgm.[PgdGatewaySortOrder];

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

            EXEC [dbo].[UpdateLineNumberForJOBDL020Gateways] @CurrentJobId,@CurrentGatewayType,@CurrentGwyOrderType,@CurrentGwyShipmentType
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
