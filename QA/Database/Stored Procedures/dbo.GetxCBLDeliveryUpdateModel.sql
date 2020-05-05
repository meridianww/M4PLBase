SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/4/2020
-- Description:	Get xCBL Delivery Model Data
-- Execution:   EXEC [dbo].[GetxCBLDeliveryUpdateModel] 127091
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
		,@InstallStatus VARCHAR(200)
		,@ActionAdditionalComment VARCHAR(5000)
		,@ExceptionDetail VARCHAR(500)
		,@ExceptionCode VARCHAR(500)
		,@CancelDate VARCHAR(50)
		,@CancelReason VARCHAR(500)
		,@RescheduleReason VARCHAR(500)
		,@DateEntered DATETIME2(7)
		,@UpdatedRescheduleDate DATETIME2(7)
		,@RescheduledInstallDate VARCHAR(50)

	SELECT TOP 1 @JobLatestAction = JG.ID
		,@ExceptionStatusId = JG.GwyExceptionStatusId
		,@ExceptionTitleId = JG.GwyExceptionTitleId
		,@ActionAdditionalComment = JG.GwyAddtionalComment
		,@UpdatedRescheduleDate = COALESCE(JG.GwyDDPNew, JG.GwyDDPCurrent)
		,@DateEntered = JG.DateEntered
	FROM [dbo].[JOBDL020Gateways] JG WITH (NOLOCK)
	INNER JOIN [dbo].[SYSTM000Ref_Options] SO WITH (NOLOCK) ON SO.Id = JG.GatewayTypeId
	WHERE JobId = @JobId
		AND ISNULL(GwyCargoId, 0) = 0
		AND SO.SysOptionName = 'Action'
	ORDER BY JG.ID DESC

	SELECT @InstallStatus = ExStatusDescription
	FROM [dbo].[JOBDL023GatewayInstallStatusMaster]
	WHERE Id = @ExceptionStatusId

	SELECT @ActionType = ActionType
		,@ExceptionDetail = JgeTitle
		,@ExceptionCode = JgeReasonCode
	FROM [dbo].[JOBDL022GatewayExceptionReason] GER
	INNER JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO ON GER.JGExceptionId = GEO.ID
	WHERE GER.Id = @ExceptionTitleId

	IF (ISNULL(@ActionType, 0) = 2)
	BEGIN
		SET @CancelDate = @DateEntered
		SET @CancelReason = @ExceptionDetail
	END
	ELSE IF (ISNULL(@ActionType, 0) = 1)
	BEGIN
		SET @RescheduleReason = @ExceptionDetail
		SET @RescheduledInstallDate = @UpdatedRescheduleDate
	END

	SELECT 'Meridian' ServiceProvider
		,CAST(Job.Id AS VARCHAR(50)) ServiceProviderID
		,Job.JobCustomerSalesOrder OrderNumber
		,CAST(Job.JobOrderedDate AS VARCHAR(50)) OrderDate
		,CAST(Job.Id AS VARCHAR(50)) SPTransactionID
		,@InstallStatus InstallStatus
		,NULL InstallStatusTS
		,NULL PlannedInstallDate
		,NULL ScheduledInstallDate
		,NULL ActualInstallDate
		,@RescheduledInstallDate RescheduledInstallDate
		,@RescheduleReason RescheduleReason
		,@CancelDate CancelDate
		,@CancelReason CancelReason
		,NULL Exceptions
		,'' UserNotes
		,NULL OrderURL
		,NULL POD
		,@ActionAdditionalComment AdditionalComments
		,NULL OrderLineDetail
	FROM JOBDL000Master Job
	WHERE Id = @jobId

	SELECT CASE 
			WHEN @ActionType = 3
				THEN 'True'
			ELSE 'False'
			END HasExceptions

	SELECT @ExceptionDetail ExceptionDetail
		,@ExceptionCode ExceptionCode

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
			WHEN ISNULL(ISM.Id, 0) > 0
				THEN @ActionAdditionalComment
			ELSE NULL
			END ItemInstallComments
		,NULL Exceptions
	FROM dbo.JOBDL010Cargo Cargo
	LEFT JOIN [dbo].[JOBDL020Gateways] JG WITH (NOLOCK) ON Cargo.Id = JG.GwyCargoId
	LEFT JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] ISM ON ISM.Id = JG.GwyExceptionStatusId
	WHERE Cargo.JobId = @JobId
	ORDER BY CgoLineItem 

	Select CgoPartNumCode AS ItemNumber, 'True' AS HasExceptions
	FROM dbo.JOBDL010Cargo Cargo
	Where JobId = @JobId

	SELECT CgoPartNumCode AS ItemNumber,'Test' ExceptionDetail
		,'Code' ExceptionCode
		FROM dbo.JOBDL010Cargo Cargo
	Where JobId = @JobId
END
GO

