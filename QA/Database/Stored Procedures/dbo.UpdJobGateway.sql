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
	SET [JobID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobId
			WHEN (
					(@isFormView = 0)
					AND (@jobId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@jobId, JobID)
			END
		,[ProgramID] = CASE 
			WHEN (@isFormView = 1)
				THEN @programId
			WHEN (
					(@isFormView = 0)
					AND (@programId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@programId, ProgramID)
			END
		,[GwyGatewayCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayCode
			WHEN (
					(@isFormView = 0)
					AND (@gwyGatewayCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayCode, GwyGatewayCode)
			END
		,[GwyGatewayTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayTitle
			WHEN (
					(@isFormView = 0)
					AND (@gwyGatewayTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayTitle, GwyGatewayTitle)
			END
		,[GwyGatewayDuration] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayDuration
			WHEN (
					(@isFormView = 0)
					AND (@gwyGatewayDuration = - 100.00)
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayDuration, GwyGatewayDuration)
			END
		,[GwyGatewayDefault] = ISNULL(@gwyGatewayDefault, GwyGatewayDefault)
		,[GwyGatewayAnalyst] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayAnalyst
			WHEN (
					(@isFormView = 0)
					AND (@gwyGatewayAnalyst = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayAnalyst, GwyGatewayAnalyst)
			END
		,[GwyGatewayResponsible] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayResponsible
			WHEN (
					(@isFormView = 0)
					AND (@gwyGatewayResponsible = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayResponsible, GwyGatewayResponsible)
			END
		,[GwyGatewayACD] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyGatewayACD
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyGatewayACD, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyGatewayACD, GwyGatewayACD)
			END
		,[GwyCompleted] = CASE 
			WHEN (
					@gatewayTypeId = @CommentGatewayType
					AND GwyCompleted = 1
					)
				THEN 1
			ELSE ISNULL(@gwyCompleted, GwyCompleted)
			END
		,[GatewayUnitId] = CASE 
			WHEN (@isFormView = 1)
				THEN @gatewayUnitId
			WHEN (
					(@isFormView = 0)
					AND (@gatewayUnitId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gatewayUnitId, GatewayUnitId)
			END
		,[GwyProcessingFlags] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyProcessingFlags
			WHEN (
					(@isFormView = 0)
					AND (@gwyProcessingFlags = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyProcessingFlags, GwyProcessingFlags)
			END
		,[GwyDateRefTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyDateRefTypeId
			WHEN (
					(@isFormView = 0)
					AND (@gwyDateRefTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)
			END
		,[Scanner] = ISNULL(@scanner, Scanner)
		,GwyShipApptmtReasonCode = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyShipApptmtReasonCode
			WHEN (
					(@isFormView = 0)
					AND (@gwyShipApptmtReasonCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode)
			END
		,GwyShipStatusReasonCode = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyShipStatusReasonCode
			WHEN (
					(@isFormView = 0)
					AND (@gwyShipStatusReasonCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode)
			END
		,[GwyOrderType] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyOrderType
			WHEN (
					(@isFormView = 0)
					AND (@gwyOrderType = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyOrderType, GwyOrderType)
			END
		,[GwyShipmentType] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyShipmentType
			WHEN (
					(@isFormView = 0)
					AND (@gwyShipmentType = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyShipmentType, GwyShipmentType)
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			WHEN (
					(@isFormView = 0)
					AND (@statusId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@statusId, StatusId)
			END
		,[GwyUpdatedById] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyUpdatedById
			WHEN (
					(@isFormView = 0)
					AND (@gwyUpdatedById = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gwyUpdatedById, GwyUpdatedById)
			END
		,[GwyClosedOn] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyClosedOn
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyClosedOn, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyClosedOn, GwyClosedOn)
			END
		,[GwyClosedBy] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyClosedBy
			WHEN (
					(@isFormView = 0)
					AND (@gwyClosedBy = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyClosedBy, GwyClosedBy)
			END
		,[GwyPerson] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyPerson
			WHEN (
					(@isFormView = 0)
					AND (@gwyPerson = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyPerson, GwyPerson)
			END
		,[GwyPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyPhone
			WHEN (
					(@isFormView = 0)
					AND (@gwyPhone = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyPhone, GwyPhone)
			END
		,[GwyEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyEmail
			WHEN (
					(@isFormView = 0)
					AND (@gwyEmail = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyEmail, GwyEmail)
			END
		,[GwyTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyTitle
			WHEN (
					(@isFormView = 0)
					AND (@gwyTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@gwyTitle, GwyTitle)
			END
		,[GwyDDPCurrent] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyDDPCurrent
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyDDPCurrent, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyDDPCurrent, GwyDDPCurrent)
			END
		,[GwyDDPNew] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyDDPNew
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyDDPNew, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyDDPNew, GwyDDPNew)
			END
		,[GwyUprDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyUprDate
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyUprDate, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyUprDate, GwyUprDate)
			END
		,[GwyLwrDate] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyLwrDate
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @gwyLwrDate, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@gwyLwrDate, GwyLwrDate)
			END
		,[GwyUprWindow] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyUprWindow
			WHEN (
					(@isFormView = 0)
					AND (@gwyUprWindow = - 100.00)
					)
				THEN NULL
			ELSE ISNULL(@gwyUprWindow, GwyUprWindow)
			END
		,[GwyLwrWindow] = CASE 
			WHEN (@isFormView = 1)
				THEN @gwyLwrWindow
			WHEN (
					(@isFormView = 0)
					AND (@gwyLwrWindow = - 100.00)
					)
				THEN NULL
			ELSE ISNULL(@gwyLwrWindow, GwyLwrWindow)
			END
		,[DateChanged] = @dateChanged
		,[ChangedBy] = @changedBy
	WHERE [Id] = @id;

	IF (@gatewayTypeId IS NULL)
	BEGIN
		SET @gatewayTypeId = (
				SELECT TOP 1 GatewayTypeId
				FROM [JOBDL020Gateways]
				WHERE JobID = @jobId
					AND ID = @ID
				)
	END

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
	END

	UPDATE [JOBDL020Gateways]
	SET [GwyCompleted] = 1
	WHERE [GwyGatewayACD] IS NOT NULL
		AND [GwyCompleted] = 0
		AND [Id] = @id;

	UPDATE [JOBDL020Gateways]
	SET [GwyGatewayACD] = GETUTCDATE()
	WHERE [GwyGatewayACD] IS NULL
		AND [GwyCompleted] = 1
		AND [Id] = @id;

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

