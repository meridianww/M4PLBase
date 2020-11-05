SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Dewangab
-- Create date: 11/04/2020
-- Description:	Get EDI Exception Details
-- =============================================
ALTER PROCEDURE [dbo].[GetEDIExceptionInfo] (@scenarioTypeId INT)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@scenarioTypeId = 9)
	BEGIN
		DECLARE @EDICount INT = 0;

		SELECT @EDICount = count(1)
		FROM [dbo].[EDI204SummaryHeader]
		WHERE CONVERT(DATE, DateEntered) = CONVERT(DATE, GETDATE())

		IF (@EDICount = 0)
			SELECT 1 [isEmpty]
		ELSE
			SELECT 0 [isEmpty]
	END

	IF (@scenarioTypeId = 11)
	BEGIN
		SELECT ediSH.DateEntered
			,eshTradingPartner [TradingPartner]
			,eshCustomerReferenceNo [OrderNnumber]
		FROM JOBDL000Master job
		INNER JOIN [dbo].[EDI204SummaryHeader] ediSH
		ON job.JobCustomerSalesOrder=ediSH.eshCustomerReferenceNo
		WHERE job.ProFlags02 = 'V'
		AND ediSH.DateEntered>DATEADD(HH,-4,GETDATE())
	END
END