SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 6/29/2020
-- Description:	Insert Cargo Exception
-- =============================================
CREATE PROCEDURE [dbo].[InsertCargoException] (
	@cargoId BIGINT
	,@GwyGatewayCode VARCHAR(50)
	,@GwyGatewayTitle VARCHAR(150)
	,@CreatedDate DATETIME2(7)
	,@CreatedBy VARCHAR(150)
	,@StatusCode VARCHAR(50)
	,@GwyExceptionTitleId BIGINT
	,@GwyExceptionStatusId BIGINT
	,@isDayLightSavingEnable BIT = 0
	,@CargoQuantity INT = 0
	,@CargoField VARCHAR(150)
	,@CgoReasonCodeOSD VARCHAR(30)
	,@CgoDateLastScan DATETIME2(7) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @jobId BIGINT
		,@sqlCommand NVARCHAR(MAX) = NULL
		,@currentId BIGINT
		,@ProgramId BIGINT
		,@ContractNumber VARCHAR(150)

	SELECT @jobId = jobId
	FROM JOBDL010Cargo
	WHERE Id = @cargoId

	IF (ISNULL(@jobId, 0) > 0)
	BEGIN
		DECLARE @deliverySitePOC NVARCHAR(75)
			,@deliverySitePOCPhone NVARCHAR(50)
			,@deliverySitePOCEmail NVARCHAR(100)
			,@JobDeliverySitePOC2 NVARCHAR(75)
			,@JobDeliverySitePOCPhone2 NVARCHAR(50)
			,@JobDeliverySitePOCEmail2 NVARCHAR(50)
			,@IsOnSitePOCExists BIT = 0
			,@JobPreferredMethod INT
			,@SortOrder INT
			,@GwyActionTypeID INT
			,@deliveryPlannedDate DATETIME2(7)
			,@JobDeliveryTimeZone VARCHAR(50)
			,@DeliveryUTCValue INT
			,@IsDeliveryDayLightSaving BIT

		SELECT @programId = ProgramId
			,@deliveryPlannedDate = Job.[JobDeliveryDateTimePlanned]
			,@deliverySitePOC = Job.[JobDeliverySitePOC]
			,@deliverySitePOCPhone = Job.[JobDeliverySitePOCPhone]
			,@deliverySitePOCEmail = Job.[JobDeliverySitePOCEmail]
			,@JobDeliverySitePOC2 = job.JobDeliverySitePOC2
			,@JobDeliverySitePOCPhone2 = job.JobDeliverySitePOCPhone2
			,@JobDeliverySitePOCEmail2 = job.JobDeliverySitePOCEmail2
			,@JobPreferredMethod = job.JobPreferredMethod
			,@JobDeliveryTimeZone = Job.JobDeliveryTimeZone
			,@ProgramId = ProgramId
		    ,@ContractNumber = JobCustomerSalesOrder
			,@IsOnSitePOCExists = CASE 
				WHEN (
						ISNULL(job.JobDeliverySitePOC2, '') <> ''
						OR ISNULL(job.JobDeliverySitePOCPhone2, '') <> ''
						OR ISNULL(job.JobDeliverySitePOCEmail2, '') <> ''
						)
					THEN 1
				ELSE 0
				END
		FROM JOBDL000Master(NOLOCK) job
		WHERE job.Id = @jobId

		SELECT @SortOrder = (ISNULL(MAX(GwyGatewaySortOrder), 0) + 1)
		FROM [dbo].[JOBDL020Gateways]
		WHERE JobId = @JobID
			AND StatusId = 194

		SELECT @GwyActionTypeID = ID
		FROM SYSTM000Ref_Options
		WHERE SysLookupCode = 'GatewayType'
			AND SysOptionName = 'Action'

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

		INSERT INTO dbo.JOBDL020Gateways (
			JobID
			,ProgramID
			,GwyGatewaySortOrder
			,GwyGatewayCode
			,GwyGatewayTitle
			,GatewayTypeId
			,GwyPerson
			,GwyPhone
			,GwyEmail
			,GwyTitle
			,GwyDDPCurrent
			,GwyUprDate
			,GwyLwrDate
			,GwyGatewayPCD
			,GwyGatewayECD
			,GwyGatewayACD
			,GwyCompleted
			,StatusId
			,DateEntered
			,EnteredBy
			,isActionAdded
			,GwyPreferredMethod
			,GwyCargoId
			,GwyExceptionTitleId
			,GwyExceptionStatusId
			,StatusCode
			)
		VALUES (
			@jobId
			,@programId
			,@SortOrder
			,@GwyGatewayCode
			,@GwyGatewayTitle
			,@GwyActionTypeID
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOC2, @deliverySitePOC)
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCPhone2, @deliverySitePOCPhone)
			,IIF(@IsOnSitePOCExists = 1, @JobDeliverySitePOCEmail2, @deliverySitePOCEmail)
			,@GwyGatewayTitle
			,@CreatedDate
			,@deliveryPlannedDate
			,NULL
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,DATEADD(HOUR, @DeliveryUTCValue, GetUTCDate())
			,1
			,194
			,@CreatedDate
			,@CreatedBy
			,1
			,@JobPreferredMethod
			,@cargoId
			,@GwyExceptionTitleId
			,@GwyExceptionStatusId
			,@StatusCode
			)

		SET @currentId = SCOPE_IDENTITY();

		IF (
				@currentId > 0
				AND @cargoId > 0
				)
		BEGIN
			UPDATE JOBDL010Cargo
			SET CgoReasonCodeOSD = @CgoReasonCodeOSD
				,CgoDateLastScan = ISNULL(@CgoDateLastScan, CgoDateLastScan)
			WHERE Id = @cargoId

			IF (ISNULL(@CargoField, '') <> '')
			BEGIN
				SET @sqlCommand = 'UPDATE JOBDL010Cargo SET ' + @CargoField + ' = ' + CONVERT(NVARCHAR(30), @CargoQuantity) + ' WHERE ID = ' + CONVERT(NVARCHAR(30), @cargoId)

				EXEC sp_executesql @sqlCommand
			END
		END
	END

	SELECT CASE 
			WHEN ISNULL(@jobId, 0) > 0
				THEN 'Success'
			ELSE 'Failure'
			END [Status]
		,CASE 
			WHEN ISNULL(@jobId, 0) > 0
				THEN 200
			ELSE 500
			END StatusCode
		,CASE 
			WHEN ISNULL(@jobId, 0) > 0
				THEN ''
			ELSE 'There is no Job Present for the mentioned CargoId.'
			END [Status]
        ,@jobId JobId
		,@ProgramId ProgramId
		,@ContractNumber ContractNumber
END
GO

