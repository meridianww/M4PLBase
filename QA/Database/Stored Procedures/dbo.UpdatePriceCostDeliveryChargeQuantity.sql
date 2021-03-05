SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 03/05/2021
-- Description:	Update Price/Cost Delivery Charge Quantity
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePriceCostDeliveryChargeQuantity] (@jobId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @QuantityCount INT

	SELECT @QuantityCount = SUM(ISNULL(CgoQtyOnHold,0))
	FROM dbo.JobDL010Cargo
	WHERE JobId = @JobId
		AND StatusId = 1
		AND (CgoQtyUnits = 'CABINET' OR CgoQtyUnitsId = 198)

		UPDATE dbo.JOBDL061BillableSheet
		SET PrcQuantity = @QuantityCount
		WHERE CASE 
				WHEN ISNULL([PrcChargeCode], '') <> ''
					AND LEN([PrcChargeCode]) >= 3
					AND SUBSTRING([PrcChargeCode], LEN([PrcChargeCode]) - 2, 3) = 'DEL'
					THEN 1
				ELSE 0
				END = 1
			AND JobId = @jobId

		UPDATE dbo.JOBDL062CostSheet
		SET CstQuantity = @QuantityCount
		WHERE CASE 
				WHEN ISNULL([CstChargeCode], '') <> ''
					AND LEN([CstChargeCode]) >= 3
					AND SUBSTRING([CstChargeCode], LEN([CstChargeCode]) - 2, 3) = 'DEL'
					THEN 1
				ELSE 0
				END = 1
			AND JobId = @jobId
END
GO

