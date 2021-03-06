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
CREATE PROCEDURE [dbo].[GetUserContactType]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@roleId BIGINT
	AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE  @locationOld NVARCHAR(MAX) = NULL
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@roleId,0)<>0)
    BEGIN   
	SELECT con.ConTypeId 
	  FROM [dbo].[SYSTM000OpnSezMe] AS sez  
  INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.[Id]  
  INNER JOIN [dbo].[ORGAN000Master] org ON sez.[SysOrgId] = org.Id  
  INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sez.[SysOrgRefRoleId] = refRole.Id  
    WHERE  sez.[Id]  = @userId AND  org.Id   = @orgId AND refRole.Id   = @roleId;
	END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
