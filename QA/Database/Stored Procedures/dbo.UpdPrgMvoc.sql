SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Upd a Program MVOC
-- Execution:                 EXEC [dbo].[UpdPrgMvoc]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgMvoc]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@vocOrgID bigint = NULL
	,@vocProgramID bigint = NULL
	,@vocSurveyCode nvarchar(20) = NULL
	,@vocSurveyTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@vocDateOpen datetime2(7) = NULL
	,@vocDateClose datetime2(7) = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
	,@vocAllStar BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[MVOC000Program]
		SET  VocOrgID        = CASE WHEN (@isFormView = 1) THEN @vocOrgID WHEN ((@isFormView = 0) AND (@vocOrgID=-100)) THEN NULL ELSE ISNULL(@vocOrgID, VocOrgID) END
			,VocProgramID    = CASE WHEN (@isFormView = 1) THEN @vocProgramID WHEN ((@isFormView = 0) AND (@vocProgramID=-100)) THEN NULL ELSE ISNULL(@vocProgramID, VocProgramID) END
			,VocSurveyCode   = CASE WHEN (@isFormView = 1) THEN @vocSurveyCode WHEN ((@isFormView = 0) AND (@vocSurveyCode='#M4PL#')) THEN NULL ELSE ISNULL(@vocSurveyCode, VocSurveyCode) END
			,VocSurveyTitle  = CASE WHEN (@isFormView = 1) THEN @vocSurveyTitle WHEN ((@isFormView = 0) AND (@vocSurveyTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vocSurveyTitle, VocSurveyTitle) END
			,StatusId        = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,VocDateOpen     = CASE WHEN (@isFormView = 1) THEN @vocDateOpen WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vocDateOpen, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vocDateOpen, VocDateOpen) END
			,VocDateClose    = CASE WHEN (@isFormView = 1) THEN @vocDateClose WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vocDateClose, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vocDateClose, VocDateClose) END
			,VocAllStar = ISNULL(@vocAllStar, VocAllStar)
			,DateChanged     = @dateChanged
			,ChangedBy       = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.Id
		,prg.VocOrgID
		,prg.VocProgramID
		,prg.VocSurveyCode
		,prg.VocSurveyTitle
		,prg.StatusId
		,prg.VocDateOpen
		,prg.VocDateClose
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
  FROM   [dbo].[MVOC000Program] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
