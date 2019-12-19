/****** Object:  StoredProcedure [dbo].[UpdJobGatewayAction]    Script Date: 12/19/2019 2:29:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               10/31/2018        
-- Description:               Upd a Job Gateway For Action fields
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
ALTER PROCEDURE [dbo].[UpdJobGatewayAction] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@jobId BIGINT = NULL
	,@programId BIGINT = NULL
	,@gwyGatewayACD DATETIME2(7) = NULL
	,@gwyCompleted BIT = NULL
	,@gwyDateRefTypeId INT = NULL
	,@gwyShipApptmtReasonCode NVARCHAR(20) = NULL
	,@gwyShipStatusReasonCode NVARCHAR(20) = NULL
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
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

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
		,[GwyCompleted] = ISNULL(@gwyCompleted, GwyCompleted)
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
		,[isActionAdded] = 1
	WHERE [Id] = @id;

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