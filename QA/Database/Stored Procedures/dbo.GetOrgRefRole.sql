SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a org Org ref role 
-- Execution:                 EXEC [dbo].[GetOrgRefRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetOrgRefRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT org.[Id]
       ,org.[OrgId]
       ,org.[OrgRoleSortOrder]
       ,org.[OrgRoleCode]
       ,org.[OrgRoleDefault]
       ,org.[OrgRoleTitle]
       ,org.[OrgRoleContactID]
       ,org.[RoleTypeId]
       ,org.[PrxJobDefaultAnalyst]
	   ,org.[PrxJobDefaultResponsible]
       ,org.[PrxJobGWDefaultAnalyst]
       ,org.[PrxJobGWDefaultResponsible]
	   ,org.[StatusId]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
      FROM [dbo].[ORGAN010Ref_Roles] org
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
