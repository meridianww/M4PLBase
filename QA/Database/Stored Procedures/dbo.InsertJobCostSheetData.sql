SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	Insert Job Cost Sheet Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobCostSheetData] (@uttJobCostCode [dbo].[uttJobCostCode] READONLY)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @JobId BIGINT

	SELECT TOP 1 @JobId = JobId
	FROM @uttJobCostCode

	UPDATE [dbo].[JOBDL062CostSheet]
	SET StatusId = 3
	WHERE JobId = @JobId

	INSERT INTO [dbo].[JOBDL062CostSheet] (
		[LineNumber]
		,[JobID]
		,[CstLineItem]
		,[CstChargeID]
		,[CstChargeCode]
		,[CstTitle]
		,[CstUnitId]
		,[CstRate]
		,[ChargeTypeId]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	SELECT [LineNumber]
		,[JobID]
		,[CstLineItem]
		,[CstChargeID]
		,[CstChargeCode]
		,[CstTitle]
		,[CstUnitId]
		,[CstRate]
		,[ChargeTypeId]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM @uttJobCostCode
END
GO

