SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 12/17/2019
-- Description:	Insert Job Comment Gateway
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobGatewayComment] @JobId BIGINT
	,@GatewayTitle NVARCHAR(50)
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@userId BIGINT
	,@isDayLightSavingEnable BIT=0
	,@GwyCompleted BIT = 1
	,@gatewayACD DATETIME2(7) = NULL
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @GwyUpdatedById INT
		,@GwyDateRefTypeId INT
		,@GatewayUnitId INT
		,@GatewayTypeId INT
		,@updatedItemNumber INT
		,@GatewayId INT
		,@GatewayStatusId INT
		,@DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)

	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId

	IF (ISNULL(@JobDeliveryTimeZone, 'Unknown') = 'Unknown')
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = @JobDeliveryTimeZone
	END

	SELECT @DeliveryUTCValue = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @DeliveryUTCValue + 1
			ELSE @DeliveryUTCValue
			END

	SELECT @GatewayStatusId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayStatus'
		AND SysOptionName = 'Active'

	SELECT @GwyUpdatedById = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayUpdateBy'
		AND SysOptionName = 'Manual'

	SELECT @GwyDateRefTypeId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayDateRefType'
		AND SysOptionName = 'Pickup Date'

	SELECT @GatewayUnitId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'UnitQuantity'
		AND SysOptionName = 'Hours'

	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Comment'

		EXEC [dbo].[GetLineNumberForJobGateways] NULL
		,@jobId
		,@gatewayTypeId
		,NULL
	    ,NULL
		,@updatedItemNumber OUTPUT 

	INSERT INTO [dbo].[JOBDL020Gateways] (
		[JobID]
		,[ProgramID]
		,[GwyGatewaySortOrder]
		,[GwyGatewayCode]
		,[GwyGatewayTitle]
		,[GatewayTypeId]
		,[GatewayUnitId]
		,[GwyOrderType]
		,[GwyShipmentType]
		,[StatusId]
		,[GwyDateRefTypeId]
		,[GwyUpdatedById]
		,[GwyCompleted]
		,[GwyTitle]
		,[GwyGatewayACD]
		,[IsActionAdded]
		,[DateEntered]
		,[EnteredBy]
		)
	SELECT Id
		,ProgramId
		,@updatedItemNumber
		,'Comment'
		,@GatewayTitle
		,@GatewayTypeId
		,@GatewayUnitId
		,JobType
		,ShipmentType
		,@GatewayStatusId
		,@GwyDateRefTypeId
		,@GwyUpdatedById
		,@GwyCompleted
		,@GatewayTitle
		,CASE WHEN ISNULL(@gatewayACD, '') = '' THEN DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate()) ELSE @gatewayACD END
		,1
		,@DateEntered
		,@EnteredBy
	FROM JOBDL000Master
	WHERE Id = @JobId

	SET @GatewayId = SCOPE_IDENTITY()

	SELECT @GatewayId
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
