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
	 IF EXISTS(SELECT sbr.Id FROM [dbo].[SYSTM000SecurityByRole] sbr
		JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sbr.OrgRefRoleId = refRole.Id and refRole.Id = @roleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(sbr.[StatusId], 1) = fgus.[StatusId]
	  	WHERE sbr.SecMainModuleId=@currentModuleId AND refRole.OrgId=@orgId)
	  BEGIN
	  	SELECT @currentOptionLevel=SecMenuOptionLevelId, @currentAccessLevel=SecMenuAccessLevelId 
		FROM [dbo].[SYSTM000SecurityByRole] sbr
		JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sbr.OrgRefRoleId = refRole.Id 
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(sbr.[StatusId], 1) = fgus.[StatusId]
	  	INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = refRole.Id AND cb.ConTableName = [dbo].fnGetEntityName(1)
		WHERE sbr.SecMainModuleId=@currentModuleId AND cb.ConOrgId = @orgId
		AND refRole.Id = @roleId
	  END
	  
	 IF EXISTS(SELECT subSbr.Id FROM [dbo].[SYSTM010SubSecurityByRole] subSbr
	 JOIN [dbo].[SYSTM000SecurityByRole] sbr ON subSbr.SecByRoleId=sbr.Id 
	 JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sbr.OrgRefRoleId = refRole.Id 
	 JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSbr.[StatusId], 1) = fgus.[StatusId] 
	 INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = refRole.Id AND cb.ConTableName = [dbo].fnGetEntityName(1)
	 WHERE sbr.SecMainModuleId=@currentModuleId 
	 AND refRole.Id = @roleId AND cb.ConOrgId = @orgId AND subSbr.RefTableName = @entity)
	 
	  BEGIN
	  	SELECT @currentOptionLevel=SubsMenuOptionLevelId, @currentAccessLevel=SubsMenuAccessLevelId 
		FROM [dbo].[SYSTM010SubSecurityByRole] subSbr
	  	INNER JOIN [dbo].[SYSTM000SecurityByRole] sbr ON subSbr.SecByRoleId=sbr.Id 
		INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sbr.OrgRefRoleId = refRole.Id 
	  	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSbr.[StatusId], 1) = fgus.[StatusId] 
		INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = refRole.Id AND cb.ConTableName = [dbo].fnGetEntityName(1)
	  	WHERE refRole.Id = @roleId AND cb.ConOrgId = @orgId AND subSbr.RefTableName = @entity
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
GO

