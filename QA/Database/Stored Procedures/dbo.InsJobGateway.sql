/****** Object:  StoredProcedure [dbo].[InsJobGateway]    Script Date: 1/28/2020 11:32:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kirty        
-- Create date:               02/06/2020        
-- Description:               Ins a Job Gateway    
-- Execution:                 EXEC [dbo].[InsJobGateway]  
-- Modified on:               
-- Modified Desc:              
-- Modified on:                
-- =============================================        
ALTER PROCEDURE [dbo].[InsJobGateway] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@jobId BIGINT
	,@programId BIGINT
	,@gwyGatewaySortOrder INT
	,@gwyGatewayCode NVARCHAR(20)
	,@gwyGatewayTitle NVARCHAR(50)
	,@gwyGatewayDuration DECIMAL(18, 2)
	,@gwyGatewayDefault BIT
	,@gatewayTypeId INT
	,@gwyGatewayAnalyst BIGINT
	,@gwyGatewayResponsible BIGINT
	,@gwyGatewayPCD DATETIME2(7)
	,@gwyGatewayECD DATETIME2(7)
	,@gwyGatewayACD DATETIME2(7)
	,@gwyCompleted BIT
	,@gatewayUnitId INT
	,@gwyAttachments INT
	,@gwyProcessingFlags NVARCHAR(20)
	,@gwyDateRefTypeId INT
	,@scanner BIT
	,@gwyShipApptmtReasonCode NVARCHAR(20)
	,@gwyShipStatusReasonCode NVARCHAR(20)
	,@gwyOrderType NVARCHAR(20)
	,@gwyShipmentType NVARCHAR(20)
	,@statusId INT
	--,@gwyUpdatedStatusOn  datetime2(7)          
	,@gwyUpdatedById INT
	,@gwyClosedOn DATETIME2(7)
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
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@where NVARCHAR(200) = NULL
	,@isScheduleReschedule BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@GtyTypeId INT
		,@endTime TIME
		,@delDay BIT = NULL

	-- DECLARE @where NVARCHAR(MAX) = ' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR)                    
	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,@jobId
		,@entity
		,@gwyGatewaySortOrder
		,@statusId
		,NULL
		,@where
		,@updatedItemNumber OUTPUT

	SELECT @GtyTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

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

	IF (@programId = 0)
	BEGIN
		SELECT @programId = ProgramID
		FROM JOBDL000Master
		WHERE Id = @jobId;
	END

	DECLARE @currentId BIGINT;

	INSERT INTO [dbo].[JOBDL020Gateways] (
		[JobID]
		,[ProgramID]
		,[GwyGatewaySortOrder]
		,[GwyGatewayCode]
		,[GwyGatewayTitle]
		,[GwyGatewayDuration]
		,[GwyGatewayDefault]
		,[GatewayTypeId]
		,[GwyGatewayAnalyst]
		,[GwyGatewayResponsible]
		,[GwyGatewayPCD]
		,[GwyGatewayECD]
		,[GwyGatewayACD]
		,[GwyCompleted]
		,[GatewayUnitId]
		,[GwyAttachments]
		,[GwyProcessingFlags]
		,[GwyDateRefTypeId]
		,[Scanner]
		,[GwyShipApptmtReasonCode]
		,[GwyShipStatusReasonCode]
		,[GwyOrderType]
		,[GwyShipmentType]
		,[StatusId]
		--,[GwyUpdatedStatusOn]         
		,[GwyUpdatedById]
		,[GwyClosedOn]
		,[GwyClosedBy]
		,[GwyPerson]
		,[GwyPhone]
		,[GwyEmail]
		,[GwyTitle]
		,[GwyDDPCurrent]
		,[GwyDDPNew]
		,[GwyUprWindow]
		,[GwyLwrWindow]
		,[GwyUprDate]
		,[GwyLwrDate]
		,[DateEntered]
		,[EnteredBy]
		)
	VALUES (
		@jobId
		,@programId
		,@updatedItemNumber
		,@gwyGatewayCode
		,@gwyGatewayTitle
		,@gwyGatewayDuration
		,@gwyGatewayDefault
		,@gatewayTypeId
		,@gwyGatewayAnalyst
		,@gwyGatewayResponsible
		,@gwyGatewayPCD
		,@gwyGatewayECD
		,ISNULL(@gwyGatewayACD, CASE 
				WHEN @gwyCompleted = 1
					THEN GETUTCDATE()
				END)
		,@gwyCompleted
		,@gatewayUnitId
		,@gwyAttachments
		,@gwyProcessingFlags
		,@gwyDateRefTypeId
		,@scanner
		,@gwyShipApptmtReasonCode
		,@gwyShipStatusReasonCode
		,@gwyOrderType
		,@gwyShipmentType
		,@statusId
		--,@gwyUpdatedStatusOn      
		,@gwyUpdatedById
		,@gwyClosedOn
		,@gwyClosedBy
		,@gwyPerson
		,@gwyPhone
		,@gwyEmail
		,@gwyTitle
		,@gwyDDPCurrent
		,@gwyDDPNew
		,@gwyUprWindow
		,@gwyLwrWindow
		,@gwyUprDate
		,@gwyLwrDate
		,@dateEntered
		,@enteredBy
		)

	SET @currentId = SCOPE_IDENTITY();

	IF (
			@isScheduleReschedule = 1
			AND @gwyGatewayCode <> 'Comment'
			)
	BEGIN
		UPDATE [JOBDL000Master]
		SET JobDeliveryDateTimePlanned = @gwyUprDate
		WHERE Id = @jobId

		UPDATE [dbo].[JOBDL020Gateways]
		SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration, @gwyDDPNew)
		WHERE JobID = @jobId
			AND GwyDateRefTypeId = (
				SELECT TOP 1 id
				FROM SYSTM000Ref_Options
				WHERE SysOptionName = 'Delivery Date'
				)
	END

	UPDATE [JOBDL020Gateways]
	SET GwyCompleted = 1
	WHERE GwyCompleted = 0
		AND GwyGatewayACD IS NOT NULL
		AND Id = @currentId;

	IF (@GtyTypeId = @gatewayTypeId)
	BEGIN
		IF (@gwyGatewayCode = 'Delivery Window')
		BEGIN
			UPDATE JOBDL000Master
			SET JobDeliveryDateTimePlanned = @gwyUprDate
			WHERE id = @jobId;
			UPDATE [dbo].[JOBDL020Gateways]
			SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration, @gwyUprDate)
			WHERE JobID = @jobId
			AND GwyDateRefTypeId = (
				SELECT TOP 1 id
				FROM SYSTM000Ref_Options
				WHERE SysOptionName = 'Delivery Date'
				)
		END

		IF (@gwyGatewayCode = 'Canceled')
		BEGIN
			UPDATE JOBDL000Master
			SET JobCompleted = 1
				,StatusId = 2
			WHERE ID = @jobId
		END

		UPDATE [dbo].[JOBDL020Gateways]
		SET isActionAdded = 1
		WHERE Id = @currentId

		--UPDATE [dbo].[JOBDL020Gateways]
		--SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration, @gwyDDPNew)
		--WHERE JobID = @jobId
		--	AND GwyDateRefTypeId = (
		--		SELECT TOP 1 id
		--		FROM SYSTM000Ref_Options
		--		WHERE SysOptionName = 'Delivery Date'
		--		)
	END

	IF (@gwyGatewayCode <> 'Canceled')
	BEGIN
		SELECT *
		FROM [dbo].[JOBDL020Gateways]
		WHERE Id = @currentId;
	END
	ELSE
	BEGIN
		SELECT *
		FROM (
			SELECT *
			FROM [dbo].[JOBDL020Gateways]
			WHERE Id = @currentId
			) A
		JOIN (
			SELECT ID AS JobId
				,StatusId AS StaID
				,JobCompleted AS Completed
			FROM JOBDL000Master
			WHERE Id = @jobId
			) B ON A.JobID = B.JobId
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