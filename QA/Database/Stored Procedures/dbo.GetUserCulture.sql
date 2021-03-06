SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               04/14/2018      
-- Description:               Get User Culture 
-- Execution:                 EXEC [dbo].[GetUserCulture]  
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetUserCulture] 
	@userId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT 1 as SysRefId
		 ,'EN' as RefName
		 ,'EN' as LangName
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
