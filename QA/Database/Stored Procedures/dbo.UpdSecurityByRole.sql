SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a security by role 
-- Execution:                 EXEC [dbo].[UpdSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@secLineOrder int  = NULL
	,@mainModuleId int = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@actRoleId BIGINT = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 DECLARE @savedRoleCode NVARCHAR(25)
EXEC [dbo].[ResetItemNumber] @userId, @id, @actRoleId, @entity, @secLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 UPDATE [dbo].[SYSTM000SecurityByRole]
		SET 
			 [SecLineOrder]          = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, SecLineOrder) END
			,[SecMainModuleId]       = CASE WHEN (@isFormView = 1) THEN @mainModuleId WHEN ((@isFormView = 0) AND (@mainModuleId=-100)) THEN NULL ELSE ISNULL(@mainModuleId, SecMainModuleId) END
			,[SecMenuOptionLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId, SecMenuOptionLevelId) END
			,[SecMenuAccessLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SecMenuAccessLevelId) END
			,[StatusId]			     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE	 [Id] = @id

	EXECUTE  GetSecurityByRole @userId,@roleId,@orgId,@id;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
