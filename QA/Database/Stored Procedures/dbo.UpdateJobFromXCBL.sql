SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/15/2020
-- Description:	Get the xCBL Details
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobFromXCBL] 
 (
   @columnsAndValues VARCHAR(MAX),
   @JobId BIGINT
 )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @UpdateQuery VARCHAR(MAX) = 'UPDATE dbo.JOBDL000Master SET ' +
	 @columnsAndValues + ', DateChanged = '''+ CONVERT(VARCHAR, GETDATE()) +'''  WHERE Id = ' 
	      + CONVERT(VARCHAR, @JobId)
	--PRINT(@UpdateQuery)

	EXEC(@UpdateQuery)

END