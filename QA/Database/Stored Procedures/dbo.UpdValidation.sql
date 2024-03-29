SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a sys validation
-- Execution:                 EXEC [dbo].[UpdValidation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdValidation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id BIGINT
	,@valTableName NVARCHAR(100) 
	,@refTabPageId BIGINT 
	,@valFieldName NVARCHAR(50)  = NULL
	,@valRequired BIT   = NULL
	,@valRequiredMessage NVARCHAR(255)   = NULL
	,@valUnique BIT   = NULL
	,@valUniqueMessage NVARCHAR(255)   = NULL
	,@valRegExLogic0 NVARCHAR(255)   = NULL
	,@valRegEx1 NVARCHAR(255)   = NULL
	,@valRegExMessage1 NVARCHAR(255)   = NULL
	,@valRegExLogic1 NVARCHAR(255)  = NULL 
	,@valRegEx2 NVARCHAR(255)   = NULL
	,@valRegExMessage2 NVARCHAR(255)  = NULL 
	,@valRegExLogic2 NVARCHAR(255)   = NULL
	,@valRegEx3 NVARCHAR(255)   = NULL
	,@valRegExMessage3 NVARCHAR(255)   = NULL
	,@valRegExLogic3 NVARCHAR(255)   = NULL
	,@valRegEx4 NVARCHAR(255)   = NULL
	,@valRegExMessage4 NVARCHAR(255)   = NULL
	,@valRegExLogic4 NVARCHAR(255)   = NULL
	,@valRegEx5 NVARCHAR(255)   = NULL
	,@valRegExMessage5 NVARCHAR(255)   = NULL
	,@statusId INT = NULL      
	,@dateChanged DATETIME2(7)   = NULL
	,@changedBy NVARCHAR(50)    = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM000Validation]
     SET    LangCode		   = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END 
           ,ValTableName 	   = @valTableName  
           ,RefTabPageId 	   = ISNull(@refTabPageId,RefTabPageId)  
           ,ValFieldName 	   = CASE WHEN (@isFormView = 1) THEN @valFieldName WHEN ((@isFormView = 0) AND (@valFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@valFieldName, ValFieldName) END
           ,ValRequired 	   = ISNULL(@valRequired, ValRequired)
           ,ValRequiredMessage = CASE WHEN (@isFormView = 1) THEN @valRequiredMessage WHEN ((@isFormView = 0) AND (@valRequiredMessage='#M4PL#')) THEN NULL ELSE ISNULL(@valRequiredMessage, ValRequiredMessage) END  
           ,ValUnique 		   = ISNULL(@valUnique, ValUnique)
           ,ValUniqueMessage   = CASE WHEN (@isFormView = 1) THEN @valUniqueMessage WHEN ((@isFormView = 0) AND (@valUniqueMessage='#M4PL#')) THEN NULL ELSE ISNULL(@valUniqueMessage, ValUniqueMessage) END
           ,ValRegExLogic0 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic0 WHEN ((@isFormView = 0) AND (@valRegExLogic0='-100')) THEN NULL ELSE ISNULL(@valRegExLogic0, ValRegExLogic0) END
           ,ValRegEx1 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx1 WHEN ((@isFormView = 0) AND (@valRegEx1='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx1, ValRegEx1) END
           ,ValRegExMessage1   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage1 WHEN ((@isFormView = 0) AND (@valRegExMessage1='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage1, ValRegExMessage1) END
           ,ValRegExLogic1 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic1 WHEN ((@isFormView = 0) AND (@valRegExLogic1='-100')) THEN NULL ELSE ISNULL(@valRegExLogic1, ValRegExLogic1) END
           ,ValRegEx2 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx2 WHEN ((@isFormView = 0) AND (@valRegEx2='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx2, ValRegEx2) END
           ,ValRegExMessage2   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage2 WHEN ((@isFormView = 0) AND (@valRegExMessage2='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage2, ValRegExMessage2) END
           ,ValRegExLogic2 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic2 WHEN ((@isFormView = 0) AND (@valRegExLogic2='-100')) THEN NULL ELSE ISNULL(@valRegExLogic2, ValRegExLogic2) END
           ,ValRegEx3 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx3 WHEN ((@isFormView = 0) AND (@valRegEx3='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx3, ValRegEx3) END
           ,ValRegExMessage3   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage3 WHEN ((@isFormView = 0) AND (@valRegExMessage3='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage3, ValRegExMessage3) END 
           ,ValRegExLogic3 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic3 WHEN ((@isFormView = 0) AND (@valRegExLogic3='-100')) THEN NULL ELSE ISNULL(@valRegExLogic3, ValRegExLogic3) END
           ,ValRegEx4 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx4 WHEN ((@isFormView = 0) AND (@valRegEx4='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx4, ValRegEx4) END
           ,ValRegExMessage4   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage4 WHEN ((@isFormView = 0) AND (@valRegExMessage4='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage4, ValRegExMessage4) END
           ,ValRegExLogic4 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic4 WHEN ((@isFormView = 0) AND (@valRegExLogic4='-100')) THEN NULL ELSE ISNULL(@valRegExLogic4, ValRegExLogic4) END
           ,ValRegEx5 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx5 WHEN ((@isFormView = 0) AND (@valRegEx5='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx5, ValRegEx5) END
           ,ValRegExMessage5   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage5 WHEN ((@isFormView = 0) AND (@valRegExMessage5='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage5, ValRegExMessage5) END
           ,StatusId		   = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,DateChanged 	   = @dateChanged  
           ,ChangedBy  		   = @changedBy 
     WHERE Id  = @id		
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
	  ,syst.[StatusId]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo,  NULL, @ErrorMessage,  NULL,  NULL, @ErrorSeverity                
END CATCH
GO
