
-- =============================================
-- Author:  Ramkumar 
-- Create date: 11 April 2016
-- Description:	gets the last occured error and severity and passes to insert it in log table
-- =============================================
CREATE PROCEDURE [dbo].[ErrorLog_LogDBErrors] 
	@RelatedTo VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		BEGIN
			DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
				@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())

			EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
		END
	END TRY 
	BEGIN CATCH  
	END CATCH 
END