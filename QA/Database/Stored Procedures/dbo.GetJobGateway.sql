/****** Object:  StoredProcedure [dbo].[GetJobGateway]    Script Date: 16-03-2020 11:52:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job Gateway  
-- Execution:                 EXEC [dbo].[GetJobGateway]   2,14,1,0,115353, 'Gateway'
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE [dbo].[GetJobGateway] --2,14,1,391404,37499,null
@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT
	,@entityFor NVARCHAR(20)= null
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF(@entityFor = 'Contact')
    BEGIN
	  SET @entityFor = NULL;
	END
	DECLARE @pickupBaselineDate DATETIME2(7)
		,@pickupPlannedDate DATETIME2(7)
		,@pickupActualDate DATETIME2(7)
		,@deliveryBaselineDate DATETIME2(7)
		,@deliveryPlannedDate DATETIME2(7)
		,@deliveryActualDate DATETIME2(7)
		,@deliverySitePOC NVARCHAR(75)
		,@deliverySitePOCPhone NVARCHAR(50)
		,@deliverySitePOCEmail NVARCHAR(100)
		,@jobCompleted BIT
		,@programId BIGINT
		,@jobDeliveryDatePlanned DATETIME2(7)
		,@DefaultTimeFromProgram DATETIME2(7)
		,@DefaultUprWindow DECIMAL
		,@DefaultLwrWindow DECIMAL
		,@GwyDDPNew DATETIME2(7)
		,@GwyDDPLatest DATETIME2(7)
		,@GwyDDPEarliest DATETIME2(7)
		,@delDay BIT = NULL
		,@GwyGatewayACD DATETIME2(7)
		,@JobDeliverySitePOC2 NVARCHAR(75)
		,@JobDeliverySitePOCPhone2 NVARCHAR(50)
		,@JobDeliverySitePOCEmail2 NVARCHAR(50)
		,@IsOnSitePOCExists BIT = 0
		,@JobPreferredMethod INT
		,@DeliveryJobPreferredMethod INT

		Select @DeliveryJobPreferredMethod = ID From [dbo].[SYSTM000Ref_Options] Where SysLookupCode='JobPreferredMethod' AND SysDefault = 1
	SELECT TOP 1 @GwyDDPNew = GwyDDPNew
		,@GwyDDPLatest = GwyUprDate
		,@GwyDDPEarliest = GwyLwrDate
		,@GwyGatewayACD = GwyGatewayACD
	FROM [JOBDL020Gateways]
	WHERE JOBID = @parentId
		AND GatewayTypeId = (
			SELECT ID
			FROM SYSTM000Ref_Options
			WHERE SysLookupCode = 'GatewayType'
				AND SysOptionName = 'Action'
			)
		AND GwyGatewayCode IN (
			'Schedule'
			,'Reschedule'
			)
	ORDER BY ID DESC

	SELECT TOP 1 @delDay = DelDay
	FROM PRGRM000Master
	WHERE ID = (
			SELECT TOP 1 PROGRAMID
			FROM JOBDL000Master
			WHERE ID = @parentId
			)

	SELECT @pickupBaselineDate = Job.[JobOriginDateTimeBaseline]
		,@pickupPlannedDate = Job.[JobOriginDateTimePlanned]
		,@pickupActualDate = Job.[JobOriginDateTimeActual]
		,@deliveryBaselineDate = Job.[JobDeliveryDateTimeBaseline]
		,@deliveryPlannedDate = Job.[JobDeliveryDateTimePlanned]
		,@deliveryActualDate = Job.[JobDeliveryDateTimeActual]
		,@jobCompleted = Job.[JobCompleted]
		,@deliverySitePOC = Job.[JobDeliverySitePOC]
		,@deliverySitePOCPhone = Job.[JobDeliverySitePOCPhone]
		,@deliverySitePOCEmail = Job.[JobDeliverySitePOCEmail]
		,@programId = job.ProgramID
		,@jobDeliveryDatePlanned = JobDeliveryDateTimePlanned
		,@JobDeliverySitePOC2 = job.JobDeliverySitePOC2
		,@JobDeliverySitePOCPhone2 = job.JobDeliverySitePOCPhone2
		,@JobDeliverySitePOCEmail2 = job.JobDeliverySitePOCEmail2
		,@JobPreferredMethod = job.JobPreferredMethod
		,@IsOnSitePOCExists = CASE 
			WHEN (
					job.JobDeliverySitePOC2 IS NOT NULL
					OR job.JobDeliverySitePOCPhone2 IS NOT NULL
					OR job.JobDeliverySitePOCEmail2 IS NOT NULL
					)
				THEN 1
			ELSE 0
			END
	FROM JOBDL000Master(NOLOCK) job
	WHERE job.Id = @parentId

	UPDATE PRGRM000Master
	SET @DefaultTimeFromProgram = PrgDeliveryTimeDefault
		,@DefaultUprWindow = DelLatest
		,@DefaultLwrWindow = DelEarliest
	WHERE Id = (
			SELECT TOP 1 ProgramID
			FROM JOBDL000Master
			WHERE Id = @parentId
			)
		AND DelDay = @delDay

	IF (
			@id = 0
			AND @entityFor = 'Gateway'
			)
	BEGIN
		EXEC GetJobGatewayFromProgram @parentId
			,@userId
	END
	ELSE IF (
			@id = 0
			AND (
				@entityFor IS NULL
				OR @entityFor = 'Action'
				)
			)
	BEGIN
		SELECT @parentId AS JobID
			,@pickupBaselineDate AS [JobOriginDateTimeBaseline]
			,@pickupPlannedDate AS [JobOriginDateTimePlanned]
			,@pickupActualDate AS [JobOriginDateTimeActual]
			,@deliveryBaselineDate AS [JobDeliveryDateTimeBaseline]
			,@deliveryPlannedDate AS [JobDeliveryDateTimePlanned]
			,@deliveryActualDate AS [JobDeliveryDateTimeActual]
			,@programId AS ProgramID
			,@DefaultTimeFromProgram AS [DefaultTime]
			,@DefaultUprWindow AS [GwyUprWindow]
			,@DefaultLwrWindow AS [GwyLwrWindow]
			,@GwyDDPNew AS [GwyDDPNew]
			,@GwyDDPLatest AS [GwyUprDate]
			,@GwyDDPEarliest AS [GwyLwrDate]
			,@delDay AS [DelDay]
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOC2, @deliverySitePOC) AS GwyPerson
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCPhone2, @deliverySitePOCPhone) AS GwyPhone
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCEmail2, @deliverySitePOCEmail) AS GwyEmail
			,IIF(@IsOnSitePOCExists = 1, @JobPreferredMethod, @DeliveryJobPreferredMethod) AS GwyPreferredMethod
			,@GwyGatewayACD AS GwyGatewayACD
			
	END
	ELSE
	BEGIN
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
			,job.GwyShipApptmtReasonCode
			,job.GwyShipStatusReasonCode
			,job.GwyOrderType
			,job.GwyShipmentType
			,job.[StatusId]
			,job.[GwyUpdatedById]
			,job.[GwyClosedOn]
			,job.[GwyClosedBy]
			--,CASE WHEN (cont.Id > 0 OR job.GwyUpdatedById IS NULL) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist  
			,CASE 
				WHEN (
						cont.Id > 0
						OR job.GwyClosedBy IS NULL
						)
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS ClosedByContactExist
			,job.GwyPerson
			,job.GwyPhone
			,job.GwyEmail
			,job.GwyPreferredMethod
			,job.GwyTitle
			,COALESCE(job.GwyDDPCurrent, @deliveryPlannedDate) AS [GwyDDPCurrent]
			,job.GwyDDPNew
			,job.GwyUprWindow
			,job.GwyLwrWindow
			,job.GwyUprDate
			,job.GwyLwrDate
			,CASE 
				WHEN job.GwyPerson IS NULL
					THEN CAST(0 AS BIT)
				ELSE CAST(1 AS BIT)
				END AS 'isScheduled'
			,job.[DateEntered]
			,job.[EnteredBy]
			,job.[DateChanged]
			,job.[ChangedBy]
			,@pickupBaselineDate AS [JobOriginDateTimeBaseline]
			,@pickupPlannedDate AS [JobOriginDateTimePlanned]
			,@pickupActualDate AS [JobOriginDateTimeActual]
			,@deliveryBaselineDate AS [JobDeliveryDateTimeBaseline]
			,@deliveryPlannedDate AS [JobDeliveryDateTimePlanned]
			,@deliveryActualDate AS [JobDeliveryDateTimeActual]
			,@jobCompleted AS [JobCompleted]
			,@DefaultTimeFromProgram AS [DefaultTime]
		FROM [dbo].[JOBDL020Gateways] job
		LEFT JOIN CONTC000Master cont ON job.GwyClosedBy = cont.ConFullName
			AND cont.StatusId = 1 -- In(1,2)  
		WHERE job.[Id] = @id
	END
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