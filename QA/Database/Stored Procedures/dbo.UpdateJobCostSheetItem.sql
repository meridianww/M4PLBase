SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/13/2019
-- Description:	Update Job Billable Sheet Item
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobCostSheetItem]
@ids NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @CostSheetJobID INT

		SELECT @CostSheetJobID = PCL.JobId
		FROM dbo.JOBDL062CostSheet PCL
		INNER JOIN [dbo].[fnSplitString](@ids, ',') FN ON FN.Item = PCL.Id

		CREATE TABLE #tempJobCostSheet (
			Id BIGINT
			,ItemNumber INT
			)

		INSERT INTO #tempJobCostSheet (
			Id
			,ItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY CstLineItem
				)
		FROM JOBDL062CostSheet
		WHERE JobId = @CostSheetJobID
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO JOBDL062CostSheet c1
		USING #tempJobCostSheet c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.CstLineItem = c2.ItemNumber;

		DROP TABLE #tempJobCostSheet
END
GO
