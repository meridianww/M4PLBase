USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgRefRole]    Script Date: 5/16/2019 10:04:53 AM ******/
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
-- Modified on:               11/27/2018( Nikhil)  
-- Modified Desc:             Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.
-- Modified on:               05/10/2019( Nikhil)
-- Modified Desc:             Modified UPDATE statment to remove #M4PL# and -100  to pass them  as orignal values ,Line(45-60)  
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
               OrgRoleSortOrder 			=	ISNULL(@updatedItemNumber, OrgRoleSortOrder) 
              ,OrgRoleCode 					=   ISNULL(@orgRoleCode, OrgRoleCode) 
              ,OrgRoleDefault 				=	ISNULL(@orgRoleDefault, OrgRoleDefault)
              ,OrgRoleTitle 				=	ISNULL(@orgRoleTitle, OrgRoleTitle) 
              ,OrgRoleContactId 			=	ISNULL(@orgRoleContactId, OrgRoleContactId) 
              ,RoleTypeId 					=	ISNULL(@roleTypeId, RoleTypeId) 
              ,PrxJobDefaultAnalyst 		=	ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)
			  ,PrxJobDefaultResponsible 	=	ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)
              ,PrxJobGWDefaultAnalyst 		=	ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)
              ,PrxJobGWDefaultResponsible	=	ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)  
              ,StatusId  					=	ISNULL(@statusId, StatusId)
              ,DateChanged 					=	ISNULL(@dateChanged  ,DateChanged)
              ,ChangedBy 					=	ISNULL(@changedBy ,ChangedBy)
     WHERE Id =	@id		
	
 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
