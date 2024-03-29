SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Upd a MVOC ref question
-- Execution:                 EXEC [dbo].[UpdPrgMvocRefQuestion]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgMvocRefQuestion]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@mVOCID bigint = NULL
	,@queQuestionNumber int = NULL
	,@queCode nvarchar(20) = NULL
	,@queTitle nvarchar(50) = NULL
	,@quesTypeId int = NULL
	,@queType_YNAnswer bit = NULL
	,@queType_YNDefault bit = NULL
	,@queType_RangeLo int = NULL
	,@queType_RangeHi int = NULL
	,@queType_RangeAnswer int = NULL
	,@queType_RangeDefault int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
	,@queDescriptionText nvarchar(Max)) 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @mVOCID, @entity, @queQuestionNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[MVOC010Ref_Questions]
		SET  MVOCID                  = CASE WHEN (@isFormView = 1) THEN @mVOCID WHEN ((@isFormView = 0) AND (@mVOCID=-100)) THEN NULL ELSE ISNULL(@mVOCID, MVOCID) END
			,QueQuestionNumber       = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, QueQuestionNumber) END
			,QueCode                 = CASE WHEN (@isFormView = 1) THEN @queCode WHEN ((@isFormView = 0) AND (@queCode='#M4PL#')) THEN NULL ELSE ISNULL(@queCode, QueCode) END
			,QueTitle                = CASE WHEN (@isFormView = 1) THEN @queTitle WHEN ((@isFormView = 0) AND (@queTitle='#M4PL#')) THEN NULL ELSE ISNULL(@queTitle, QueTitle) END
			,StatusId		         = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,QuesTypeId              = CASE WHEN (@isFormView = 1) THEN @quesTypeId WHEN ((@isFormView = 0) AND (@quesTypeId=-100)) THEN NULL ELSE ISNULL(@quesTypeId, QuesTypeId) END
			,QueType_YNAnswer        = ISNULL(@queType_YNAnswer, QueType_YNAnswer)
			,QueType_YNDefault       = ISNULL(@queType_YNDefault, QueType_YNDefault)
			,QueType_RangeLo         = CASE WHEN (@isFormView = 1) THEN @queType_RangeLo WHEN ((@isFormView = 0) AND (@queType_RangeLo=-100)) THEN NULL ELSE ISNULL(@queType_RangeLo, QueType_RangeLo) END
			,QueType_RangeHi         = CASE WHEN (@isFormView = 1) THEN @queType_RangeHi WHEN ((@isFormView = 0) AND (@queType_RangeHi=-100)) THEN NULL ELSE ISNULL(@queType_RangeHi, QueType_RangeHi) END
			,QueType_RangeAnswer     = CASE WHEN (@isFormView = 1) THEN @queType_RangeAnswer WHEN ((@isFormView = 0) AND (@queType_RangeAnswer=-100)) THEN NULL ELSE ISNULL(@queType_RangeAnswer, QueType_RangeAnswer) END
			,QueType_RangeDefault    = CASE WHEN (@isFormView = 1) THEN @queType_RangeDefault WHEN ((@isFormView = 0) AND (@queType_RangeDefault=-100)) THEN NULL ELSE ISNULL(@queType_RangeDefault, QueType_RangeDefault) END
			,QueDescriptionText    =   CASE WHEN (@isFormView = 1) THEN QueDescriptionText WHEN ((@isFormView = 0) AND (@queDescriptionText='#M4PL#')) THEN NULL ELSE ISNULL(@queDescriptionText, QueDescriptionText) END
			,DateChanged             = @dateChanged
			,ChangedBy               = @changedBy
	 WHERE   [Id] = @id
		
	EXEC [dbo].[GetPrgMvocRefQuestion] @userId, @roleId, 0, @id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
