SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara      
-- Create date:               01/23/2018      
-- Description:               Get system settings
-- Execution:                 EXEC [dbo].[GetSystemSettings]
-- Modified on:  
-- Modified Desc:  
-- =============================================     
CREATE PROCEDURE [dbo].[GetSystemSettings]
 @langCode NVARCHAR(24)   
AS    
BEGIN TRY      
 SET NOCOUNT ON;     
 SELECT settings.[Id]
      ,settings.[OrganizationId]
      ,settings.[UserId]
      ,settings.[LangCode]
      ,settings.[SysJsonSetting]
   FROM [dbo].[SYSTM000Ref_UserSettings](NOLOCK) settings WHERE   settings.LangCode= @langCode AND settings.GlobalSetting=1
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
