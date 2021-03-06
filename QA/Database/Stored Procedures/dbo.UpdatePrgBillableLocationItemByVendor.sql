SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/13/2019
-- Description:	Update Job Billable Sheet Item
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePrgBillableLocationItemByVendor]
@ids NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @PblProgramId INT

		SELECT @PblProgramId = PBL.PblProgramId
		FROM dbo.PRGRM042ProgramBillableLocations PBL
		INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = PBL.PblVenderDCLocationId
		INNER JOIN dbo.fnSplitString(@ids, ',') TM ON TM.Item = PVL.Id

		CREATE TABLE #pbltemptable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #pbltemptable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PblItemNumber
				)
		FROM [PRGRM042ProgramBillableLocations]
		WHERE PblProgramID = @PblProgramId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO [PRGRM042ProgramBillableLocations] c1
		USING #pbltemptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PblItemNumber = c2.PvlItemNumber;

		DROP TABLE #pbltemptable
END
GO
