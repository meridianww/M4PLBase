/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Ins a System Account
-- Execution:                 EXEC [dbo].[UpdSystemAccount]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSystemAccount]      
	 @userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT = NULL  
	,@sysUserContactId BIGINT = NULL   
	,@sysScreenName NVARCHAR(50) = NULL 
	,@sysPassword NVARCHAR(250) = NULL   
	,@sysOrgId BIGINT = NULL   
	,@actRoleId BIGINT = NULL   
	,@isSysAdmin BIT = NULL 
	,@sysAttempts INT = NULL     
	,@statusId INT = NULL      
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL       
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     

  DECLARE @oldPassword Nvarchar(255)
  SELECT @oldPassword = SysPassword FROM SYSTM000OpnSezMe WHERE Id = @id;
 
   UPDATE [dbo].[SYSTM000OpnSezMe] SET
               SysUserContactID			= CASE WHEN (@isFormView = 1) THEN @sysUserContactId WHEN ((@isFormView = 0) AND (@sysUserContactId=-100)) THEN NULL ELSE ISNULL(@sysUserContactId,SysUserContactID) END
			  ,SysScreenName			= CASE WHEN (@isFormView = 1) THEN @sysScreenName WHEN ((@isFormView = 0) AND (@sysScreenName='#M4PL#')) THEN NULL ELSE ISNULL(@sysScreenName,SysScreenName) END
			  ,SysPassword				= CASE WHEN (@isFormView = 1) THEN @sysPassword WHEN ((@isFormView = 0) AND (@sysPassword='#M4PL#')) THEN NULL ELSE ISNULL(@sysPassword,SysPassword)  END
			  ,SysOrgId					= CASE WHEN (@isFormView = 1) THEN @sysOrgId WHEN ((@isFormView = 0) AND (@sysOrgId=-100)) THEN NULL ELSE ISNULL(@sysOrgId,SysOrgId)  END
			  ,SysOrgRefRoleId			= CASE WHEN (@isFormView = 1) THEN @actRoleId WHEN ((@isFormView = 0) AND (@actRoleId=-100)) THEN NULL ELSE ISNULL(@actRoleId,SysOrgRefRoleId)  END
			  ,IsSysAdmin				= ISNULL(@isSysAdmin,IsSysAdmin)
			  ,SysAttempts				= CASE WHEN (@isFormView = 1) THEN @sysAttempts WHEN ((@isFormView = 0) AND (@sysAttempts=-100)) THEN NULL ELSE ISNULL(@sysAttempts,SysAttempts)  END
			 ,StatusId					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId)  END
			  ,DateChanged				= @dateChanged
			  ,ChangedBy				= @changedBy 
			  WHERE Id = @id;

 --update sezme user password security tables
	 UPDATE  [Security].[AUTH050_UserPassword]
	 SET [Password] = @sysPassword 
		,UpdatedBy  = @userId
		,UpdatedDatetime = GETUTCDATE()
	 WHERE UserId = @id AND  @oldPassword <> @sysPassword
			    
	UPDATE [dbo].[CONTC010Bridge] SET 
	ConCodeId = @actRoleId
    ,DateChanged = @dateChanged
    ,ChangedBy = @changedBy
	WHERE ContactMSTRID = @sysUserContactId AND ConTableName = @entity AND ConOrgId = @sysOrgId

	 EXEC [dbo].[GetSystemAccount] @userId, @roleId, @sysOrgId, 'EN', @id
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

