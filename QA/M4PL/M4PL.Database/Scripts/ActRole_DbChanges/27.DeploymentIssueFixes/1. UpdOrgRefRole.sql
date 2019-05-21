SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Org Ref Role
-- Execution:                 EXEC [dbo].[UpdOrgRefRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgRefRole]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL 
	,@orgRoleCode NVARCHAR(25) = NULL 
	,@orgRoleDefault BIT = NULL 
	,@orgRoleTitle NVARCHAR(50) = NULL 
	,@orgRoleContactId BIGINT = NULL 
	,@roleTypeId INT = NULL 
	,@prxJobDefaultAnalyst BIT  = NULL
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL
	,@prxJobGWDefaultResponsible BIT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL 
	,@statusId INT = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  UPDATE [dbo].[ORGAN010Ref_Roles]
       SET     --OrgId 						=	NULL
               OrgRoleSortOrder 			=	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OrgRoleSortOrder) END
              ,OrgRoleCode 					=	CASE WHEN (@isFormView = 1) THEN @orgRoleCode WHEN ((@isFormView = 0) AND (@orgRoleCode='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleCode, OrgRoleCode) END
              ,OrgRoleDefault 				=	ISNULL(@orgRoleDefault, OrgRoleDefault)
              ,OrgRoleTitle 				=	CASE WHEN (@isFormView = 1) THEN @orgRoleTitle WHEN ((@isFormView = 0) AND (@orgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleTitle, OrgRoleTitle) END
              ,OrgRoleContactId 			=	CASE WHEN (@isFormView = 1) THEN @orgRoleContactId WHEN ((@isFormView = 0) AND (@orgRoleContactId=-100)) THEN NULL ELSE ISNULL(@orgRoleContactId, OrgRoleContactId) END
              ,RoleTypeId 					=	CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END
              ,PrxJobDefaultAnalyst 		=	ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)
			  ,PrxJobDefaultResponsible 	=	ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)
              ,PrxJobGWDefaultAnalyst 		=	ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)
              ,PrxJobGWDefaultResponsible	=	ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)  
              ,StatusId  					=	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
              ,DateChanged 					=	@dateChanged  
              ,ChangedBy 					=	@changedBy 
     WHERE Id =	@id		
	
 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH