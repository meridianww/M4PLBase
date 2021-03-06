SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               09/22/2018      
-- Description:               Upd a system message
-- Execution:                 EXEC [dbo].[UpdSystemMessage]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdSystemMessage]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id bigint
	,@sysMessageCode nvarchar(25) = NULL
	,@sysRefId int
	,@sysMessageScreenTitle nvarchar(50) = NULL
	,@sysMessageTitle nvarchar(50) = NULL
	,@sysMessageDescription nvarchar(MAX) = NULL
	,@sysMessageInstruction nvarchar(MAX) = NULL
	,@sysMessageButtonSelection nvarchar(100) = NULL
	,@statusId INT = NULL      
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[SYSTM000Master]
		SET  [LangCode]                      = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END
			,[SysMessageCode]                = CASE WHEN (@isFormView = 1) THEN @sysMessageCode WHEN ((@isFormView = 0) AND (@sysMessageCode='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageCode, SysMessageCode) END
			,[SysRefId]                      = @sysRefId
			,[SysMessageScreenTitle]         = CASE WHEN (@isFormView = 1) THEN @sysMessageScreenTitle WHEN ((@isFormView = 0) AND (@sysMessageScreenTitle='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageScreenTitle, SysMessageScreenTitle) END
			,[SysMessageTitle]               = CASE WHEN (@isFormView = 1) THEN @sysMessageTitle WHEN ((@isFormView = 0) AND (@sysMessageTitle='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageTitle, SysMessageTitle) END
			,[SysMessageDescription]         = CASE WHEN (@isFormView = 1) THEN @sysMessageDescription WHEN ((@isFormView = 0) AND (@sysMessageDescription='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageDescription, SysMessageDescription) END
			,[SysMessageInstruction]         = CASE WHEN (@isFormView = 1) THEN @sysMessageInstruction WHEN ((@isFormView = 0) AND (@sysMessageInstruction='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageInstruction, SysMessageInstruction) END
			,[SysMessageButtonSelection]     = CASE WHEN (@isFormView = 1) THEN @sysMessageButtonSelection WHEN ((@isFormView = 0) AND (@sysMessageButtonSelection='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageButtonSelection, SysMessageButtonSelection) END
			,[StatusId]					     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]                   = @dateChanged
			,[ChangedBy]                     = @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysMessageCode]
		,syst.[SysRefId]
		,syst.[SysMessageScreenTitle]
		,syst.[SysMessageTitle]
		,syst.[SysMessageButtonSelection]
		,syst.[StatusId]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Master] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
