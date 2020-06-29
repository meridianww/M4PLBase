SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 6/29/2020
-- Description:	Get the List of all the exceptions and Install Statuses
-- =============================================
CREATE PROCEDURE [dbo].[GetJobExceptionDetail]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CustomerId
		,JGE.Id ExceptionId
		,JgeReferenceCode ExceptionReferenceCode
		,JgeReasonCode ExceptionReasonCode
		,ER.Id ExceptionReasonId
		,ER.JgeTitle ExceptionTitle
	FROM [dbo].[JOBDL021GatewayExceptionCode] JGE
	INNER JOIN [dbo].[JOBDL022GatewayExceptionReason] ER ON ER.JGExceptionId = JGE.Id
	Where JgeReferenceCode Like 'Exception%'

	SELECT COMP.CompPrimaryRecordId CustomerId
		,JIS.Id InstallStatusId
		,ExStatusDescription InstallStatusDescription
		,CAST(1 AS BIT) IsException
	FROM [JOBDL023GatewayInstallStatusMaster] JIS
	INNER JOIN dbo.COMP000Master COMP ON COMP.Id = JIS.CompanyId
		AND COMP.CompTableName = 'Customer'
	Where ExceptionType = 0
END
GO

