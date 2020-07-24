SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 6/29/2020
-- Description:	Get the List of all the Reschedule Reasons and Install Statuses
-- Call Sample: [dbo].[GetJobRescheduleReasonDetail] 190812,1
-- =============================================
CREATE PROCEDURE [dbo].[GetJobRescheduleReasonDetail] (
	@JobId BIGINT
	,@IsSpecificCustomer BIT
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@IsSpecificCustomer = 1)
	BEGIN
		SELECT CustomerId
			,JGE.Id ExceptionId
			,JgeReferenceCode ExceptionReferenceCode
			,JgeReasonCode ExceptionReasonCode
			,ER.Id ExceptionReasonId
			,ER.JgeTitle ExceptionTitle
		FROM [dbo].[JOBDL021GatewayExceptionCode] JGE
		INNER JOIN [dbo].[JOBDL022GatewayExceptionReason] ER ON ER.JGExceptionId = JGE.Id
		INNER JOIN dbo.PRGRM000Master Prg ON Prg.PrgCustID = JGE.CustomerId
		INNER JOIN dbo.JobDL000Master Job ON Job.ProgramId = Prg.Id
		WHERE Job.Id = @JobId
			AND JgeReferenceCode LIKE 'Reschedule%'
	END
	ELSE
	BEGIN
		SELECT Program.PrgCustId CustomerId
			,PG.Id ExceptionId
			,PG.PgdGatewayCode ExceptionReferenceCode
			,'Reschedule' ExceptionReasonCode
			,PG.Id ExceptionReasonId
			,PG.PgdGatewayTitle ExceptionTitle
		FROM [dbo].[PRGRM010Ref_GatewayDefaults] PG
		INNER JOIN dbo.PRGRM000Master Program ON Program.Id = PG.PgdProgramId
		INNER JOIN dbo.JobDL000Master Job ON Job.ProgramId = Program.Id
		WHERE Job.Id = 1283
			AND PgdGatewayCode LIKE '%Reschedule%'
			AND PG.StatusId = 1
	END

	SELECT COMP.CompPrimaryRecordId CustomerId
		,JIS.Id InstallStatusId
		,ExStatusDescription InstallStatusDescription
		,CAST(1 AS BIT) IsException
	FROM [JOBDL023GatewayInstallStatusMaster] JIS
	INNER JOIN dbo.COMP000Master COMP ON COMP.Id = JIS.CompanyId
		AND COMP.CompTableName = 'Customer'
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.PrgCustID = COMP.CompPrimaryRecordId
	INNER JOIN dbo.JobDL000Master Job ON Job.ProgramId = Prg.Id
	WHERE Job.Id = @JobId
END
GO

