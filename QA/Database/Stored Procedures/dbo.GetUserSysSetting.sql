SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Akhil Chauhan               
-- Create date:               12/09/2018            
-- Description:               Get User System Setting        
-- Execution:                 EXEC [dbo].[GetUserSysSetting]        
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)          
-- Modified Desc:        
-- =============================================              
CREATE PROCEDURE  [dbo].[GetUserSysSetting]  
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @contactId BIGINT            
AS            
BEGIN TRY                            
 SET NOCOUNT ON;         
          
IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.GlobalSetting=0)            
 BEGIN          
   
    SELECT  usys.[Id]
			,usys.[OrganizationId]
			,usys.[UserId]
			,usys.[LangCode]
			,usys.[SysJsonSetting]
			  
    	 ,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon   
	    FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.GlobalSetting=0             
  END            
ELSE            
 BEGIN  
   IF EXISTS(SELECT TOP 1 1 FROM CONTC000Master where Id=@contactId ) 
   BEGIN        
   SELECT  usys.[Id]
			,usys.[OrganizationId]
			,usys.[UserId]
			,usys.[LangCode]
			,usys.[SysJsonSetting]
			  
    	 ,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon   
	    FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE  usys.GlobalSetting=1     
	END	  
 END        
            
END TRY                            
BEGIN CATCH                            
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                            
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                            
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                            
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                            
END CATCH
GO
