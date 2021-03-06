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
CREATE PROCEDURE [dbo].[UpdJobGatewayAction] (
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
	,@isScheduleReschedule BIT =0
	,@gwyGatewayCode nvarchar(20)
	,@gatewayTypeId INT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @GtyTypeId int ,@delDay BIT = NULL
	SELECT @GtyTypeId =Id FROM SYSTM000Ref_Options WHERE SysLookupCode='GatewayType' and SysOptionName='Action' 
  SELECT TOP 1 @delDay = DelDay
	FROM PRGRM000Master
	WHERE ID = (
			SELECT TOP 1 PROGRAMID
			FROM JOBDL000Master
			WHERE ID = @jobId
			)

	IF (@isScheduleReschedule = 1)
	BEGIN
		IF (ISNULL(@delDay, 0) = 1)
		BEGIN
			SET @gwyUprDate = @gwyDDPNew
			SET @gwyLwrDate = NULL --@gwyDDPNew
		END
		ELSE IF (
				@gwyUprWindow = NULL
				AND @gwyLwrWindow = NULL
				)
		BEGIN
			SET @gwyUprDate = @gwyDDPNew
			SET @gwyLwrDate = @gwyDDPNew
		END
		ELSE
		BEGIN
			IF OBJECT_ID('tempdb..#TempgwyUprWindow') IS NOT NULL
			BEGIN
				DROP TABLE #TempgwyUprWindow
			END

			CREATE TABLE #TempgwyUprWindow (
				ID INT IDENTITY(1, 1)
				,item VARCHAR(10)
				)

			INSERT INTO #TempgwyUprWindow
			SELECT item
			FROM dbo.fnSplitString(CONVERT(NVARCHAR(10), @gwyUprWindow), '.')

			IF OBJECT_ID('tempdb..#TempgwyLwrWindow') IS NOT NULL
			BEGIN
				DROP TABLE #TempgwyLwrWindow
			END

			CREATE TABLE #TempgwyLwrWindow (
				ID INT IDENTITY(1, 1)
				,item VARCHAR(10)
				)

			INSERT INTO #TempgwyLwrWindow
			SELECT item
			FROM dbo.fnSplitString(CONVERT(NVARCHAR(10), @gwyLwrWindow), '.')

			DECLARE @LgwyUprWindow INT
				,@RgwyUprWindow INT
				,@LgwyLwrWindow INT
				,@RgwyLwrWindow INT

			SELECT @LgwyUprWindow = CONVERT(INT, ITEM)
			FROM #TempgwyUprWindow
			WHERE ID = 1

			SELECT @RgwyUprWindow = CONVERT(INT, ITEM)
			FROM #TempgwyUprWindow
			WHERE ID = 2

			SELECT @LgwyLwrWindow = CONVERT(INT, ITEM)
			FROM #TempgwyLwrWindow
			WHERE ID = 1

			SELECT @RgwyLwrWindow = CONVERT(INT, ITEM)
			FROM #TempgwyLwrWindow
			WHERE ID = 2

			IF (@LgwyUprWindow IS NOT NULL)
			BEGIN
				SET @gwyUprDate = DATEADD(HOUR, CONVERT(INT, @LgwyUprWindow), @gwyDDPNew)

				IF (@RgwyUprWindow IS NOT NULL)
				BEGIN
					IF (CONVERT(INT, @LgwyUprWindow) < 0)
					BEGIN
						SET @RgwyUprWindow = '-' + @RgwyUprWindow;
					END

					SET @gwyUprDate = DATEADD(MINUTE, CONVERT(INT, @RgwyUprWindow), @gwyUprDate)
				END
			END

			IF (@LgwyLwrWindow IS NOT NULL)
			BEGIN
				SET @gwyLwrDate = DATEADD(HOUR, CONVERT(INT, @LgwyLwrWindow), @gwyDDPNew)

				IF (@RgwyLwrWindow IS NOT NULL)
				BEGIN
					IF (CONVERT(INT, @LgwyLwrWindow) < 0)
					BEGIN
						SET @RgwyLwrWindow = '-' + @RgwyLwrWindow;
					END

					SET @gwyLwrDate = DATEADD(MINUTE, CONVERT(INT, @RgwyLwrWindow), @gwyLwrDate)
				END
			END
		END
	END

	IF (@isScheduleReschedule =1 AND @gwyGatewayCode <> 'Comment')
	BEGIN
		UPDATE [JOBDL000Master] SET JobDeliveryDateTimePlanned=@gwyDDPNew WHERE Id=@jobId
		UPDATE [dbo].[JOBDL020Gateways]
		SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration,@gwyDDPNew)
		WHERE JobID = @jobId AND GwyDateRefTypeId  = (SELECT TOP 1 id from SYSTM000Ref_Options where  SysOptionName= 'Delivery Date')
	END
  
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
			WHEN (@isFormView = 1  AND @gwyDateRefTypeId IS NOT NULL)
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
		,[isActionAdded] = CASE 
		WHEN (@gwyGatewayCode = 'Comment' AND @gatewayTypeId <> @GtyTypeId)
		THEN 0
		ELSE 1
		END
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
		,job.[GwyDDPNew]
		,job.GwyUprDate
		,job.GwyLwrDate
	FROM [dbo].[JOBDL020Gateways] job
	WHERE [Id] = @id
	 UPDATE JOBDL000Master SET JobDeliveryDateTimePlanned = @gwyUprDate  WHERE Id= @jobId 
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
