SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Ins a  MVOC ref question
-- Execution:                 EXEC [dbo].[InsPrgMvocRefQuestion]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsPrgMvocRefQuestion]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@mVOCID bigint
	,@queQuestionNumber int
	,@queCode nvarchar(20)
	,@queTitle nvarchar(50)
	,@quesTypeId int
	,@queType_YNAnswer bit
	,@queType_YNDefault bit
	,@queType_RangeLo int
	,@queType_RangeHi int
	,@queType_RangeAnswer int
	,@queType_RangeDefault int
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
	,@queDescriptionText nvarchar(Max))
AS
BEGIN TRY                
 SET NOCOUNT ON;
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @mVOCID, @entity, @queQuestionNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[MVOC010Ref_Questions]
           (MVOCID
			,QueQuestionNumber
			,QueCode
			,QueTitle
			,QuesTypeId
			,QueType_YNAnswer
			,QueType_YNDefault
			,QueType_RangeLo
			,QueType_RangeHi
			,QueType_RangeAnswer
			,QueType_RangeDefault
			,StatusId
			,DateEntered
			,EnteredBy
			,QueDescriptionText)
     VALUES
           (@mVOCID
		   	,@updatedItemNumber
		   	,@queCode
		   	,@queTitle
		   	,@quesTypeId
		   	,@queType_YNAnswer
		   	,@queType_YNDefault
		   	,@queType_RangeLo
		   	,@queType_RangeHi
		   	,@queType_RangeAnswer
		   	,@queType_RangeDefault
			,@statusId
		   	,@dateEntered
		   	,@enteredBy
			,@queDescriptionText)
			SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetPrgMvocRefQuestion] @userId, @roleId, 0, @currentId

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
