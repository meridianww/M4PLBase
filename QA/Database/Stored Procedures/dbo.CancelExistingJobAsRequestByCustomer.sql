SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                   Prashant Aggarwal              
-- Create date:              4/24/2020              
-- Description:              Cancel the existing job on Customer Request      
-- Execution:                EXEC [dbo].[CancelExistingJobAsRequestByCustomer] 190810,10014,'2020-04-21','Test',2,0             
-- =============================================              
CREATE PROCEDURE [dbo].[CancelExistingJobAsRequestByCustomer]
(
	 @JobID BIGINT
	,@ProgramID BIGINT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@userId BIGINT
	,@IsGatewayExceptionUpdate BIT 
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
		,@CancelInstallStatus BIGINT
		,@SortOrder INT = 0

    IF(@IsGatewayExceptionUpdate = 1)
    BEGIN
	Select @CancelInstallStatus = Id
	FROM [dbo].[JOBDL023GatewayInstallStatusMaster] Where ExStatusDescription = 'Canceled'
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
	WHERE SysOptionName = 'Action'
		AND [SysLookupCode] = 'GatewayType'

	SELECT @GatewayTypeIdForPickUp = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Pickup Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

	SELECT @GatewayTypeIdForDeliver = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysOptionName = 'Delivery Date'
		AND [SysLookupCode] = 'GatewayDateRefType'

    IF(@IsGatewayExceptionUpdate = 1)
	BEGIN
	SELECT @copiedProgramGatewayId = MAX(Id)
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdGatewayDefault = 1
		AND PgdProgramID = @programId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND GatewayTypeId = @GatewayTypeId
		AND PgdGatewayCode = 'Canceled-49'
		AND StatusId = 1
	END
	ELSE 
	BEGIN
	SELECT @copiedProgramGatewayId = MAX(Id)
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE PgdProgramID = @programId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND GatewayTypeId = @GatewayTypeId
		AND PgdGatewayCode Like '%Cancel%'
		AND StatusId = 1
	END

     SELECT @SortOrder =  (ISNULL(MAX(GwyGatewaySortOrder), 0) + 1)
	FROM [dbo].[JOBDL020Gateways]
	WHERE JobId = @JobID AND StatusId = @StatusId 

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
		,isActionAdded
		,GwyExceptionStatusId
		,GwyAddtionalComment
		,[GwyDateCancelled]
		,[GwyCancelOrder]
		)
	SELECT @JobID
		,prgm.[PgdProgramID]
		,@SortOrder
		,'Canceled'
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
		,@StatusId --prgm.[StatusId]     given 194 as gateway status lookup's 'Active' status id            
		,@dateEntered --ISNULL(@dateEntered,GETUTCDATE())
		,@enteredBy
		,@GwyUprWindow
		,@GwyLwrWindow
		,prgm.[PgdGatewayDefaultComplete]
		,@dateEntered
		,1
		,@CancelInstallStatus
		,'Customer Request'
		,@dateEntered
		,1
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	INNER JOIN [dbo].[JOBDL000Master] job ON prgm.[PgdProgramID] = job.ProgramID
	WHERE prgm.Id = @copiedProgramGatewayId
		AND job.Id = @JobID

	SET @updatedGatewayId = SCOPE_IDENTITY()

	IF (@updatedGatewayId > 0)
	BEGIN
	DECLARE @CancelId INT
	SELECT @CancelId =Id FROM SYSTM000Ref_Options WHERE SysLookupCode = 'Status' AND SysOptionName = 'Canceled'
		UPDATE JOBDL000Master
		SET JobGatewayStatus = 'Canceled'
		,IsCancelled = 1
		,StatusId =@CancelId
		WHERE Id = @JobID
	END


	Select @updatedGatewayId
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
