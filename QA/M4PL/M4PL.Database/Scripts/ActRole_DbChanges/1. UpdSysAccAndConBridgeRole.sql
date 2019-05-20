/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan  
-- Create date:               05/19/2019      
-- Description:               To update system account defaultRole
-- Modified on:               
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdSysAccAndConBridgeRole]      
	 @userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@updateSysAccount BIT
	,@sysUserContactId BIGINT = NULL   
	,@sysOrgId BIGINT = NULL   
	,@actRoleId BIGINT = NULL   
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
	
	UPDATE [dbo].[CONTC010Bridge] SET 
	 ConCodeId = @actRoleId
    ,DateChanged = @dateChanged
    ,ChangedBy = @changedBy
	WHERE ContactMSTRID = @sysUserContactId 
	AND ConTableName = @entity 
	AND ConOrgId = @sysOrgId


	IF(ISNULL(@updateSysAccount,0) = 1)
		BEGIN
		 UPDATE [dbo].[SYSTM000OpnSezMe] SET
               SysOrgRefRoleId = @actRoleId
			  ,DateChanged = @dateChanged
			  ,ChangedBy = @changedBy 
			  WHERE SysUserContactID = @sysUserContactId
			  AND SysOrgId = @sysOrgId
		END
	 
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

