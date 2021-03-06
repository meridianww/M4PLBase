USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[GetUserSecurities]    Script Date: 5/8/2019 3:20:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetUserSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[GetUserSecurities]     
 @userId BIGINT,    
 @orgId BIGINT,    
 @roleId BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  

	 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		--IF EXISTS(SELECT 1 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] Where actRole.Id= @roleId AND actRole.[OrgId] = @orgId)
		--BEGIN
		--	SELECT orgSec.Id    
		--   ,orgSec.[SecMainModuleId]    
		--   ,orgSec.[SecMenuOptionLevelId]    
		--   ,orgSec.[SecMenuAccessLevelId]    
		-- FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole  
		-- INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] AND (orgSec.SecMenuOptionLevelId > 22) AND (orgSec.SecMenuAccessLevelId > 16)
		-- WHERE actRole.[OrgId] = @orgId  AND actRole.Id = @roleId AND (ISNULL(orgSec.StatusId, 1) =1)  
		--END
		--ELSE
		--BEGIN
			SELECT 
	      Id as SecMainModuleId,
		  27 as SecMenuOptionLevelId,
		  21 as SecMenuAccessLevelId
	    FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId = 22;
		--END

	 END
	 ELSE
	 BEGIN
		 SELECT orgSec.Id    
		   ,orgSec.[SecMainModuleId]    
		   ,orgSec.[SecMenuOptionLevelId]    
		   ,orgSec.[SecMenuAccessLevelId]    
		 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole  
		 INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgRefRoleId] = actRole.[OrgRefRoleId] AND (orgSec.SecMenuOptionLevelId > 22) AND (orgSec.SecMenuAccessLevelId > 16)
		 WHERE actRole.[OrgId] = @orgId  AND actRole.Id = @roleId AND (ISNULL(orgSec.StatusId, 1) =1)  
    END
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH