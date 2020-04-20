SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/20/2020
-- Description:	Update the xCBL Details
-- =============================================
ALTER PROCEDURE xcbl.UpdatexCBLRejected (
	@CustomerReferenceNo VARCHAR(30)
	,@ChangedByName VARCHAR(50)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SummaryHeaderId BIGINT

	SELECT @SummaryHeaderId = MAX(SummaryHeaderId)
	FROM [Xcbl].[SummaryHeader]
	WHERE CustomerReferenceNo = @CustomerReferenceNo

	UPDATE [Xcbl].[SummaryHeader]
	SET [isxcblProcessed] = 1
		,[isxcblRejected] = 1
		,[ProcessingDate] = GETDATE()
		,[DateChanged] = GETDATE()
		,[ChangedBy] = @ChangedByName
	WHERE SummaryHeaderId = @SummaryHeaderId
END
GO

