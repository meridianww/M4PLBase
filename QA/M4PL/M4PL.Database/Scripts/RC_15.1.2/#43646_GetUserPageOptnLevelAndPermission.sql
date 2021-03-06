USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[GetUserPageOptnLevelAndPermission]    Script Date: 5/15/2019 11:38:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               07/23/2018      
-- Description:               Get GetPageOptionLevelAndPermission
-- Execution:                 EXEC [dbo].[GetPageOptionLevelAndPermission] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetUserPageOptnLevelAndPermission]
    @userId BIGINT,
    @orgId BIGINT,
    @roleId BIGINT,
	@entity NVARCHAR(100)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentOptionLevel INT = -1, @currentAccessLevel INT = -1, @currentModuleId INT = -1;

 SELECT @currentModuleId=TblMainModuleId FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity

 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000MenuDriver] menuDriver JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( menuDriver.[StatusId], 1) = fgus.[StatusId] WHERE MnuTableName = @entity AND MnuModuleId = @currentModuleId)
  BEGIN
	SELECT @currentOptionLevel=MnuOptionLevelId, @currentAccessLevel=MnuAccessLevelId FROM [dbo].[SYSTM000MenuDriver] menuDriver
	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( menuDriver.[StatusId], 1) = fgus.[StatusId]
	WHERE MnuTableName = @entity AND MnuModuleId = @currentModuleId
  END
 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		SET @currentOptionLevel = 27;
		SET @currentAccessLevel = 21;
	 END
 ELSE
 BEGIN
	 IF EXISTS(SELECT sec.Id FROM [dbo].[ORGAN021Act_SecurityByRole] sec
		JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
		JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) refSec ON refSec.[OrgRefRoleId]= actRole.OrgRefRoleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(refSec.[StatusId], 1) = fgus.[StatusId]
	  	WHERE refSec.SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId)
	  BEGIN
	  	SELECT @currentOptionLevel=refSec.SecMenuOptionLevelId, @currentAccessLevel=refSec.SecMenuAccessLevelId FROM [dbo].[ORGAN021Act_SecurityByRole] sec
		JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
		JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) refSec ON refSec.[OrgRefRoleId]= actRole.OrgRefRoleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(sec.[StatusId], 1) = fgus.[StatusId]
	  	WHERE refSec.SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId
	  END
	  
	 IF EXISTS(SELECT subSec.Id FROM [dbo].[ORGAN021Act_SecurityByRole] sec  
	 JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
	 INNER JOIN [dbo].[SYSTM000SecurityByRole] refSec ON refSec.[OrgRefRoleId]= actRole.OrgRefRoleId 
	 INNER JOIN [dbo].[SYSTM010SubSecurityByRole] subSec ON subSec.[SecByRoleId]= refSec.Id
	 JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSec.[StatusId], 1) = fgus.[StatusId] 
	 WHERE refSec.SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId AND RefTableName=@entity)
	  BEGIN
	  	SELECT @currentOptionLevel=SubsMenuOptionLevelId, @currentAccessLevel=SubsMenuAccessLevelId FROM [dbo].[ORGAN021Act_SecurityByRole] sec  
		 JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
		 INNER JOIN [dbo].[SYSTM000SecurityByRole] refSec ON refSec.[OrgRefRoleId]= actRole.OrgRefRoleId 
		 INNER JOIN [dbo].[SYSTM010SubSecurityByRole] subSec ON subSec.[SecByRoleId]= refSec.Id
		 JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSec.[StatusId], 1) = fgus.[StatusId] 
		 WHERE refSec.SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId AND RefTableName=@entity
	  END
 END

 SELECT @userId AS Id, @currentModuleId AS SecMainModuleId, @currentOptionLevel AS SecMenuOptionLevelId, @currentAccessLevel AS SecMenuAccessLevelId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH