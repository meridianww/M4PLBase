/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara       
-- Create date:               12/17/2018      
-- Description:               Ins a System Account
-- Execution:                 EXEC [dbo].[InsSystemAccount]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[InsSystemAccount]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId BIGINT = NULL 
	,@sysUserContactId BIGINT = NULL   
	,@sysScreenName NVARCHAR(50) = NULL 
	,@sysPassword NVARCHAR(250) = NULL   
	,@sysOrgId BIGINT = NULL    
	,@actRoleId BIGINT = NULL   
	,@isSysAdmin BIT = 0
	,@sysAttempts INT = NULL
	,@statusId INT = NULL      
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
   INSERT INTO [dbo].[SYSTM000OpnSezMe]
            (  [SysUserContactID]
			  ,[SysScreenName]
			  ,[SysPassword]
			  ,[SysOrgId]
			  ,[SysOrgRefRoleId]
			  ,[IsSysAdmin]
			  ,[SysAttempts]
			  ,[StatusId]
			  ,[DateEntered]
			  ,[EnteredBy]			 
			  )  
     VALUES  
      (     @sysUserContactId 
	       ,@sysScreenName
           ,@sysPassword 
           ,@sysOrgId 
           ,@actRoleId
           ,@isSysAdmin
		   ,@sysAttempts		  
		   ,@statusId
		   ,@dateEntered
		   ,@enteredBy)    
 SET @currentId = SCOPE_IDENTITY();  

 --INSERT sezme user into security tables
 INSERT INTO [Security].[AUTH050_UserPassword](UserId,[Password],UpdatedBy,UpdatedDatetime) Values (@currentId,@sysPassword,@userId, @dateEntered)

 DECLARE @contactTitle NVARCHAR(50), @conTypeId INT;

 SELECT @contactTitle = ConJobTitle, @conTypeId = ConTypeId FROM [dbo].[CONTC000Master] con WHERE con.Id = @sysUserContactId

 INSERT INTO [dbo].[CONTC010Bridge]
           ([ConOrgId]
           ,[ContactMSTRID]
           ,[ConTableName]
           ,[ConPrimaryRecordId]
           ,[ConTitle]
           ,[ConCodeId]
           ,[ConTypeId]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@sysOrgId
           ,@sysUserContactId
           ,@entity
		   ,@sysOrgId
           ,@contactTitle
           ,@actRoleId
		   ,@conTypeId
           ,@statusId
           ,@enteredBy
           ,@dateEntered)


 EXEC [dbo].[GetSystemAccount] @userId, @roleId, @orgId, 'EN', @currentId

END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

