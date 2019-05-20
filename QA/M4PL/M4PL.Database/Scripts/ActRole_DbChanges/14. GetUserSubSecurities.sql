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

	 DECLARE  @maxMenuOptionLevelId INT, @maxMenuAccessLevelId INT,
	  @menuOptionLevelLookupId INT, @menuAccessLevelLookupId INT;

	 SELECT @menuOptionLevelLookupId = Id FROM [dbo].[SYSTM000Ref_Lookup] Where LkupCode LIKE 'MenuOptionLevel%';
	 SELECT @menuAccessLevelLookupId = Id FROM [dbo].[SYSTM000Ref_Lookup] Where LkupCode LIKE 'MenuAccessLevel%'

	 SELECT @maxMenuOptionLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysSortOrder > 0 AND SysLookupId= @menuOptionLevelLookupId  ORDER BY SysSortOrder 
	 SELECT @maxMenuAccessLevelId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysSortOrder > 0 AND SysLookupId= @menuAccessLevelLookupId  ORDER BY SysSortOrder 
	 

	  IF NOT EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
		 BEGIN
			  SELECT subSbr.SecByRoleId,
			  subSbr.RefTableName,
			  @maxMenuOptionLevelId as SecMenuOptionLevelId,
			  @maxMenuAccessLevelId as SecMenuAccessLevelId
			  FROM  [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr
			  INNER JOIN [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) subSbr ON subSbr.SecByRoleId = sbr.Id
			  WHERE subSbr.SecByRoleId = @secByRoleId
		 END
	  ELSE
		  BEGIN
			  SELECT subSbr.SecByRoleId,
			  subSbr.RefTableName,
			  subSbr.SubsMenuOptionLevelId,
			  subSbr.SubsMenuAccessLevelId
			  FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) subSbr 
			  INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr ON subSbr.SecByRoleId = sbr.Id
			  WHERE subSbr.SecByRoleId = @secByRoleId AND subSbr.StatusId=1 AND sbr.StatusId=1;
		  END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

