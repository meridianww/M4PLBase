USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[GetUserSubSecurities]    Script Date: 5/8/2019 3:20:37 PM ******/
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
-- Execution:                 EXEC [dbo].[GetUserSubSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[GetUserSubSecurities] 
 @userId BIGINT,  
 @secByRoleId BIGINT,  
 @orgId BIGINT,  
 @roleId BIGINT
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  IF NOT EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		 SELECT 
		 subSec.SecByRoleId  
		   ,subSec.RefTableName  
		   ,subSec.SubsMenuOptionLevelId   
		   ,subSec.SubsMenuAccessLevelId   
		 FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec  
		 INNER JOIN [dbo].[ORGAN020Act_Roles](NOLOCK) rol ON sec.OrgActRoleId = rol.Id
		 INNER JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) refSec ON refSec.[OrgRefRoleId]= rol.OrgRefRoleId 
		 INNER JOIN [dbo].[SYSTM010SubSecurityByRole](NOLOCK) subSec ON subSec.[SecByRoleId]= refSec.Id 
		 WHERE sec.OrgId= @orgId AND rol.Id= @roleId AND refSec.Id = @secByRoleId AND subSec.StatusId=1 AND sec.StatusId=1 AND refSec.StatusId=1;
	 END
  ELSE IF EXISTS(SELECT 1 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] Where actRole.Id= @roleId AND actRole.[OrgId] = @orgId)
  BEGIN
	SELECT 
		 subSec.SecByRoleId  
		   ,subSec.RefTableName  
		   ,27 as SecMenuOptionLevelId   
		   ,21 as SecMenuAccessLevelId
		 FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec  
		 INNER JOIN [dbo].[ORGAN020Act_Roles](NOLOCK) rol ON sec.OrgActRoleId = rol.Id
		 INNER JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) refSec ON refSec.[OrgRefRoleId]= rol.OrgRefRoleId 
		 INNER JOIN [dbo].[SYSTM010SubSecurityByRole](NOLOCK) subSec ON subSec.[SecByRoleId]= refSec.Id 
		 WHERE sec.OrgId= @orgId AND rol.Id= @roleId AND refSec.Id = @secByRoleId AND subSec.StatusId=1 AND sec.StatusId=1 AND refSec.StatusId=1;
  END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH