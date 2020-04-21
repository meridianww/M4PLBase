SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/15/2020
-- Description:	Get the xCBL Details
-- =============================================
ALTER PROCEDURE [dbo].[UpdateJobFromXCBL] 
 (
   @columnsAndValues VARCHAR(MAX),
   @JobId BIGINT,
   @SummaryHeaderId BIGINT
 )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @UpdateQuery VARCHAR(MAX) = 'UPDATE dbo.JOBDL000Master SET ' +
	 @columnsAndValues + ', DateChanged = '''+ CONVERT(VARCHAR, GETDATE()) +'''  WHERE Id = ' 
	      + CONVERT(VARCHAR, @JobId)

	EXEC(@UpdateQuery)

	UPDATE [dbo].[JOBDL020Gateways]
	SET GwyCompleted = 1
	WHERE xCBLHeaderId = @SummaryHeaderId

END