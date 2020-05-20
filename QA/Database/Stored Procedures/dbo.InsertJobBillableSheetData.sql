SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	Insert Job Billable Sheet Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobBillableSheetData] 
(
@uttJobPriceCode [dbo].[uttJobPriceCode] READONLY,
@jobId BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL061BillableSheet]
	SET StatusId = 3
	WHERE JobId = @JobId

	INSERT INTO [dbo].[JOBDL061BillableSheet] (
		[LineNumber]
		,[JobID]
		,[prcLineItem]
		,[prcChargeID]
		,[prcChargeCode]
		,[prcTitle]
		,[prcUnitId]
		,[prcRate]
		,[ChargeTypeId]
		,[prcElectronicBilling]
		,[IsProblem]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	SELECT [LineNumber]
		,[JobID]
		,[prcLineItem]
		,[prcChargeID]
		,[prcChargeCode]
		,[prcTitle]
		,[prcUnitId]
		,[prcRate]
		,[ChargeTypeId]
		,[prcElectronicBilling]
		,[IsProblem]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM @uttJobPriceCode

	EXEC [dbo].[UpdateLineNumberForJobBillableSheet] @jobId
END
GO

