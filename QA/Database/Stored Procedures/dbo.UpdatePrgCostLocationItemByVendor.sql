SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/13/2019
-- Description:	Update Job Billable Sheet Item
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePrgCostLocationItemByVendor]
@ids NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @PclProgramID INT

		SELECT @PclProgramID = PCL.PclProgramID
		FROM dbo.PRGRM043ProgramCostLocations PCL
		INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = PCL.PclVenderDCLocationId
		INNER JOIN dbo.fnSplitString(@ids, ',') TM ON TM.Item = PVL.Id

		CREATE TABLE #tempPclProgramtable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #tempPclProgramtable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PclItemNumber
				)
		FROM PRGRM043ProgramCostLocations
		WHERE PclProgramID = @PclProgramID
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO PRGRM043ProgramCostLocations c1
		USING #tempPclProgramtable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PclItemNumber = c2.PvlItemNumber;

		DROP TABLE #tempPclProgramtable
END
GO
