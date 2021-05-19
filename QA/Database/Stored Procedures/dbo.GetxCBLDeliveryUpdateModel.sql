
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/4/2020
-- Description:	Get xCBL Delivery Model Data
-- Execution:   EXEC [dbo].[GetxCBLDeliveryUpdateModel] 248599
-- =============================================
CREATE PROCEDURE [dbo].[GetxCBLDeliveryUpdateModel] (@JobId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @JobLatestAction BIGINT
		,@ExceptionTitleId BIGINT
		,@ExceptionStatusId BIGINT
		,@ActionType INT
		,@ActionCode VARCHAR(500)
		,@GatewayCode VARCHAR(200)
		,@InstallStatus VARCHAR(200)
		,@ActionAdditionalComment VARCHAR(5000)
		,@ExceptionDetail VARCHAR(500)
		,@ExceptionCode VARCHAR(500)
		,@CancelDate DATETIME2(7)
		,@CancelReason VARCHAR(500)
		,@RescheduleReason VARCHAR(500)
		,@AttemptReason VARCHAR(500)
		,@DateEntered DATETIME2(7)
		,@UpdatedRescheduleDate DATETIME2(7)
		,@RescheduledInstallDate DATETIME2(7)
		,@ProgramId BIGINT
		,@GatewayType VARCHAR(200)
		,@InvoicedDate DATETIME2(7)
		,@JobIsInvoiced BIT = 0

	SELECT @ProgramId = ProgramId
		,@InvoicedDate = JobInvoicedDate
		,@JobIsInvoiced = CASE 
			WHEN ISNULL(JobInvoicedDate, '') <> ''
				THEN 1
			ELSE 0
			END
	FROM JOBDL000Master WITH (NOLOCK)
	WHERE Id = @JobId

	SELECT TOP 1 @JobLatestAction = JG.ID
		,@ExceptionStatusId = JG.GwyExceptionStatusId
		,@ExceptionTitleId = ISNULL(JG.GwyExceptionTitleId,GER.Id)
		,@ActionAdditionalComment = JG.GwyAddtionalComment
		,@UpdatedRescheduleDate = COALESCE(JG.GwyDDPNew, JG.GwyDDPCurrent)
		,@GatewayCode = CASE 
			WHEN ISNULL(JG.StatusCode, '') <> ''
				AND JG.GwyGatewayCode <> JG.StatusCode
				THEN CONCAT (
						JG.GwyGatewayCode
						,'-'
						,ISNULL(JG.StatusCode, '')
						)
			ELSE JG.GwyGatewayCode
			END
		,@DateEntered = JG.DateEntered
		,@GatewayType = SO.SysOptionName
	FROM [dbo].[JOBDL020Gateways] JG WITH (NOLOCK)
	LEFT JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO ON GEO.JgeReferenceCode = CASE 
			WHEN ISNULL(JG.StatusCode, '') <> ''
				AND JG.GwyGatewayCode <> JG.StatusCode
				THEN CONCAT (
						JG.GwyGatewayCode
						,'-'
						,ISNULL(JG.StatusCode, '')
						)
			ELSE JG.GwyGatewayCode
			END
    LEFT JOIN [dbo].[JOBDL022GatewayExceptionReason] GER ON GER.JGExceptionId = GEO.ID
	INNER JOIN [dbo].[SYSTM000Ref_Options] SO WITH (NOLOCK) ON SO.Id = JG.GatewayTypeId
	WHERE JobId = @JobId
		AND ISNULL(GwyCargoId, 0) = 0
	ORDER BY JG.ID DESC

	IF (ISNULL(@JobIsInvoiced, 0) = 1)
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM [dbo].[JOBDL023GatewayInstallStatusMaster]
		WHERE ExStatusDescription = 'Invoiced'

		SET @DateEntered = @InvoicedDate
	END
	ELSE
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM [dbo].[JOBDL023GatewayInstallStatusMaster]
		WHERE Id = @ExceptionStatusId
	END
	SELECT @ActionType = ISNULL(ActionType, 0)
		,@ExceptionDetail = GEO.JgeReasonCode
		,@ExceptionCode = GEO.CustomerReferenceCode
	FROM [dbo].[JOBDL022GatewayExceptionReason] GER
	INNER JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO ON GER.JGExceptionId = GEO.ID
	WHERE GER.Id = @ExceptionTitleId

	IF (ISNULL(@ActionType, 0) = 0 AND ISNULL(@JobIsInvoiced, 0) = 0)
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM PRGRM010Ref_GatewayDefaults GP
		INNER JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] GIS ON GIS.Id = GP.InstallStatusId
		WHERE GP.PgdProgramId = @ProgramId
			AND PgdGatewayCode = @GatewayCode
	END
	ELSE IF ( ISNULL(@ActionType, 0) = 1 AND ISNULL(@JobIsInvoiced, 0) = 0 )
	BEGIN
		SET @RescheduleReason = @ExceptionDetail
		SET @RescheduledInstallDate = @UpdatedRescheduleDate
	END
	ELSE IF ( ISNULL(@ActionType, 0) = 2 AND ISNULL(@JobIsInvoiced, 0) = 0 )
	BEGIN
		SET @CancelReason = @ExceptionDetail
		SET @CancelDate = @UpdatedRescheduleDate
	END
	ELSE IF ( ISNULL(@ActionType, 0) = 4 AND ISNULL(@JobIsInvoiced, 0) = 0 )
	BEGIN
		SET @AttemptReason = @ExceptionDetail
		SELECT @InstallStatus = ExStatusDescription
		FROM PRGRM010Ref_GatewayDefaults GP
		INNER JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] GIS ON GIS.Id = GP.InstallStatusId
		WHERE GP.PgdProgramId = @ProgramId
			AND PgdGatewayCode = @GatewayCode
	END
	
	SELECT 'Meridian' ServiceProvider
		,CASE 
			WHEN ISNULL(CAST(Job.Id AS VARCHAR(50)), '') <> ''
				THEN CAST(Job.Id AS VARCHAR(50))
			ELSE ''
			END ServiceProviderID
		,CASE 
			WHEN ISNULL(Job.JobCustomerSalesOrder, '') <> ''
				THEN Job.JobCustomerSalesOrder
			ELSE ''
			END OrderNumber
		,CASE 
			WHEN ISNULL(CAST(Job.JobOrderedDate AS VARCHAR(50)), '') <> ''
				THEN FORMAT(Job.JobOrderedDate,'yyyyMMdd')
			ELSE ''
			END OrderDate
		,CASE 
			WHEN ISNULL(CAST(Job.Id AS VARCHAR(50)), '') <> ''
				THEN CAST(Job.Id AS VARCHAR(50))
			ELSE ''
			END SPTransactionID
		,CASE 
			WHEN ISNULL(@InstallStatus, '') <> ''
				THEN @InstallStatus
			ELSE ''
			END InstallStatus
		,CASE 
			WHEN ISNULL(@InstallStatus, '') <> ''
				THEN FORMAT(@DateEntered,'yyyyMMddHHmmss')
			ELSE ''
			END InstallStatusTS
		,CASE 
			WHEN ISNULL(CAST(Job.JobDeliveryDateTimeBaseline AS VARCHAR(50)), '') <> ''
				THEN FORMAT(Job.JobDeliveryDateTimeBaseline,'yyyyMMddHHmmss')
			ELSE ''
			END PlannedInstallDate
		,CASE 
			WHEN ISNULL(CAST(job.JobDeliveryDateTimePlanned AS VARCHAR(50)), '') <> ''
				THEN FORMAT(Job.JobDeliveryDateTimePlanned,'yyyyMMddHHmmss')
			ELSE ''
			END ScheduledInstallDate
		,CASE 
			WHEN ISNULL(CAST(job.JobDeliveryDateTimeActual AS VARCHAR(50)), '') <> ''
				THEN FORMAT(Job.JobDeliveryDateTimeActual,'yyyyMMddHHmmss')
			ELSE ''
			END ActualInstallDate
		,CASE 
			WHEN ISNULL(@RescheduledInstallDate, '') <> ''
				THEN FORMAT(CAST(@RescheduledInstallDate AS DateTime),'yyyyMMddHHmmss')
			ELSE ''
			END RescheduledInstallDate
		,CASE 
			WHEN ISNULL(@RescheduleReason, '') <> ''
				THEN @RescheduleReason
			ELSE ''
			END RescheduleReason
		,CASE 
			WHEN ISNULL(@CancelDate, '') <> ''
				THEN FORMAT(CAST(@CancelDate AS DateTime),'yyyyMMddHHmmss')
			ELSE ''
			END CancelDate
		,CASE 
			WHEN ISNULL(@CancelReason, '') <> ''
				THEN @CancelReason
			ELSE ''
			END CancelReason
		,CASE
			WHEN ISNULL(@AttemptReason, '') <> ''
				THEN @AttemptReason
			ELSE ''
			END AttemptReason
		,CASE 
			WHEN ISNULL(@ActionAdditionalComment, '') <> ''
				THEN @ActionAdditionalComment
			ELSE ''
			END AdditionalComments
		,CASE 
			WHEN @ActionType IN (2,3)
				THEN 'True'
			ELSE 'False'
			END HasExceptions
		,CASE 
			WHEN ISNULL(@ExceptionDetail, '') <> ''
				THEN @ExceptionDetail
			ELSE ''
			END ExceptionDetail
		,CASE 
			WHEN ISNULL(@ExceptionCode, '') <> ''
				THEN @ExceptionCode
			ELSE ''
			END ExceptionCode
		,CASE 
			WHEN ISNULL(Job.JobSignText, '') <> ''
				THEN Job.JobSignText
			ELSE ''
			END SignedBy
	FROM JOBDL000Master Job
	WHERE Job.Id = @jobId

	SELECT CAST(CgoLineItem AS VARCHAR(50)) LineNumber
		,Cargo.CgoPartNumCode ItemNumber
		,CASE 
			WHEN ISNULL(ISM.Id, 0) > 0
				THEN ExStatusDescription
			ELSE @InstallStatus
			END ItemInstallStatus
		,Cargo.CgoComment UserNotes
		,CASE 
			WHEN ISNULL(JG.ID, 0) > 0
				THEN JG.GwyAddtionalComment
			WHEN ISNULL(JG.ID, 0) = 0
				THEN @ActionAdditionalComment
			ELSE NULL
			END ItemInstallComments
		,NULL Exceptions
		,Cargo.CgoLongitude Longitude
		,Cargo.CgoLatitude Latitude
		,Cargo.CgoSerialBarcode
		,Cargo.CgoSerialNumber
		,Cargo.CgoLineNumber
		,CAST(Cargo.CgoQtyOrdered AS VARCHAR(50)) Quantity
	FROM dbo.JOBDL010Cargo Cargo WITH (NOLOCK)
	LEFT JOIN [dbo].[JOBDL020Gateways] JG WITH (NOLOCK) ON Cargo.Id = JG.GwyCargoId
	LEFT JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] ISM WITH (NOLOCK) ON ISM.Id = JG.GwyExceptionStatusId
	WHERE Cargo.JobId = @JobId
		AND Cargo.StatusId = 1
	ORDER BY CgoLineItem

	SELECT CgoPartNumCode AS ItemNumber
		,CASE 
			WHEN ISNULL(GEO.ActionType, 0) = 3
				THEN 'True'
			ELSE 'False'
			END AS HasExceptions
	FROM dbo.JOBDL010Cargo Cargo
	LEFT JOIN [dbo].[JOBDL020Gateways] JG WITH (NOLOCK) ON JG.GwyCargoId = Cargo.Id
	LEFT JOIN [dbo].[JOBDL022GatewayExceptionReason] GER WITH (NOLOCK) ON GER.Id = JG.GwyExceptionTitleId
	LEFT JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO WITH (NOLOCK) ON GEO.Id = GER.JGExceptionId
	WHERE Cargo.JobId = @JobId
		AND Cargo.StatusId = 1

	SELECT CgoPartNumCode AS ItemNumber
		,GEO.JgeReasonCode ExceptionDetail
		,GEO.CustomerReferenceCode ExceptionCode
	FROM dbo.JOBDL010Cargo Cargo
	LEFT JOIN [dbo].[JOBDL020Gateways] JG WITH (NOLOCK) ON JG.GwyCargoId = Cargo.Id
	LEFT JOIN [dbo].[JOBDL022GatewayExceptionReason] GER WITH (NOLOCK) ON GER.Id = JG.GwyExceptionTitleId
	LEFT JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO WITH (NOLOCK) ON GEO.Id = GER.JGExceptionId
	WHERE Cargo.JobId = @JobId
		AND Cargo.StatusId = 1
END