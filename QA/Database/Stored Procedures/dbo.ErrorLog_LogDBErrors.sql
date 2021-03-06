SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Ramkumar         
-- Create date:               04/11/2018      
-- Description:               gets the last occured error and severity and passes to insert it in log table  
-- Execution:                 EXEC [dbo].[ErrorLog_LogDBErrors]   
-- Modified on:  
-- Modified Desc:  
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
			EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
		END
	END TRY 
	BEGIN CATCH  
	END CATCH 
END
GO
