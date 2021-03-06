USE [M4PL_FreshCopy]
GO
/****** Object:  StoredProcedure [dbo].[UpdSystemAccount]    Script Date: 5/19/2019 7:13:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
               SysUserContactID			= ISNULL(@sysUserContactId,SysUserContactID)
			  ,SysScreenName			= ISNULL(@sysScreenName,SysScreenName) 
			  ,SysPassword				= ISNULL(@sysPassword,SysPassword)  
			  ,SysOrgId					= ISNULL(@sysOrgId,SysOrgId)  
			  ,SysOrgRefRoleId			= ISNULL(@actRoleId,SysOrgRefRoleId) 
			  ,IsSysAdmin				= ISNULL(@isSysAdmin,IsSysAdmin)
			  ,SysAttempts				= ISNULL(@sysAttempts,SysAttempts)  
			  ,StatusId					= ISNULL(@statusId,StatusId)  
			  ,DateChanged				= ISNULL(@dateChanged,DateChanged)
			  ,ChangedBy				= ISNULL(@changedBy, ChangedBy)
			  WHERE Id = @id;

 --update sezme user password security tables
	 UPDATE  [Security].[AUTH050_UserPassword]
	 SET [Password] =ISNULL(@sysPassword,[Password]) 
		,UpdatedBy  = @userId
		,UpdatedDatetime = GETUTCDATE()
	 WHERE UserId = @id AND  @oldPassword <> @sysPassword
			    
	--DECLARE @contTableName NVARCHAR(100)= 'Organization';
	UPDATE [dbo].[CONTC010Bridge] SET 
	ConCodeId = ISNULL(@actRoleId,ConCodeId) 
    ,DateChanged =ISNULL(@dateChanged,DateChanged)
    ,ChangedBy = ISNULL(@changedBy, ChangedBy)
	WHERE ContactMSTRID = @sysUserContactId AND ConTableName = @entity and ConOrgId = @sysOrgId

	 EXEC [dbo].[GetSystemAccount] @userId, @roleId, @sysOrgId, 'EN', @id
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH