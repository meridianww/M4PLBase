SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               04/04/2018      
-- Description:               Switch Organization
-- Execution:                 EXEC [dbo].[SwitchOrganization]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[SwitchOrganization]		  
            @userId BIGINT
		   ,@contactId BIGINT 
		   ,@orgId BIGINT = NULL
		   ,@roleId BIGINT
		  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 --DECLARE @roleId BIGINT;
 --SELECT @roleId = actRole.OrgRefRoleId FROM [dbo].[ORGAN020Act_Roles] actRole WHERE actRole.OrgRoleContactID=@contactId AND actRole.OrgID =@orgId
 --IF(@roleId> 0)
	-- BEGIN
	--  UPDATE [dbo].[SYSTM000OpnSezMe]
	--			SET  [SysOrgId] 	 =	 ISNULL(@orgId, SysOrgId)
	--			,[SysOrgRefRoleId]			 =  ISNULL(@roleId, SysOrgRefRoleId)
	--	 WHERE Id = @userId
	-- END 
SELECT [SysPassword] FROM [dbo].[SYSTM000OpnSezMe] where Id = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
