SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job Gateway   
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
ALTER PROCEDURE [dbo].[UpdJobGateway] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@jobId BIGINT = NULL
	,@programId BIGINT = NULL
	,@gwyGatewaySortOrder INT = NULL
	,@gwyGatewayCode NVARCHAR(20) = NULL
	,@gwyGatewayTitle NVARCHAR(50) = NULL
	,@gwyGatewayDuration DECIMAL(18, 2) = NULL
	,@gwyGatewayDefault BIT = NULL
	,@gatewayTypeId INT = NULL
	,@gwyGatewayAnalyst BIGINT = NULL
	,@gwyGatewayResponsible BIGINT = NULL
	,@gwyGatewayPCD DATETIME2(7) = NULL
	,@gwyGatewayECD DATETIME2(7) = NULL
	,@gwyGatewayACD DATETIME2(7) = NULL
	,@gwyCompleted BIT = NULL
	,@gatewayUnitId INT = NULL
	,@gwyAttachments INT = NULL
	,@gwyProcessingFlags NVARCHAR(20) = NULL
	,@gwyDateRefTypeId INT = NULL
	,@scanner BIT = NULL
	,@gwyShipApptmtReasonCode NVARCHAR(20)
	,@gwyShipStatusReasonCode NVARCHAR(20)
	,@gwyOrderType NVARCHAR(20)
	,@gwyShipmentType NVARCHAR(20)
	,@statusId INT = NULL
	--,@gwyUpdatedStatusOn  datetime2(7)    =NULL    
	,@gwyUpdatedById INT = NULL
	,@gwyClosedOn DATETIME2(7) = NULL
	,@gwyClosedBy NVARCHAR(50) = NULL
	,@gwyPerson NVARCHAR(50) = NULL
	,@gwyPhone NVARCHAR(25) = NULL
	,@gwyEmail NVARCHAR(25) = NULL
	,@gwyTitle NVARCHAR(50) = NULL
	,@gwyDDPCurrent DATETIME2(7) = NULL
	,@gwyDDPNew DATETIME2(7) = NULL
	,@gwyUprWindow DECIMAL(18, 2) = NULL
	,@gwyLwrWindow DECIMAL(18, 2) = NULL
	,@gwyUprDate DATETIME2(7) = NULL
	,@gwyLwrDate DATETIME2(7) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
	,@gwyPreferredMethod INT = 0
    ,@where NVARCHAR(200) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@CommentGatewayType INT
		,@GtyGatewayTypeId INT
		,@PickUpDateRefId INT
		,@DeliverUpDateRefId INT
		,@JobOriginDateplanned DATETIME2(7)
		,@JobGatewayStatus NVARCHAR(50)
		,@JobOriginDateTimeActual DATETIME2(7) = NULL

	SELECT @PickUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Pickup Date'

	SELECT @DeliverUpDateRefId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Delivery Date'

	SELECT @GtyGatewayTypeId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @CommentGatewayType = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Comment'

	SET @gatewayTypeId = (
			SELECT TOP 1 GatewayTypeId
			FROM [JOBDL020Gateways]
			WHERE JobID = @jobId
				AND ID = @ID
			)

	SELECT @JobOriginDateplanned = JobOriginDateTimePlanned
	FROM JOBDL000Master
	WHERE ID = @jobId
		AND StatusId = 1

	UPDATE [dbo].[JOBDL020Gateways]
	SET [JobID] = ISNULL(@jobId, JobID)
		,[ProgramID] = ISNULL(@programId, ProgramID)
		,[GwyGatewayCode] = ISNULL(@gwyGatewayCode, GwyGatewayCode)
		,[GwyGatewayTitle] = ISNULL(@gwyGatewayTitle, GwyGatewayTitle)
		,[GwyGatewayDuration] = ISNULL(@gwyGatewayDuration, GwyGatewayDuration)
		,[GwyGatewayDefault] = ISNULL(@gwyGatewayDefault, GwyGatewayDefault)
		,[GwyGatewayAnalyst] =ISNULL(@gwyGatewayAnalyst, GwyGatewayAnalyst)
		,[GwyGatewayResponsible] = ISNULL(@gwyGatewayResponsible, GwyGatewayResponsible)
		,[GwyGatewayACD] = ISNULL(@gwyGatewayACD, GwyGatewayACD)
		,[GwyCompleted] =ISNULL(@gwyCompleted, GwyCompleted)
		,[GatewayUnitId] = ISNULL(@gatewayUnitId, GatewayUnitId)
		,[GwyProcessingFlags] = ISNULL(@gwyProcessingFlags, GwyProcessingFlags)
		,[GwyDateRefTypeId] = ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)
		,[Scanner] = ISNULL(@scanner, Scanner)
		,GwyShipApptmtReasonCode = ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode)
		,GwyShipStatusReasonCode = ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode)
		,[GwyOrderType] = ISNULL(@gwyOrderType, GwyOrderType)
		,[GwyShipmentType] = ISNULL(@gwyShipmentType, GwyShipmentType)
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[GwyUpdatedById] = ISNULL(@gwyUpdatedById, GwyUpdatedById)
		,[GwyClosedOn] = ISNULL(@gwyClosedOn, GwyClosedOn)
		,[GwyClosedBy] = ISNULL(@gwyClosedBy, GwyClosedBy)
		,[GwyPerson] = ISNULL(@gwyPerson, GwyPerson)
		,[GwyPhone] = ISNULL(@gwyPhone, GwyPhone)
		,[GwyEmail] = ISNULL(@gwyEmail, GwyEmail)
		,[GwyTitle] = ISNULL(@gwyTitle, GwyTitle)
		,[GwyDDPCurrent] = ISNULL(@gwyDDPCurrent, GwyDDPCurrent)
		,[GwyDDPNew] = ISNULL(@gwyDDPNew, GwyDDPNew)
		,[GwyUprDate] = ISNULL(@gwyUprDate, GwyUprDate)
		,[GwyLwrDate] = ISNULL(@gwyLwrDate, GwyLwrDate)
		,[GwyUprWindow] = ISNULL(@gwyUprWindow, GwyUprWindow)
		,[GwyLwrWindow] = ISNULL(@gwyLwrWindow, GwyLwrWindow)
		,[DateChanged] = GETUTCDATE()
		,[ChangedBy] = ISNULL(@changedBy,ChangedBy)
		,GwyPreferredMethod = ISNULL(@gwyPreferredMethod, GwyPreferredMethod)
	WHERE [Id] = @id;

	IF (@gatewayTypeId IS NULL) -- batch update
	BEGIN
		SET @gatewayTypeId = (
				SELECT TOP 1 GatewayTypeId
				FROM [JOBDL020Gateways]
				WHERE JobID = @jobId
					AND ID = @ID
				)
	END

	UPDATE [JOBDL020Gateways]
	SET [GwyGatewayACD] = GETUTCDATE()
	WHERE [GwyGatewayACD] IS NULL
		AND [GwyCompleted] = 1
		AND [Id] = @id;

	IF (@gatewayTypeId = @GtyGatewayTypeId)
	BEGIN
		UPDATE gateway
		SET GwyGatewayPCD = CASE 
				WHEN @gwyDateRefTypeId = @DeliverUpDateRefId
					AND job.JobDeliveryDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobDeliveryDateTimePlanned)
				WHEN @gwyDateRefTypeId = @PickUpDateRefId
					AND job.JobOriginDateTimePlanned IS NOT NULL
					THEN [dbo].[fnGetUpdateGwyGatewayPCD](@gatewayUnitId, ISNULL(@gwyGatewayDuration, 0), job.JobOriginDateTimePlanned)
				ELSE NULL
				END
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @id

	    UPDATE job
		SET job.JobGatewayStatus = gateway.GwyGatewayCode ,@JobGatewayStatus =gateway.GwyGatewayCode	 
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
		AND gateway.[Id] = (SELECT MAX(ID) FROM JOBDL020Gateways WHERE GatewayTypeId = @GtyGatewayTypeId AND GwyCompleted = 1)	
		
		UPDATE job
		SET job.JobOriginDateTimeActual = ISNULL(gateway.GwyGatewayACD,GETUTCDATE()),
		@JobOriginDateTimeActual = gateway.GwyGatewayACD
		FROM JOBDL020Gateways gateway
		INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
		WHERE gateway.JobID = @JobID
			AND gateway.[Id] = @id
			AND gateway.GatewayTypeId = @GtyGatewayTypeId
			AND gateway.GwyGatewayCode = 'On Hand'
			AND job.JobOriginDateTimeActual IS NULL
	END
	SELECT job.[Id]
		,job.[JobID]
		,job.[ProgramID]
		,job.[GwyGatewaySortOrder]
		,job.[GwyGatewayCode]
		,job.[GwyGatewayTitle]
		,job.[GwyGatewayDuration]
		,job.[GwyGatewayDefault]
		,job.[GatewayTypeId]
		,job.[GwyGatewayAnalyst]
		,job.[GwyGatewayResponsible]
		,job.[GwyGatewayPCD]
		,job.[GwyGatewayECD]
		,job.[GwyGatewayACD]
		,job.[GwyCompleted]
		,job.[GatewayUnitId]
		,job.[GwyAttachments]
		,job.[GwyProcessingFlags]
		,job.[GwyDateRefTypeId]
		,job.[Scanner]
		,job.[StatusId]
		,job.[GwyUpdatedById]
		,job.[GwyClosedOn]
		,job.[GwyClosedBy]
		,job.[DateEntered]
		,job.[EnteredBy]
		,job.[DateChanged]
		,job.[ChangedBy]
		,job.[GwyShipApptmtReasonCode]
		,job.[GwyShipStatusReasonCode]
		,job.[GwyOrderType]
		,job.[GwyShipmentType]
		,@JobGatewayStatus AS JobGatewayStatus
		,@JobOriginDateTimeActual AS JobOriginActual
	FROM [dbo].[JOBDL020Gateways] job
	WHERE [Id] = @id
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

