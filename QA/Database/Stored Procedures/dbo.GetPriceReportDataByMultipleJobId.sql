SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/09/2020
-- Description: GetPriceReportDataByMultipleJobId
-- =============================================
CREATE PROCEDURE [dbo].[GetPriceReportDataByMultipleJobId] (
	@JobIdList uttIDList READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Job.Id JobId
	FROM dbo.JOBDL061BillableSheet BS 
	INNER JOIN @JobIdList Job ON BS.JobId = Job.Id
	WHERE BS.StatusId=1
END

GO
