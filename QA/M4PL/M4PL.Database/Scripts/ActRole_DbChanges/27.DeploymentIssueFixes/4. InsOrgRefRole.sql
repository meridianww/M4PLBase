SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Org Ref Role
-- Execution:                 EXEC [dbo].[InsOrgRefRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgRefRole]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL 
	,@orgRoleCode NVARCHAR(25) = NULL 
	,@orgRoleDefault BIT = NULL 
	,@orgRoleTitle NVARCHAR(50) = NULL 
	,@orgRoleContactId BIGINT  = NULL
	,@roleTypeId INT = NULL 
	,@prxJobDefaultAnalyst BIT  = NULL
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL
	,@prxJobGWDefaultResponsible BIT = NULL 
	,@dateEntered DATETIME2(7) 
	,@enteredBy NVARCHAR(50)  = NULL
	,@phsLogical BIT  = NULL
	,@statusId INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN010Ref_Roles]
              ([OrgId]
              ,[OrgRoleSortOrder]
              ,[OrgRoleCode]
              ,[OrgRoleDefault]
              ,[OrgRoleTitle]
              ,[OrgRoleContactId]
              ,[RoleTypeId]
              ,[PrxJobDefaultAnalyst]
			  ,[PrxJobDefaultResponsible]
              ,[PrxJobGWDefaultAnalyst]
              ,[PrxJobGWDefaultResponsible]
              ,[DateEntered]
              ,[EnteredBy]
              ,[StatusId])
     VALUES
		   (@orgId  
           ,@updatedItemNumber   
           ,@orgRoleCode  
           ,@orgRoleDefault  
           ,@orgRoleTitle  
           ,@orgRoleContactId   
           ,@roleTypeId 
           ,@prxJobDefaultAnalyst   
		   ,@prxJobDefaultResponsible
           ,@prxJobGWDefaultAnalyst   
           ,@PrxJobGWDefaultResponsible    
           ,@dateEntered  
           ,@enteredBy   
           ,@statusId)	
		   SET @currentId = SCOPE_IDENTITY();

		 
	 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @currentId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH