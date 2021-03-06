SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               06/08/2018      
-- Description:               Update user system settings
-- Execution:                 EXEC [dbo].[UpdUserSystemSettings]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[UpdUserSystemSettings]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@sysJsonSetting NVARCHAR(MAX)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>'')
    BEGIN   
	DECLARE  @SysJsonSetting_local NVARCHAR(MAX) = NULL
	SELECT @SysJsonSetting_local = usys.[SysJsonSetting] 
	FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys where usys.GlobalSetting =1 ; 
	 IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode AND usys.GlobalSetting<>1)            
	 BEGIN 	  
	     UPDATE [dbo].[SYSTM000Ref_UserSettings] 
		 SET [SysJsonSetting] = ISNULL(@sysJsonSetting, @SysJsonSetting_local)
		 WHERE UserId=@userId AND OrganizationId=@orgId AND LangCode = @langCode AND GlobalSetting<>1;  
	 END
   ELSE
	   BEGIN
		INSERT INTO [dbo].[SYSTM000Ref_UserSettings](OrganizationId, UserId, LangCode, SysJsonSetting) 
		VALUES(@orgId, @userId, @langCode, ISNULL(@sysJsonSetting, @SysJsonSetting_local));
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
