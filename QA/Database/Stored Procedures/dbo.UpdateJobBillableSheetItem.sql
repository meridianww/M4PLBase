SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/13/2019
-- Description:	Update Job Billable Sheet Item
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobBillableSheetItem]
@ids NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @BillableSheetJobID INT

		SELECT @BillableSheetJobID = PCL.JobId
		FROM dbo.JOBDL061BillableSheet PCL
		INNER JOIN [dbo].[fnSplitString](@ids, ',') FN ON FN.Item = PCL.Id

		CREATE TABLE #tempJobBillableSheet (
			Id BIGINT
			,ItemNumber INT
			)

		INSERT INTO #tempJobBillableSheet (
			Id
			,ItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY prcLineItem
				)
		FROM JOBDL061BillableSheet
		WHERE JobId = @BillableSheetJobID
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO JOBDL061BillableSheet c1
		USING #tempJobBillableSheet c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.prcLineItem = c2.ItemNumber;

		DROP TABLE #tempJobBillableSheet
END
GO
