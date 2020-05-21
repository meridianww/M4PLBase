SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 21/May/2020
-- Description:	Complete a Job
-- =============================================
CREATE PROCEDURE [dbo].[CompleteJobById] (
	@JobId BIGINT
	,@User VARCHAR(100)
	,@DeliveryDate DATETIME2(7)
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL000Master]
	SET JobCompleted = 1,
	     StatusId = 3
		,DateChanged = GETUTCDATE()
		,ChangedBy = @User
	WHERE Id = @JobId
	AND JobDeliveryDateTimePlanned < @DeliveryDate
	AND StatusId = 1

		UPDATE JOBDL020Gateways
	SET StatusID = 195
		,GwyCompleted = 1
	WHERE GwyGatewayPCD < @DeliveryDate
		AND StatusId = 1


END
GO

