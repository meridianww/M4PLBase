/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get Secured resources
-- Execution:                 EXEC [dbo].[GetPasswordTimestamp]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [Security].[GetSecuredResources]
    @sysAdmin BIT,
	@orgId BIGINT,
	@roleCode NVARCHAR(25)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT sbr.[SecMainModuleId] as ResourceId
	,ref.[SysOptionName] as Name
    ,sbr.[SecMenuOptionLevelId] as OptionId
	FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr
	INNER JOIN [dbo].[SYSTM000Ref_Options] ref ON ref.Id= sbr.SecMainModuleId
	INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = sbr.OrgRefRoleId
	INNER JOIN [dbo].[ORGAN010Ref_Roles] orgRefRole ON orgRefRole.Id = sbr.OrgRefRoleId
	WHERE cb.ConOrgId = (CASE WHEN @sysAdmin = 0 THEN @orgId ELSE cb.ConOrgId END)
	    AND orgRefRole.OrgRoleCode = (CASE WHEN @sysAdmin = 0 THEN @roleCode ELSE orgRefRole.OrgRoleCode END)
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

