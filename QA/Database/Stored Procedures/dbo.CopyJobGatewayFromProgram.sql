 
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
			,@StartDate DATETIME2
			,@EndDate DATETIME2 
			,@DelEarliestHours INT 
			,@DelEarliestMiutes INT
			,@DelLatestHours INT 
			,@DelLatestMinutes INT
	SELECT @DelEarliestHours = Left(CASE WHEN DelEarliest = NULL THEN 0.00 ELSE DelEarliest END, CharIndex('.',CASE WHEN DelEarliest = NULL THEN 0.00 ELSE DelEarliest END)-1),
		   @DelEarliestMiutes = RIGHT(CASE WHEN DelEarliest = NULL THEN 0.00 ELSE DelEarliest END, len(CASE WHEN DelEarliest = NULL THEN 0.00 ELSE DelEarliest END) - CharIndex('.',CASE WHEN DelEarliest = NULL THEN 0.00 ELSE DelEarliest END)) 
		   FROM PRGRM000Master WHERE Id = @ProgramID and DelEarliest IS NOT NULL
	SELECT @DelLatestHours = Left(CASE WHEN DelLatest = NULL THEN 0.00 ELSE DelLatest END, CharIndex('.',CASE WHEN DelLatest = NULL THEN 0.00 ELSE DelLatest END)-1),
		   @DelLatestMinutes = RIGHT(CASE WHEN DelLatest = NULL THEN 0.00 ELSE DelLatest END, len(CASE WHEN DelLatest = NULL THEN 0.00 ELSE DelLatest END) - CharIndex('.',CASE WHEN DelLatest = NULL THEN 0.00 ELSE DelLatest END)) 
		   FROM PRGRM000Master WHERE Id=@ProgramID and DelLatest IS NOT NULL 

	UPDATE PRGRM000Master
	SET @StartDate = CASE WHEN DelDay= 0 THEN DATEADD(mi,CASE WHEN @DelEarliestHours > 0 THEN @DelEarliestMiutes ELSE -1 *(Abs(@DelEarliestMiutes))  END,DATEADD(hh,@DelEarliestHours,PrgDeliveryTimeDefault)) ELSE null END,
		@EndDate =   CASE WHEN DelDay= 0 THEN DATEADD(mi,CASE WHEN @DelLatestHours > 0 THEN @DelLatestMinutes ELSE  -1 *(Abs(@DelLatestMinutes)) END,DATEADD(hh,@DelLatestHours,PrgDeliveryTimeDefault))  ELSE PrgDeliveryTimeDefault END
		
	WHERE Id=@ProgramID	
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
		,GwyLwrDate
		,GwyUprDate
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
		,@StartDate
		,@EndDate
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
