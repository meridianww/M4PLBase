SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal             
-- Create date:               04/14/2020             
-- Description:              ArchiveJobGatewayForXcBL
--  EXEC [dbo].[CopyJobGatewayFromProgramForXcBL] 127199,10014,'XCBL-GPS Coordinate',NULL,'nfujomoto',2
-- =============================================             
CREATE PROCEDURE [dbo].[CopyJobGatewayFromProgramForXcBL] (
	@JobID BIGINT
	,@ProgramID BIGINT
	,@GwyGatewayCode NVARCHAR(50)
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
		,@Count INT = 0
		,@CurrentJobId BIGINT = 0
		,@CurrentGatewayType INT = 0
		,@CurrentGwyOrderType NVARCHAR(20)
		,@CurrentGwyShipmentType NVARCHAR(20)
		,@copiedProgramGatewayId BIGINT = 0
		,@GatewayTypeIdForPickUp INT = 0
		,@GatewayTypeIdForDeliver INT = 0
		,@ProgramDatereferenceID INT = 0
		,@updatedGatewayId BIGINT = 0
		,@GatewayType VARCHAR(20) = 'Action'
		,@SortOrder INT = 0
		,@GatewayTypeIdForGateway INT

			SELECT @GatewayTypeIdForGateway = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Gateway'
		AND [SysLookupCode] = 'GatewayType'

	IF EXISTS (
			SELECT 1
			FROM dbo.JobUpdateDecisionmaker
			WHERE ActionCode = @GwyGatewayCode
				AND xCBLTablename = 'UserDefinedField'
			)
	BEGIN
		SET @GatewayType = 'Gateway'
	END

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
	WHERE SysOptionName = @GatewayType
		AND [SysLookupCode] = 'GatewayType'

	SELECT @GatewayTypeIdForPickUp = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Pickup Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

	SELECT @GatewayTypeIdForDeliver = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Delivery Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

	SELECT @copiedProgramGatewayId = MAX(Id)
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE
		--PgdGatewayDefault = 1 AND
		PgdProgramID = @programId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND GatewayTypeId = @GatewayTypeId
		AND PgdGatewayCode = @GwyGatewayCode
		AND StatusId = 1

	SELECT @ProgramDatereferenceID = GatewayDateRefTypeId
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE Id = @copiedProgramGatewayId

	SELECT @SortOrder = (ISNULL(MAX(GwyGatewaySortOrder), 0) + 1)
	FROM [dbo].[JOBDL020Gateways]
	WHERE JobId = @JobID
		AND StatusId = @StatusId

	INSERT INTO [dbo].[JOBDL020Gateways] (
		JobID
		,ProgramID
		,GwyGatewaySortOrder
		,GwyGatewayCode
		,GwyGatewayTitle
		,GwyTitle
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
		,IsActionAdded
		)
	SELECT @JobID
		,prgm.[PgdProgramID]
		,@SortOrder
		,prgm.[PgdGatewayCode]
		,CASE 
			WHEN prgm.[PgdGatewayCode] = 'Comment'
				THEN 'Shipping Instruction'
			ELSE prgm.[PgdGatewayTitle]
			END
		,CASE 
			WHEN prgm.[PgdGatewayCode] = 'Comment'
				THEN 'Shipping Instruction'
			ELSE prgm.[PgdGatewayTitle]
			END
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
		,@StatusId --prgm.[StatusId]     given 194 as gateway status lookup's 'Active' status id            
		,@dateEntered --ISNULL(@dateEntered,GETUTCDATE())
		,@enteredBy
		,@GwyUprWindow
		,@GwyLwrWindow
		,prgm.[PgdGatewayDefaultComplete]
		,@dateEntered
		,1
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID
	WHERE prgm.Id = @copiedProgramGatewayId
		AND job.Id = @JobID
		AND JOB.JobCompleted =0

	SET @updatedGatewayId = SCOPE_IDENTITY()

	IF (@updatedGatewayId > 0)
	BEGIN
		UPDATE gateway
		SET GwyGatewayPCD = CASE 
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForDeliver
					AND job.JobDeliveryDateTimeBaseline IS NULL
					THEN NULL
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForDeliver
					AND job.JobDeliveryDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, ISNULL(GwyGatewayDuration, 0), job.JobDeliveryDateTimePlanned)
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForPickUp
					AND job.JobOriginDateTimePlanned IS NULL
					THEN NULL
				WHEN @ProgramDatereferenceID = @GatewayTypeIdForPickUp
					AND job.JobOriginDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, ISNULL(GwyGatewayDuration, 0), job.JobOriginDateTimePlanned)
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

		UPDATE JOBDL000Master 
		SET JobIsSchedule = CASE WHEN @GwyGatewayCode = 'XCBL-Schedule' THEN 1 ELSE JobIsSchedule END
		WHERE ID =@JobID
	END

	SELECT GwyCompleted
		,@updatedGatewayId AS Id
	FROM [dbo].[JOBDL020Gateways]
	WHERE Id = @updatedGatewayId
		--DROP TABLE #GatewayType
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
