SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	Insert Job Cost Sheet Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobCostSheetData] 
(
@uttJobCostCode [dbo].[uttJobCostCode] READONLY,
@jobId BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

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
		,[CstQuantity]
		,[CstElectronicBilling]
		,[IsProblem]
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
		,CASE WHEN ISNULL(CstQuantity, 0) = 0 
			 AND ISNULL(CstChargeCode, '') <> '' 
			 AND LEN(CstChargeCode) >= 3 
			 AND SUBSTRING(CstChargeCode, LEN(CstChargeCode) - 2, 3) IN ('MIL','STO') 
			 THEN 1 ELSE CstQuantity END 
		,[CstElectronicBilling]
		,[IsProblem]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM @uttJobCostCode

	EXEC [dbo].[UpdateLineNumberForJobCostSheet] @jobId
END

GO
