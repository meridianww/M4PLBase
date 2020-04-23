SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/20/2020
-- Description:	Update the xCBL Details
-- =============================================
ALTER PROCEDURE [Xcbl].[UpdatexCBLRejected] (
	 @ChangedByName VARCHAR(50),
	 @gatewayId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SummaryHeaderId BIGINT


	SELECT @SummaryHeaderId  =  XCBLHeaderId
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
	WHERE xCBLHeaderId = @SummaryHeaderId
END


