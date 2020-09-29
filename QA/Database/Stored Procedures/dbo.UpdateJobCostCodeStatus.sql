SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/20/2020
-- Description:	Update Job Price&Cost Code Status
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobCostCodeStatus] (
	@JobId BIGINT
	,@StatusId INT
	,@CustomerId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CostChargeId BIGINT
	
	SELECT @CostChargeId = Max(ID)
	FROM [dbo].[JOBDL062CostSheet]
	WHERE JobId = @JobId
		AND ISNULL(CstChargeCode, '') <> ''
		AND LEN(CstChargeCode) >= 3
		AND SUBSTRING(CstChargeCode, LEN(CstChargeCode) - 2, 3) = 'DEL'

	IF (ISNULL(@CostChargeId, 0) > 0)
	BEGIN
		UPDATE [dbo].[JOBDL062CostSheet]
		SET StatusId = @StatusId
		WHERE Id = @CostChargeId

		EXEC [dbo].[UpdateLineNumberForJobCostSheet] @JobID
	END
END
GO

