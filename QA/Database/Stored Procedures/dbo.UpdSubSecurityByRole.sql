SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a subsecurity by role 
-- Execution:                 EXEC [dbo].[UpdSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@secByRoleId bigint = NULL
	,@refTableName nvarchar(100) = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[SYSTM010SubSecurityByRole]
		SET  [SecByRoleId]				= CASE WHEN (@isFormView = 1) THEN @secByRoleId WHEN ((@isFormView = 0) AND (@secByRoleId=-100)) THEN NULL ELSE ISNULL(@secByRoleId, SecByRoleId) END
			,[RefTableName]				= CASE WHEN (@isFormView = 1) THEN @refTableName WHEN ((@isFormView = 0) AND (@refTableName='#M4PL#')) THEN NULL ELSE ISNULL(@refTableName, RefTableName) END
			,[SubsMenuOptionLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId,SubsMenuOptionLevelId) END
			,[SubsMenuAccessLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SubsMenuAccessLevelId) END
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]				= @dateChanged
			,[ChangedBy]				= @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		 ,syst.[SecByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[SYSTM010SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
