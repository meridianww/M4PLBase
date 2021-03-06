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
-- Execution:                 EXEC [dbo].[GetJobGateway] 2,14,1,813444,186915,'Gateway',0,0,'Will Call'
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE [dbo].[GetJobGateway] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT
	,@entityFor NVARCHAR(20) = NULL
	,@is3PlAction BIT = 0
	,@isDayLightSavingEnable BIT = 0
	,@gatewayCode NVARCHAR(150) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (ISNULL(@Id, 0) > 0)
	BEGIN
		DECLARE @DeliveryUTCValue INT
			,@OriginUTCValue INT
			,@JobOriginDateTimeBaseline DATETIME2(7)
			,@JobOriginDateTimePlanned DATETIME2(7)
			,@JobOriginDateTimeActual DATETIME2(7)
			,@JobDeliveryDateTimeBaseline DATETIME2(7)
			,@JobDeliveryDateTimePlanned DATETIME2(7)
			,@JobDeliveryDateTimeActual DATETIME2(7)
			,@jobDeliveryTimeZone NVARCHAR(15)
			,@jobOriginTimeZone NVARCHAR(15)
			,@ProgramId BIGINT
			,@gwyCargoId BIGINT = 0
			,@cargoField NVARCHAR(150) = NULL
			,@sqlCommand NVARCHAR(MAX) = NULL
			,@cargoQuantity DECIMAL(18, 2) = NULL
			,@jobCompleted BIT
			,@DefaultTimeFromProgram DATETIME2(7)
			,@isCargoRequired BIT
			,@CustomerId BIGINT
			,@JobCustomerSalesOrder VARCHAR(50)
			,@gwyOrderType VARCHAR(30)
			,@gwyShipmentType VARCHAR(30)

		SELECT @JobDeliveryTimeZone = JobDeliveryTimeZone
			,@jobOriginTimeZone = JobOriginTimeZone
			,@ProgramId = ProgramId
			,@JobOriginDateTimeBaseline = JobOriginDateTimeBaseline
			,@JobOriginDateTimePlanned = JobOriginDateTimePlanned
			,@JobOriginDateTimeActual = JobOriginDateTimeActual
			,@JobDeliveryDateTimeBaseline = JobDeliveryDateTimeBaseline
			,@JobDeliveryDateTimePlanned = JobDeliveryDateTimePlanned
			,@JobDeliveryDateTimeActual = JobDeliveryDateTimeActual
			,@jobCompleted = JobCompleted
			,@JobCustomerSalesOrder = JobCustomerSalesOrder
			,@gwyOrderType = JobType
			,@gwyShipmentType = ShipmentType
		FROM [dbo].[JOBDL000Master]
		WHERE Id = @parentId

		SELECT @CustomerId = PrgCustId
			,@DefaultTimeFromProgram = CASE 
				WHEN @is3PlAction = 1
					THEN PrgPickUpTimeDefault
				ELSE PrgDeliveryTimeDefault
				END
		FROM PRGRM000Master
		WHERE Id = @ProgramId

		SELECT TOP 1 @DeliveryUTCValue = CASE 
				WHEN IsDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN UTC + 1
				ELSE UTC
				END
		FROM Location000Master
		WHERE TimeZoneShortName = CASE 
				WHEN ISNULL(@JobDeliveryTimeZone, 'Unknown') = 'Unknown'
					THEN 'Pacific'
				ELSE @JobDeliveryTimeZone
				END

		SELECT TOP 1 @OriginUTCValue = CASE 
				WHEN IsDayLightSaving = 1
					AND @isDayLightSavingEnable = 1
					THEN UTC + 1
				ELSE UTC
				END
		FROM Location000Master
		WHERE TimeZoneShortName = CASE 
				WHEN ISNULL(@jobOriginTimeZone, 'Unknown') = 'Unknown'
					THEN 'Pacific'
				ELSE @jobOriginTimeZone
				END

		SELECT @gatewayCode = GwyGatewayTitle
			,@gwyCargoId = GwyCargoId
		FROM JOBDL020Gateways
		WHERE JobID = @parentId
			AND Id = @id

		SELECT TOP 1 @cargoField = CargoField
			,@isCargoRequired = IsCargoRequired
		FROM JOBDL021GatewayExceptionCode
		WHERE CustomerId = @CustomerId
			AND JgeReasonCode = @gatewayCode
			AND ISNULL(CargoField,'') <> ''
		IF (ISNULL(@cargoField,'') <> '')
		BEGIN
			DECLARE @ParmDefinition NVARCHAR(500);

			SET @sqlCommand = 'SELECT @retvalOUT = ' + @cargoField + ' FROM JOBDL010Cargo WHERE JobID = ' + CONVERT(NVARCHAR(30), @parentId) + ' AND Id = ' + CONVERT(NVARCHAR(30), @gwyCargoId)
			SET @ParmDefinition = N'@retvalOUT decimal(18,2) OUTPUT';

			EXEC sp_executesql @sqlCommand
				,@ParmDefinition
				,@retvalOUT = @cargoQuantity OUTPUT;
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
			,job.GwyShipApptmtReasonCode
			,job.GwyShipStatusReasonCode
			,@gwyOrderType  AS GwyOrderType
			,@gwyShipmentType AS GwyShipmentType
			,job.[StatusId]
			,job.[GwyUpdatedById]
			,job.[GwyClosedOn]
			,job.[GwyClosedBy]
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
			,COALESCE(job.GwyDDPCurrent, @JobDeliveryDateTimePlanned) AS [GwyDDPCurrent]
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
			,@JobOriginDateTimeBaseline AS [JobOriginDateTimeBaseline]
			,@JobOriginDateTimePlanned AS [JobOriginDateTimePlanned]
			,@JobOriginDateTimeActual AS [JobOriginDateTimeActual]
			,@JobDeliveryDateTimeBaseline AS [JobDeliveryDateTimeBaseline]
			,@JobDeliveryDateTimePlanned AS [JobDeliveryDateTimePlanned]
			,@JobDeliveryDateTimeActual AS [JobDeliveryDateTimeActual]
			,@jobCompleted AS [JobCompleted]
			,@DefaultTimeFromProgram AS [DefaultTime]
			,GwyCargoId
			,GwyExceptionTitleId
			,GwyExceptionStatusId
			,GwyAddtionalComment
			,@CustomerId CustomerId
			,@DeliveryUTCValue DeliveryUTCValue
			,@OriginUTCValue OriginUTCValue
			,StatusCode
			,@cargoField AS CargoField
			,@isCargoRequired AS IsCargoRequired
			,@cargoQuantity AS CargoQuantity
			,@JobCustomerSalesOrder ContractNumber
			,er.JgeTitle as GwyExceptionTitleIdName
			,cargo.CgoTitle GwyCargoIdName
			,ins.ExStatusDescription GwyExceptionStatusIdName
			,job.GwyGatewayText
		FROM [dbo].[JOBDL020Gateways] job
		LEFT JOIN CONTC000Master cont ON job.GwyClosedBy = cont.ConFullName
			AND cont.StatusId = 1
		LEFT JOIN JOBDL010Cargo cargo
		ON job.GwyCargoId = cargo.Id
		LEFT JOIN JOBDL022GatewayExceptionReason er
		ON job.GwyExceptionTitleId = er.Id
		LEFT JOIN JOBDL021GatewayExceptionCode ec
		ON er.JGExceptionId=ec.Id
		LEFT JOIN JOBDL023GatewayInstallStatusMaster ins
		on ins.Id=job.GwyExceptionStatusId
		WHERE job.[Id] = @id
	END
	ELSE
	BEGIN
		IF (@entityFor = 'Gateway')
		BEGIN
			EXEC GetJobGatewayFromProgram @parentId
				,@userId
				,@isDayLightSavingEnable
				,@gatewayCode
		END

		IF (@entityFor IS NULL OR @entityFor = 'Action')
		BEGIN
			EXEC [dbo].[GetJobGatewayAction] @userId
				,@roleId
				,@orgId
				,@id
				,@parentId
				,@entityFor
				,@is3PlAction
				,@isDayLightSavingEnable
				,@gatewayCode
		END
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
GO
