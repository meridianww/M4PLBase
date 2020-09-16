SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal Adhikary           
-- Create date:               09/15/2020        
-- Description:               Get a Job Gateway Action 
-- Execution:                 EXEC [dbo].[GetJobGateway] 2,14,1,0,186915,'Gateway',0,0,'Will Call'  
-- =============================================  
ALTER PROCEDURE [dbo].[GetJobGatewayAction] @userId BIGINT
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
		,@DefaultUprWindow DECIMAL
		,@DefaultLwrWindow DECIMAL
		,@GwyDDPNew DATETIME2(7)
		,@GwyDDPLatest DATETIME2(7)
		,@GwyDDPEarliest DATETIME2(7)
		,@GwyGatewayACD DATETIME2(7)
		,@GwyDDPCurrent DATETIME2(7) = NULL
		,@delDay BIT = NULL
		,@DeliveryJobPreferredMethod INT
		,@IsOnSitePOCExists BIT
		,@JobDeliverySitePOC2 NVARCHAR(75)
		,@JobDeliverySitePOCPhone2 NVARCHAR(50)
		,@JobDeliverySitePOCEmail2 NVARCHAR(50)
		,@deliverySitePOC NVARCHAR(75)
		,@deliverySitePOCPhone NVARCHAR(50)
		,@deliverySitePOCEmail NVARCHAR(100)
		,@gwyStatusExceptionId BIGINT = 0
		,@gwyShipStatusReasonCode VARCHAR(30)
		,@gwyShipApptmtReasonCode VARCHAR(30)

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
		,@JobDeliverySitePOC2 = JobDeliverySitePOC2
		,@JobDeliverySitePOCPhone2 = JobDeliverySitePOCPhone2
		,@JobDeliverySitePOCEmail2 = JobDeliverySitePOCEmail2
		,@deliverySitePOC = JobDeliverySitePOC
		,@deliverySitePOCPhone = JobDeliverySitePOCPhone
		,@deliverySitePOCEmail = JobDeliverySitePOCEmail
		,@IsOnSitePOCExists = CASE 
			WHEN (
					JobDeliverySitePOC2 IS NOT NULL
					OR JobDeliverySitePOCPhone2 IS NOT NULL
					OR JobDeliverySitePOCEmail2 IS NOT NULL
					)
				THEN 1
			ELSE 0
			END
		,@gwyShipStatusReasonCode = PgdShipStatusReasonCode
		,@gwyShipApptmtReasonCode = PgdShipApptmtReasonCode
	FROM [dbo].[JOBDL000Master] Job
	INNER JOIN PRGRM010Ref_GatewayDefaults Prg ON Prg.PgdProgramId = JOb.ProgramId
	WHERE Job.Id = @parentId

	SELECT @CustomerId = PrgCustId
		,@delDay = DelDay
		,@DefaultTimeFromProgram = CASE 
			WHEN @is3PlAction = 1
				THEN PrgPickUpTimeDefault
			ELSE PrgDeliveryTimeDefault
			END
		,@DefaultUprWindow = DelLatest
		,@DefaultLwrWindow = DelEarliest
	FROM PRGRM000Master
	WHERE Id = @ProgramId

	SELECT TOP 1 @gwyStatusExceptionId = InstallStatus.ID
	FROM COMP000Master COMP
	INNER JOIN CUST000Master CUST ON CUST.Id = COMP.CompPrimaryRecordId
		AND CompTableName = 'Customer'
		AND COMP.CompPrimaryRecordId = @customerId
	INNER JOIN JOBDL023GatewayInstallStatusMaster InstallStatus ON COMP.Id = InstallStatus.CompanyId
	WHERE CUST.CustCode <> 'Electrolux'

	SELECT TOP 1 @GwyDDPNew = GW.GwyDDPNew
		,@GwyDDPLatest = GW.GwyUprDate
		,@GwyDDPEarliest = GW.GwyLwrDate
		,@GwyGatewayACD = GW.GwyGatewayACD
		,@GwyDDPCurrent = GW.GwyDDPCurrent
	FROM [JOBDL020Gateways] GW
	WHERE GW.JOBID = @parentId AND GW.GatewayTypeId = 86 AND GW.GwyGatewayCode IN ('Schedule', 'Reschedule')
	ORDER BY GW.ID DESC

	SELECT @DeliveryJobPreferredMethod = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'JobPreferredMethod'
		AND SysDefault = 1

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

	SELECT @parentId AS JobID
		,@JobOriginDateTimeBaseline AS [JobOriginDateTimeBaseline]
		,@JobOriginDateTimePlanned AS [JobOriginDateTimePlanned]
		,@JobOriginDateTimeActual AS [JobOriginDateTimeActual]
		,@JobDeliveryDateTimeBaseline AS [JobDeliveryDateTimeBaseline]
		,@JobDeliveryDateTimePlanned AS [JobDeliveryDateTimePlanned]
		,@JobDeliveryDateTimeActual AS [JobDeliveryDateTimeActual]
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
		,@DeliveryJobPreferredMethod AS GwyPreferredMethod
		,@GwyGatewayACD AS GwyGatewayACD
		,@GwyDDPCurrent AS GwyDDPCurrent
		,@CustomerId CustomerId
		,@DeliveryUTCValue DeliveryUTCValue
		,@OriginUTCValue OriginUTCValue
		,@cargoField AS CargoField
		,@isCargoRequired AS IsCargoRequired
		,@gwyStatusExceptionId AS GwyExceptionStatusId
		,@gwyShipStatusReasonCode GwyShipStatusReasonCode
		,@gwyShipApptmtReasonCode GwyShipApptmtReasonCode
		,@JobCustomerSalesOrder ContractNumber
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

