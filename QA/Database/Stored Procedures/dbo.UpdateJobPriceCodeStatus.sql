SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/20/2020
-- Description:	Update Job Price&Cost Code Status
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobPriceCodeStatus] (
	 @JobId BIGINT
	,@StatusId INT
	,@CustomerId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PriceChargeId BIGINT
		,@ParentOrder Varchar(50)= NULL

	SELECT @PriceChargeId = Max(ID)
	FROM [dbo].[JOBDL061BillableSheet]
	WHERE JobId = @JobId
		AND ISNULL(PrcChargeCode, '') <> ''
		AND LEN(PrcChargeCode) >= 3
		AND SUBSTRING(PrcChargeCode, LEN(PrcChargeCode) - 2, 3) = 'DEL'

	IF (ISNULL(@PriceChargeId, 0) > 0)
	BEGIN
		UPDATE [dbo].[JOBDL061BillableSheet]
		SET StatusId = @StatusId
		WHERE Id = @PriceChargeId

		EXEC [dbo].[UpdateLineNumberForJobBillableSheet] @JobID
	END

	IF (ISNULL(@StatusId, 0) = 1)
	BEGIN
		EXEC [dbo].[GetJobParentIdAfterNavOrderCreation] @JobId
			,@customerId
			,@ParentOrder OUTPUT

		IF (ISNULL(@ParentOrder, '') <>'')
		BEGIN
			UPDATE dbo.JobDL000Master
			SET JobBOLMaster = @ParentOrder
			WHERE Id = @JobId
		END
	END
END
GO

