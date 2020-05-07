SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	Insert Job Billable Sheet Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobBillableSheetData] (@uttJobPriceCode [dbo].[uttJobPriceCode] READONLY)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @JobId BIGINT

	SELECT TOP 1 @JobId = JobId
	FROM @uttJobPriceCode

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
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM @uttJobPriceCode
END
GO

