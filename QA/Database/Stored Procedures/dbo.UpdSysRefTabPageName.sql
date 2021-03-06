SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a Sys ref tab page name 
-- Execution:                 EXEC [dbo].[UpdSysRefTabPageName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdSysRefTabPageName]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id bigint
	,@refTableName nvarchar(100)=NULL
	,@tabSortOrder int =NULL
	,@tabTableName nvarchar(100) =NULL
	,@tabPageTitle nvarchar(50)= NULL
	,@tabExecuteProgram nvarchar(50) = NULL
	,@where NVARCHAR(500) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @tabSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
  
   UPDATE [dbo].[SYSTM030Ref_TabPageName]
		SET  [RefTableName]			= CASE WHEN (@isFormView = 1) THEN @refTableName WHEN ((@isFormView = 0) AND (@refTableName='#M4PL#')) THEN NULL ELSE ISNULL(@refTableName, RefTableName) END
			,[LangCode]				= CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN NULL ELSE ISNULL(@langCode, LangCode) END
			,[TabSortOrder]			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, TabSortOrder) END
			,[TabTableName]			= CASE WHEN (@isFormView = 1) THEN @tabTableName WHEN ((@isFormView = 0) AND (@tabTableName='#M4PL#')) THEN NULL ELSE ISNULL(@tabTableName, TabTableName) END
			,[TabPageTitle]			= CASE WHEN (@isFormView = 1) THEN @tabPageTitle WHEN ((@isFormView = 0) AND (@tabPageTitle='#M4PL#')) THEN NULL ELSE ISNULL(@tabPageTitle, TabPageTitle) END
			,[TabExecuteProgram]    = CASE WHEN (@isFormView = 1) THEN @tabExecuteProgram WHEN ((@isFormView = 0) AND (@tabExecuteProgram='#M4PL#')) THEN NULL ELSE ISNULL(@tabExecuteProgram, TabExecuteProgram) END
			,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]			= @dateChanged
			,[ChangedBy]			= @changedBy
      WHERE Id = @id
	SELECT refTpn.[Id]
		,refTpn.[LangCode]
		,refTpn.[RefTableName]
		,refTpn.[TabSortOrder]
		,refTpn.[TabTableName]
		,refTpn.[TabPageTitle]
		,refTpn.[TabExecuteProgram]
		,refTpn.[StatusId]
		,refTpn.[DateEntered]
		,refTpn.[EnteredBy]
		,refTpn.[DateChanged]
		,refTpn.[ChangedBy]
 FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
 WHERE [Id]=@id AND refTpn.LangCode= @langCode
END TRY        
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
