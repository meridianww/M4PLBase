/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               03/30/2018      
-- Description:               Get Dashboard on module by User 
-- Execution:                 EXEC [dbo].[GetUserDashboards]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetUserDashboards]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @mainModuleId INT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @roleCode NVARCHAR(25), @isSysAdmin BIT = 0 ; 
 SELECT @isSysAdmin =  sez.IsSysAdmin FROM [dbo].[SYSTM000OpnSezMe] sez where sez.Id= @userId
 SELECT @roleCode = refrole.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] refrole where refrole.Id= @roleId
  SELECT dsh.[Id]
      ,dsh.[DshName]
 FROM [dbo].[SYSTM000Ref_Dashboard] dsh
 WHERE dsh.[DshMainModuleId] =  CASE WHEN ((@isSysAdmin) =1) THEN 
 dsh.DshMainModuleId  ELSE (CASE WHEN (@roleCode = 'SYSADMIN') THEN dsh.[DshMainModuleId] ELSE @mainModuleId END)
	END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

