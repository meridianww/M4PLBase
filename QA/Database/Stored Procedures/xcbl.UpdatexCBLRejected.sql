SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/20/2020
-- Description:	Update the xCBL Details
-- =============================================
CREATE PROCEDURE [Xcbl].[UpdatexCBLRejected] (
	 @ChangedByName VARCHAR(50),
	 @gatewayId BIGINT,
	 @User VARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SummaryHeaderId BIGINT
	DECLARE @JobId BIGINT


	SELECT @SummaryHeaderId  =  XCBLHeaderId,
	       @JobId = JobId
	FROM [dbo].[JOBDL020Gateways]
	WHERE Id = @gatewayId


	UPDATE [Xcbl].[SummaryHeader]
	SET [isxcblProcessed] = 1
		,[isxcblRejected] = 1
		,[ProcessingDate] = GETDATE()
		,[DateChanged] = GETDATE()
		,[ChangedBy] = @ChangedByName
	WHERE SummaryHeaderId = @SummaryHeaderId

	UPDATE [dbo].[JOBDL020Gateways]
	SET GwyCompleted = 1
	WHERE Id = @gatewayId

	UPDATE [dbo].[JOBDL000Master]
	SET DateChanged =  GETDATE(),
	ChangedBy = @User
	WHERE Id = @JobId

END



GO
