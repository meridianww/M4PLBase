SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               12/18/2018      
-- Description:               Get  Login error Message
-- Execution:                 EXEC [dbo].[GetLoginErrorMessage]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetLoginErrorMessage]  
    @sysmessageCode NVARCHAR(25),  
	@sysRefId INT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
  SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = @sysmessageCode and  SysRefId = @sysRefId
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
