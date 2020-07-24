SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 6/29/2020
-- Description:	Get the List of all the exceptions and Install Statuses
-- Call Sample: [dbo].[GetJobExceptionDetail] 2349403
-- =============================================
CREATE PROCEDURE [dbo].[GetJobExceptionDetail]
(@CargoId BIGINT )
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CustomerId
		,JGE.Id ExceptionId
		,JgeReferenceCode ExceptionReferenceCode
		,JgeReasonCode ExceptionReasonCode
		,ER.Id ExceptionReasonId
		,ER.JgeTitle ExceptionTitle
		,JGE.IsCargoRequired
		,JGE.CargoField
	FROM [dbo].[JOBDL021GatewayExceptionCode] JGE
	INNER JOIN [dbo].[JOBDL022GatewayExceptionReason] ER ON ER.JGExceptionId = JGE.Id
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.PrgCustID = JGE.CustomerId
	INNER JOIN dbo.JobDL000Master Job ON Job.ProgramId = Prg.Id
	INNER JOIN JobDL010Cargo Cargo ON Cargo.jobId = Job.Id
	Where Cargo.Id = @CargoId AND JgeReferenceCode Like 'Exception%'

	SELECT COMP.CompPrimaryRecordId CustomerId
		,JIS.Id InstallStatusId
		,ExStatusDescription InstallStatusDescription
		,CAST(1 AS BIT) IsException
	FROM [JOBDL023GatewayInstallStatusMaster] JIS
	INNER JOIN dbo.COMP000Master COMP ON COMP.Id = JIS.CompanyId AND COMP.CompTableName = 'Customer'
	INNER JOIN dbo.PRGRM000Master Prg ON Prg.PrgCustID = COMP.CompPrimaryRecordId
	INNER JOIN dbo.JobDL000Master Job ON Job.ProgramId = Prg.Id
	INNER JOIN JobDL010Cargo Cargo ON Cargo.jobId = Job.Id
	Where Cargo.Id = @CargoId AND ExceptionType = 0
END
GO

