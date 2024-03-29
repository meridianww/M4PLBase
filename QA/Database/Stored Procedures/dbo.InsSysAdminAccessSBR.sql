SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana        
-- Create date:               03/30/2018      
-- Description:               Insert System Admin FullRole TO SBR
-- Execution:                 EXEC [dbo].[InsSysAdminAccessSBR]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[InsSysAdminAccessSBR]     
	 --@userId BIGINT,    
	 @orgId BIGINT,    
	 @roleId BIGINT,
	 @enteredBy NVARCHAR(50)  
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  

	 INSERT INTO [dbo].[SYSTM000SecurityByRole]
           (
           [OrgRefRoleId]
           ,[SecLineOrder]
           ,[SecMainModuleId]
           ,[SecMenuOptionLevelId]
           ,[SecMenuAccessLevelId]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           )

		   SELECT
		   @roleId as RoleId
		   ,ROW_NUMBER() OVER( ORDER By Id)
	       ,Id as SecMainModuleId,
		    27 as SecMenuOptionLevelId,
		    21 as SecMenuAccessLevelId
		   ,1
		   ,GETUTCDATE()
		   ,@enteredBy
	    FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId = 22 AND Id <> 178;
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
