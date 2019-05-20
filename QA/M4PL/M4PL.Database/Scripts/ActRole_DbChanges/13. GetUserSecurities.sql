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

	 DECLARE @minMenuOptionLevelId INT, @minMenuAccessLevelId INT,
	 @maxMenuOptionLevelId INT, @maxMenuAccessLevelId INT,
	 @mainModuleLookupId INT, @menuOptionLevelLookupId INT, @menuAccessLevelLookupId INT;

	  SELECT @mainModuleLookupId = Id FROM [dbo].[SYSTM000Ref_Lookup] Where LkupCode LIKE 'MainModule%';
	 SELECT @menuOptionLevelLookupId = Id FROM [dbo].[SYSTM000Ref_Lookup] Where LkupCode LIKE 'MenuOptionLevel%';
	 SELECT @menuAccessLevelLookupId = Id FROM [dbo].[SYSTM000Ref_Lookup] Where LkupCode LIKE 'MenuAccessLevel%'

	 SELECT @minMenuOptionLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId= @menuOptionLevelLookupId  ORDER BY SysSortOrder DESC 
	 SELECT @maxMenuOptionLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysSortOrder> 0 AND SysLookupId= @menuOptionLevelLookupId  ORDER BY SysSortOrder 


	 SELECT @minMenuAccessLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId= @menuAccessLevelLookupId  ORDER BY SysSortOrder DESC 
	 SELECT @maxMenuAccessLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysSortOrder> 0 AND SysLookupId= @menuAccessLevelLookupId  ORDER BY SysSortOrder 

	 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
		 BEGIN
			SELECT 
			  Id as SecMainModuleId,
			  @maxMenuOptionLevelId as SecMenuOptionLevelId,
			  @maxMenuAccessLevelId as SecMenuAccessLevelId
			FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId = @mainModuleLookupId;
		 END
	 ELSE
		 BEGIN
			 SELECT sbr.Id    
			   ,sbr.[SecMainModuleId]    
			   ,sbr.[SecMenuOptionLevelId]    
			   ,sbr.[SecMenuAccessLevelId]    
			 FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) refRole  
			 INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr ON sbr.[OrgRefRoleId] = refRole.[Id] AND (sbr.SecMenuOptionLevelId > @minMenuOptionLevelId) AND (sbr.SecMenuAccessLevelId > @minMenuAccessLevelId)
			 WHERE refRole.[OrgId] = @orgId  AND refRole.Id = @roleId AND (ISNULL(sbr.StatusId, 1) =1)  
		END
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO

